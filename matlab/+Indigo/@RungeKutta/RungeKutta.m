%
%> Class container for Runge-Kutta solvers of the system of Ordinary Differential
%> Equations (ODEs) or Differential Algebraic Equations (DAEs). The user must
%> simply define the Butcher tableau of the solver, which defined as:
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
classdef RungeKutta < handle
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
    %> string with the RK type 'ERK', 'DIRK', 'IRK'
    %
    m_RK_type;
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
    %> Boolean vector to project the corresponding invariants.
    %
    m_projected_invs = [];
    %
    %> System object handle (fake pointer).
    %
    m_sys;
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
    m_safety_factor = 0.9;
    %
    %> Minimum safety factor for adaptive step.
    %
    m_fac_min = 0.2;
    %
    %> Maximum safety factor for adaptive step.
    %
    m_fac_max = 1.5;
    %
    %> Minimum step for advancing
    %
    m_dt_min = 1e-50;
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor that requires the name of the solver used to integrate
    %> the system.
    %>
    %> \param t_name  The name of the solver.
    %> \param t_order Order of the RK method.
    %> \param tbl.A   The matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
    %> \param tbl.b   The weights vector \f$ \mathbf{b} \f$ (row vector).
    %> \param tbl.b_e The embedded weights vector \f$ \hat{\mathbf{b}} \f$ (row
    %>                vector).
    %> \param tbl.c   The nodes vector \f$ \mathbf{c} \f$ (column vector).
    %>
    %> \return An instance of the class.
    %
    function this = RungeKutta( t_name, t_order, tbl )

      % Collect input arguments
      this.m_name          = t_name;
      this.m_order         = t_order;
      this.m_newton_solver = Indigo.NewtonSolver();

      % Set the Butcher tableau
      this.set_tableau(tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the name of the solver used to integrate the system.
    %>
    %> \return The name of the solver.
    %
    function t_name = get_name( this )
      t_name = this.m_name;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the name of the solver used to integrate the system.
    %>
    %> \param t_name The name of the solver.
    %
    function set_name( this, t_name )
      this.m_name = t_name;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the order of the solver used to integrate the system.
    %>
    %> \return The order of the solver.
    %
    function t_order = get_order( this )
      t_order = this.m_order;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the system to be solved.
    %>
    %> \return The system to be solved.
    %
    function t_sys = get_system( this )
      t_sys = this.m_sys;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the system to be solved.
    %>
    %> \param t_sys The system to be solved.
    %
    function set_system( this, t_sys )
      this.m_sys = t_sys;
      this.m_projected_invs = true(this.m_sys.get_num_invs(), 1);
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

      CMD = 'Indigo.RungeKutta.set_max_substeps(...): ';

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

      CMD = 'Indigo.RungeKutta.set_max_projection_iter(...): ';

      assert(t_max_projection_iter > 0, ...
        [CMD, 'invalid maximum number of iterations.']);

      this.m_max_projection_iter = t_max_projection_iter;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get projected invariants boolean vector.
    %>
    %> \return The projected invariants boolean vector.
    %
    function t_projected_invs = get_projected_invs( this )
      t_projected_invs = this.m_projected_invs;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the projected invariants boolean vector.
    %>
    %> \param t_projected_invs The projected invariants boolean vector.
    %
    function set_projected_invs( this, t_projected_invs )

      CMD = 'Indigo.RungeKutta.set_projected_invs(...): ';

      assert(length(t_projected_invs) == this.m_sys.get_num_invs(), ...
        [CMD, 'invalid input detected.']);

      this.m_projected_invs = t_projected_invs;
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
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the safety factor for adaptive step.
    %>
    %> \return The safety factor for adaptive step.
    %
    function t_fac = get_safety_factor( this )
      t_fac = this.m_safety_factor;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set safety factor for adaptive step.
    %>
    %> \param t_fac The safety factor for adaptive step.
    %
    function set_safety_factor( this, t_fac )
      this.m_safety_factor = t_fac;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the minimum safety factor for adaptive step.
    %>
    %> \return The minimum safety factor for adaptive step.
    %
    function t_min_fac = get_min_factor( this )
      t_min_fac = this.m_min_fac;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the minimum safety factor for adaptive step.
    %>
    %> \param t_min_fac The minimum safety factor for adaptive step.
    %
    function set_min_factor( this, t_min_fac )
      this.m_min_fac = t_min_fac;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the maximum safety factor for adaptive step.
    %>
    %> \return The maximum safety factor for adaptive step.
    %
    function t_max_fac = get_max_factor( this )
      t_max_fac = this.m_max_fac;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the maximum safety factor for adaptive step.
    %>
    %> \param t_max_fac The maximum safety factor for adaptive step.
    %
    function set_max_factor( this, t_max_fac )
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
    %> Get the stages number of the solver used to integrate the system.
    %>
    %> \return The stages number of the solver.
    %
    function out = get_stages( this )
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
      out = strcmp(this.m_RK_type,'ERK');
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the solver is implicit.
    %>
    %> \return True if the solver is implicit, false otherwise.
    %
    function out = is_implicit( this )
      out = ~strcmp(this.m_RK_type,'ERK');
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
    set_tableau( this, tbl )
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
    [out, order, e_order] = check_tableau( this, tbl )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    [order,msg] = tableau_order( this, A, b, c )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Project the system initial condition \f$ \mathbf{x} \f$ at time \f$ t \f$
    %> on the invariants \f$ \mathbf{h} (\mathbf{x}, \mathbf{v}, t) = \mathbf{0}
    %> \f$. The constrained minimization is solved through the projection
    %> algorithm described in the project method.
    %>
    %> \param x   The initial guess for the states \f$ \widetilde{\mathbf{x}} \f$.
    %> \param t   The time \f$ t \f$ at which the states are evaluated.
    %> \param x_b [optional] Boolean vector to project the corresponding states
    %>            to be projected (default: all states are projected).
    %>
    %> \return The solution of the projection problem \f$ \mathbf{x} \f$.
    %
    function x = project_initial_conditions( this, x_t, t, varargin )

      CMD = 'Indigo.RungeKutta.project_initial_conditions(...): ';

      if (nargin == 3)
        x = this.do_projection(x_t, t);
      elseif (nargin == 4)
        x = this.do_projection(x_t, t, varargin);
      else
        error([CMD, 'invalid number of input arguments.']);
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    x = do_projection( this, x_t, t, varargin )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    [x_out, x_dot_out, t, v_out, h_out] = solve( this, t, x_0 )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Solve the system and calculate the approximate solution over the
    %> suggested mesh of time points.
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
    %>         system. Additionally, the veils \f$ \mathbf{v}(t) \f$ and
    %>         invariants \f$ \mathbf{h}(\mathbf{x}, \mathbf{v}, t) \f$ are also
    %>         returned.
    %
    function [x_out, x_dot_out, t_out, v_out, h_out] = solve_adaptive_step( this, t, x_0, varargin )

      CMD = 'Indigo.RungeKutta.solve_adaptive(...): ';

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
      num_eqns = this.m_sys.get_num_eqns();
      num_veil = this.m_sys.get_num_veil();
      num_invs = this.m_sys.get_num_invs();
      assert(num_eqns == length(x_0), ...
        [CMD, 'in %s solver, length(x_0) is %d, expected %d.'], ...
        this.m_name, length(x_0), num_eqns);

      % Instantiate output
      safety_length  = ceil(1.5/f_min)*length(t);
      t_out          = zeros(1, safety_length);
      x_out          = zeros(num_eqns, safety_length);
      x_dot_out      = zeros(num_eqns, safety_length);
      v_out          = zeros(num_veil, safety_length);
      h_out          = zeros(num_invs, safety_length);

      % Store first step
      t_out(1)   = t(1);
      x_out(:,1) = x_0(:);
      v_out(:,1) = this.m_sys.v(x_0, t(1));
      h_out(:,1) = this.m_sys.h(x_0, v_out(:,1), t(1));

      % Instantiate temporary variables
      s = 1; % Current step

      % Start progress bar
      if (this.m_progress_bar)
        Indigo.Utils.progress_bar('_start');
      end

      while (true)
        % Print percentage of solution completion
        if (this.m_progress_bar)
          Indigo.Utils.progress_bar(ceil(100*t_s/t(end)))
        end

        % Integrate system
        [x_new, x_dot_new, d_t_star] = ...
          this.do_step(x_out(:,s), x_dot_out(:,s), t_out(s), d_t);

        % Store solution
        t_out(s+1)       = t_out(s) + d_t;
        x_out(:,s+1)     = x_new;
        x_dot_out(:,s+1) = x_dot_new;
        v_out(:,s+1)     = this.m_sys.v(x_new, t_out(s+1));
        h_out(:,s+1)     = this.m_sys.h(x_new, v_out(:,s+1), t_out(s+1));

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
        Indigo.Utils.progress_bar(100);
        if (this.m_projection)
          bar_str = strcat(['Projected-', this.m_name, ' completed!']);
        else
          bar_str = strcat([this.m_name, ' completed!']);
        end
        Indigo.Utils.progress_bar(bar_str);
      end

      % Resize the output
      t_out     = t_out(:,1:s-1);
      x_out     = x_out(:,1:s-1);
      x_dot_out = x_dot_out(:,1:s-1);
      v_out     = v_out(:,1:s-1);
      h_out     = h_out(:,1:s-1);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    [x_new, x_dot_new, d_t_star] = do_step( this, x_k, x_dot_k, t_k, d_t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    out = estimate_step( this, x_h, x_l, d_t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function info( this )
      fprintf('Runge-Kutta method:\t%s\n', this.m_name);
      fprintf('\t- order:\t%d\n',    this.get_order());
      fprintf('\t- stages:\t%d\n',   this.get_stages());
      fprintf('\t- explicit:\t%d\n', this.is_explicit());
      fprintf('\t- implicit:\t%d\n', this.is_implicit());
      fprintf('\t- embedded:\t%d\n', this.is_embedded());
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute a step using a generic integration method for a system of the
    %> form \f$ \mathbf{F}(\mathbf{x}, \mathbf{x}', \mathbf{v}, t) = \mathbf{0}
    %> \f$. The step is based on the following formula:
    %>
    %> \f[
    %> \mathbf{x}_{k+1}(t_{k}+\Delta t) = \mathbf{x}_k(t_{k}) +
    %> \mathcal{S}(\mathbf{x}_k(t_k), \mathbf{x}'_k(t_k), t_k, \Delta t)
    %> \f]
    %>
    %> where \f$ \mathcal{S} \f$ is the generic advancing step of the solver.
    %>
    %> \param x_k     States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
    %> \param t_k     Time step \f$ t_k \f$.
    %> \param d_t     Advancing time step \f$ \Delta t\f$.
    %>
    %> \return The approximation of \f$ \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$ and
    %>         \f$ \mathbf{x}'_{k+1}(t_{k}+\Delta t) \f$.
    %
    function [ x_out, d_t_star, ierr ] = step( this, x_k, t_k, d_t )
      if this.is_explicit() && this.m_sys.is_explicit()
        [x_out, d_t_star, ierr] = this.explicit_step(x_k, t_k, d_t);
      else
        [x_out, d_t_star, ierr] = this.implicit_step(x_k, t_k, d_t);
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    K = explicit_K( this, x_k, t_k, d_t )
    out = implicit_jacobian( this, x_k, K, t_k, d_t )
    out = implicit_residual( this, x_k, K, t_k, d_t )
    [ x_out, d_t_star, ierr ] = explicit_step( this, x_k, t_k, d_t )
    [ x_out, d_t_star, ierr ] = implicit_step( this, x_k, t_k, d_t )
  end
end
