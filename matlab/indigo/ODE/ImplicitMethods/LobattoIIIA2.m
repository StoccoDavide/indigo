%
%> Class container for Lobatto IIIA method.
%
classdef LobattoIIIA2 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIA method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0 &   0 &   0 \\
    %>     1 & 1/2 & 1/2 \\
    %>     \hline
    %>       & 1/2 & 1/2
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIA2()
      this@RKimplicit( ...
        'LobattoIIIA2', ...
        [0, 0; 1/2, 1/2], ...
        [1/2, 1/2], ...
        [0, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
