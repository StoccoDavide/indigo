
.. _program_listing_file_+Indigo_@RungeKutta_advance.m:

Program Listing for File advance.m
==================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_@RungeKutta_advance.m>` (``+Indigo/@RungeKutta/advance.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %> Advance using a generic integration method for a system of the form
   %> \f$ \mathbf{F}(\mathbf{x}, \mathbf{x}', \mathbf{v}, t) = \mathbf{0} \f$.
   %> The step is based on the following formula:
   %>
   %> \f[
   %> \mathbf{x}_{k+1}(t_{k}+\Delta t) = \mathbf{x}_k(t_{k}) +
   %> \mathcal{S}(\mathbf{x}_k(t_k), \mathbf{x}'_k(t_k), t_k, \Delta t)
   %> \f]
   %>
   %> where \f$ \mathcal{S} \f$ is the generic advancing step of the solver.
   %> In the advvancing step, the system solution is also projected on the
   %> manifold \f$ \mathcal{h}(\mathbf{x}, \mathbf{v}, t) \f$. Substepping is
   %> also used to ensure that the solution is accurate.
   %>
   %> \param x_k States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
   %> \param t_k Time step \f$ t_k \f$.
   %> \param d_t Advancing time step \f$ \Delta t\f$.
   %>
   %> \return The approximation of \f$ \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$,
   %>         \f$ \mathbf{x}'_{k+1}(t_{k}+\Delta t) \f$ and the suggested time
   %>         step for the next advancing step \f$ \Delta t_{k+1} \f$.
   %
   function [x_new, d_t_star, ierr] = advance( this, x_k, t_k, d_t )
   
     CMD = 'Indigo.RungeKutta.advance(...): ';
   
     % Check initial conditions
     num_eqns = this.m_sys.get_num_eqns();
     assert(num_eqns == length(x_k), ...
       [CMD, 'in %s solver, length(x_0) is %d, expected %d.'], ...
       this.m_name, length(x_k), num_eqns);
   
     % Check step size
     assert(d_t > 0, ...
       [CMD, 'in %s solver, d_t is %f, expected > 0.'], ...
       this.m_name, d_t);
   
     % Integrate system
     [x_new, d_t_star, ierr] = this.step( x_k, t_k, d_t );
   
     % If the advance failed, try again with substepping
     if (ierr ~= 0)
   
       x_tmp   = x_k;
       t_tmp   = t_k;
       d_t_tmp = 0.5 * d_t;
   
       max_k = this.m_max_substeps * this.m_max_substeps;
       k = 2;
       while (k > 0)
         % Integrate system
         [x_tmp, d_t_star_tmp, ierr] = this.step(x_tmp, t_tmp, d_t_tmp);
   
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
       end
   
       % Store output states substepping solutions
       x_new    = x_tmp;
       d_t_star = d_t_tmp;
     end
   
     % Project intermediate solution on the invariants
     if (this.m_projection)
       x_new = this.project(x_new, t_k+d_t);
     end
   end
   %
