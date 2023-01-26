%
%> Class implementing the abstract function step for the explicit Runge-Kutta
%> integration method. The user must simply define the Butcher tableau of the
%> method, which defined as:
%>
%> \f[
%> \begin{array}{c|c}
%>   c & A \\ \hline
%>     & b
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
%> \f$ \mathbf{b} \f$ is the Runge-Kutta weights vector (row vector):
%>
%> \f[
%> \mathbf{b} = \left[ b_1, b_2, \dots, b_s \right],
%> \f]
%>
%> and \f$ \mathbf{c} \f$ is the Runge-Kutta nodes vector (column vector):
%>
%> \f[
%> \mathbf{c} = \left[ c_1, c_2, \dots, c_s \right]^T.
%> \f]
%
classdef RKexplicit < ODEsolver
  %
  properties (SetAccess = protected, Hidden = true)
    %
    %> Matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
    %
    m_A;
    %
    %> Weights vector \f$ \mathbf{b} \f$ (row vector).
    %
    m_b;
    %
    %> Nodes vector \f$ \mathbf{c} \f$ (column vector).
    %
    m_c;
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Initialize the class with the explicit Runge-Kutta method name and its
    %> Butcher tableau.
    %>
    %> \param name Name of the method.
    %> \param A    Matrix (lower triangular matrix).
    %> \param b    Weights vector (row vector).
    %> \param c    Nodes vector (column vector).
    %
    function this = RKexplicit( name, A, b, c )

      % Call the superclass constructor
      this@ODEsolver(name);

      % Set the Butcher tableau
      this.set_tableau(A, b, c);
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
    %> Set the Butcher tableau.
    %>
    %> \param A Matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
    %> \param b Weights vector \f$ \mathbf{b} \f$ (row vector).
    %> \param c Nodes vector \f$ \mathbf{c} \f$ (column vector).
    %
    function set_tableau( this, A, b, c )

      CMD = 'indigo::RKexplicit::set_tableau(...): ';

      % Check the Butcher tableau
      assert(RKexplicit.check_tableau(A, b, c), ...
        [CMD, 'invalid tableau detected.']);

      % Set the Butcher tableau
      this.m_A = A;
      this.m_b = b;
      this.m_c = c;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute the node as:
    %>
    %> \f[
    %> \mathbf{x}_i = \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{i-1}
    %>   a_{ij} \mathbf{K}_j.
    %> \f]
    %>
    %> \param i   Index of the node to be computed.
    %> \param x_k States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
    %> \param K   Variable \f$ \mathbf{K} \f$ of the system to be solved.
    %> \param d_t Advancing time step \f$ \Delta t\f$.
    %>
    %> \return The residual of the ODEs system to be solved.
    %
    function out = step_node( this, i, x_k, K, d_t )

      % Compute node
      out = zeros(length(x_k), 1);
      for j = 1:i-1
        out = out + this.m_A(i,j) * K(:,j);
      end
      out = x_k + out * d_t;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute the left hand side of the ODEs system to be solved:
    %>
    %> \f[
    %> \mathbf{F}_i\left(\mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{i-1}
    %>   a_{ij} \mathbf{K}_j, \, \mathbf{K}_i, \, t_k + c_i \Delta t
    %> \right) = \mathbf{0}.
    %> \f]
    %>
    %> \param i   Index of the step to be computed.
    %> \param x_i \f$ i \f$-th node.
    %> \param K   Variable \f$ \mathbf{K} \f$ of the system to be solved.
    %> \param t_k Time step \f$ t_k \f$.
    %> \param d_t Advancing time step \f$ \Delta t\f$.
    %>
    %> \return The residual of the ODEs system to be solved.
    %
    function out = step_residual( this, i, x_i, K, t_k, d_t )

      % Compute the residuals
      out = this.m_ode.F(x_i, K, t_k + this.m_c(i) * d_t);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute the Jacobian of the ODEs system of equations:
    %>
    %> \f[
    %> \mathbf{F}_i\left(\mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{i-1}
    %>   a_{ij} \mathbf{K}_j, \, \mathbf{K}_i, \, t_k + c_i \Delta t
    %> \right) = \mathbf{0}
    %> \f]
    %>
    %> to be solved in the \f$ \mathbf{K} \f$ variable:
    %>
    %> \f[
    %> \dfrac{\partial \mathbf{F}_i}{\partial \mathbf{K}_i} \left(
    %>   \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{i-1} a_{ij} \mathbf{K}_j,
    %>   \, \mathbf{K}_i, \, t_k + c_i \Delta t
    %> \right)
    %> \f]
    %>
    %> \param i   Index of the step to be computed.
    %> \param x_i \f$ i \f$-th node.
    %> \param K   Variable \f$ \mathbf{K} \f$ of the system to be solved.
    %> \param t_k Time step \f$ t_k \f$.
    %> \param d_t Advancing time step \f$ \Delta t\f$.
    %>
    %> \return The Jacobian of the ODEs system of equations to be solved.
    %
    function out = step_jacobian( this, i, x_i, K, t_k, d_t )

      % Compute the Jacobians
      [~, out] = this.m_ode.JF(x_i, K, t_k + this.m_c(i) * d_t);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Solve the \f$ i \f$-th explicit step of the ODEs system to find the
    %> \f$ \mathbf{K}_i \f$ variable:
    %>
    %> \f[
    %> \mathbf{F}_i\left(\mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{i-1}
    %>   a_{ij} \mathbf{K}_j, \, \mathbf{K}_i, \, t_k + c_i \Delta t
    %> \right) = \mathbf{0}
    %> \f]
    %>
    %> by Newton method.
    %>
    %> \param x_k States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
    %> \param K   Initial guess for the \f$ \mathbf{K} \f$ variable to be found.
    %> \param t_k Time step \f$ t_k \f$.
    %> \param d_t Advancing time step \f$ \Delta t\f$.
    %>
    %> \return The \f$ \mathbf{K} \f$ variables of the ODEs system to be solved.
    %
    function out = solve_step( this, x_k, K_0, t_k, d_t )

      CMD = 'indigo::RKexplicit::solve_step(...): ';

      % Extract lengths
      nc = length(this.m_c);

      K = repmat(K_0, 1, nc);
      for i = 1:nc

        % Compute node
        x_i = this.step_node(i, x_k, K, d_t);

        % Define the function handles
        fun = @(K_i) this.step_residual(i, x_i, K_i, t_k, d_t);
        jac = @(K_i) this.step_jacobian(i, x_i, K_i, t_k, d_t);

        % Solve using Newton
        [K(:,i), ierr] = NewtonSolver(fun, jac, K(:,i));
        if (ierr ~= 0)
          fprintf(1, [CMD, 'not converged flag = %d.\n'], ierr);
        end
      end
      out = K;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute an integration step using the explicit Runge-Kutta method for a
    %> system of ODEs of the form \f$ \mathbf{F}(\mathbf{x}, \mathbf{x}', t) =
    %> \mathbf{0} \f$.
    %>
    %> **Solution Algorithm**
    %>
    %> Consider a Runge-Kutta method, written for a system of ODEs of the
    %> form \f$ \mathbf{x}' = \mathbf{f}(\mathbf{x}, t) \f$:
    %>
    %>  \f[
    %>  \begin{array}{l}
    %>  \mathbf{K}_i = \mathbf{f} \left(
    %>    \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{s} a_{ij} \mathbf{K}_j,
    %>    \, t_k + c_i \Delta t
    %>    \right), \qquad i = 1, 2, \ldots, s \\
    %>  \mathbf{x}_{k+1} = \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^s b_j
    %>  \mathbf{K}_j \, ,
    %>  \end{array}
    %>  \f]
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
    %> Then the explicit Runge-Kutta method for an implicit system of ODEs of
    %> the form \f$\mathbf{F}(\mathbf{x}, \mathbf{x}', t) = \mathbf{0} \f$ can
    %> be written as:
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
    %> explicit Runge-Kutta method can also be used in the `RKimplicit` class.
    %>
    %> \param x_k     States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
    %> \param x_dot_k States derivative at \f$ k \f$-th time step \f$ \mathbf{x}'
    %>                (t_k) \f$.
    %> \param t_k     Time step \f$ t_k \f$.
    %> \param d_t     Advancing time step \f$ \Delta t\f$.
    %>
    %> \return The approximation of \f$ \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$ and
    %>         \f$ \mathbf{x}'_{k+1}(t_{k}+\Delta t) \f$.
    %>
    function [out, out_dot] = step( this, x_k, x_dot_k, t_k, d_t )

      % Solve the system to obtain K
      K = this.solve_step( x_k, x_dot_k, t_k, d_t );

      % Perform the step and obtain x_k+1
      out = x_k + d_t * K * this.m_b';

      % Extract x_dot_k+1 from K (i.e., its last value)
      out_dot = K(:,end);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
  methods (Static)
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check Butcher tableau consistency for an explicit Runge-Kutta method.
    %>
    %> \param A Matrix \f$ \mathbf{A} \f$.
    %> \param b Weights vector \f$ \mathbf{b} \f$.
    %> \param c Nodes vector \f$ \mathbf{c} \f$.
    %>
    %> \return True if the Butcher tableau is consistent, false otherwise.
    %
    function out = check_tableau( A, b, c )

      CMD = 'indigo::RKexplicit::check_tableau(...): ';

      out = true;

      % Check matrix A
      if (~isnumeric(A))
        warning([CMD, 'matrix A must be numeric.']);
        out = false;
      end
      if (~istril(A))
        warning([CMD, 'matrix A is not a lower triangular matrix.']);
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
        warning([CMD, 'vector b must be numeric.']);
        out = false;
      end
      if (~isrow(b))
        warning([CMD, 'vector b is not a row vector.']);
        out = false;
      end
      if (size(A, 2) ~= length(b))
        warning([CMD, 'vector b is not consistent with the size of matrix A.']);
        out = false;
      end
      if (any(isnan(b)))
        warning([CMD, 'vector b found with NaN values.']);
        out = false;
      end

      % Check vector c
      if (~isnumeric(c))
        warning([CMD, 'vector c must be numeric.']);
        out = false;
      end
      if (~iscolumn(c))
        warning([CMD, 'vector c is not a column vector.']);
        out = false;
      end
      if (size(A, 1) ~= length(c))
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
