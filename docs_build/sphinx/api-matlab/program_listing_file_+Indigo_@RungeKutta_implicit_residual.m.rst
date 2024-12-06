
.. _program_listing_file_+Indigo_@RungeKutta_implicit_residual.m:

Program Listing for File implicit_residual.m
============================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_@RungeKutta_implicit_residual.m>` (``+Indigo/@RungeKutta/implicit_residual.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %> Compute the residual of system to be solved:
   %>
   %> \f[
   %> \mathbf{F}_i\left(\mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{s}
   %>   a_{ij} \mathbf{K}_j, \, \mathbf{K}_i, \, t_k + c_i \Delta t
   %> \right) = \mathbf{0}.
   %> \f]
   %>
   %> \param x_k States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
   %> \param K   Variable \f$ \mathbf{K} \f$ of the system to be solved.
   %> \param t_k Time step \f$ t_k \f$.
   %> \param d_t Advancing time step \f$ \Delta t\f$.
   %>
   %> \return The residual of system to be solved.
   %
   function out = implicit_residual( this, x_k, K_in, t_k, d_t )
   
     % Extract lengths
     nc = length(this.m_c);
     nx = length(x_k);
     K  = reshape(K_in, nx, nc);
   
     % Loop through each equation of the system
     res = zeros(nx, nc);
     for i = 1:nc
       t_i = t_k + this.m_c(i) * d_t;
       x_i = x_k + K * this.m_A(i,:).';
       v_i = this.m_sys.v(x_i, t_i);
       y_i = this.m_sys.y(x_i, v_i, t_i);
       res(:,i) = this.m_sys.F(x_i, K(:,i)./d_t, y_i, v_i, t_i);
     end
     out = reshape(res, nc*nx, 1);
   end
