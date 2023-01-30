%
%> Class container for Runge-Kutta solvers of the system of Ordinary Differential
%> Equations (ODEs) or index-0 Differential Algebraic Equations (DAEs). The user
%> must simply define the Butcher tableau of the method, which defined as:
%>
%> \f[
%> \begin{array}{c|c}
%>   \mathbf{c} & \mathbf{A} \\ \hline
%>              & \mathbf{b} \\
%>              & \hat{\mathbf{b}}
%> \end{array}
%> \f]
%>
%> where \f$ \mathbf{A} \f$ is the Runge-Kutta matrix (lower triangular matrix):
%>
%> \f[
%> \mathbf{A} = \begin{bmatrix}
%>   a_{11} & a_{12} & \dots  & a_{1s} \\
%>   a_{21} & a_{22} & \dots  & a_{2s} \\
%>   \vdots & \vdots & \ddots & \vdots \\
%>   a_{s1} & a_{s2} & \dots  & a_{ss}
%> \end{bmatrix},
%> \f]
%>
%> \f$ \mathbf{b} \f$ is the Runge-Kutta weights vector relative to a method of
%> order \f$ p \f$ (row vector):
%>
%> \f[
%> \mathbf{b} = \left[ b_1, b_2, \dots, b_s \right],
%> \f]
%>
%> \f$ \hat{\mathbf{b}} \f$ is the (optional) embedded Runge-Kutta weights
%> vector relative to a method of order \f$ \hat{p} \f$ (usually \f$ \hat{p} =
%> p−1 \f$ or \f$ \hat{p} = p+1 \f$) (row vector):
%>
%> \f[
%> \hat{\mathbf{b}} = \left[ \hat{b}_1, \hat{b}_2, \dots, \hat{b}_s \right],
%> \f]
%>
%> and \f$ \mathbf{c} \f$ is the Runge-Kutta nodes vector (column vector):
%>
%> \f[
%> \mathbf{c} = \left[ c_1, c_2, \dots, c_s \right]^T.
%> \f]
%
classdef ODEsolver < handle
  %
  properties (SetAccess = protected, Hidden = true)
    %
    %> Name of the solver.
    %
    m_name;
    %
    %> Matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
    %
    m_A;
    %
    %> Weights vector \f$ \mathbf{b} \f$ (row vector).
    %
    m_b;
    %
    %> Embedded weights vector \f$ \hat{\mathbf{b}} \f$ (row vector).
    %
    m_b_e;
    %
    %> Nodes vector \f$ \mathbf{c} \f$ (column vector).
    %
    m_c;
    %
    %> Maximum number of substeps (default = 5).
    %
    m_max_substeps;
    %
    %> Maximum number of iterations in the projection process (default = 5).
    %
    m_max_projection_iter;
    %
    %> System of ODEs/DAEs to be solved (fake pointer).
    %
    m_ode;
    %
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor for ODEsolver, which requires the name of the solver
    %> used to integrate the system of ODEs/DAEs as input.
    %>
    %> \param t_name The name of the solver.
    %> \param t_A    The matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
    %> \param t_b    The weights vector \f$ \mathbf{b} \f$ (row vector).
    %> \param t_b_e  The embedded weights vector \f$ \hat{\mathbf{b}} \f$
    %>               (row vector).
    %> \param t_c    The nodes vector \f$ \mathbf{c} \f$ (column vector).
    %>
    %> \return An instance of the ODEsolver class.
    %
    function this = ODEsolver( varargin )

      CMD = 'indigo::ODEsolver::ODEsolver(...): ';

      if (nargin == 4)
        t_name = varargin{1};
        t_A    = varargin{2};
        t_b    = varargin{3};
        t_b_e  = [];
        t_c    = varargin{4};
      elseif (nargin == 5)
        t_name = varargin{1};
        t_A    = varargin{2};
        t_b    = varargin{3};
        t_b_e  = varargin{4};
        t_c    = varargin{5};
      else
        error([CMD, 'Wrong number of input arguments.']);
      end

      % Collect input arguments
      this.m_name = t_name;

      % Set the Butcher tableau
      this.set_tableau(t_A, t_b, t_b_e, t_c);

      % Set default values
      this.m_max_substeps        = 5;
      this.m_max_projection_iter = 5;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the name of the method used to integrate the system of ODEs/DAEs.
    %>
    %> \return The name of the solver.
    %
    function t_name = get_name( this )
      t_name = this.m_name;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the name of the method used to integrate the system of ODEs/DAEs.
    %>
    %> \param t_name The name of the solver.
    %
    function set_name( this, t_name )
      this.m_name = t_name;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the system of ODEs/DAEs to be solved.
    %>
    %> \return The system of ODEs/DAEs to be solved.
    %
    function t_ode = get_ode( this )
      t_ode = this.m_ode;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the system of ODEs/DAEs to be solved.
    %>
    %> \param t_ode The system of ODEs/DAEs to be solved.
    %
    function set_ode( this, t_ode )
      this.m_ode = t_ode;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the maximum number of substeps.
    %>
    %> \return The maximum number of substeps.
    %
    function t_max_substeps = get_max_substeps( this )
      t_max_substeps = this.m_max_substeps;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the maximum number of substeps.
    %>
    %> \param t_max_substeps The maximum number of substeps.
    %
    function set_max_substeps( this, t_max_substeps )

      CMD = 'indigo::ODEsolver::set_max_substeps(...)';

      assert(t_max_substeps >= 0, ...
        [CMD, 'invalid maximum number of substeps.']);

      this.m_max_substeps = t_max_substeps;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the maximum number of iterations in the projection process.
    %>
    %> \return The maximum number of iterations in the projection process.
    %
    function t_max_iter = get_max_projection_iter( this )
      t_max_iter = this.m_max_projection_iter;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the maximum number of iterations in the projection process.
    %>
    %> \param t_max_projection_iter The maximum number of projection iterations.
    %
    function set_max_projection_iter( this, t_max_projection_iter )

      CMD = 'indigo::ODEsolver::set_max_projection_iter(...)';

      assert(t_max_projection_iter > 0, ...
        [CMD, 'invalid maximum number of iterations.']);

      this.m_max_projection_iter = t_max_projection_iter;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
    %>
    %> \return The matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
    %
    function t_A = get_A( this )
      t_A = this.m_A;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
    %>
    %> \param t_A The matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
    %
    function set_A( this, t_A )
      this.m_A = t_A;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the weights vector \f$ \mathbf{b} \f$ (row vector).
    %>
    %> \return The weights vector \f$ \mathbf{b} \f$ (row vector).
    %
    function t_b = get_b( this )
      t_b = this.m_b;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the weights vector \f$ \mathbf{b} \f$ (row vector).
    %>
    %> \param t_b The weights vector \f$ \mathbf{b} \f$ (row vector).
    %
    function set_b( this, t_b )
      this.m_b = t_b;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the embedded weights vector \f$ \hat{\mathbf{b}} \f$ (row vector).
    %>
    %> \return The embedded weights vector \f$ \hat{\mathbf{b}} \f$ (row vector).
    %
    function t_b_e = get_b_e( this )
      t_b_e = this.m_b_e;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the embedded weights vector \f$ \hat{\mathbf{b}} \f$ (row vector).
    %>
    %> \param t_b_e The embedded weights vector \f$ \hat{\mathbf{b}} \f$ (row
    %>        vector).
    %
    function set_b_e( this, t_b_e )
      this.m_b_e = t_b_e;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the nodes vector \f$ \mathbf{c} \f$ (column vector).
    %>
    %> \return The nodes vector \f$ \mathbf{c} \f$ (column vector).
    %
    function t_c = get_c( this )
      t_c = this.m_c;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the nodes vector \f$ \mathbf{c} \f$ (column vector).
    %>
    %> \param t_c The nodes vector \f$ \mathbf{c} \f$ (column vector).
    %
    function set_c( this, t_c )
      this.m_c = t_c;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the Butcher tableau.
    %>
    %> \return The matrix \f$ \mathbf{A} \f$ (lower triangular matrix), the
    %>         weights vector \f$ \mathbf{b} \f$ (row vector), the embedded
    %>         weights vector \f$ \hat{\mathbf{b}} \f$ (row vector), and nodes
    %>         vector \f$ \mathbf{c} \f$ (column vector).
    %
    function [A, b, b_e, c] = get_tableau( this )
      A   = this.m_A;
      b   = this.m_b;
      b_e = this.m_b_e;
      c   = this.m_c;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the Butcher tableau.
    %>
    %> \param A   Matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
    %> \param b   Weights vector \f$ \mathbf{b} \f$ (row vector).
    %> \param b_e [optional] Embedded weights vector \f$ \hat{\mathbf{b}} \f$
    %>            (row vector).
    %> \param c   Nodes vector \f$ \mathbf{c} \f$ (column vector).
    %
    function set_tableau( this, varargin )

      CMD = 'indigo::ODEsolver::set_tableau(...): ';

      if (nargin == 4)
        A   = varargin{1};
        b   = varargin{2};
        b_e = [];
        c   = varargin{3};
      elseif (nargin == 5)
        A   = varargin{1};
        b   = varargin{2};
        b_e = varargin{3};
        c   = varargin{4};
      else
        error([CMD, 'Wrong number of input arguments.']);
      end

      % Check the Butcher tableau
      assert(this.check_tableau(A, b, b_e, c), ...
        [CMD, 'invalid tableau detected.']);

      % Set the tableau
      this.m_A   = A;
      this.m_b   = b;
      this.m_b_e = b_e;
      this.m_c   = c;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Project the ODEs system solution \f$ \mathbf{x} \f$ on the invariants/hidden
    %> constraints \f$ \mathbf{H} (\mathbf{x}, t) = \mathbf{0} \f$. The constrained
    %> minimization problem to be solved is:
    %>
    %> \f[
    %> \textrm{minimize} \quad
    %> \dfrac{1}{2}\left(\mathbf{x} - \widetilde{\mathbf{x}}\right)^2 \quad
    %> \textrm{subject to} \quad \mathbf{H}(\mathbf{x}, t) = \mathbf{0}.
    %> \f]
    %>
    %> **Solution Algorithm**
    %>
    %> Given the Lagrangian of the minimization problem of the form:
    %>
    %> \f[
    %> \mathcal{L}(\mathbf{x}, \boldsymbol{\lambda}) =
    %> \frac{1}{2}\left(\mathbf{x} - \widetilde{\mathbf{x}}\right)^2 +
    %> \boldsymbol{\lambda} \cdot \mathbf{H}(\mathbf{x}, t).
    %> \f]
    %>
    %> The solution of the problem is obtained by solving the following:
    %>
    %> \f[
    %> \left\{\begin{array}{l}
    %> \mathbf{x} + \mathbf{JH}_\mathbf{x}^T \boldsymbol{\lambda} =
    %> \widetilde{\mathbf{x}} \\[0.5em]
    %> \mathbf{H}(\mathbf{x}, t) = \mathbf{0}
    %> \end{array}\right.
    %> \f]
    %>
    %> Using the Taylor expansion of the Lagrangian:
    %>
    %> \f[
    %> \mathbf{H}(\mathbf{x}, t) + \mathbf{JH}_\mathbf{x} \delta\mathbf{x} +
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
    %> \mathbf{I}             & \mathbf{JH}_\mathbf{x}^T \\[0.5em]
    %> \mathbf{JH}_\mathbf{x} & \mathbf{0}
    %> \end{bmatrix}
    %> \begin{bmatrix}
    %> \delta\mathbf{x} \\[0.5em]
    %> \boldsymbol{\lambda}
    %> \end{bmatrix}
    %> =
    %> \begin{bmatrix}
    %> \widetilde{\mathbf{x}} - \mathbf{x} \\[0.5em]
    %> -\mathbf{H}(\mathbf{x}, t)
    %> \end{bmatrix}
    %> \f]
    %>
    %> where \f$ \mathbf{JH}_\mathbf{x} \f$ is the Jacobian of the invariants/
    %> hidden constraints with respect to the states \f$ \mathbf{x} \f$.
    %>
    %> \param x_tilde The initial guess for the states \f$ \widetilde{\mathbf{x}} \f$.
    %> \param t The time \f$ t \f$ at which the states are evaluated.
    %>
    %> \return The solution of the projection problem \f$ \mathbf{x} \f$.
    %
    function x = project( this, x_tilde, t )

      CMD = 'indigo::ODEsolver::project(...): ';

      % Get the number of states, equations and invariants
      num_eqns = this.m_ode.get_num_eqns();
      num_invs = this.m_ode.get_num_invs();
      x        = x_tilde;

      assert(length(x_tilde) ~= num_eqns, ...
        [CMD, 'the number of states does not match the number of equations.']);

      % Check if there are any constraints
      if (num_invs > 0)

        % Calculate and scale the tolerance
        tolerance = max(1, norm(x_tilde, inf)) * sqrt(eps);

        % Iterate until the projected solution is found
        for k = 1:this.m_max_projection_iter

          %     [A]         {x}    =        {b}
          % / I  JH^T \ /   dx   \   / x_tilde - x_k \
          % |         | |        | = |               |
          % \ JH   0  / \ lambda /   \      -H       /

          % Evaluate the invariants/hidden constraints vector and its Jacobian
          H  = this.m_ode.H(x, t);
          JH = this.m_ode.JH(x, t);

          % Compute the solution of the linear system
          A   = [eye(num_eqns), JH.'; ...
                 JH, zeros(num_invs, num_invs)];
          b   = [x_tilde - x; -H];
          sol = A\b;

          % Update the solution
          dx = sol(1:num_eqns);
          x  = x + dx;

          % Check if the solution is found
          if (max(abs(dx)) < tolerance && max(abs(H)) < tolerance)
            break;
          elseif (k == MAX_ITER)
            warning([CMD, 'maximum number of iterations reached.']);
          end
        end
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Solve the system of ODEs/DAEs and calculate the approximate solution.
    %>
    %> \param t       Time vector \f$ \mathbf{t} = \left[ t_0, t_1, \ldots, t_n
    %>                \right]^T \f$.
    %> \param x_0     Initial states value \f$ \mathbf{x}(t_0) \f$.
    %> \param project [optional, default = false] Apply projection to invariants
    %>                 at each step.
    %> \param verbose [optional, default = \f$ \mathrm{false} \f$] Activate
    %>                vebose mode.
    %> \param epsilon [optional, default = \f$ 1.0\mathrm{e}3 \f$] If
    %>                \f$ || \mathbf{x} ||_{\infty} > \varepsilon \f$
    %>                the computation is interrupted.
    %>
    %> \return A matrix \f$ \left[(\mathrm{size}(\mathbf{x}) \times \mathrm{size}
    %>         (\mathbf{t})\right] \f$ containing the approximated solution
    %>         \f$ \mathbf{x}(t) \f$ of the system of ODEs/DAEs.
    %>
    %> **Usage**
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
    %>
    %> **Usage**
    %>
    %> Notice that the solve method is implemented through a while loop, thus
    %> the final time step might not be exactly the same as the last element of
    %> the desired input time vector \f$ \mathbf{t} \f$.
    %>
    %> \param t       Time vector \f$ \mathbf{t} = \left[ t_0, t_1, \ldots, t_n
    %>                \right]^T \f$.
    %> \param x_0     Initial states value \f$ \mathbf{x}(t_0) \f$.
    %> \param project [optional, default = false] Apply projection to invariants
    %>                 at each step.
    %> \param verbose [optional, default = \f$ \mathrm{false} \f$] Activate
    %>                vebose mode.
    %> \param epsilon [optional, default = \f$ 1.0\mathrm{e}3 \f$] If
    %>                \f$ || \mathbf{x} ||_{\infty} > \varepsilon \f$
    %>                the computation is interrupted.
    %>
    %> \return A matrix \f$ \left[(\mathrm{size}(\mathbf{x}) \times \mathrm{size}
    %>         (\mathbf{t})\right] \f$ containing the approximated solution
    %>         \f$ \mathbf{x}(t) \f$ of the system of ODEs/DAEs.
    %
    function [x_out, t_out] = solve( this, t, x_0, varargin )

      CMD = 'indigo::ODEsolver::solve(...): ';

      % Check initial conditions
      num_eqns = this.m_ode.get_num_eqns();
      if (num_eqns ~= length(x_0))
        error([CMD, 'in %s solver, length(x_0) is %d, expected %d.'], ...
          this.m_name, length(x_0), num_eqns);
      end

      % Collect optional projection flag
      if (nargin > 3)
        project = varargin{1};
      else
        project = false;
      end

      % Collect optional verbose flag
      if (nargin > 4)
        verbose = varargin{2};
      else
        verbose = false;
      end

      % Collect optional epsilon value
      if (nargin > 5)
        epsilon = varargin{3};
      else
        epsilon = 1.0e3;
      end

      % Check number of input arguments
      if (nargin > 6)
        error([CMD, 'in %s solver, too many input arguments.'], this.m_name);
      end

      % Instantiate output
      safety_length  = 2*length(t);
      t_out          = zeros(1, safety_length);
      x_out          = zeros(num_eqns, safety_length);
      x_out_dot      = zeros(num_eqns, safety_length);

      % Initialize first step
      t_out(:,1)     = t(1);
      x_out(:,1)     = x_0(:);
      x_out_dot(:,1) = zeros(num_eqns, 1);

      % Instantiate temporary variables
      max_k = this.m_max_substeps * this.m_max_substeps;
      k = 0; % Number of substepping
      s = 1; % Current step
      p = 0; % Current percentage

      % Compute the initial step size
      d_t_ini = t(2) - t(1);
      d_t     = d_t_ini;

      while (t_out(s) <= t(end))

        % TODO: The while loop does not guarantee that the final time step
        %       end in t(end)

        % Print percentage of completion
        if (verbose == true)
          p_new = ceil(100*s/steps);
          if (p_new > p + 4)
            p = p_new;
            fprintf('%3d%%\n', p);
          end
        end

        % Integrate system of ODEs/DAEs
        [x_new, x_dot_new, d_t_star, ierr] = ...
          this.step(x_out(:,s), x_out_dot(:,s), t_out(s), d_t);

        % Calculate the next time step with substepping logic
        % TODO: Maybe it doesn't work because it does not take the drift into
        % consideration
        if (ierr == 0)

          % Accept the step
          d_t = d_t_star;

          % If substepping is enabled,
          if (k > 0 && k < max_k)
            k = k - 1;
            % If the substepping index is even, double the step size
            if (rem(k, 2) == 0)
              d_t = 2 * d_t;
            end
          end

        else

          % If the substepping index is too high, abort
          k = k + 2;
          if (k > max_k)
            error([CMD, 'in %s solver, at t(%d) = %g, integration failed', ...
              '(error code %d) with d_t = %g, aborting.'], ...
              this.m_name, s, t(s), ierr, d_t);
          end

          % Otherwise, try again with a smaller step
          warning([CMD, 'in %s solver, at t(%d) = %g, integration failed', ...
          '(error code %d), perfom substepping.'], ...
          this.m_name, s, t(s), ierr, k);
          d_t = d_t/2;
          continue;

        end

        % Store time solution
        t_out(s+1) = t_out(s) + d_t;

        % Project solution on the invariants/hidden constraints
        if (project == true)
          x_new = this.project(t(s+1), x_new);
        end

        % Check the infinity norm of the solution
        norm_x_new = norm(x_new, inf);
        if (norm_x_new > epsilon)
          fprintf([CMD, 'in %s solver, at t(%d) = %g, ||x||_inf = %g, ', ...
          'computation interrupted.\n'], this.m_name, s, t(s), norm_x_new);
          break;
        end

        % Store states solutions
        x_out(:,s+1)     = x_new;
        x_out_dot(:,s+1) = x_dot_new;

        % Update steps counter
        s = s + 1;
      end

      % Resize the output
      t_out     = t_out(:,1:s-1);
      x_out     = x_out(:,1:s-1);
      %x_out_dot = x_out_dot(:,1:s-1);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute adaptive time step for the next advancing step according to the
    %> error control method. The error control method used is the local truncation
    %> error method, which is based on the following formula:
    %>
    %> \f[
    %> e = \sqrt{\dfrac{1}{n} \displaystyle\sum_{i=1}{n}\left(\dfrac
    %>   {\mathbf{x} - \hat{\mathbf{x}}}
    %>   {s c_i}
    %> \right)^2}
    %> \f]
    %>
    %> where \f$ \mathbf{x} \f$ is the approximation of the states at computed
    %> with higher order method of \f$ p \f$, and \f$ \hat{\mathbf{x}} \f$ is the
    %> approximation of the states at computed with lower order method of \f$
    %> \hat{p} \f$. To compute the suggested time step for the next advancing step
    %> \f$ \Delta t_{k+1} \f$, The error is compared to \f$ 1 \f$ in order to find
    %> an optimal step size. From the error behaviour \f$ e \approx Ch^{q+1} \f$
    %> and from \f$ 1 \approx Ch_{opt}^{q+1} \f$ (where \f$ q = \min(p,\hat{p}) \f$)
    %> the optimal step size is obtained as:
    %>
    %> \f[
    %> h_{opt} = h \left( \dfrac{1}{e} \right)^{\frac{1}{q+1}}
    %> \f]
    %>
    %> We multiply the previous quation by a safety factor \f$ f \f$, usually
    %> \f$ f = 0.8 \f$, \f$ 0.9 \f$, \f$ (0.25)^{1/(q+1)} \f$, or \f$ (0.38)^{1/(q+1)} \f$,
    %> so that the error will be acceptable the next time with high probability.
    %> Further, \f$ h \f$ is not allowed to increase nor to decrease too fast.
    %> So we put:
    %>
    %> \f[
    %> h_{new} = h \min \left( f_{max} \max \left( f_{max}, f \left(
    %>   \dfrac{1}{e} \right)^{\frac{1}{q+1}},
    %> \right), \right)
    %> \f]
    %>
    %> for the new step size. Then, if \f$ e \leq 1 \f$, the computed step is
    %> accepted and the solution is advanced to \f$ \mathbf{x} \f$ and a new step
    %> is tried with \f$ h_{new} \f$ as step size. Else, the step is rejected
    %> and the computations are repeated with the new step size \f$ h_{new} \f$.
    %> Typially, \f$ f \f$ is set in the interval \f$ [0.8, 0.9] \f$,
    %> \f$ f_{max} \f$ is set in the interval \f$ [1.5, 5] \f$, and \f$ f_{min} \f$
    %> is set in the interval \f$ [0.1, 0.2] \f$.
    %>
    %> \param x_h Approximation of the states at \f$ k+1 \f$-th time step \f$
    %>            \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$ with higher order method.
    %> \param x_l Approximation of the states at \f$ k+1 \f$-th time step \f$
    %>            \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$ with lower order method.
    %> \param d_t Actual advancing time step \f$ \Delta t\f$.
    %> \param A_tol   [optional, default = \f$ 1e-6 \f$] Absolute tolerance
    %>                 \f$ A_{tol} \f$.
    %> \param R_tol   [optional, default = \f$ 1e-6 \f$] Relative tolerance
    %>                 \f$ R_{tol} \f$.
    %> \param fac     [optional, default = \f$ 0.9 \f$] Safety factor \f$ f \f$.
    %> \param fac_min [optional, default = \f$ 0.2 \f$] Minimum safety factor
    %>                \f$ f_{min} \f$.
    %> \param fac_max [optional, default = \f$ 2.0 \f$]Maximum safety factor
    %>                \f$ f_{max} \f$.
    %>
    %> \return The suggested time step for the next advancing step \f$ \Delta
    %>         t_{k+1} \f$.
    %>
    function out = adapt_step( this, x_h, x_l, d_t, varargin )

      CMD = 'indigo::ODEsolver::adapt_step(...): ';

      % Collect optional inputs
      A_tol   = 1e-6;
      R_tol   = 1e-6;
      fac     = 0.9;
      fac_min = 0.2;
      fac_max = 2.0;

      % Absolute tolerance
      if (nargin > 4)
        A_tol  = 1e-6;
      end

      % Relative tolerance
      if (nargin > 5)
        R_tol  = 1e-6;
      end

      % Safety factor
      if (nargin > 5)
        fac    = 0.9;
      end

      % Desent safety factor
      if (nargin > 5)
        fac_min = 0.2;
      end

      % Ascent safety factor
      if (nargin > 5)
        fac_max = 2.0;
      end

      % Check inputs number
      if (nargin > 8)
        error([CMD 'wrong number of input arguments.']);
      end

      % Compute the error with 2-norm
      e = sqrt(sum(((x_h - x_l)./( ...
        A_tol + R_tol * max(abs(x_h), abs(x_l)) ...
      ))^2)/length(x_h));

      % Compute the suggested time step
      out = d_t * min(fac_max, max(fac_min, ...
        fac * (1/e) ^ (1/(length(this.m_c)+1) ...
      )));
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
    %> Compute a step using a generic integration method for a system of ODEs/DAEs of
    %> the form \f$ \mathbf{F}(\mathbf{x}, \mathbf{x}', t) = \mathbf{0} \f$. The
    %> step is based on the following formula:
    %>
    %> \f[
    %> \mathbf{x}_{k+1}(t_{k}+\Delta t) = \mathbf{x}_k(t_{k}) +
    %> \mathcal{S}(\mathbf{x}_k(t_k), \mathbf{x}'_k(t_k), t_k, \Delta t)
    %> \f]
    %>
    %> where \f$ \mathcal{S} \f$ is the generic advancing step of the solver.
    %>
    %> \param x_k     States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
    %> \param x_dot_k States derivative at \f$ k \f$-th time step \f$ \mathbf{x}'
    %>                (t_k) \f$.
    %> \param t_k     Time step \f$ t_k \f$.
    %> \param d_t     Advancing time step \f$ \Delta t\f$.
    %>
    %> \return The approximation of \f$ \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$ and
    %>         \f$ \mathbf{x}'_{k+1}(t_{k}+\Delta t) \f$.
    %
    step( this, x_k, x_dot_k, t_k, d_t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check Butcher tableau consistency for an explicit Runge-Kutta method.
    %>
    %> \param A   Matrix \f$ \mathbf{A} \f$.
    %> \param b   Weights vector \f$ \mathbf{b} \f$.
    %> \param b_e [optional] Embedded weights vector \f$ \hat{\mathbf{b}} \f$
    %>            (row vector).
    %> \param c   Nodes vector \f$ \mathbf{c} \f$.
    %>
    %> \return True if the Butcher tableau is consistent, false otherwise.
    %
    check_tableau( varargin )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
end
