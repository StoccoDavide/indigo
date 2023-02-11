%
%> Class container for Lobatto IIIA 1(2) method.
%
classdef LobattoIIIA12 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIA 1(2) method.
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
        [0,   0; ...
         1/2, 1/2], ...
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
