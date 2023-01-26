%
%> Class implementing the abstract function step for the implicit Runge-Kutta
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
classdef RKimplicit < ODEsolver
  %
  properties (SetAccess = protected, Hidden = true)
    %
    %> Matrix \f$ \mathbf{A} \f$.
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
    %> Initialize the class with the implicit Runge-Kutta method name and its
    %> Butcher tableau.
    %>
    %> \param name Name of the method.
    %> \param A    Matrix.
    %> \param b    Weights vector (row vector).
    %> \param c    Nodes vector (column vector).
    %
    function this = RKimplicit( name, A, b, c )
      % Call the superclass constructor
      this@ODEsolver( name );

      % Set the Butcher tableau
      this.set_tableau(A, b, c);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the matrix \f$ \mathbf{A} \f$.
    %>
    %> \return The matrix \f$ \mathbf{A} \f$.
    %
    function t_A = get_A( this )
      t_A = this.m_A;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the matrix \f$ \mathbf{A} \f$.
    %>
    %> \param t_A The matrix \f$ \mathbf{A} \f$.
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
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the Butcher tableau.
    %>
    %> \param A Matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
    %> \param b Weights vector \f$ \mathbf{b} \f$ (row vector).
    %> \param c Nodes vector \f$ \mathbf{c} \f$ (column vector).
    %
    function set_tableau( this, A, b, c )

      CMD = 'RKimplicit::set_tableau(...): ';

      % Check the Butcher tableau
      assert(this.check_tableau(A, b, c), ...
        [CMD, 'invalid Butcher tableau detected.']);

      % Set the Butcher tableau
      this.m_A = A;
      this.m_b = b;
      this.m_c = c;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute the LHS of the system of equations to be solved \f$ \mathbf{F}(\mathbf{x}_k + dt \sum{a_{ij} K_j}, \mathbf{K}, t_k + c_i dt) = \mathbf{0} \f$
    %>
    %> \param x_k     States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
    %> \param K       \f$ \mathbf{K} \f$ variable of the system to be solved.
    %> \param t_k     Time step \f$ t_k \f$.
    %> \param d_t     Advancing time step \f$ \Delta t\f$.
    %>
    %
    function R = step_residual( this, x_k, K, t_k, d_t )
      % Reassign for readability
      A   = this.m_A;
      c   = this.m_c;

      % Extract lengths
      nc  = length(c);
      nx  = length(x_k);

      % There are as many residuals as equations in the system
      R   = zeros(nc*nx, 1);

      % Loop through each equation of the system
      idx = 1:nx;
      for i = 1:nc
        % Compute x_k + sum(a_ij*Kj, j)
        tmp = x_k;
        jdx = 1:nx;
        for j = 1:nc
          tmp = tmp + d_t * A(i,j) * K(jdx);
          jdx = jdx + nx;
        end

        % Compute the residuals
        R(idx) = this.m_ode.F( tmp, K(idx), t_k + c(i) * d_t );

        idx = idx + nx;
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute the Jacobian of the LHS of the system of equations to be solved \f$ \mathbf{F}(\mathbf{x}_k + dt \sum{a_{ij} K_j}, \mathbf{K}, t_k + c_i dt) = 0 \f$ in the \f$ \mathbf{K} \f$ variable:
    %>
    %> \f[ \frac{\partial\mathbf{F}(\mathbf{x}_k + dt \sum{a_{ij} K_j}, \mathbf{K}, t_k + c_i dt)}{\partial \mathbf{K}} \f].
    %>
    %> \param x_k     States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
    %> \param K       \f$ \mathbf{K} \f$ variable of the system to be solved.
    %> \param t_k     Time step \f$ t_k \f$.
    %> \param d_t     Advancing time step \f$ \Delta t\f$.
    %>
    %
    function JR = step_jacobian( this, x_k, K, t_k, d_t )
      % Reassign for readability
      A   = this.m_A;
      c   = this.m_c;

      % Extract lengths
      nc  = length(this.m_c);
      nx  = length(x_k);

      % The Jacobian is a square nc*nx (i.e., length(K)) matrix
      JR  = eye(nc*nx);

      % Loop through each equation of the system
      idx = 1:nx;
      for i = 1:nc
        % Compute x_k + sum(a_ij*Kj, j)
        tmp = x_k;
        jdx = 1:nx;
        for j = 1:nc
          tmp = tmp + d_t * A(i,j) * K(jdx);
          jdx = jdx + nx;
        end
        jdx = 1:nx;
        for j = 1:nc
          % Mask for the Jacobian w.r.t. x_dot
          mask = 0;
          if i == j
            mask = 1;
          end

          % Compute the Jacobians w.r.t. x and x_dot
          [JF_x, JF_x_dot] = this.m_ode.JF( tmp, K(idx), t_k + c(i) * d_t );

          % Combine the Jacobians w.r.t. x and x_dot to obtain
          % the Jacobian w.r.t. K
          JR(idx,jdx) = JF_x * d_t * A(i,j) + JF_x_dot * mask;

          jdx = jdx + nx;
        end
        idx = idx + nx;
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Solve the implicit step \f$ \mathbf{F}(\mathbf{x}_k + dt \sum{a_{ij} K_j}, \mathbf{K}, t_k + c_i dt)=\mathbf{0} \f$ by Newton method.
    %>
    %> \param x_k     States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
    %> \param K       Initial guess for the \f$ \mathbf{K} \f$ variable of the system to be solved.
    %> \param t_k     Time step \f$ t_k \f$.
    %> \param d_t     Advancing time step \f$ \Delta t\f$.
    %>
    %
    function K = solve_step( this, x_k, K0, t_k, d_t )
      % Define the function handles
      fun = @(K) this.step_residual( x_k, K, t_k, d_t );
      jac = @(K) this.step_jacobian( x_k, K, t_k, d_t );

      % Solve using Newton
      [K, ierr] = NewtonSolver( fun, jac, K0 );
      if ierr ~= 0
        fprintf( 1, 'RKimplicit::solve_step(...): Not converged flag = %d!\n', ierr );
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
    %> form \f$ \mathbf{x}' = \mathbf{f}(\mathbf{x}, t) \f$:
    %>
    %>  \f[
    %>  \begin{array}{l}
    %>  \mathbf{K}_i = \mathbf{f} \left(
    %>    \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{s} a_{ij} \mathbf{K}_j, \,
    %>    t_k + c_i \Delta t
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
    %>   \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{s} a_{ij} \mathbf{K}_j, \, \mathbf{K}_i, \, t_k + c_i \Delta t
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
    %>   \mathbf{x}_k, \, \mathbf{K}_1, \, t_k
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
    %> \param x_k     States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
    %> \param x_dot_k States derivative at \f$ k \f$-th time step \f$ \mathbf{x}'
    %>                (t_k) \f$.
    %> \param t_k     Time step \f$ t_k \f$.
    %> \param d_t     Advancing time step \f$ \Delta t\f$.
    %>
    %> \return The approximation of \f$ \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$ and
    %>         \f$ \mathbf{x}'_{k+1}(t_{k}+\Delta t) \f$.
    %>
    %
    function [out, out_dot] = step( this, x_k, x_dot_k, t_k, d_t )
      % Extract lengths
      nc = length(this.m_c);
      nx = length(x_k);

      % Create the intial guess for K
      K0 = repmat(x_dot_k, nc, 1);

      % Solve the system to obtain K
      K = this.solve_step( x_k, K0, t_k, d_t );

      % Perform the step and obtain x_k+1
      out = x_k + d_t * reshape(K, nx, nc) * this.m_b';

      % Extract x_dot_k+1 from K (i.e., its last value)
      out_dot = K(end + 1 - nx:end);
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
    %> \param A Matrix \f$ \mathbf{A} \f$.
    %> \param b Weights vector \f$ \mathbf{b} \f$.
    %> \param c Nodes vector \f$ \mathbf{c} \f$.
    %>
    %> \return True if the Butcher tableau is consistent, false otherwise.
    %
    function out = check_tableau( A, b, c )

      CMD = 'indigo::RKimplicit::check_tableau(...): ';

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