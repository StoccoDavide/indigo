%> Implementation of ODE for assessing the integration method order
%>
%> \rst
%> .. math::
%> 
%>   \begin{cases}
%>      x' =  x+y & \quad x(0)=0 \\
%>      y' = -x+y & \quad y(0)=1
%>   \end{cases}
%>
%> \endrst
%
classdef CheckOrder < BVP_ODEsystem
  %
  properties (SetAccess = protected, Hidden = true)
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function this = CheckOrder()
      neqn = 2;
      ninv = 0;
      this@BVP_ODEsystem( 'CheckOrder', neqn, ninv );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = f( ~, ~, X )
      out    = zeros(2,1);
      out(1) =  X(1) + X(2);
      out(2) = -X(1) + X(2);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = DfDx( ~, ~, ~ )
      out = [ 1.0, 1.0; ...
             -1.0, 1.0 ];
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function h( ~, ~, ~ )
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function DhDx( ~, ~, ~ )
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function plot( ~, ~, ~ )
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function out = exact( ~, x_i, t )
      out      = zeros(2,length(t));
      out(1,:) = exp(t) .* (x_i(1) .* cos(t) + x_i(2) .* sin(t));
      out(2,:) = exp(t) .* (x_i(2) .* cos(t) - x_i(1) .* sin(t));
    end
    %
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
