%
%> Class container for Lobatto IIIC method.
%
classdef LobattoIIIC2 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIC method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0 & 1/2 & -1/2 \\
    %>     1 & 1/2 &  1/2 \\
    %>     \hline
    %>       & 1/2 &  1/2
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIC2()
      this@RKimplicit( ...
        'LobattoIIIC2', ...
        [1/2, -1/2; 1/2, 1/2], ...
        [1/2, 1/2], ...
        [0, 1]' ...
      );
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
