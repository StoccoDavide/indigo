%
%> Class container for The Heun-Euler method of first- and second-order method.
%
classdef HeunEuler < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Heun-Euler method of first- and second-order method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0 & 0 & 0 \\
    %>     1 & 1 & 0 \\
    %>     \hline
    %>       & 1/2 & 1/2 \\
    %>       &   1 & 1   \\
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = HeunEuler()
        this@RKexplicit( ...
        'RKF12', ...
        [0, 0; ...
         1, 1], ...
        [1/2, 1/2], ...
        [1, 1], ...
        [0, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
