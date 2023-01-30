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
classdef ThreeBodyProblem_Implicit < ODEsystem
  %
  properties (SetAccess = protected, Hidden = true)
    %
    %> Body mass factor
    %
    m_mu;
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function this = ThreeBodyProblem_Implicit( mu )
      neq  = 4;
      ninv = 0;
      this@ODEsystem( 'ThreeBodyProblem', neq, ninv );
      this.m_mu = mu;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    % x = [x, y, u, v]
    % x_dot = [x', y', u', v']
    %
    function out = F( this, x, x_dot, t )
      mup    = 1 - this.m_mu;
      D1     = ((x(1) + this.m_mu)^2 + x(2)^2)^(3/2);
      D2     = ((x(1) - mup)^2 + x(2)^2)^(3/2);
      out    = zeros(4,1);
      out(1) = x_dot(1) - x(3);
      out(2) = x_dot(2) - x(4);
      out(3) = x_dot(3) - (x(1) + 2 * x(4) - mup * (x(1) + this.m_mu) / D1 - ...
        this.m_mu * (x(1) - mup) / D2);
      out(4) = x_dot(4) - (x(2) - 2 * x(3) - mup * x(2) / D1 - this.m_mu * x(2) / D2);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function [JF_x, JF_x_dot] = JF( this, x, x_dot, t )
      mup       = 1 - this.m_mu;
      JF_x      = zeros(4,4);
      JF_x_dot  = eye(4,4);

      JF_x(1,3) = -1;
      JF_x(2,4) = -1;
      JF_x(3,1) = -1 + mup/((x(1) + this.m_mu)^2 + x(2)^2)^(3/2) - (3*mup*(x(1) + this.m_mu)*(2*x(1) + 2*this.m_mu))/(2*((x(1) + this.m_mu)^2 + x(2)^2)^(5/2)) + this.m_mu/((x(1) - mup)^2 + x(2)^2)^(3/2) - (3*this.m_mu*(x(1) - mup)*(2*x(1) - 2*mup))/(2*((x(1) - mup)^2 + x(2)^2)^(5/2));
      JF_x(3,2) = -3*mup*(x(1) + this.m_mu)*x(2)/((x(1) + this.m_mu)^2 + x(2)^2)^(5/2) - 3*this.m_mu*(x(1) - mup)*x(2)/((x(1) - mup)^2 + x(2)^2)^(5/2);
      JF_x(3,4) = -2;
      JF_x(4,1) = -(3*mup*x(2)*(2*x(1) + 2*this.m_mu))/(2*((x(1) + this.m_mu)^2 + x(2)^2)^(5/2)) - (3*this.m_mu*x(2)*(2*x(1) - 2*mup))/(2*((x(1) - mup)^2 + x(2)^2)^(5/2));
      JF_x(4,2) = -1 + mup/((x(1) + this.m_mu)^2 + x(2)^2)^(3/2) - 3*mup*x(2)^2/((x(1) + this.m_mu)^2 + x(2)^2)^(5/2) + this.m_mu/((x(1) - mup)^2 + x(2)^2)^(3/2) - 3*this.m_mu*x(2)^2/((x(1) - mup)^2 + x(2)^2)^(5/2);
      JF_x(4,3) = 2;
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
