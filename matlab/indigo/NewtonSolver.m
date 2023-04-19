
%
%> Class container for a dumped Newton's method with affine invariant step.
%>
%> **Solution Algorithm:**
%>
%> Given a zeros of a vectorial function problem of the form \f$ \mathbf{F}
%> (\mathbf{x}) = \mathbf{0} \f$, where \f$ \mathbf{F}: \mathbb{R}^n \rightarrow
%> \mathbb{R}^n \f$, then the Newton's method is defined as:
%>
%> \f[
%> \mathbf{JF}(\mathbf{x}_k)\mathbf{h} = -\mathbf{F}(\mathbf{x}_k).
%> \f]
%>
%> The dumped step is defined as:
%>
%> \f[
%> \mathbf{x}_{k+1} = \mathbf{x}_k + \alpha_k \mathbf{h}
%> \f]
%>
%> where \f$ \alpha_k \f$ is a dumping coefficient that satisfies:
%>
%> \f[
%> \left\| \mathbf{JF}(\mathbf{x}_k)^{-1} \mathbf{F}(\mathbf{x}_{k+1}) \right\|
%> \leq \left(1 - \dfrac{\alpha_k}{2}\right) \left\| \mathbf{JF}(\mathbf{x}_k)^{-1}
%> \mathbf{F}(\mathbf{x}_k) \right\| = \left(1 - \dfrac{\alpha_k}{2} \right)
%> \left\| \mathbf{h}  \right\|.
%> \f]
%>
%> **Note:**
%>
%> For more details on the Newton's method with affine invariant step refer to:
%> https://www.zib.de/deuflhard/research/algorithm/ainewton.en.html.
%
classdef NewtonSolver < handle
  %
  properties (Access = private)
    %
    %> Function handle.
    %
    m_function_handle;
    %
    %> Jacobian handle.
    %
    m_jacobian_handle;
    %
    %> Algorithm tolerance.
    %
    m_tolerance = 1.0e-8;
    %
    %> Maximum allowed algorithm iterations.
    %
    m_max_iterations = 25;
    %
    %> Maximum allowed function evaluations.
    %
    m_max_function_evaluations = 50;
    %
    %> Maximum allowed jacobian evaluations.
    %
    m_max_jacobian_evaluations = 25;
    %
    %> Maximum allowed algorithm relaxations.
    %
    m_max_relaxations = 10;
    %
    %> Verbose mode boolean.
    %
    m_verbose = false;
    %
    %> Algorithm iterations.
    %
    m_iterations = 0;
    %
    %> Function evaluations.
    %
    m_function_evaluations = 0;
    %
    %> Jacobian evaluations.
    %
    m_jacobian_evaluations = 0;
    %
    %> Algorithm relaxations.
    %
    m_relaxations = 0;
    %
    %> Function residuals.
    %
    m_residuals = 0.0;
    %
    %> Convergence boolean.
    %
    m_converged = false;
    %
    %> Relaxation factor.
    %
    m_alpha = 0.9;
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Newton's solver class constructor.
    %>
    %> \return The Newton's solver object.
    %
    function this = NewtonSolver()
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set algorithm tolerance.
    %>
    %> \param t_tolerance The algorithm tolerance.
    %
    function set_tolerance( this, t_tolerance )

      CMD = 'indigo::NewtonSolver::set_tolerance(...): ';

      assert( ...
        ~isnan(t_tolerance) && ...
        isfinite(t_tolerance) && ...
        t_tolerance > 0.0, ...
        [CMD, 'invalid input detected.']);

      this.m_tolerance = t_tolerance;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get algorithm tolerance.
    %>
    %> \return The algorithm tolerance.
    %
    function out = get_tolerance( this )
      out = this.m_tolerance;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set maximum allowed algorithm iterations.
    %>
    %> \param t_max_iterations The maximum allowed algorithm iterations.
    %
    function set_max_iterations( this, t_max_iterations )

      CMD = 'indigo::NewtonSolver::set_max_iterations(...): ';

      assert( ...
        ~isnan(t_max_iterations) && ...
        isfinite(t_max_iterations) && ...
        t_max_iterations > 0, ...
        [CMD, 'invalid input detected.']);

      this.m_max_iterations = t_max_iterations;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set maximum allowed algorithm iterations.
    %>
    %> \return The maximum allowed algorithm iterations.
    %
    function out = get_max_iterations( this )
      out = this.m_max_iterations;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set maximum allowed function evaluations.
    %>
    %> \param t_max_evaluations The maximum allowed function evaluations.
    %
    function set_max_function_evaluations( this, t_max_function_evaluations )

      CMD = 'indigo::NewtonSolver::set_max_function_evaluations(...): ';

      assert( ...
        ~isnan(t_max_function_evaluations) && ...
        isfinite(t_max_function_evaluations) && ...
        t_max_function_evaluations > 0, ...
        [CMD, 'invalid input detected.']);

      this.m_max_function_evaluations = t_max_function_evaluations;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get maximum allowed function evaluations.
    %>
    %> \return The maximum allowed function evaluations.
    %
    function out = get_max_function_evaluations( this )
      out = this.m_max_function_evaluations;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set maximum allowed jacobian evaluations.
    %>
    %> \param t_max_evaluations The maximum allowed jacobian evaluations.
    %
    function set_max_jacobian_evaluations( this, t_max_jacobian_evaluations )

      CMD = 'indigo::NewtonSolver::set_max_jacobian_evaluations(...): ';

      assert( ...
        ~isnan(t_max_jacobian_evaluations) && ...
        isfinite(t_max_jacobian_evaluations) && ...
        t_max_jacobian_evaluations > 0, ...
        [CMD, 'invalid input detected.']);

      this.m_max_jacobian_evaluations = t_max_jacobian_evaluations;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get maximum allowed jacobian evaluations.
    %>
    %> \return The maximum allowed jacobian evaluations.
    %
    function out = get_max_jacobian_evaluations( this )
      out = this.m_max_jacobian_evaluations;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set maximum allowed algorithm relaxations.
    %>
    %> \param t_max_relaxations The maximum allowed algorithm relaxations.
    %
    function set_max_relaxations( this, t_max_relaxations )

      CMD = 'indigo::NewtonSolver::set_max_relaxations(...): ';

      assert( ...
        ~isnan(t_max_relaxations) && ...
        isfinite(t_max_relaxations) && ...
        t_max_relaxations > 0, ...
        [CMD, 'invalid input detected.']);

      this.m_max_evaluations = t_max_relaxations;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get maximum allowed algorithm relaxations.
    %>
    %> \return The maximum allowed algorithm relaxations.
    %
    function out = get_max_relaxations( this )
      out = this.m_max_relaxations;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set relaxation factor.
    %>
    %> \param t_alpha The relaxation factor.
    %
    function set_alpha( this, t_alpha )

      CMD = 'indigo::NewtonSolver::set_alpha(...): ';

      assert(~isnan(t_alpha) && isfinite(t_alpha) && 0.0 < t_alpha && t_alpha < 1.0, ...
        [CMD, 'invalid input detected.']);

      this.m_alpha = t_alpha;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get relaxation factor.
    %>
    %> \return The relaxation factor.
    %
    function out = get_alpha( this )
      out = this.m_alpha;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Enable verbose mode.
    %>
    %> \param t_alpha The relaxation factor.
    %
    function enable_verbose( this )
      this.m_verbose = true;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Disable verbose mode.
    %>
    %> \param t_alpha The relaxation factor.
    %
    function disable_verbose( this )
      this.m_verbose = false;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get algorithm iterations.
    %>
    %> \return The algorithm iterations.
    %
    function out = out_iterations( this )
      out = this.m_iterations;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set function evaluations.
    %>
    %> \return The function evaluations.
    %
    function out = out_function_evaluations( this )
      out = this.m_function_evaluations;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set jacobian evaluations.
    %>
    %> \return The jacobian evaluations.
    %
    function out = out_jacobian_evaluations( this )
      out = this.m_jacobian_evaluations;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get algorithm relaxations.
    %>
    %> \return The algorithm relaxations.
    %
    function out = out_relaxations( this )
      out = this.m_relaxations;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get function evaluations.
    %>
    %> \return The function evaluations.
    %
    function out = out_residuals( this )
      out = this.m_residuals;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get convergence boolean value.
    %>
    %> \return The convergence boolean value.
    %
    function out = out_converged( this )
      out = this.m_converged;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Solve non-linear system of equations \f$ \mathbf{F}(\mathbf{x}) =
    %> \mathbf{0} \f$
    %>
    %> \param t_function_handle The function handle.
    %> \param t_jacobian_handle The jacobian handle.
    %> \param x_ini             The initial guess vector \f$ \mathbf{x} \f$.
    %>
    %> \return The solution vector \f$ \mathbf{x} \f$.
    %
    function [out, ierr] = solve_handle( this, t_function_handle, t_jacobian_handle, x_ini )
      this.m_function_handle = t_function_handle;
      this.m_jacobian_handle = t_jacobian_handle;
      [out, ierr] = this.solve(x_ini);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Reset solver internal counter and variables.
    %>
    %> \param t_function_handle The function handle.
    %
    function reset( this )
      this.m_iterations           = 0;
      this.m_function_evaluations = 0;
      this.m_jacobian_evaluations = 0;
      this.m_relaxations          = 0;
      this.m_residuals            = 0.0;
      this.m_converged            = false;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Perform function \f$ \mathbf{F}(\mathbf{x}) \f$ evaluation.
    %>
    %> \param x The input vector \f$ \mathbf{x} \f$.
    %>
    %> \return The function value \f$ \mathbf{F}(\mathbf{x}) \f$.
    %
    function out = eval_function( this, x )

      CMD = 'indigo::NewtonSolver::eval_function(...): ';

      this.m_function_evaluations = this.m_function_evaluations + 1;

      assert( this.m_function_evaluations <= this.m_max_function_evaluations, ...
        [CMD, 'maximum number of function evaluations reached.']);

      out = this.m_function_handle(x);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Perform function \f$ \mathbf{JF}(\mathbf{x}) \f$ evaluation.
    %>
    %> \param x The input vector \f$ \mathbf{x} \f$.
    %>
    %> \return The jacobian value \f$ \mathbf{JF}(\mathbf{x}) \f$.
    %
    function out = eval_jacobian( this, x )

      CMD = 'indigo::NewtonSolver::eval_jacobian(...): ';

      this.m_jacobian_evaluations = this.m_jacobian_evaluations + 1;

      assert( this.m_jacobian_evaluations <= this.m_max_jacobian_evaluations, ...
        [CMD, 'maximum number of jacobian evaluations reached.']);

      out = this.m_jacobian_handle(x);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Solve non-linear system of equations \f$ \mathbf{F} (\mathbf{x}) =
    %> \mathbf{0} \f$.
    %>
    %> \param x_ini The initial guess for the vector \f$ \mathbf{x} \f$.
    %>
    %> \return The solution \f$ \mathbf{x} \f$ and the output flag:
    %>         \f$ 0 \f$ = success,
    %>         \f$ 1 \f$ = failed because of bad initial point,
    %>         \f$ 2 \f$ = failed because of bad dumping (step got too short).
    %
    function [out, ierr] = solve( this, x_ini )

      CMD = 'indigo::NewtonSolver::solve(...): ';

      % Setup internal variables
      this.reset();

      % Set initial iteration
      ierr = 0;
      out  = x_ini;
      if (any(isnan(x_ini)))
        fprintf(1, [CMD, 'bad initial point.\n']) ;
        ierr = 1;
        return;
      end

      % Algorithm iterations
      this.m_converged = false;
      x = x_ini;
      for i = 1:this.m_max_iterations
        this.m_iterations = i;

        % Evaluate advancing direction
        F = this.eval_function(x);
        J = this.eval_jacobian(x);
        D = -J\F;

        % Check convergence
        if (norm(F, inf) < this.m_tolerance)
          this.m_converged = true;
          break;
        end

        % Relax the iteration process
        tau    = 1.0;
        dumped = false;
        for j = 1:this.m_max_relaxations
          this.m_relaxations = j;

          % Update point
          x_dump = x + tau * D;
          F_dump = this.eval_function(x_dump);
          D_dump = -J\F_dump;

          % Check relaxation convergence
          if (norm(D_dump, 2) < (1.0-tau/2.0) * norm(D, 2))
            dumped = true;
            break;
          else
            tau = tau * this.m_alpha;
          end
        end

        % Check if dumping failed
        if (dumped == false)
          if (this.m_verbose == true)
            fprintf(1, [CMD, 'tau = %d, failed dumping iteration.\n'], tau);
          end
          ierr = 2;
          break;
        end

        % Update solution
        x   = x_dump;
        out = x;
        if (this.m_verbose == true)
          fprintf(1, [CMD, 'iter %d: ||F||_inf = %f, tau = %1.4f.\n'], ...
            i, norm(F, inf), tau);
        end

        % Check if converged
        if (norm(D, inf) < this.m_tolerance)
          return;
        end
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
end
