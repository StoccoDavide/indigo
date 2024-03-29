%
%> Class implementing the abstract function step for the implicit Runge-Kutta
%> integration method. The user must simply define the Butcher tableau of the
%> method, which is defined as:
%>
%> \f[
%> \begin{array}{c|c}
%>   \mathbf{c} & \mathbf{A} \\ \hline
%>              & \mathbf{b} \\
%>              & \hat{\mathbf{b}}
%> \end{array}
%> \f]
%>
%> where \f$ \mathbf{A} \f$ is the Runge-Kutta matrix:
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
%> \f$ \mathbf{b} \f$ is the Runge-Kutta weights vector (row vector):
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
classdef Indigo_ImplicitRungeKutta < Indigo_BaseRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Initialize the class with the implicit Runge-Kutta method name and its
    %> Butcher tableau.
    %>
    %> \param name    The name of the solver.
    %> \param order   The order of the scheme.
    %> \param tbl.A   The matrix \f$ \mathbf{A} \f$.
    %> \param tbl.b   The weights vector \f$ \mathbf{b} \f$ (row vector).
    %> \param tbl.b_e [optional] The embedded weights vector \f$ \hat{\mathbf{b}}
    %>                \f$ (row vector).
    %> \param tbl.c   The nodes vector \f$ \mathbf{c} \f$ (column vector).
    %>
    %> \return The instance of the ImplicitRungeKutta class.
    %
    function this = Indigo_ImplicitRungeKutta( name, order, tbl )
      % Call the superclass constructor
      this@Indigo_BaseRungeKutta(name, order, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute the left hand side of the ODEs system to be solved:
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
    %> \return The residual of the ODEs system to be solved.
    %
    function out = step_residual( this, x_k, K, t_k, d_t )

      % Extract lengths
      nc = length(this.m_c);
      nx = length(x_k);

      % There are as many residuals as equations in the system
      out = zeros(nc*nx, 1);

      % Loop through each equation of the system
      idx = 1:nx;
      for i = 1:nc
        % Compute x_k + sum(a_ij*Kj, j)
        tmp = x_k;
        jdx = 1:nx;
        for j = 1:nc
          tmp = tmp + d_t * this.m_A(i,j) * K(jdx);
          jdx = jdx + nx;
        end

        % Compute the residuals
        out(idx) = this.m_ode.F(tmp, K(idx), t_k + this.m_c(i) * d_t);
        idx = idx + nx;
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute the Jacobian of the ODEs system of equations:
    %>
    %> \f[
    %> \mathbf{F}_i\left(\mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^s
    %>   a_{ij} \mathbf{K}_j, \, \mathbf{K}_i, \, t_k + c_i \Delta t
    %> \right) = \mathbf{0}
    %> \f]
    %>
    %> to be solved in the \f$ \mathbf{K} \f$ variable:
    %>
    %> \f[
    %> \dfrac{\partial \mathbf{F}_i}{\partial \mathbf{K}_i} \left(
    %>   \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^s a_{ij} \mathbf{K}_j,
    %>   \, \mathbf{K}_i, \, t_k + c_i \Delta t
    %> \right)
    %> \f]
    %>
    %> \param i   Index of the step to be computed.
    %> \param x_i States value at \f$ i \f$-th node.
    %> \param K   Variable \f$ \mathbf{K} \f$ of the system to be solved.
    %> \param t_k Time step \f$ t_k \f$.
    %> \param d_t Advancing time step \f$ \Delta t\f$.
    %>
    %> \return The Jacobian of the ODEs system of equations to be solved.
    %
    function out = step_jacobian( this, x_k, K, t_k, d_t )

      % Extract lengths
      nc = length(this.m_c);
      nx = length(x_k);

      % The Jacobian is a square nc*nx (i.e., length(K)) matrix
      out = eye(nc*nx);

      % Loop through each equation of the system
      idx = 1:nx;
      for i = 1:nc
        % Compute x_k + sum(a_ij*Kj, j)
        tmp = x_k;
        jdx = 1:nx;
        for j = 1:nc
          tmp = tmp + d_t * this.m_A(i,j) * K(jdx);
          jdx = jdx + nx;
        end
        jdx = 1:nx;
        for j = 1:nc
          % Mask for the Jacobian with respect to x_dot
          mask = 0;
          if (i == j)
            mask = 1;
          end

          % Compute the Jacobians with respect to x and x_dot
          t_tmp    = t_k + d_t * this.m_c(i);
          JF_x     = this.m_ode.JF_x(tmp, K(idx), t_tmp);
          JF_x_dot = this.m_ode.JF_x_dot(tmp, K(idx), t_tmp);

          % Combine the Jacobians with respect to x and x_dot to obtain the
          % Jacobian with respect to K
          out(idx, jdx) = d_t * this.m_A(i,j) * JF_x  + JF_x_dot * mask;

          jdx = jdx + nx;
        end
        idx = idx + nx;
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Solve the \f$ i \f$-th implicit step of the ODEs system to find the
    %> \f$ \mathbf{K} \f$ variables:
    %>
    %> \f[
    %> \mathbf{F}_i\left(\mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^s
    %>   a_{ij} \mathbf{K}_j, \, \mathbf{K}_i, \, t_k + c_i \Delta t
    %> \right) = \mathbf{0}
    %> \f]
    %>
    %> by Newton's method.
    %>
    %> \param x_k States value at \f$ k \f$-th time step \f$
    %>            \mathbf{x}(t_k) \f$.
    %> \param K   Initial guess for the \f$ \mathbf{K} \f$ variables to be
    %>            found.
    %> \param t_k Time step \f$ t_k \f$.
    %> \param d_t Advancing time step \f$ \Delta t\f$.
    %>
    %> \return The \f$ \mathbf{K} \f$ variables of the ODEs system to be solved
    %>         and the error control flag.
    %
    function [out, ierr] = solve_step( this, x_k, K0, t_k, d_t )

      % Define the function handles
      fun = @(K) this.step_residual(x_k, K, t_k, d_t);
      jac = @(K) this.step_jacobian(x_k, K, t_k, d_t);

      % Solve using Newton's method
      [out, ierr] = this.m_newton_solver.solve_handle(fun, jac, K0);

      if ierr > 0
        return;
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute an integration step using the implicit Runge-Kutta method for a
    %> system of ODEs of the form \f$ \mathbf{F}(\mathbf{x}, \mathbf{x}', t) =
    %> \mathbf{0} \f$.
    %>
    %> **Solution Algorithm**
    %>
    %> Consider a Runge-Kutta method, written for a system of ODEs of the
    %> form \f$ \mathbf{x}' = \mathbf{f}(\mathbf{x}, \mathbf{v}, t) \f$:
    %>
    %>  \f[
    %>  \begin{array}{l}
    %>  \mathbf{K}_i = \mathbf{f} \left(
    %>    \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{s} a_{ij}
    %>    \mathbf{K}_j,
    %>    \, t_k + c_i \Delta t
    %>    \right), \qquad i = 1, 2, \ldots, s \\
    %>  \mathbf{x}_{k+1} = \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^s b_j
    %>  \mathbf{K}_j \, ,
    %>  \end{array}
    %>  \f]
    %>
    %> Then the implicit Runge-Kutta method for an implicit system of ODEs of
    %> the form \f$\mathbf{F}(\mathbf{x}, \mathbf{x}', t) = \mathbf{0} \f$ can
    %> be written as:
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
    %> \param x_k     States value at \f$ k \f$-th time step
    %>                \f$ \mathbf{x}(t_k) \f$.
    %> \param x_dot_k States derivative at \f$ k \f$-th time step
    %>                \f$ \mathbf{x}' (t_k) \f$.
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
    function [x_out, x_dot_out, d_t_star, ierr] = step( this, x_k, x_dot_k, t_k, d_t )

      % Extract lengths
      nc = length(this.m_c);
      nx = length(x_k);

      % Create the intial guess for K
      K0 = repmat(x_dot_k, nc, 1);

      % Solve the system to obtain K
      [K, ierr] = this.solve_step(x_k, K0, t_k, d_t);

      % Suggested time step for the next advancing step
      d_t_star = d_t;

      % Error code check
      if (ierr > 0)
        x_out     = NaN * x_k;
        x_dot_out = NaN * x_dot_k;
        return;
      end

      % Perform the step and obtain x_k+1
      x_out = x_k + d_t * reshape(K, nx, nc) * this.m_b';

      % Extract x_dot_k+1 from K (i.e., its last value)
      x_dot_out = K(end + 1 - nx:end);

      % Adapt next time step
      if (this.m_adaptive_step)
        x_e = x_k + d_t * reshape(K, nx, nc) * this.m_b_e';
        d_t_star = this.adapt_step(x_out, x_e, d_t_star);
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
  %
  methods (Static)
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check Butcher tableau consistency for an implict Runge-Kutta method.
    %>
    %> \param tbl.A   Matrix \f$ \mathbf{A} \f$.
    %> \param tbl.b   Weights vector \f$ \mathbf{b} \f$.
    %> \param tbl.b_e [optional] Embedded weights vector \f$ \hat{\mathbf{b}} \f$.
    %> \param tbl.c   Nodes vector \f$ \mathbf{c} \f$.
    %>
    %> \return True if the Butcher tableau is consistent, false otherwise.
    %
    function out = check_tableau( tbl )

      CMD = 'Indigo_ImplicitRungeKutta::check_tableau(...): ';

      % Collect input data
      A   = tbl.A;
      b   = tbl.b;
      b_e = tbl.b_e;
      c   = tbl.c;

      % Prepare output
      out = true;

      % Check matrix A
      if (~isnumeric(A))
        warning([CMD, 'A must be a numeric matrix.']);
        out = false;
      end
      if (size(A, 1) ~= size(A, 2))
        warning([CMD, 'matrix A is not a square matrix.']);
        out = false;
      end
      if (any(isnan(A)))
        warning([CMD, 'matrix A found with NaN values.']);
        out = false;
      end

      % Check vector b
      if (~isnumeric(b))
        warning([CMD, 'b must be a numeric vector.']);
        out = false;
      end
      if (~isrow(b))
        warning([CMD, 'vector b is not a row vector.']);
        out = false;
      end
      if (size(A, 2) ~= size(b, 2))
        warning([CMD, 'vector b is not consistent with the size of matrix A.']);
        out = false;
      end
      if (any(isnan(b)))
        warning([CMD, 'vector b found with NaN values.']);
        out = false;
      end

      % Check vector b_e
      if ~isempty(b_e)
        if (~isnumeric(b_e))
          warning([CMD, 'b_e must be a numeric vector.']);
          out = false;
        end
        if (~isrow(b_e))
          warning([CMD, 'vector b_e is not a row vector.']);
          out = false;
        end
        if (size(A, 2) ~= size(b_e, 2))
          warning([CMD, ...
            'vector b_e is not consistent with the size of matrix A.']);
          out = false;
        end
        if (any(isnan(b_e)))
          warning([CMD, 'vector b_e found with NaN values.']);
          out = false;
        end
      end

      % Check vector c
      if (~isnumeric(c))
        warning([CMD, 'c must be a numeric vector.']);
        out = false;
      end
      if (~iscolumn(c))
        warning([CMD, 'vector c is not a column vector.']);
        out = false;
      end
      if (size(A, 1) ~= size(c, 1))
        warning([CMD, 'vector c is not consistent with the size of matrix A.']);
        out = false;
      end
      if (any(isnan(c)))
        warning([CMD, 'vector c found with NaN values.']);
        out = false;
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
end
