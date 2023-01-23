
.. _program_listing_file_ODE_RKexplicit.m:

Program Listing for File RKexplicit.m
=====================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_RKexplicit.m>` (``ODE/RKexplicit.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class implementing the abstract function `step` for the **explicit**
   %> Runge-Kutta integration method. The user must simply define the Butcher
   %> tableau of the Runge-Kutta method:
   %>
   %> \rst
   %> .. math::
   %>
   %>   \begin{array}{c|c}
   %>     c & A \\
   %>     \hline
   %>       & b
   %>   \end{array}.
   %>
   %> \endrst
   %
   classdef RKexplicit < ODEsolver
     %
     properties (SetAccess = protected, Hidden = true)
       %
       %> Runge-Kutta matrix *A* (lower triangular matrix).
       %
       m_A;
       %
       %> Runge-Kutta weights vector *b* (row vector).
       %
       m_b;
       %
       %> Runge-Kutta nodes vector *c* (column vector).
       %
       m_c;
     end
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Initialize the class with the method name and the Butcher tableau:
       %>
       %> - *name* Name of the Runge-Kutta method;
       %> - *A*    Runge-Kutta matrix (lower triangular matrix);
       %> - *b*    Runge-Kutta weights vector (row vector);
       %> - *c*    Runge-Kutta nodes vector (column vector).
       %
       function this = RKexplicit( name, A, b, c )
   
         CMD = 'RKexplicit::RKexplicit(...): ';
   
         % Perform preliminary check on inputs
         assert(istril(A), ...
           [CMD, 'matrix A is not a lower triangular matrix.']);
         assert(size(A, 1) == size(A, 2), ...
           [CMD, 'matrix A is not a square matrix.']);
         assert(isrow(b), ...
           [CMD, 'vector b is not a row vector.']);
         assert(size(A, 2) == length(b), ...
           [CMD, 'vector b is not consistent with the size of matrix A.']);
         assert(iscolumn(c),
           [CMD, 'vector c is not a column vector.']);
         assert(size(A, 1) == length(c), ...
           [CMD, 'vector b is not consistent with the size of matrix A.']);
   
         % Call the superclass constructor
         this@ODEsolver(name);
   
         % Set the Butcher tableau
         this.m_A = A;
         this.m_b = b;
         this.m_c = c;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Get the Runge-Kutta matrix *A* (lower triangular matrix).
       %
       function out = get_A( this )
         out = this.m_A;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Get the Runge-Kutta weights vector *b* (row vector).
       %
       function out = get_b( this )
         out = this.m_b;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Get the Runge-Kutta nodes vector *c* (column vector).
       %
       function out = get_c( this )
         out = this.m_c;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Set the Runge-Kutta matrix *A* (lower triangular matrix).
       %
       function set_A( this, in )
         this.m_A = in;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Set the Runge-Kutta weights vector *b* (row vector).
       %
       function set_b( this, in )
         this.m_b = in;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Set the Runge-Kutta nodes vector *c* (column vector).
       %
       function set_c( this, in )
         this.m_c = in;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Compute an integration step using the **explicit** Runge-Kutta method:
       %>
       %>  \f[
       %>     \begin{array}{rcl}
       %>        x_{k+1} &=& x_k + \displaystyle\sum_{j=1}^s b_j K_j \\
       %>        K_i     &=& h f \left(
       %>                          t_k + c_i \Delta t,
       %>                          x_k + \displaystyle\sum_{j=1}^{i-1} A_{ij} K_j
       %>                        \right),
       %>        \qquad i = 1, 2, \ldots, s.
       %>     \end{array}
       %>  \f]
       %>
       %> The method requires the following inputs:
       %>
       %> - *x_k* States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$;
       %> - *t_k* Time step \f$ t_k \f$;
       %> - *d_t* Advancing time step \f$ \Delta t\f$.
       %>
       %> The return value is the approximation of \f$ \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$.
       %>
       function out = step( this, t_k, x_k, d_t )
         nx     = length( x_k );
         nc     = length( this.m_c );
         tt     = t_k + d_t * this.m_c;
         k      = zeros( nx, nc );
         k(:,1) = d_t * this.m_ode.f( tt(1), x_k );
         for i = 2:nc
           tmp = x_k;
           for j = 1:i-1
             tmp = tmp + this.m_A(i,j) * k(:,j);
           end
           k(:,i) = d_t * this.m_ode.f( tt(i), tmp );
         end
         out = x_k;
         for i = 1:nc
           out = out + this.m_b(i) * k(:,i);
         end
       end
     end
   end
