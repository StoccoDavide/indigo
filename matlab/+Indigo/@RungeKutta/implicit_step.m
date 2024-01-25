%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%> Compute an integration step using the implicit Runge-Kutta method for a
%> system of the form \f$ \mathbf{F}(\mathbf{x}, \mathbf{x}', t) =
%> \mathbf{0} \f$.
%>
%> **Solution Algorithm**
%>
%> Consider a Runge-Kutta method, written for a system of the form
%> \f$ \mathbf{x}' = \mathbf{f}(\mathbf{x}, \mathbf{v}, t) \f$:
%>
%> \f[
%> \begin{array}{l}
%> \mathbf{K}_i = \mathbf{f} \left(
%>   \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{s} a_{ij}
%>   \mathbf{K}_j,
%>   \, t_k + c_i \Delta t
%>   \right), \qquad i = 1, 2, \ldots, s \\
%> \mathbf{x}_{k+1} = \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^s b_j
%> \mathbf{K}_j \, ,
%> \end{array}
%> \f]
%>
%> Then the implicit Runge-Kutta method for an implicit system of the form
%> \f$\mathbf{F}(\mathbf{x}, \mathbf{x}', t) = \mathbf{0} \f$ can be written
%> as:
%>
%> \f[
%> \begin{array}{l}
%> \mathbf{F}_i \left(
%>   \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^s a_{ij}
%>     \mathbf{K}_j, \, \mathbf{K}_i, \, t_k + c_i \Delta t
%> \right) = \mathbf{0}, \qquad i = 1, 2, \ldots, s \\
%> \mathbf{x}_{k+1} = \mathbf{x}_k + \displaystyle\sum_{j=1}^s b_j \mathbf{K}_j.
%> \end{array}
%> \f]
%>
%> Thus, the final system to be solved is the following:
%>
%> \f[
%> \left\{\begin{array}{l}
%> \mathbf{F}_1 \left(
%>   \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^s a_{1j}
%>   \mathbf{K}_j, \, \mathbf{K}_1, \, t_k + c_1 \Delta t
%> \right) = \mathbf{0} \\
%> \mathbf{F}_2 \left(
%>   \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^s a_{2j}
%>   \mathbf{K}_j, \, \mathbf{K}_2, \, t_k + c_2 \Delta t
%> \right) = \mathbf{0} \\
%> ~~ \vdots \\
%> \mathbf{F}_s \left(
%>   \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^s a_{sj}
%>   \mathbf{K}_j, \, \mathbf{K}_s, \, t_k + c_s \Delta t
%> \right) = \mathbf{0}
%> \end{array}\right.
%> \f]
%>
%> The \f$ \mathbf{K} \f$ variables are computed using the Newton's method.
%>
%> The suggested time step for the next advancing step
%> \f$ \Delta t_{k+1} \f$, is the same as the input time step
%> \f$ \Delta t \f$ since in the implicit Runge-Kutta method the time step
%> is not modified through any error control method.
%>
%> \param x_k     States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
%> \param t_k     Time step \f$ t_k \f$.
%> \param d_t     Advancing time step \f$ \Delta t\f$.
%>
%> \return The approximation of the states at \f$ k+1 \f$-th time step \f$
%>         \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$, the approximation of the
%>         states derivatives at \f$ k+1 \f$-th time step
%>         \f$ \mathbf{x}'_{k+1} (t_{k}+\Delta t) \f$, the suggested time
%>         step for the next advancing step \f$ \Delta t_{k+1} \f$, and the
%>         error control flag.
%
function [ x_out, d_t_star, ierr ] = implicit_step( this, x_k, t_k, d_t )

  % Extract lengths
  nc = length(this.m_c);
  nx = length(x_k);

  % Create the intial guess for K
  K0 = zeros( nc * nx, 1);

  % Define the function handles
  fun = @(K) this.implicit_residual(x_k, K, t_k, d_t);
  jac = @(K) this.implicit_jacobian(x_k, K, t_k, d_t);

  % Solve using Newton's method
  [K, ierr] = this.m_newton_solver.solve_handle(fun, jac, K0);

  % Suggested time step for the next advancing step
  d_t_star = d_t;

  % Error code check
  if ierr ~= 0; x_out = x_k; return; end

  % Perform the step and obtain x_k+1
  x_out = x_k + d_t * reshape(K, nx, nc) * this.m_b';

  % Adapt next time step
  if (this.m_adaptive_step)
    x_e = x_k + d_t * reshape(K, nx, nc) * this.m_b_e';
    d_t_star = this.estimate_step( x_out, x_e, d_t_star );
  end
end
