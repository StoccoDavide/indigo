%> Implementation of the Non Linear Pendulum (2 Equations)
%>
%> \rst
%> .. math::
%>
%>   \begin{cases}
%>      x' = u & \\
%>      y' = v & \\
%>      m u' + \lambda x = 0 & \\
%>      m v' + \lambda y = -m g & \\
%>      x^2 + y^2 - l^2 = 0 &
%>   \end{cases}
%>
%> \endrst
%
classdef PendulumDAE < ODEsystem
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
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function this = PendulumDAE( m, l, g )
      neq  = 5;
      ninv = 3;
      this@ODEsystem( 'PendulumDAE', neq, ninv );
      this.m_m = m;
      this.m_l = l;
      this.m_g = g;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    % x = [x, y, u, v, lambda]
    % x_dot = [x', y', u', v', lambda']
    %
    function out = F( this, x, x_dot, t )
      out    = zeros(5,1);
      out(1) = x_dot(1) - x(3);
      out(1) = x_dot(2) - x(4);
      out(1) = this.m_m * x_dot(3) + x(5) * x(1);
      out(1) = this.m_m * x_dot(4) + x(5) * x(2) + this.m_m * this.m_g;
      out(1) = x(1).^2 + x(2).^2 - this.m_l;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function [JF_x, JF_x_dot] = JF( this, x, x_dot, t )
      JF_x     = zeros(5,5);
      JF_x_dot = zeros(5,5);

      JF_x(1,3) = -1;
      JF_x(2,4) = -1;
      JF_x(3,1) = x(5);
      JF_x(3,5) = x(1);
      JF_x(4,2) = x(5);
      JF_x(4,5) = x(2);
      JF_x(5,1) = 2.*x(1);
      JF_x(5,2) = 2.*x(2);

      JF_x_dot(1,1) = 1;
      JF_x_dot(2,2) = 1;
      JF_x_dot(3,3) = this.m_m;
      JF_x_dot(4,4) = this.m_m;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function res__h = H( this, x, x_dot, t )

      % extract states
      x = vars__(1);
      y = vars__(2);
      u = vars__(3);
      v = vars__(4);
      lambda = vars__(5);

      % evaluate function
      t1 = ell ^ 2;
      t2 = x ^ 2;
      t3 = y ^ 2;
      res__1 = t1 - t2 - t3;
      res__2 = 2 * x * u + 2 * y * v;
      t8 = u ^ 2;
      t9 = v ^ 2;
      res__3 = 0.1e1 / m * (m * (2 * g * y - 2 * t8 - 2 * t9) + 2 * (t2 + t3) * lambda);

      % store on output
      res__h = zeros(3,1);
      res__h(1) = res__1;
      res__h(2) = res__2;
      res__h(3) = res__3;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = JH( this, x, x_dot, t )
      m = this.m_m;
      g = this.m_g;

      % Extract states
      x      = X(1);
      y      = X(2);
      u      = X(3);
      v      = X(4);
      lambda = X(5);

      % Evaluate function
      t1 = 2 * x;
      res__1_1 = -t1;
      t2 = 2 * y;
      res__1_2 = -t2;
      res__2_1 = 2 * u;
      res__2_2 = 2 * v;
      res__2_3 = t1;
      res__2_4 = t2;
      t3 = 0.1e1 / m;
      res__3_1 = 4 * lambda * t3 * x;
      res__3_2 = t3 * (2 * m * g + 4 * lambda * y);
      res__3_3 = -4 * u;
      res__3_4 = -4 * v;
      t13 = x ^ 2;
      t14 = y ^ 2;
      res__3_5 = t3 * (2 * t13 + 2 * t14);

      % Store output
      out      = zeros(3,5);
      out(1,1) = res__1_1;
      out(1,2) = res__1_2;
      out(2,1) = res__2_1;
      out(2,2) = res__2_2;
      out(2,3) = res__2_3;
      out(2,4) = res__2_4;
      out(3,1) = res__3_1;
      out(3,2) = res__3_2;
      out(3,3) = res__3_3;
      out(3,4) = res__3_4;
      out(3,5) = res__3_5;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function plot( this, ~, X )
      x  = X(1);
      y  = X(2);
      x0 = 0;
      y0 = 0;
      tt = 0:pi/100:2*pi;
      xx = this.m_l*cos(tt);
      yy = this.m_l*sin(tt);
      hold off;
      plot(xx, yy, 'LineWidth', 1.0, 'Color', 'red');
      hold on;
      grid on; grid minor;
      xlabel('$x$(m)');
      ylabel('$y$(m)');
      l = 1.1*this.m_l;
      drawLine(x0, y0, x, y, 'LineWidth', 5, 'Color', 'k');
      drawCOG( 0.1*this.m_l, x0, y0 );
      fillCircle( 'r', x, y, 0.1*this.m_l );
      xlim([-l, l]);
      ylim([-l, l]);
      axis equal;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
