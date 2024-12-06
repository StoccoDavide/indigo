
.. _program_listing_file_+Indigo_@RungeKutta_explicit_step.m:

Program Listing for File explicit_step.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_@RungeKutta_explicit_step.m>` (``+Indigo/@RungeKutta/explicit_step.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %> Compute an integration step using the explicit Runge-Kutta method for a
   %> system of the form \f$ \mathbf{F}(\mathbf{x}, \mathbf{x}', \mathbf{v}, t)
   %> = \mathbf{0} \f$.
   %>
   %> **Solution Algorithm**
   %>
   %> Consider a Runge-Kutta method, written for a system of the
   %> form \f$ \mathbf{x}' = \mathbf{f}(\mathbf{x}, \mathbf{v}, t) \f$:
   %>
   %> \f[
   %> \begin{array}{l}
   %> \mathbf{K}_i = \mathbf{f} \left(
   %>   \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{s} a_{ij} \mathbf{K}_j,
   %>   \, t_k + c_i \Delta t
   %>   \right), \qquad i = 1, 2, \ldots, s \\
   %> \mathbf{x}_{k+1} = \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^s b_j
   %> \mathbf{K}_j \, ,
   %> \end{array}
   %> \f]
   %>
   %> Beacuse of the nature of the matrix \f$ \mathbf{A} \f$ (lower triangular)
   %> the \f$ s\f$ stages for a generic explicit Runge-Kutta method take the
   %> form:
   %>
   %> \f[
   %> \mathbf{K}_i = \mathbf{f} \left(
   %>   \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{i-1} a_{ij}
   %>   \mathbf{K}_j, \, t_k + c_i \Delta t
   %>   \right), \qquad i = 1, 2, \ldots, s.
   %> \f]
   %>
   %> Then the explicit Runge-Kutta method for an implicit system of the form
   %> \f$\mathbf{F}(\mathbf{x}, \mathbf{x}', t) = \mathbf{0} \f$ can be
   %> written as:
   %>
   %> \f[
   %> \begin{array}{l}
   %> \mathbf{F}_i \left(
   %>   \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{i-1} a_{ij}
   %>     \mathbf{K}_j, \, \mathbf{K}_i, \, t_k + c_i \Delta t
   %> \right) = \mathbf{0}, \qquad i = 1, 2, \ldots, s \\
   %> \mathbf{x}_{k+1} = \mathbf{x}_k + \displaystyle\sum_{j=1}^s b_j \mathbf{K}_j.
   %> \end{array}
   %> \f]
   %>
   %> It is important to notice that the system of \f$ s \f$ equations
   %> \f$ \mathbf{F}_i \f$ is a triangular system (which may be non-linear in
   %> the \f$ \mathbf{K}_i \f$ variables), so it can be solved using forward
   %> substitution and the solution of the system is the vector \f$ \mathbf{K}
   %> \f$. Thus, the final system to be solved is the following:
   %>
   %> \f[
   %> \left\{\begin{array}{l}
   %> \mathbf{F}_1 \left(
   %>   \mathbf{x}_k, \, \mathbf{K}_1, \, t_k + c_1 \Delta t
   %> \right) = \mathbf{0} \\
   %> \mathbf{F}_2 \left(
   %>   \mathbf{x}_k + \Delta t \, a_{21} \mathbf{K}_1, \,
   %>   \mathbf{K}_2, \, t_k + c_2 \Delta t
   %> \right) = \mathbf{0} \\
   %> ~~ \vdots \\
   %> \mathbf{F}_s \left(
   %>   \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{s-1} a_{sj}
   %>   \mathbf{K}_j, \, \mathbf{K}_s, \, t_k + c_s \Delta t
   %> \right) = \mathbf{0}
   %> \end{array}\right.
   %> \f]
   %>
   %> The \f$ \mathbf{K}_i \f$ variable are computed using the Newton's method.
   %>
   %> **Note**
   %>
   %> Another approach is to directly solve the whole system of equations by
   %> Newton'smethod. In other words, the system of equations is solved
   %> iteratively by computing the Jacobian matrixes of the system and using
   %> them to compute the solution. This approach is used in the implicit
   %> Runge-Kutta method. For this reason, a Butcher tableau relative to an
   %> explicit Runge-Kutta method can also be used in the `ImplicitRungeKutta` class.
   %>
   %> The suggested time step for the next advancing step \f$ \Delta t_{k+1} \f$,
   %> is the same as the input time step \f$ \Delta t \f$ since in the explicit
   %> Runge-Kutta method the time step is not modified through any error control
   %> method.
   %>
   %> \param x_k States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
   %> \param t_k Time step \f$ t_k \f$.
   %> \param d_t Advancing time step \f$ \Delta t\f$.
   %>
   %> \return The approximation of the states at \f$ k+1 \f$-th time step \f$
   %>         \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$, the suggested time step for the
   %>          next advancing step \f$ \Delta t_{k+1} \f$, and the error control flag.
   %
   function [x_out, d_t_star, ierr] = explicit_step( this, x_k, t_k, d_t )
   
     % No error and default x_out and suggested time step for the next advancing step
     ierr     = 0;
     d_t_star = d_t;
     x_out    = x_k;
   
     % Solve the system to obtain K
     K = this.explicit_K( x_k, t_k, d_t );
   
     % Check for errors
     if ~all(isfinite(K))
       ierr = 1;
       return;
     end
   
     % Perform the step and obtain x_k+1
     x_out = x_k + K * this.m_b';
   
     % Adapt next time step
     if this.m_adaptive_step && this.m_is_embedded
       x_e      = x_k + K * this.m_b_e';
       d_t_star = this.estimate_step( x_out, x_e, d_t );
     end
   end
