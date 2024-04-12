%> Project the system solution \f$ \mathbf{x} \f$ on the invariants
%> \f$ \mathbf{h} (\mathbf{x}, \mathbf{v}, t) = \mathbf{0} \f$. The
%> constrained minimization problem to be solved is:
%>
%> \f[
%> \textrm{minimize} \quad
%> \dfrac{1}{2}\left(\mathbf{x} - \widetilde{\mathbf{x}}\right)^2 \quad
%> \textrm{subject to} \quad \mathbf{h}(\mathbf{x}, \mathbf{v}, t) =
%> \mathbf{0}.
%> \f]
%>
%> **Solution Algorithm**
%>
%> Given the Lagrangian of the minimization problem of the form:
%>
%> \f[
%> \mathcal{L}(\mathbf{x}, \boldsymbol{\lambda}) =
%> \frac{1}{2}\left(\mathbf{x} - \widetilde{\mathbf{x}}\right)^2 +
%> \boldsymbol{\lambda} \cdot \mathbf{h}(\mathbf{x}, \mathbf{v}, t).
%> \f]
%>
%> The solution of the problem is obtained by solving the following:
%>
%> \f[
%> \left\{\begin{array}{l}
%> \mathbf{x} + \mathbf{Jh}_\mathbf{x}^T \boldsymbol{\lambda} =
%> \widetilde{\mathbf{x}} \\[0.5em]
%> \mathbf{h}(\mathbf{x}, \mathbf{v}, t) = \mathbf{0}
%> \end{array}\right.
%> \f]
%>
%> Using the Taylor expansion of the Lagrangian:
%>
%> \f[
%> \mathbf{h}(\mathbf{x}, \mathbf{v}, t) + \mathbf{Jh}_\mathbf{x} \delta\mathbf{x} +
%> \mathcal{O}\left(\left\| \delta\mathbf{x} \right\|^2\right) = \mathbf{0}
%> \f]
%>
%> define the iterative method as:
%>
%> \f[
%> \mathbf{x} = \widetilde{\mathbf{x}} + \delta\mathbf{x}.
%> \f]
%>
%> Notice that \f$ \delta\mathbf{x} \f$ is the solution of the linear system:
%>
%> \f[
%> \begin{bmatrix}
%> \mathbf{I}             & \mathbf{Jh}_\mathbf{x}^T \\[0.5em]
%> \mathbf{Jh}_\mathbf{x} & \mathbf{0}
%> \end{bmatrix}
%> \begin{bmatrix}
%> \delta\mathbf{x} \\[0.5em]
%> \boldsymbol{\lambda}
%> \end{bmatrix}
%> =
%> \begin{bmatrix}
%> \widetilde{\mathbf{x}} - \mathbf{x} \\[0.5em]
%> -\mathbf{h}(\mathbf{x}, \mathbf{v}, t)
%> \end{bmatrix}
%> \f]
%>
%> where \f$ \mathbf{Jh}_\mathbf{x} \f$ is the Jacobian of the invariants/
%> with respect to the states \f$ \mathbf{x} \f$.
%>
%> \param x_t The initial guess for the states \f$ \widetilde{\mathbf{x}} \f$.
%> \param t   The time \f$ t \f$ at which the states are evaluated.
%> \param x_b [optional] Boolean vector to project the corresponding states
%>            to be projected (default: all states are projected).
%>
%> \return The solution of the projection problem \f$ \mathbf{x} \f$.
%
function x = project( this, x_t, t, varargin )

  CMD = 'Indigo.RungeKutta.project(...): ';

  % Get the number of states, equations and invariants
  num_eqns = this.m_sys.get_num_eqns();
  num_invs = this.m_sys.get_num_invs();

  assert(length(x_t) == num_eqns, ...
    [CMD, 'the number of states does not match the number of equations.']);

  % Check the input
  if (nargin == 3)
    projected_x = true(num_eqns, 1);
  elseif (nargin == 4)
    projected_x = varargin{1}{1};
    assert(length(projected_x) == num_eqns, ...
      [CMD, 'the number of the projectes states does not match the ', ...
      'number of equations.']);
  else
    error([CMD, 'invalid number of input arguments.']);
  end
  num_projected_x = sum(projected_x);

  % Check if there are any constraints
  x = x_t;
  if (num_invs > 0)
    for k = 1:this.m_max_projection_iter

      % Standard projection method
      %     [A]         {x}    =        {b}
      % / I  Jh^T \ /   dx   \   / x_t - x_k \
      % |         | |        | = |           |
      % \ Jh   0  / \ lambda /   \    -h     /

      % Evaluate the veils, invariants vector and their Jacobian
      v    = this.m_sys.v(x, t);
      h    = this.m_sys.h(x, v, t);
      Jh_x = this.m_sys.Jh_x(x, v, t);
      Jh_v = this.m_sys.Jh_v(x, v, t);
      Jv_x = this.m_sys.Jv_x(x, v, t);
      Jh   = Jh_x + Jh_v * Jv_x;

      % Select only the projected invariants
      h   = h(this.m_projected_invs);
      Jh  = Jh(this.m_projected_invs, projected_x);

      % Check if the solution is found
      if (norm(h, inf) < this.m_projection_low_tolerance)
        break;
      end

      % Compute the solution of the linear system
      A = [eye(num_projected_x), Jh.'; ...
           Jh, zeros(sum(this.m_projected_invs))];
      b = [x_t(projected_x) - x(projected_x); -h];
      if (rcond(A) > this.m_projection_rcond_tolerance)
        sol = A\b;
      else
        [sol, ~] = lsqr(A, b, this.m_projection_low_tolerance, 500);
      end

      % Update the solution
      dx = sol(1:num_projected_x);
      x(projected_x) = x(projected_x) + dx;

      % Check if the solution is found
      if (k == this.m_max_projection_iter)
        warning([CMD, 'maximum number of iterations reached.']);
      end
    end
  end
end
