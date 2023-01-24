%
%> Class implementing the abstract function `step` for the
%> advancing using **implicit** Runge-Kutta methods.
%> The user must simply define the Tableau of the Runge-Kutta method:
%>
%> \rst
%> .. math::
%>
%>    \begin{array}{c|c}
%>       c & A \\
%>       \hline
%>         & b^T
%>    \end{array}
%>
%> \endrst
%>
%> The advancing for the ODE \f$ x'=f(t,x) \f$ is done as follows:
%>
%> \f[
%>     \begin{array}{rcl}
%>        x_{k+1} &=& x_k + \displaystyle\sum_{j=1}^s b_j K_j \\
%>        K_i     &=& h f\left( t_k + c_i \Delta t, x_k + \displaystyle\sum_{j=1}^s A_{ij} K_j \right),
%>        \qquad i=1,2,\ldots,s
%>     \end{array}
%> \f]
%>
%> where the coefficients \f$ \mathbf{K} = (K_1,K_2,\ldots,K_s)^T \f$ are the solution of
%> \f$ \mathbf{F}(\mathbf{K}) = \mathbf{0} \f$ the nonlinear system
%>
%> \f[
%>     \mathbf{F}(\mathbf{K}) =
%>     \left\{\begin{array}{rcl}
%>        F_1(K_1,K_2,\ldots,K_s) &=& 0, \\
%>        F_2(K_1,K_2,\ldots,K_s) &=& 0, \\
%>        &\vdots& \\
%>        F_s(K_1,K_2,\ldots,K_s) &=& 0,
%>     \end{array}\right.
%> \f]
%>
%> where
%>
%> \f[
%>     \begin{array}{rcl}
%>        F_1(K_1,K_2,\ldots,K_s) &=& K_1-h f\left( t_k + c_1 \Delta t, x_k + \displaystyle\sum_{j=1}^s A_{1j} K_j \right), \\
%>        F_2(K_1,K_2,\ldots,K_s) &=& K_2-h f\left( t_k + c_1 \Delta t, x_k + \displaystyle\sum_{j=1}^s A_{2j} K_j \right), \\
%>        &\vdots& \\
%>        F_s(K_1,K_2,\ldots,K_s) &=& K_s-h f\left( t_k + c_s \Delta t, x_k + \displaystyle\sum_{j=1}^s A_{sj} K_j \right),
%>     \end{array}
%> \f]
%
classdef RKimplicit < ODEsolver
  %
  properties (SetAccess = protected, Hidden = true)
    %
    %> Runge-Kutta matrix
    %
    m_A;
    %
    %> Runge-Kutta weights vector (row vector)
    %
    m_b;
    %
    %> Runge-Kutta nodes vector (column vector)
    %
    m_c;
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Initialize the class with the method name and the Butcher tableau
    %>
    %> - *A* Runge-Kutta matrix
    %> - *b* Runge-Kutta weights vector (row vector)
    %> - *c* Runge-Kutta nodes vector (column vector)
    %
    function this = RKimplicit( name, A, b, c )
      CMD = 'RKimplicit::RKimplicit(...): ';
      assert( ismatrix(A), ...
        [CMD, 'Found Runge-Kutta matrix A not as a matrix.'] );
      assert( ~nnz(isnan(A)), ...
        [CMD, 'Found NaN in Runge-Kutta matrix A.'] );
      assert( isrow(b), ...
        [CMD, 'Found Runge-Kutta weights vector b not as a row vector.'] );
      assert( ~nnz(isnan(b)), ...
        [CMD, 'Found NaN in Runge-Kutta weights vector b.'] );
      assert( iscolumn(c), ...
        [CMD, 'Found Runge-Kutta nodes vector c not as a column vector.'] );
      assert( ~nnz(isnan(c)), ...
        [CMD, 'Found NaN in Runge-Kutta nodes vector c.'] );

      this@ODEsolver( name );
      this.m_A = A;
      this.m_b = b;
      this.m_c = c;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the Runge-Kutta matrix
    %
    function out = get_A( this )
      out = this.m_A;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the Runge-Kutta weights vector (row vector)
    %
    function out = get_b( this )
      out = this.m_b;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the Runge-Kutta nodes vector (column vector)
    %
    function out = get_c( this )
      out = this.m_c;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the Runge-Kutta matrix
    %
    function setA( this, in )
      CMD = 'RKimplicit::set_A(...): ';
      assert( ismatrix(in), ...
        [CMD, 'Found Runge-Kutta matrix A not as a matrix.'] );
      assert( ~nnz(isnan(in)), ...
        [CMD, 'Found NaN in Runge-Kutta matrix A.'] );
      this.m_A = in;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the Runge-Kutta weights vector (row vector)
    %
    function set_b( this, in )
      CMD = 'RKimplicit::set_b(...): ';
      assert( isrow(in), ...
        [CMD, 'Found Runge-Kutta weights vector b not as a row vector.'] );
      assert( ~nnz(isnan(in)), ...
        [CMD, 'Found NaN in Runge-Kutta weights vector b.'] );
      this.m_b = in;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the Runge-Kutta nodes vector (column vector)
    %
    function set_c( this, in )
      CMD = 'RKimplicit::set_c(...): ';
      assert( iscolumn(in), ...
        [CMD, 'Found Runge-Kutta nodes vector c not as a column vector.'] );
      assert( ~nnz(isnan(in)), ...
        [CMD, 'Found NaN in Runge-Kutta nodes vector c.'] );
      this.m_c = in;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check the Butcher tableau
    %
    function check_tableau( this, A, b, c )
      CMD = 'indigo::RKimplicit::check_tableau(...): ';
      assert( size(A, 1) == size(c, 1), ...
        [CMD, 'Found Runge-Kutta matrix A rows != rows of nodes vector c.'] );
      assert( size(A, 2) == size(b, 2), ...
        [CMD, 'Found Runge-Kutta matrix A columns ', ...
         '!= columns of weights vector b.'] );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute the step residual \f$ \mathbf{F}(\mathbf{x}_k + dt \sum{a_{ij} K_j}, \mathbf{K}, t_k + c_i dt) \f$
    %
    function R = stepResidual( this, x_k, x_dot_k, t_k, d_t )
      nc  = length(this.m_c);
      nx  = length(x_k);
      R   = zeros(nc*nx, 1);
      idx = 1:nx;
      for i = 1:nc
        R(idx) = this.m_ode.F( ...
            x_k + this.m_A(i,:) * x_dot_k, x_dot_k, t_k + this.m_c(i) * d_t ...
          );
        idx    = idx + nx;
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Compute the Jacobian of \f$ \mathbf{F}(\mathbf{x}_k + dt \sum{a_{ij} K_j}, \mathbf{K}, t_k + c_i dt) \f$:
    %>
    %> \f[ \frac{\partial\mathbf{F}(\mathbf{x}_k + dt \sum{a_{ij} K_j}, \mathbf{K}, t_k + c_i dt)}{\partial \mathbf{K}} \f].
    %
    function JR = stepJacobian( this, x_k, x_dot_k, t_k, d_t )
      nc  = length(this.m_c);
      nx  = length(x_k);
      JR  = eye(nc*nx, 2*nx + 1);
      idx = 1:nx;
      for i = 1:nc
        JR(idx,:) = this.m_ode.JF( ...
            x_k + this.m_A(i,:) * x_dot_k, x_dot_k, t_k + this.m_c(i) * d_t ...
          );
        idx       = idx + nx;
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Solve the implicit step \f$ \mathbf{F}(\mathbf{x}_k + dt \sum{a_{ij} K_j}, \mathbf{K}, t_k + c_i dt)=\mathbf{0} \f$ by Newton method
    %>
    %> \f[ \mathbf{K}^{\ell+1} = \mathbf{K}^{\ell} -
    %>     \left(\frac{\partial\mathbf{F}(\mathbf{K}^{\ell})}{\partial \mathbf{K}}\right)^{-1}\mathbf{F}(\mathbf{K}^{\ell}) \f].
    %
    function K = solveStep( this, x_k, x_dot_k, t_k, d_t )
      fun = @(x_dot_k) this.stepResidual( x_k, x_dot_k, t_k, d_t );
      jac = @(x_dot_k) this.stepJacobian( x_k, x_dot_k, t_k, d_t );
      K0  = x_dot_k;
      [K, ierr] = NewtonSolver( fun, jac, K0 );
      if ierr ~= 0
        fprintf( 1, 'RKimplicit::solveStep(...): Not converged flag = %d!\n', ierr );
      end
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Perform an implicit step by solving the residual \f$ \mathbf{F}(\mathbf{x}_k + dt \sum{a_{ij} K_j}, \mathbf{K}, t_k + c_i dt)=\mathbf{0} \f$
    %
    function [out, K] = step( this, x_k, x_dot_k, t_k, d_t )
      K   = this.solveStep( x_k, x_dot_k, t_k, d_t );
      out = x_k + d_t * this.m_b(:) * K;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end