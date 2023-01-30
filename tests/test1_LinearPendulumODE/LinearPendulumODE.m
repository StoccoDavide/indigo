%> Implementation of the Linear Pendulum
%>
%> \rst
%> .. math::
%>
%>   \begin{cases}
%>      \theta' - \omega & = 0\\
%>      \omega' - -\displaystyle\frac{g}{\ell}\theta = 0&
%>   \end{cases}
%>
%> \endrst
%
classdef LinearPendulumODE < ODEsystem
  %
  properties (SetAccess = protected, Hidden = true)
    %
    %> Pendulum mass (kg)
    %
    m_m;
    %
    %> Pendulum length (m)
    %
    m_l;
    %
    %> Gravity acceleration (m/s^2)
    %
    m_g;
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function this = LinearPendulumODE( m, l, g )

      CMD = 'LinearPendulumODE::LinearPendulumODE(...): ';

      % Set the number of equations and the number of invariants
      num_eqns = 2;
      num_invs = 0;

      % Call the superclass constructor
      this@ODEsystem( 'LinearPendulumODE', num_eqns, num_invs );

      % Check the input arguments
      assert(m > 0, ...
        [CMD, 'pendulum mass must be positive.']);
      assert(l > 0, ...
        [CMD, 'pendulum length must be positive.']);
      assert(g > 0, ...
        [CMD, 'gravity acceleration must be positive.']);

      this.m_m = m;
      this.m_l = l;
      this.m_g = g;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = F( this, x, x_dot, t )

      CMD = 'LinearPendulumODE::F(...): ';

      % Check the input arguments
      assert(length(x) == this.m_num_eqns, ...
        [CMD, 'invalid x vector length.']);
      assert(length(x_dot) == this.m_num_eqns, ...
        [CMD, 'invalid x_dot vector length.']);
      assert(isnumeric(t), ...
        [CMD, 'invalid t vector.']);

      % Evaluate the system of ODEs
      out    = zeros(2,1);
      out(1) = x_dot(1) - x(2);
      out(2) = x_dot(2) + this.m_g / this.m_l * x(1);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function [JF_x, JF_x_dot] = JF( this, x, x_dot, t )

      CMD = 'LinearPendulumODE::JF(...): ';

      % Check the input arguments
      assert(length(x) == this.m_num_eqns, ...
        [CMD, 'invalid x vector length.']);
      assert(length(x_dot) == this.m_num_eqns, ...
        [CMD, 'invalid x_dot vector length.']);
      assert(isnumeric(t), ...
        [CMD, 'invalid t vector.']);

      % Evaluate the system of ODEs Jacobians
      JF_x      = zeros(2);
      JF_x_dot  = eye(2);
      JF_x(1,2) = -1.0;
      JF_x(2,1) = this.m_g / this.m_l;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = H( ~, ~, ~ )
      out = [];
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = JH( ~, ~, ~ )
      out = [];
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = exact( this, x_i, t )

      % Calculate temporary variables
      sqrt_t = sqrt(this.m_g/this.m_l);
      cos_t  = cos(sqrt_t.*t);
      sin_t  = sin(sqrt_t.*t);

      % Evaluate the exact solution
      out      = zeros(2,length(t));
      out(1,:) = -sqrt_t.*x_i(2).*sin_t + x_i(1).*cos_t;
      out(2,:) = sqrt_t.*(sqrt_t.*x_i(2).*cos_t - x_i(1).*sin_t);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
