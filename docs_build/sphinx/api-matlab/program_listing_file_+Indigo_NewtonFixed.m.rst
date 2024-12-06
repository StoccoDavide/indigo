
.. _program_listing_file_+Indigo_NewtonFixed.m:

Program Listing for File NewtonFixed.m
======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_NewtonFixed.m>` (``+Indigo/NewtonFixed.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   
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
   classdef NewtonFixed < handle
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
       m_tolerance = 1e-10;
       %
       %> Maximum allowed algorithm iterations.
       %
       m_max_iterations = 50;
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
       %> Function residuals.
       %
       m_residuals = 0.0;
       %
       %> Convergence boolean.
       %
       m_converged = false;
       %
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
       function this = NewtonFixed()
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Set algorithm tolerance.
       %>
       %> \param t_tolerance The algorithm tolerance.
       %
       function set_tolerance( this, t_tolerance )
   
         CMD = 'Indigo.NewtonFixed.set_tolerance(...): ';
   
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
   
         CMD = 'Indigo.NewtonFixed.set_max_iterations(...): ';
   
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
       %> Set Jacobian evaluations.
       %>
       %> \return The Jacobian evaluations.
       %
       function out = out_jacobian_evaluations( this )
         out = this.m_jacobian_evaluations;
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
       %> \param t_jacobian_handle The Jacobian handle.
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
         this.m_function_evaluations = this.m_function_evaluations + 1;
         out = this.m_function_handle(x);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Perform function \f$ \mathbf{JF}(\mathbf{x}) \f$ evaluation.
       %>
       %> \param x The input vector \f$ \mathbf{x} \f$.
       %>
       %> \return The Jacobian value \f$ \mathbf{JF}(\mathbf{x}) \f$.
       %
       function out = eval_jacobian( this, x )
         this.m_jacobian_evaluations = this.m_jacobian_evaluations + 1;
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
       function [x, ierr] = solve( this, x_ini )
   
         CMD = 'Indigo.NewtonFixed.solve(...): ';
   
         % Setup internal variables
         this.reset();
   
         % Algorithm iterations
         this.m_converged = false;
         ierr = 1;
         x    = x_ini;
         for i=1:this.m_max_iterations
           this.m_iterations = i;
   
           if ~all(isfinite(x)); break; end
   
           % Evaluate F
           F = this.eval_function(x);
           if ~all(isfinite(F)); break; end
   
           % Check convergence
           if norm(F, inf) < this.m_tolerance
             ierr             = 0;
             this.m_converged = true;
             break;
           end
   
           % Evaluate JF
           J = this.eval_jacobian(x);
           if ~all(isfinite(J)); break; end
   
           % Evaluate advancing direction
           %D = -J\F;
           %[D, ~] = lsqr(J, -F, 1e-8, 50);
           if (rcond(J) > 1e-14)
             D = -J\F;
           else
             [D, ~] = lsqr(J, -F, 1e-6, 50);
           end
           if ~all(isfinite(D)); break; end
   
           % Update solution
           x = x+D;
           if this.m_verbose
             fprintf(1, '%s iter %d: ||F||_inf = %f, tau = %1.4f.\n', CMD, i, norm(F, inf), tau);
           end
   
           % Check convergence
           %if norm(D,inf) < this.m_tolerance
           %  this.m_converged = true;
           %  break;
           %end
         end
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
   end
