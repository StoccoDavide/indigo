%
%> Class container for Lobatto IIIC second-order embedded method (2 stages)
%
classdef LobattoIIIC12 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIC second-order embedded method (2 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0 & 1/2 & -1/2 \\
    %>     1 & 1/2 &  1/2 \\
    %>     \hline
    %>       & 1/2 &  1/2 \\
    %>       & 1   &  0
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIC12()
      this@RKimplicit( ...
        'LobattoIIIC12', ...
        [1/2, -1/2; 1/2, 1/2], ...
        [1/2, 1/2], ...
        [1, 0], ...
        [0, 1]' ...
      );
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
