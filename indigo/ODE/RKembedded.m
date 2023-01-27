%
%> Class implementing the abstract function step for the embedded Runge-Kutta
%> integration method. The user must simply define the Butcher tableau of the
%> method, which defined as:
%>
%> \f[
%> \begin{array}{c|c}
%>   \mathbf{c} & \mathbf{A} \\ \hline
%>              & \mathbf{b}
%>              & \hat{\mathbf{b}}
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
%> \f$ \mathbf{b} \f$ is the Runge-Kutta weights vector relative to a method of
%> order \f$ p \f$ (row vector):
%>
%> \f[
%> \mathbf{b} = \left[ b_1, b_2, \dots, b_s \right],
%>
%> \f]
%> \f$ \hat{\mathbf{b}} \f$ is the Runge-Kutta weights vector relative to a
%> method of order \f$ \hat{p} \f$ (usually \f$ \hat{p} = p−1 \f$ or \f$ \hat{p}
%> = p+1 \f$) (row vector):
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
classdef RKembedded %< RKexplicit & RKimplicit
  %
  properties (SetAccess = protected, Hidden = true)
    %
    %> Matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
    %
    m_A;
    %
    %> High weights vector \f$ \mathbf{b} \f$ (row vector).
    %
    m_b_h;
    %
    %> Low weights vector \f$ \hat{\mathbf{b}} \f$ (row vector).
    %
    m_b_l;
    %
    %> Nodes vector \f$ \mathbf{c} \f$ (column vector).
    %
    m_c;
    %
    %> Runge-Kutta type (choose between 'explicit' and 'implicit').
    %
    m_type;
    %
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Initialize the class with the embedded Runge-Kutta method name and its
    %> Butcher tableau.
    %>
    %> \param name Name of the method.
    %> \param A    Matrix (lower triangular matrix).
    %> \param b_h  Low weights vector (row vector).
    %> \param b_l  High weights vector (row vector).
    %> \param c    Nodes vector (column vector).
    %
    function this = RKembedded( name, A, b_h, b_l, c )

      % Call the superclasses constructor
      this@RKexplicit(name);
      this@RKimplicit(name);

      % Check the embedded method type
      if (istril(A))
        this.m_type = 'explicit';
      else
        this.m_type = 'implicit';
      end

      % Set the Butcher tableau
      this.set_tableau(A, b_h, b_l, c);
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
    %> Get the high weights vector \f$ \mathbf{b} \f$ (row vector).
    %>
    %> \return The high weights vector \f$ \mathbf{b} \f$ (row vector).
    %
    function t_b_h = get_b_h( this )
      t_b_h = this.m_b_h;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the high weights vector \f$ \mathbf{b} \f$ (row vector).
    %>
    %> \param t_b_h The high weights vector \f$ \mathbf{b} \f$ (row vector).
    %
    function set_b_h( this, t_b_h )
      this.m_b_h = t_b_h;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the low weights vector \f$ \hat{\mathbf{b}} \f$ (row vector).
    %>
    %> \return The low weights vector \f$ \hat{\mathbf{b}} \f$ (row vector).
    %
    function t_b_l = get_b_l( this )
      t_b_l = this.m_b_l;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the low weights vector \f$ \hat{\mathbf{b}} \f$ (row vector).
    %>
    %> \param t_b_l The low weights vector \f$ \hat{\mathbf{b}} \f$ (row vector).
    %
    function set_b_l( this, t_b_l )
      this.m_b_l = t_b_l;
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
    %> \param A   Matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
    %> \param b_h High weights vector \f$ \mathbf{b} \f$ (row vector).
    %> \param b_l Low weights vector \f$ \hat{\mathbf{b}} \f$ (row vector).
    %> \param c   Nodes vector \f$ \mathbf{c} \f$ (column vector).
    %
    function set_tableau( this, A, b_h, b_l, c )

      CMD = 'indigo::RKembedded::set_tableau(...): ';

      % Check the Butcher tableau
      assert(RKembedded.check_tableau(A, b_h, b_l, c), ...
        [CMD, 'invalid tableau detected.']);

      % Set the Butcher tableau
      this.m_A   = A;
      this.m_b_h = b_h;
      this.m_b_l = b_l;
      this.m_c   = c;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute an integration step using the embedded Runge-Kutta method for a
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
    %> the \f$ s\f$ stages for a generic embedded Runge-Kutta method take the
    %> form:
    %>
    %> \f[
    %> \mathbf{K}_i = \mathbf{f} \left(
    %>   \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{i-1} a_{ij}
    %>   \mathbf{K}_j, \, t_k + c_i \Delta t
    %>   \right), \qquad i = 1, 2, \ldots, s.
    %> \f]
    %>
    %> Then the embedded Runge-Kutta method for an implicit system of ODEs of
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
    %> The suggested time step for the next advancing step \f$ \Delta t_{k+1} \f$,
    %> is the same as the input time step \f$ \Delta t \f$ since in the implicit
    %> Runge-Kutta method the time step is not modified through any error control
    %> method.
    %>
    %> \param x_k     States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
    %> \param x_dot_k States derivative at \f$ k \f$-th time step \f$ \mathbf{x}'
    %>                (t_k) \f$.
    %> \param t_k     Time step \f$ t_k \f$.
    %> \param d_t     Advancing time step \f$ \Delta t\f$.
    %>
    %> \return The approximation of the states at \f$ k+1 \f$-th time step \f$
    %>         \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$, the approximation of the
    %>         states derivatives at \f$ k+1 \f$-th time step \f$ \mathbf{x}'_{k+1}
    %>         (t_{k}+\Delta t) \f$, the suggested time step for the next
    %>         advancing step \f$ \Delta t_{k+1} \f$, and the error control flag.
    %>
    function [x_out, x_dot_out, d_t_star, ierr] = step( this, x_k, x_dot_k, t_k, d_t )

      % Solve the system to obtain K
      if (strcmp(this.m_type, 'explicit'))
        [K, ierr] = solve_step@RKexplicit(x_k, x_dot_k, t_k, d_t);
      elseif (strcmp(this.m_type, 'implicit'))
        [K, ierr] = solve_step@RKimplicit(x_k, x_dot_k, t_k, d_t);
      else
      end

      % Perform the step and obtain x_k+1 with higher and lower order method
      x_h = x_k + d_t * K * this.m_b_h';
      x_l = x_k + d_t * K * this.m_b_l';

      % Extract x_k+1
      x_out = x_h;

      % Extract x_dot_k+1 from K (i.e., its last value)
      x_dot_out = K(:,end);

      % Suggestions for the next time step
      d_t_star = this.compute_adaptive_time_step(x_h, x_l, d_t);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute adaptive time step for the next advancing step according to the
    %> error control method. The error control method used is the local truncation
    %> error (LTE) method, which is based on the following formula:
    %>
    %> \f[
    %> \left| \mathbf{x}_{k+1} - \mathbf{x}_{k+1}^{(h)} \right| \leq
    %> \dfrac{C \Delta t^{p+1}}{p+1} \left| \mathbf{x}_{k+1}^{(h)} -
    %> \mathbf{x}_{k+1}^{(l)} \right|
    %> \f]
    %>
    %> where \f$ \mathbf{x}_{k+1}^{(h)} \f$ is the approximation of the states at
    %> \f$ k+1 \f$-th time step \f$ \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$ with
    %> higher order method, \f$ \mathbf{x}_{k+1}^{(l)} \f$ is the approximation
    %> of the states at \f$ k+1 \f$-th time step \f$ \mathbf{x_{k+1}}(t_{k}+\Delta
    %> t) \f$ with lower order method, \f$ C \f$ is a constant, and \f$ p \f$ is
    %> the order of the method.
    %>
    %> To compute the suggested time step for the next advancing step \f$
    %> \Delta t_{k+1} \f$, the following formula is used:
    %>
    %> \f[
    %> \Delta t_{k+1} = \dfrac{C \Delta t^{p+1}}{p+1} \left| \mathbf{x}_{k+1}^{(h)}
    %> - \mathbf{x}_{k+1}^{(l)} \right|^{-\frac{1}{p+1}}
    %> \f]
    %>
    %> \param x_h Approximation of the states at \f$ k+1 \f$-th time step \f$
    %>            \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$ with higher order method.
    %> \param x_l Approximation of the states at \f$ k+1 \f$-th time step \f$
    %>            \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$ with lower order method.
    %> \param d_t Advancing time step \f$ \Delta t\f$.
    %>
    %> \return The suggested time step for the next advancing step \f$ \Delta
    %>         t_{k+1} \f$.
    %>
    function out = compute_adaptive_time_step( this, x_h, x_l, d_t )

      % Compute the error
      err = x_h - x_l;

      % Compute the error norm
      err_norm = norm(err, this.m_norm);

      % Compute the suggested time step
      out = d_t * (this.m_tol / err_norm)^(1 / (this.m_s + 1));
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
    %> Check Butcher tableau consistency for an embedded Runge-Kutta method.
    %>
    %> \param A   Matrix \f$ \mathbf{A} \f$.
    %> \param b_h High weights vector \f$ \mathbf{b} \f$.
    %> \param b_l Low weights vector \f$ \hat{\mathbf{b}} \f$.
    %> \param c    Nodes vector \f$ \mathbf{c} \f$.
    %>
    %> \return True if the Butcher tableau is consistent, false otherwise.
    %
    function out = check_tableau( A, b_h, b_l, c )

      CMD = 'indigo::RKembedded::check_tableau(...): ';

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

      % Check vector b_h
      if (~isnumeric(b_h))
        warning([CMD, 'vector b_h must be numeric.']);
        out = false;
      end
      if (~isrow(b_h))
        warning([CMD, 'vector b_h is not a row vector.']);
        out = false;
      end
      if (size(A, 2) ~= length(b_h))
        warning([CMD, 'vector b_h is not consistent with the size of matrix A.']);
        out = false;
      end
      if (any(isnan(b_h)))
        warning([CMD, 'vector b_h found with NaN values.']);
        out = false;
      end

      % Check vector b_l
      if (~isnumeric(b_l))
        warning([CMD, 'vector b_l must be numeric.']);
        out = false;
      end
      if (~isrow(b_l))
        warning([CMD, 'vector b_l is not a row vector.']);
        out = false;
      end
      if (size(A, 2) ~= length(b_l))
        warning([CMD, 'vector b_l is not consistent with the size of matrix A.']);
        out = false;
      end
      if (any(isnan(b_l)))
        warning([CMD, 'vector b_l found with NaN values.']);
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
