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
classdef BaseRungeKutta < handle
  %
  properties (SetAccess = protected, Hidden = true)
    %
    %> Name of the solver.
    %
    m_name;
    %
    %> Order of the solver.
    %
    m_order;
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
    %> Boolean to check if the method is explicit.
    %
    m_is_explicit;
    %
    %> Boolean to check if the method is embedded.
    %
    m_is_embedded;
    %
    %> Maximum number of substeps.
    %
    m_max_substeps = 5;
    %
    %> Maximum number of iterations in the projection process.
    %
    m_max_projection_iter = 10;
    %
    %> System of ODEs/DAEs to be object handle (fake pointer).
    %
    m_ode;
    %
    %> Non-linear system solver.
    %
    m_newton_solver;
    %
    %> Verbose mode boolean.
    %
    m_verbose = false;
    %
    %> Progress bar boolean.
    %
    m_progress_bar = true;
    %
    %> Projection mode boolean.
    %
    m_projection = false;
    %
    %> Aadaptive step mode boolean.
    %
    m_adaptive_step = false;
    %
    %> Absolute tolerance for adaptive step.
    %
    m_A_tol = 1e-6;
    %
    %> Relative tolerance for adaptive step.
    %
    m_R_tol = 1e-4;
    %
    %> Safety factor for adaptive step.
    %
    m_fac = 0.9;
    %
    %> Minimum safety factor for adaptive step.
    %
    m_fac_min = 0.2;
    %
    %> Maximum safety factor for adaptive step.
    %
    m_fac_max = 1.5;
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor for ODEsolver, which requires the name of the solver
    %> used to integrate the system of ODEs/DAEs as input.
    %>
    %> \param t_name  The name of the solver.
    %> \param t_order Order of the RK method.
    %> \param tbl.A   The matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
    %> \param tbl.b   The weights vector \f$ \mathbf{b} \f$ (row vector).
    %> \param tbl.b_e The embedded weights vector \f$ \hat{\mathbf{b}} \f$ (row
    %>                vector).
    %> \param tbl.c   The nodes vector \f$ \mathbf{c} \f$ (column vector).
    %>
    %> \return An instance of the ODEsolver class.
    %
    function this = BaseRungeKutta( t_name, t_order, tbl )

      % Collect input arguments
      this.m_name          = t_name;
      this.m_order         = t_order;
      this.m_newton_solver = NewtonSolver();

      % Set the Butcher tableau
      this.set_tableau(tbl);
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
    %> Get the order of the method used to integrate the system of ODEs/DAEs.
    %>
    %> \return The order of the solver.
    %
    function t_order = get_order( this )
      t_order = this.m_order;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the order of the method used to integrate the system of ODEs/DAEs.
    %>
    %> \param t_order The order of the solver.
    %
    function set_order( this, t_order )
      this.m_order = t_order;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the system of ODEs/DAEs to be solved.
    %>
    %> \return The system of ODEs/DAEs to be solved.
    %
    function t_ode = get_system( this )
      t_ode = this.m_ode;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the system of ODEs/DAEs to be solved.
    %>
    %> \param t_ode The system of ODEs/DAEs to be solved.
    %
    function set_system( this, t_ode )
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

      CMD = 'indigo::BaseRungeKutta::set_max_substeps(...)';

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

      CMD = 'indigo::BaseRungeKutta::set_max_projection_iter(...)';

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
    %> Get the absolute tolerance for adaptive step.
    %>
    %> \return The absolute tolerance for adaptive step.
    %
    function t_A_tol = get_A_tol( this )
      t_A_tol = this.m_A_tol;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set absolute tolerance for adaptive step.
    %>
    %> \param t_A_tol The absolute tolerance for adaptive step.
    %
    function set_A_tol( this, t_A_tol )
      this.m_A_tol = t_A_tol;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the relative tolerance for adaptive step.
    %>
    %> \return The relative tolerance for adaptive step.
    %
    function t_R_tol = get_R_tol( this )
      t_R_tol = this.m_R_tol;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set relative tolerance for adaptive step.
    %>
    %> \param t_R_tol The relative tolerance for adaptive step.
    %
    function set_R_tol( this, t_R_tol )
      this.m_R_tol = t_R_tol;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the safety factor for adaptive step.
    %>
    %> \return The safety factor for adaptive step.
    %
    function t_fac = get_fac( this )
      t_fac = this.m_fac;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set safety factor for adaptive step.
    %>
    %> \param t_fac The safety factor for adaptive step.
    %
    function set_fac( this, t_fac )
      this.m_fac = t_fac;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the minimum safety factor for adaptive step.
    %>
    %> \return The minimum safety factor for adaptive step.
    %
    function t_min_fac = get_min_fac( this )
      t_min_fac = this.m_min_fac;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the minimum safety factor for adaptive step.
    %>
    %> \param t_min_fac The minimum safety factor for adaptive step.
    %
    function set_min_fac( this, t_min_fac )
      this.m_min_fac = t_min_fac;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the maximum safety factor for adaptive step.
    %>
    %> \return The maximum safety factor for adaptive step.
    %
    function t_max_fac = get_max_fac( this )
      t_max_fac = this.m_max_fac;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the maximum safety factor for adaptive step.
    %>
    %> \param t_max_fac The maximum safety factor for adaptive step.
    %
    function set_max_fac( this, t_max_fac )
      this.m_max_fac = t_max_fac;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Enable verbose mode.
    %
    function enable_verbose( this )
      this.m_verbose      = true;
      this.m_progress_bar = false;
      this.m_newton_solver.enable_verbose();
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Disable verbose mode.
    %
    function disable_verbose( this )
      this.m_verbose = false;
      this.m_progress_bar = false;
      this.m_newton_solver.disable_verbose();
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Enable progress bar.
    %
    function enable_progress_bar( this )
      this.m_progress_bar = true;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Disable progress bar.
    %
    function disable_progress_bar( this )
      this.m_progress_bar = false;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Enable projection mode.
    %
    function enable_projection( this )
      this.m_projection = true;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Disable projection mode.
    %
    function disable_projection( this )
      this.m_projection = false;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Enable adaptive step mode.
    %
    function enable_adaptive_step( this )
      this.m_adaptive_step = true;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Disable adaptive step mode.
    %
    function disable_adaptive_step( this )
      this.m_adaptive_step = false;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the steps of the method used to integrate the system of ODEs/DAEs.
    %>
    %> \return The steps of the solver.
    %
    function out = get_steps( this )
      out = length(this.m_b);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the solver is explicit.
    %>
    %> \return True if the solver is explicit, false otherwise.
    %
    function out = is_explicit( this )
      out = this.m_is_explicit;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the solver is implicit.
    %>
    %> \return True if the solver is implicit, false otherwise.
    %
    function out = is_implicit( this )
      out = ~this.m_is_explicit;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the solver is embedded.
    %>
    %> \return True if the solver is embedded, false otherwise.
    %
    function out = is_embedded( this )
      out = this.m_is_embedded;
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
    function out = get_tableau( this )
      out.A   = this.m_A;
      out.b   = this.m_b;
      out.c   = this.m_c;
      out.b_e = this.m_b_e;
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
    function set_tableau( this, tbl )

      CMD = 'indigo::BaseRungeKutta::set_tableau(...): ';

      % Check the Butcher tableau
      ok = this.check_tableau(tbl);
      assert( ok, [CMD, 'invalid tableau detected.'] );

      % Set the tableau
      this.m_A   = tbl.A;
      this.m_b   = tbl.b;
      this.m_b_e = tbl.b_e;
      this.m_c   = tbl.c;

      % Set boolean flags
      this.m_is_explicit = istril(this.m_A);
      this.m_is_embedded = ~isempty(this.m_b_e);

      % Update the solver properties
      this.m_adaptive_step = this.is_embedded();
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Project the ODEs system solution \f$ \mathbf{x} \f$ on the invariants/hidden
    %> constraints \f$ \mathbf{h} (\mathbf{x}, t) = \mathbf{0} \f$. The constrained
    %> minimization problem to be solved is:
    %>
    %> \f[
    %> \textrm{minimize} \quad
    %> \dfrac{1}{2}\left(\mathbf{x} - \widetilde{\mathbf{x}}\right)^2 \quad
    %> \textrm{subject to} \quad \mathbf{h}(\mathbf{x}, t) = \mathbf{0}.
    %> \f]
    %>
    %> **Solution Algorithm**
    %>
    %> Given the Lagrangian of the minimization problem of the form:
    %>
    %> \f[
    %> \mathcal{L}(\mathbf{x}, \boldsymbol{\lambda}) =
    %> \frac{1}{2}\left(\mathbf{x} - \widetilde{\mathbf{x}}\right)^2 +
    %> \boldsymbol{\lambda} \cdot \mathbf{h}(\mathbf{x}, t).
    %> \f]
    %>
    %> The solution of the problem is obtained by solving the following:
    %>
    %> \f[
    %> \left\{\begin{array}{l}
    %> \mathbf{x} + \mathbf{Jh}_\mathbf{x}^T \boldsymbol{\lambda} =
    %> \widetilde{\mathbf{x}} \\[0.5em]
    %> \mathbf{h}(\mathbf{x}, t) = \mathbf{0}
    %> \end{array}\right.
    %> \f]
    %>
    %> Using the Taylor expansion of the Lagrangian:
    %>
    %> \f[
    %> \mathbf{h}(\mathbf{x}, t) + \mathbf{Jh}_\mathbf{x} \delta\mathbf{x} +
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
    %> -\mathbf{h}(\mathbf{x}, t)
    %> \end{bmatrix}
    %> \f]
    %>
    %> where \f$ \mathbf{Jh}_\mathbf{x} \f$ is the Jacobian of the invariants/
    %> hidden constraints with respect to the states \f$ \mathbf{x} \f$.
    %>
    %> \param x_tilde The initial guess for the states \f$ \widetilde{\mathbf{x}} \f$.
    %> \param t The time \f$ t \f$ at which the states are evaluated.
    %>
    %> \return The solution of the projection problem \f$ \mathbf{x} \f$.
    %
    function x = project( this, x_tilde, t )

      CMD = 'indigo::BaseRungeKutta::project(...): ';

      % Get the number of states, equations and invariants
      num_eqns = this.m_ode.get_num_eqns();
      num_invs = this.m_ode.get_num_invs();
      x        = x_tilde;

      assert(length(x_tilde) == num_eqns, ...
        [CMD, 'the number of states does not match the number of equations.']);

      % Check if there are any constraints
      if (num_invs > 0)

        % Calculate and scale the tolerance
        tolerance = max(1, norm(x_tilde, inf)) * sqrt(eps);

        % Iterate until the projected solution is found
        for k = 1:this.m_max_projection_iter

          %     [A]         {x}    =        {b}
          % / I  Jh^T \ /   dx   \   / x_tilde - x_k \
          % |         | |        | = |               |
          % \ Jh   0  / \ lambda /   \      -h       /

          % Evaluate the invariants/hidden constraints vector and its Jacobian
          h  = this.m_ode.h(x, t);
          Jh = this.m_ode.Jh(x, t);

          % Compute the solution of the linear system
          A   = [eye(num_eqns), Jh.'; ...
                 Jh, zeros(num_invs, num_invs)];
          b   = [x_tilde - x; -h];
          sol = A\b;

          % Update the solution
          dx = sol(1:num_eqns);
          x  = x + dx;

          % Check if the solution is found
          if (max(abs(dx)) < tolerance || max(abs(h)) < tolerance)
            break;
          elseif (k == this.m_max_projection_iter)
            warning([CMD, 'maximum number of iterations reached.']);
          end
        end
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Solve the system of ODEs/DAEs and calculate the approximate solution over
    %> the mesh of time points.
    %>
    %> \param t   Time mesh points \f$ \mathbf{t} = \left[ t_0, t_1, \ldots, t_n
    %>            \right]^T \f$.
    %> \param x_0 Initial states value \f$ \mathbf{x}(t_0) \f$.
    %>
    %> \return A matrix \f$ \left[(\mathrm{size}(\mathbf{x}) \times \mathrm{size}
    %>         (\mathbf{t})\right] \f$ containing the approximated solution
    %>         \f$ \mathbf{x}(t) \f$ and \f$ \mathbf{x}^\prime(t) \f$ of the
    %>         system of ODEs/DAEs.
    %
    function [x_out, x_dot_out, t] = solve( this, t, x_0 )

      CMD = 'indigo::BaseRungeKutta::solve(...): ';

      % Check initial conditions
      num_eqns = this.m_ode.get_num_eqns();
      assert(num_eqns == length(x_0), ...
        [CMD, 'in %s solver, length(x_0) is %d, expected %d.'], ...
        this.m_name, length(x_0), num_eqns);

      % Instantiate output
      x_out      = zeros(num_eqns, length(t));
      x_dot_out  = zeros(num_eqns, length(t));

      % Store first step
      x_out(:,1) = x_0(:);

      % Instantiate temporary variables
      s   = 1;         % Current step
      tol = sqrt(eps); % Tolerance

      % Update the current step
      x_s     = x_out(:,1);
      x_dot_s = x_dot_out(:,1);
      t_s     = t(1);
      d_t_s   = t(2) - t(1);
      d_t_tmp = d_t_s;

      % Start progress bar
      if (this.m_progress_bar)
        progress_bar('_start');
      end

      while (true)
        % Print percentage of solution completion
        if (this.m_progress_bar)
          progress_bar(ceil(100*t_s/t(end)))
        end

        % Integrate system of ODEs/DAEs
        [x_s, x_dot_s, d_t_star] = this.advance(x_s, x_dot_s, t_s, d_t_s);

        % Update the current step
        t_s = t_s + d_t_s;

        % Saturate the suggested timestep
        mesh_point_bool = abs(t_s - t(s+1)) < tol;
        saturation_bool = t_s + d_t_star > t(s+1) + tol;
        if (this.m_adaptive_step && ~mesh_point_bool && saturation_bool)
          d_t_tmp = d_t_star;
          d_t_s   = t(s+1) - t_s;
        else
          d_t_s = d_t_star;
        end

        % Store solution if the step is a mesh point
        if (~this.m_adaptive_step || mesh_point_bool)

          % Update temporaries
          s     = s+1;
          d_t_s = d_t_tmp;

          % Update outputs
          x_out(:,s)     = x_s;
          x_dot_out(:,s) = x_dot_s;

          % Check if the current step is the last one
          if (abs(t_s - t(end)) < tol)
            break;
          end
        end
      end

      % End progress bar
      if (this.m_progress_bar)
        progress_bar(100);
        progress_bar(strcat([this.m_name, ' completed!']));
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Solve the system of ODEs/DAEs and calculate the approximate solution over
    %> the suggested mesh of time points.
    %>
    %> \param t     Time mesh points \f$ \mathbf{t} = \left[ t_0, t_1, \ldots,
    %>              t_n \right]^T \f$.
    %> \param x_0   Initial states value \f$ \mathbf{x}(t_0) \f$.
    %> \param t_min [optional] Minimum timestep \f$ \Delta t_{\mathrm{min}} \f$.
    %> \param t_max [optional] Maximum timestep \f$ \Delta t_{\mathrm{max}} \f$.
    %>
    %> \return A matrix \f$ \left[(\mathrm{size}(\mathbf{x}) \times \mathrm{size}
    %>         (\mathbf{t})\right] \f$ containing the approximated solution
    %>         \f$ \mathbf{x}(t) \f$ and \f$ \mathbf{x}^\prime(t) \f$ of the
    %>         system of ODEs/DAEs.
    %
    function [x_out, x_dot_out, t_out] = solve_adaptive_step( this, t, x_0, varargin )

      CMD = 'indigo::BaseRungeKutta::solve_adaptive(...): ';

      % Collect optional arguments
      d_t = t(2) - t(1);
      if (nargin == 4)
        t_min = 0.5*dt;
        t_max = 1.5*dt;
      elseif (nargin == 5)
        [t_min, t_max] = varargin{1};
      elseif (nargin == 6)
        t_min = varargin{1};
        t_max = varargin{2};
      else
        error([CMD, 'invalid number of inputs detected.']);
      end
      assert(t_max > t_min && t_min > 0, ...
        [CMD, 'invalid time bounds detected.']);
      d_t = max(min(d_t, t_max), t_min);

      % Check initial conditions
      num_eqns = this.m_ode.get_num_eqns();
      assert(num_eqns == length(x_0), ...
        [CMD, 'in %s solver, length(x_0) is %d, expected %d.'], ...
        this.m_name, length(x_0), num_eqns);

      % Instantiate output
      safety_length  = ceil(1.5/f_min)*length(t);
      t_out          = zeros(1, safety_length);
      x_out          = zeros(num_eqns, safety_length);
      x_dot_out      = zeros(num_eqns, safety_length);

      % Store first step
      t_out(1)   = t(1);
      x_out(:,1) = x_0(:);

      % Instantiate temporary variables
      s = 1; % Current step

      % Start progress bar
      if (this.m_progress_bar)
        progress_bar('_start');
      end

      while (true)
        % Print percentage of solution completion
        if (this.m_progress_bar)
          progress_bar(ceil(100*t_s/t(end)))
        end

        % Integrate system of ODEs/DAEs
        [x_new, x_dot_new, d_t_star] = ...
          this.advance(x_out(:,s), x_dot_out(:,s), t_out(s), d_t);

        % Store solution
        t_out(s+1)       = t_out(s) + d_t;
        x_out(:,s+1)     = x_new;
        x_dot_out(:,s+1) = x_dot_new;

        % Saturate the suggested timestep
        d_t = max(min(d_t_star, t_max), t_min);

        % Check if the current step is the last one
        if (t_out(s+1) + d_t > t(end))
          break;
        end

        % Update steps counter
        s = s+1;
      end

      % End progress bar
      if (this.m_progress_bar)
        progress_bar(100);
        progress_bar(strcat([this.m_name, ' completed!']));
      end

      % Resize the output
      t_out     = t_out(:,1:s-1);
      x_out     = x_out(:,1:s-1);
      x_dot_out = x_dot_out(:,1:s-1);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Advance using a generic integration method for a system of ODEs/DAEs of
    %> the form \f$ \mathbf{F}(\mathbf{x}, \mathbf{x}', t) = \mathbf{0} \f$. The
    %> step is based on the following formula:
    %>
    %> \f[
    %> \mathbf{x}_{k+1}(t_{k}+\Delta t) = \mathbf{x}_k(t_{k}) +
    %> \mathcal{S}(\mathbf{x}_k(t_k), \mathbf{x}'_k(t_k), t_k, \Delta t)
    %> \f]
    %>
    %> where \f$ \mathcal{S} \f$ is the generic advancing step of the solver.
    %> In the advvancing step, the system of ODEs/DAEs is also projected on the
    %> manifold \f$ \mathcal{h}(\mathbf{x}, t) \f$. Substepping is also used to
    %> ensure that the solution is accurate.
    %>
    %> \param x_k     States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
    %> \param x_dot_k States derivative at \f$ k \f$-th time step \f$ \mathbf{x}'
    %>                (t_k) \f$.
    %> \param t_k     Time step \f$ t_k \f$.
    %> \param d_t     Advancing time step \f$ \Delta t\f$.
    %>
    %> \return The approximation of \f$ \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$,
    %>         \f$ \mathbf{x}'_{k+1}(t_{k}+\Delta t) \f$ and the suggested time
    %>         step for the next advancing step \f$ \Delta t_{k+1} \f$.
    %
    function [x_new, x_dot_new, d_t_star] = advance( this, x_k, x_dot_k, t_k, d_t )

      CMD = 'indigo::BaseRungeKutta::advance(...): ';

      % Check initial conditions
      num_eqns = this.m_ode.get_num_eqns();
      assert(num_eqns == length(x_k), ...
        [CMD, 'in %s solver, length(x_0) is %d, expected %d.'], ...
        this.m_name, length(x_k), num_eqns);

      % Check step size
      assert(d_t > 0, ...
        [CMD, 'in %s solver, d_t is %f, expected > 0.'], ...
        this.m_name, d_t);

      % Integrate system of ODEs/DAEs
      [x_new, x_dot_new, d_t_star, ierr] = this.step(x_k, x_dot_k, t_k, d_t);

      % If the advance failed, try again with substepping
      if (ierr ~= 0)

        x_tmp     = x_k;
        x_dot_tmp = x_dot_k;
        t_tmp     = t_k;
        d_t_tmp   = 0.5 * d_t;

        max_k = this.m_max_substeps * this.m_max_substeps;
        k = 2;
        while (k > 0)
          % Integrate system of ODEs/DAEs
          [x_tmp, x_dot_tmp, t_tmp, d_t_star_tmp] = ...
            this.step(x_tmp, x_dot_tmp, t_tmp, d_t_tmp);

          % Calculate the next time step with substepping logic
          if (ierr == 0)

            % Accept the step
            d_t_tmp = d_t_star_tmp;

            % If substepping is enabled, double the step size
            if (k > 0 && k < max_k)
              k = k - 1;
              % If the substepping index is even, double the step size
              if (rem(k, 2) == 0)
                d_t_tmp = 2.0 * d_t_tmp;
                if (this.m_verbose)
                  warning([CMD, 'in %s solver, at t = %g, integration ', ...
                    'succedded disable one substepping layer.'], ...
                    this.m_name, t_tmp);
                end
              end
            end

            % Check the infinity norm of the solution
            assert(isfinite(norm(x_tmp, inf)), ...
              [CMD, 'in %s solver, at t = %g, ||x||_inf = inf, computation ', ...
              'interrupted.\n'], ...
              this.m_name, t_tmp);

          else

            % If the substepping index is too high, abort the integration
            k = k + 2;
            assert(k < max_k, ...
              [CMD, 'in %s solver, at t = %g, integration failed ', ...
              '(error code %d) with d_t = %g, aborting.'], ...
              this.m_name, t_tmp, ierr, d_t);

            % Otherwise, try again with a smaller step
            if (this.m_verbose)
              warning([CMD, 'in %s solver, at t = %g, integration failed ', ...
                '(error code %d), adding substepping layer.'], ...
                this.m_name, t_tmp, ierr);
            end
            d_t_tmp = 0.5 * d_t_tmp;
            continue;

          end

          % Store time solution
          t_tmp = t_tmp + d_t_tmp;

          % Project intermediate solution on the invariants/hidden constraints
          if (this.m_projection)
            x_tmp = this.project(x_tmp, t_tmp);
          end
        end

        % Store states solutions
        x_new     = x_tmp;
        x_dot_new = x_dot_tmp;
        d_t_star  = d_t_tmp;
      end
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
    %> h_{new} = h \min \left( f_{max}, \max \left( f_{max}, f \left(
    %>   \dfrac{1}{e} \right)^{\frac{1}{q+1}}
    %> \right) \right)
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
    %>
    %> \return The suggested time step for the next advancing step \f$ \Delta
    %>         t_{k+1} \f$.
    %
    function out = adapt_step( this, x_h, x_l, d_t )

      % Compute the error with 2-norm
      r = (x_h - x_l) ./ (this.m_A_tol + 0.5*this.m_R_tol*(abs(x_h)+abs(x_l)));
      e = norm(r, 2)/length(x_h);

      % Compute the suggested time step
      q   = this.m_order + 1;
      out = d_t * min(this.m_fac_max, max(this.m_fac_min, this.m_fac*(1/e)^(1/q)));
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function info( this )
      fprintf('Runge-Kutta Solver:\t%s\n', this.m_name);
      fprintf('\t- order:\t%d\n',    this.get_order());
      fprintf('\t- steps:\t%d\n',    this.get_order());
      fprintf('\t- explicit:\t%d\n', this.is_explicit());
      fprintf('\t- implicit:\t%d\n', this.is_implicit());
      fprintf('\t- embedded:\t%d\n', this.is_embedded());
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
    %> \param tbl.A   Matrix \f$ \mathbf{A} \f$.
    %> \param tbl.b   Weights vector \f$ \mathbf{b} \f$.
    %> \param tbl.b_e [optional] Embedded weights vector \f$ \hat{\mathbf{b}}
    %>                \f$ (row vector).
    %> \param tbl.c   Nodes vector \f$ \mathbf{c} \f$.
    %>
    %> \return True if the Butcher tableau is consistent, false otherwise.
    %
    check_tableau( tbl )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
end