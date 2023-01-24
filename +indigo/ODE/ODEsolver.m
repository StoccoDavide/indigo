%
%> Class container for solver of  the system of Ordinary Differential Equations
%> (ODEs) or Differential Algebraic Equations (DAEs).
%
classdef ODEsolver < handle
  %
  properties (SetAccess = protected, Hidden = true)
    %
    %> Name of the solver.
    %
    m_name;
    %
    %> System of ODEs/DAEs to be solved.
    %
    m_ode;
    %
    %> Maximum number of iterations in the projection process.
    %
    m_max_iter;
    %
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor for ODEsolver, which requires the name of the solver
    %> used to integrate the system of ODEs as input.
    %>
    %> \param name The name of the solver.
    %
    function this = ODEsolver( t_name )
      this.m_name = t_name;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the name of the method used to integrate the system of ODEs.
    %>
    %> \return The name of the solver.
    %
    function out = get_name( this )
      out = this.m_name;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the name of the method used to integrate the system of ODEs.
    %>
    %> \param name The name of the solver.
    %
    function out = set_name( this, t_name )
      this.m_name = t_name;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the system of ODEs to be solved.
    %>
    %> \return The system of ODEs to be solved.
    %
    function out = get_ode( this )
      out = this.m_ode;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the system of ODEs to be solved.
    %>
    %> \param ode The system of ODEs to be solved.
    %
    function set_ode( this, t_ode )
      this.m_ode = t_ode;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the maximum number of iterations in the projection process.
    %>
    %> \return The maximum number of iterations in the projection process.
    %
    function out = get_max_iter( this )
      out = this.m_max_iter;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the maximum number of iterations in the projection process.
    %>
    %> \param max_iter The maximum number of iterations in the projection process.
    %
    function set_max_iter( this, t_max_iter )

      CMD = 'indigo::ODEsolver::set_max_iter(...)'

      assert(t_max_iter > 0, ...
        [CMD, 'invalid maximum number of iterations.']);

      this.m_max_iter = t_max_iter;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Solve the ODEs system through the problem:
    %>
    %> \f[
    %> \textrm{minimize} \quad
    %> \dfrac{1}{2}\left(
    %>   \begin{bmatrix} \mathbf{x} \\ \mathbf{x}' \end{bmatrix} -
    %>   \begin{bmatrix} \tilde{\mathbf{x}} \\ \tilde{\mathbf{x}}' \end{bmatrix}
    %> \right)^2 \quad
    %> \textrm{subject to} \quad \mathbf{H}(\mathbf{x}, \mathbf{x}', t) = \mathbf{0}
    %> \f]
    %>
    %> given the Lagrangian of the form:
    %>
    %> \f[
    %> \mathcal{L}(\mathbf{x}, \mathbf{x}', \boldsymbol{\lambda}) =
    %> \frac{1}{2}\left(
    %>   \begin{bmatrix} \mathbf{x} \\ \mathbf{x}' \end{bmatrix} -
    %>   \begin{bmatrix} \widetilde{\mathbf{x}} \\ \widetilde{\mathbf{x}}' \end{bmatrix}
    %> \right)^2 +
    %> \boldsymbol{\lambda} \cdot \mathbf{H}(\mathbf{x}, \mathbf{x}', t).
    %> \f]
    %>
    %> The solution of the problem is obtained by solving the following:
    %>
    %> \f[
    %> \left\{\begin{array}{l}
    %> \begin{bmatrix} \mathbf{x} \\ \mathbf{x}' \end{bmatrix} + \mathbf{JH}_\mathbf{x}^T
    %> \boldsymbol{\lambda} = \begin{bmatrix}
    %>   \widetilde{\mathbf{x}} \\ \widetilde{\mathbf{x}}'
    %> \end{bmatrix} \\[1em]
    %> \mathbf{H}(\mathbf{x}, \mathbf{x}', t) = \mathbf{0}
    %> \end{array}\right.
    %> \f]
    %>
    %> **Solution algorithm**
    %>
    %> Using the Taylor expansion of the Lagrangian:
    %>
    %> \f[
    %> \mathbf{H}(\mathbf{x}, \mathbf{x}', t) +
    %> \mathbf{JH}_\mathbf{x}
    %> \begin{bmatrix} \delta\mathbf{x} \\ \delta\mathbf{x}' \end{bmatrix} +
    %> \mathcal{O}\left(\left\|
    %> \begin{bmatrix} \delta\mathbf{x} \\ \delta\mathbf{x}' \end{bmatrix}
    %> \right\|^2\right) = \mathbf{0}
    %> \f]
    %>
    %> define the iterative method as:
    %>
    %> \f[
    %> \begin{bmatrix} \mathbf{x}_{k+1} \\ \mathbf{x}_{k+1}' \end{bmatrix} =
    %> \begin{bmatrix} \mathbf{x}_{k} \\ \mathbf{x}_{k}' \end{bmatrix} +
    %> \begin{bmatrix} \delta\mathbf{x} \\ \delta\mathbf{x}' \end{bmatrix}.
    %> \f]
    %>
    %> Notice that \f$ \left[\delta\mathbf{x}, \delta\mathbf{x}'\right]^T \f$ is the
    %> solution of the linear system:
    %>
    %> \f[
    %> \left[\begin{array}{c|c} \\[-0.75em]
    %> \mathbf{I}             & \mathbf{JH}_\mathbf{x}^T \\[0.5em] \hline
    %> \mathbf{JH}_\mathbf{x} & \mathbf{0}
    %> \end{array}\right]
    %> \left[\begin{array}{c}
    %> \delta\mathbf{x} \\ \delta\mathbf{x}' \\ \hline \boldsymbol{\lambda}
    %> \end{array}\right]
    %> =
    %> \left[\begin{array}{c}
    %> \widetilde{\mathbf{x}}  - \mathbf{x}_k \\
    %> \widetilde{\mathbf{x}}' - \mathbf{x}'_k \\ \hline
    %> -\mathbf{H}(\mathbf{x}_k, \mathbf{x}_k', t_k)
    %> \end{array}\right]
    %> \f]
    %>
    %> where \f$ \mathbf{JH}_\mathbf{x} \f$ is the Jacobian of the invariants/
    %> hidden constraints with respect to the states \f$ \mathbf{x} \f$.
    %
    function [x, x_dot] = project( this, x_tilde, x_dot_tilde, t )

      CMD = 'indigo::ODEsolver::project(...): ';

      % Get the number of states, equations and invariants
      num_eqns = this.m_ode.get_num_eqns();
      num_invs = this.m_ode.get_num_invs();
      x        = x_tilde;
      x_dot    = x_dot_tilde;

      assert(length(x_tilde) == num_eqns, ...
        [CMD, 'the number of states does not match the number of equations.']);
      assert(length(x_dot_tilde) == num_eqns, ...
        [CMD, 'the number of states derivatives does not match the number of equations.']);

      % Check if there are any constraints
      if num_invs > 0

        % Calculate and scale the tolerance
        tolerance = max(1, norm(x_tilde, inf)) * sqrt(eps);

        % Iterate until the projected solution is found
        for k = 1:this.m_max_iter
          %     [A]           {x}      =                   {b}
          % / I  JH^T \ / dx, dx_dot \   / x_tilde - x_k, x_dot_tilde - x_dot \
          % |         | |            | = |                                    |
          % \ JH   0  / \   lambda   /   \                 -H                 /

          % Evaluate the invariants/hidden constraints vector and its Jacobian
          J  = this.m_ode.H(x, x_dot, t);
          JH = this.m_ode.JH(x, x_dot, t);

          % Compute the solution of the linear system
          A   = [eye(num_eqns), JH.'; ...
                 JH, zeros(num_invs, num_invs)];
          b   = [x_tilde-x; x_dot_tilde-x_dot; -H];
          sol = A\b;

          % Update the solution
          dx     = sol(1:num_eqns);
          dx_dot = sol(num_eqns+1:2*num_eqns+1);
          x      = x     + dx;
          x_dot  = x_dot + dx_dot;

          % Check if the solution is found
          if (max(abs(dx)) < tolerance && max(abs(H)) < tolerance)
            break;
          else if (k == MAX_ITER)
            warning([CMD, 'maximum number of iterations reached.']);
          end
          end
        end
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Solve the system of ODEs and calculate the approximate solution.
    %>
    %> \param t       Time vector \f$ \left[ t_0, t_1, \ldots, t_n \right]^T \f$.
    %> \param x_0     Initial states value \f$ \mathbf{x}(t_0) \f$.
    %> \param project [optional, default = false] Apply projection to invariants
    %>                 at each step.
    %> \param verbose [optional, default = \f$ \mathrm{false} \f$] Activate
    %>                vebose mode.
    %> \param epsilon [optional, default = \f$ 1.0\mathrm{e}3 \f$] If
    %>                \f$ || \mathbf{x} ||_{\infty} > \varepsilon \f$
    %>                the computation is interrupted.
    %>
    %> \return A matrix \f$ \left[(\mathrm{size}(\mathbf{x}) + \mathrm{size}
    %>         (\mathbf{x}')) \times \mathrm{size}(t)\right] \f$ containing the
    %>         approximated solution \f$ \mathbf{x}(t) \f$ of the system of ODEs.
    %>
    %> **Usage:**
    %>
    %> Solve without the solution projection on invariants/hidden constraints and
    %> disabled verbose mode.
    %>
    %> \rst
    %> .. code-block:: none
    %>
    %>   sol = obj.solve(t, x_0);
    %>
    %> \endrst
    %>
    %> Solve with the solution projection on invariants/hidden constraints and
    %> disabled verbose mode.
    %>
    %> \rst
    %> .. code-block:: none
    %>
    %>   sol = obj.solve(t, x_0, true);
    %>
    %> \endrst
    %>
    %> Solve without the solution projection on invariants/hidden constraints and
    %> enabled verbose mode.
    %>
    %> \rst
    %> .. code-block:: none
    %>
    %>   sol = obj.solve(t, x_0, false, true);
    %>
    %> \endrst
    %>
    %> Plot the first component of the solution.
    %>
    %> \rst
    %> .. code-block:: none
    %>
    %>   plot(t, sol(1,:));
    %>
    %> \endrst
    %
    function out = solve( this, t, x_0, varargin )

      CMD = 'indigo::ODEsolver::solve(...): ';

      % Check initial conditions
      num_eqns = this.m_ode.get_num_eqns();
      if num_eqns ~= length(x_0)
        error([CMD, 'in %s solver, length(x_0) is %d, expected %d.'], ...
          this.m_name, length(x_0), num_eqns);
      end

      % Collect optional projection flag
      if nargin > 3
        project = varargin{1};
      else
        project = false;
      end

      % Collect optional verbose flag
      if nargin > 4
        verbose = varargin{2};
      else
        verbose = false;
      end

      % Collect optional epsilon value
      if nargin > 5
        epsilon = varargin{3};
      else
        epsilon = 1.0e3;
      end

      % Check number of input arguments
      if nargin > 6
        error([CMD, 'in %s solver, too many input arguments.'], this.m_name);
      end

      out      = zeros(num_eqns, length(t));
      out(:,1) = x_0(:);
      perc     = 0.0;
      nt       = length(t)-1;
      for k = 1:nt
        if verbose
          newpp = ceil(100*k/nt);
          if newpp > perc+4
            perc = newpp;
            fprintf('%3d%%\n', perc);
          end
        end

        % Integrate system of ODEs
        x_new = this.step(t(k), out(:,k), t(k+1)-t(k));

        % Project solution on the invariants/hidden constraints
        if project
          x_new = this.project(t(k+1), x_new);
        end

        % Check the infinity norm of the projected solution
        norm_x_new = norm(x_new, inf);
        if norm_x_new > epsilon
          fprintf([CMD, 'in %s solver, at t(%d) = %g, ||x||_inf = %g, computation interrupted.\n'], ...
            this.m_name, k, t(k), norm_xnew);
          break;
        end
        out(:,k+1) = x_new;
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
  methods (Abstract)
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Generic advancing step for a generic solver.
    %>
    %> \param x_k     States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
    %> \param x_dot_k States derivative at \f$ k \f$-th time step \f$ \mathbf{x}'(t_k) \f$.
    %> \param t_k     Time step \f$ t_k \f$.
    %> \param d_t     Advancing time step \f$ \Delta t\f$.
    %>
    %> \return The approximation of \f$ \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$.
    %
    step( this, x_k, x_dot_k, t_k, d_t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
end
