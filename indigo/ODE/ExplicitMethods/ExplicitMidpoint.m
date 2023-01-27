%
%> Class container for Explicit midpoint second-order method.
%
classdef ExplicitMidpoint < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Explicit midpoint second-order method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0   &   0 & 0 \\
    %>     1/2 & 1/2 & 0 \\
    %>     \hline
    %>         &   0 & 1
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = ExplicitMidpoint()
      this@RKexplicit( ...
        'ExplicitMidpoint', ...
        [0, 0; 1/2, 0], ...
        [0, 1], ...
        [0, 1/2]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
