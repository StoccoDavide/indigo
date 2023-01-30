%
%> Class container for Lobatto IIIA second-order embedded method (2 stages)
%
classdef LobattoIIIA12 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIA second-order embedded method (2 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0 &   0 &   0 \\
    %>     1 & 1/2 & 1/2 \\
    %>     \hline
    %>       & 1/2 & 1/2 \\
    %>       & 1   & 0
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIA12()
      this@RKimplicit( ...
        'LobattoIIIA12', ...
        [0, 0; 1/2, 1/2], ...
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
