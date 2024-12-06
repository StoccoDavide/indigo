
.. _program_listing_file_+Indigo_@RungeKutta_estimate_step.m:

Program Listing for File estimate_step.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_@RungeKutta_estimate_step.m>` (``+Indigo/@RungeKutta/estimate_step.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

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
   function out = estimate_step( this, x_h, x_l, d_t )
   
     CMD = "Indigo.RungeKutta.estimate_step(...): ";
   
     assert(length(x_h) == length(x_l), ...
       [CMD, "x_h and x_l must have the same length"]);
   
     % Compute the error with 2-norm
     r = (x_h - x_l) ./ (this.m_A_tol + this.m_R_tol*max(abs(x_h), abs(x_l)));
     e = max(abs(r));
   
     % Compute the suggested time step
     q   = this.m_order + 1;
     out = d_t * min(this.m_factor_max, max( ...
       this.m_factor_min, this.m_safety_factor*(1/e)^(1/q) ...
     ));
   end
