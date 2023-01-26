%> Implementation of the Non Linear Pendulum (2 Equations)
%>
%> \rst
%> .. math::
%>
%>   \begin{cases}
%>      \theta' = \omega & \\
%>      \omega' = -\displaystyle\frac{g}{\ell}\sin(\theta) &
%>   \end{cases}
%>
%> \endrst
%
classdef PendulumODE_Implicit < ODEsystem
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
    function this = PendulumODE_Implicit( m, l, g )
      neq  = 2;
      ninv = 0;
      this@ODEsystem( 'NonLinearPendulum2Eqns', neq, ninv );
      this.m_m = m;
      this.m_l = l;
      this.m_g = g;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = F( this, x, x_dot, t )
      out    = zeros(2,1);
      out(1) = x_dot(1) - x(2);
      out(2) = x_dot(2) + (this.m_g/this.m_l)*sin(x(1));
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function [JF_x, JF_x_dot] = JF( this, x, x_dot, t )
      JF_x      = zeros(2,2);
      JF_x_dot  = eye(2);
      JF_x(1,2) = -1;
      JF_x(2,1) = (this.m_g/this.m_l)*cos(x(1));
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function H( ~, ~, ~ )
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function JH( ~, ~, ~ )
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function plot( this, ~, x )
      x  =  this.m_l*sin(x(1));
      y  = -this.m_l*cos(x(1));
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
