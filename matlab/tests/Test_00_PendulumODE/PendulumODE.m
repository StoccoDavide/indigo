% Class container for the non-linear pendulum (ODE version)
classdef PendulumODE < Indigo.DAE.Implicit
  %
  properties (SetAccess = protected, Hidden = true)
    m_m;   % Pendulum mass (kg)
    m_l;   % Pendulum length (m)
    m_g;   % Gravity acceleration (m/s^2)
    m_X_0; % Initial conditions
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function this = PendulumODE( m, l, g, X_0 )

      CMD = 'PendulumODE::PendulumODE(...): ';

      % Set the number of equations and the number of invariants
      num_eqns = 2;
      num_invs = 1;
      num_veil = 0;

      % Call the superclass constructor
      this@Indigo.DAE.Implicit('PendulumODE', num_eqns, num_veil, num_invs);

      % Check the input arguments
      assert(m > 0, [CMD, 'pendulum mass must be positive.']);
      assert(l > 0, [CMD, 'pendulum length must be positive.']);
      assert(g > 0, [CMD, 'gravity acceleration must be positive.']);
      assert(length(X_0) == num_eqns, [CMD, 'invalid initial conditions vector size.']);

      this.m_m   = m;
      this.m_l   = l;
      this.m_g   = g;
      this.m_X_0 = X_0;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = F( this, x, x_dot, ~, ~ )

      CMD = 'PendulumODE::F(...): ';

      % Check the input arguments
      assert(length(x) == this.m_num_eqns, [CMD, 'invalid x vector length.']);
      assert(length(x_dot) == this.m_num_eqns, [CMD, 'invalid x_dot vector length.']);

      % Evaluate the system
      out    = zeros(2,1);
      out(1) = x_dot(1) - x(2);
      out(2) = x_dot(2) + this.m_g / this.m_l * sin(x(1));
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = JF_x( this, x, ~, ~, ~ )

      CMD = 'PendulumODE::JF_x(...): ';

      % Check the input arguments
      assert(length(x) == this.m_num_eqns, ...
        [CMD, 'invalid x vector length.']);

      % Evaluate the system Jacobian
      out = zeros(2);
      out(1,2) = -1.0;
      out(2,1) = this.m_g / this.m_l * cos(x(1));
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = JF_x_dot( this, x, ~, ~, ~ )

      CMD = 'PendulumODE::JF_x_dot(...): ';

      % Check the input arguments
      assert(length(x) == this.m_num_eqns, ...
        [CMD, 'invalid x vector length.']);

      % Evaluate the system Jacobian
      out = eye(2);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = JF_v( this, ~, ~, ~, ~ )

      % Evaluate the system index-1 variables
      out = zeros(this.m_num_eqns, this.m_num_veil);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = h( this, x, ~, ~ )

      CMD = 'PendulumODE::h(...): ';

      % Check the input arguments
      assert(size(x,1) == this.m_num_eqns, ...
        [CMD, 'invalid x vector length.']);

      % Evaluate the system invariant
      out = -this.m_m.*this.m_g.*this.m_l.*(cos(x(1,:)) - cos(this.m_X_0(1))) + ...
            0.5.*this.m_m.*this.m_l^2.*(x(2,:).^2 - this.m_X_0(2)^2);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = Jh_x( this, x, ~, ~ )

      CMD = 'PendulumODE::Jh_x(...): ';

      % Check the input arguments
      assert(length(x) == this.m_num_eqns, [CMD, 'invalid x vector length.']);

      % Evaluate the system invariant Jacobian
      out = [this.m_m*this.m_g*this.m_l*sin(x(1)), ...
             this.m_m*this.m_l^2*x(2)];
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = Jh_v( this, ~, ~, ~ )

      % Evaluate the system invariant Jacobian
      out = zeros(this.m_num_invs, this.m_num_veil);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = v( this, ~, ~ )

      % Evaluate the system veils
      out = zeros(this.m_num_veil, 1);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = Jv_x( this, ~, ~ )

      % Evaluate the system veils Jacobian
      out = zeros(this.m_num_veil, this.m_num_eqns);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = in_domain( ~, ~, ~ )
      out = true;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
