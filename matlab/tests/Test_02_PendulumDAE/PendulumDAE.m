% Class container for the non-linear pendulum (DAE version)
classdef PendulumDAE < Indigo.DAE.Implicit
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
    function this = PendulumDAE( m, l, g, X_0 )

      CMD = 'PendulumDAE::PendulumDAE(...): ';

      % Set the number of equations and the number of invariants
      num_eqns = 5;
      num_veil = 0;
      num_invs = 1;

      % Call the superclass constructor
      this@Indigo.DAE.Implicit('PendulumODE', num_eqns, num_veil, num_invs);

      % Check the input arguments
      assert(m > 0, ...
        [CMD, 'pendulum mass must be positive.']);
      assert(l > 0, ...
        [CMD, 'pendulum length must be positive.']);
      assert(g > 0, ...
        [CMD, 'gravity acceleration must be positive.']);
      assert(length(X_0) == num_eqns, ...
        [CMD, 'invalid initial conditions vector size.']);

      this.m_m   = m;
      this.m_l   = l;
      this.m_g   = g;
      this.m_X_0 = X_0;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = F( this, x, x_dot, ~ )
      out    = zeros(5,1);

      out(1) = x_dot(1) - x(3);
      out(2) = x_dot(2) - x(4);
      out(3) = this.m_m * x_dot(3) + x(5) * x(1);
      out(4) = this.m_m * x_dot(4) + x(5) * x(2) + this.m_m * this.m_g;
      out(5) = x(1)^2 + x(2)^2 - this.m_l^2;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = JF_x( ~, x, ~, ~ )
      out      = zeros(5, 5);
      out(1,3) = -1;
      out(2,4) = -1;
      out(3,1) = x(5);
      out(3,5) = x(1);
      out(4,2) = x(5);
      out(4,5) = x(2);
      out(5,1) = 2*x(1);
      out(5,2) = 2*x(2);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function JF_x_dot = JF_x_dot( this, ~, ~, ~ )
      JF_x_dot      = zeros(5,5);
      JF_x_dot(1,1) = 1;
      JF_x_dot(2,2) = 1;
      JF_x_dot(3,3) = this.m_m;
      JF_x_dot(4,4) = this.m_m;
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
    function out = h( this, x, ~ )

      CMD = 'PendulumODE::h(...): ';

      % Check the input arguments
      assert(size(x,1) == this.m_num_eqns, ...
        [CMD, 'invalid x vector length.']);

      % Evaluate the system invariant
      out = this.m_m.*this.m_g.*this.m_l.*(x(2,:) - this.m_X_0(2)) + ...
            0.5.*this.m_m.*this.m_l.*( ...
              x(3,:).^2 - this.m_X_0(3)^2 + x(4,:).^2 - this.m_X_0(4)^2 ...
            );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = Jh_x( this, x, ~ )

      CMD = 'PendulumODE::Jh(...): ';

      % Check the input arguments
      assert(size(x,1) == this.m_num_eqns, ...
        [CMD, 'invalid x vector length.']);

      % Evaluate the system gradient of the invariant
      out = [zeros(1,size(x,2)), ...
             this.m_m.*this.m_g.*this.m_l, ...
             this.m_m.*this.m_l.*x(3,:), ...
             this.m_m.*this.m_l.*x(4,:), ...
             zeros(1,size(x,2))];
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
  end
end
