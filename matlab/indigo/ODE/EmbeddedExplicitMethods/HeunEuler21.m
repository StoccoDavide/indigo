%
%> Class container for Heun-Euler 2(1) method.
%
classdef HeunEuler21 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Heun-Euler 2(1) method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0 & 0 & 0 \\
    %>     1 & 1 & 0 \\
    %>     \hline
    %>       & 1/2 & 1/2 \\
    %>       &   1 & 0   \\
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = HeunEuler21()
        this@RKexplicit( ...
        'HeunEuler21', ...
        [0, 0; ...
         1, 1], ...
        [1/2, 1/2], ...
        [1, 0], ...
        [0, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
