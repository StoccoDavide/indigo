%
%> Class container for Lobatto IIIA method.
%
classdef LobattoIIIA2 < ImplicitRungeKutta
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
      tbl.A   = [0, 0; 1/2, 1/2];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [];
      tbl.c   = [0, 1]';
      this@ImplicitRungeKutta('LobattoIIIA2', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end