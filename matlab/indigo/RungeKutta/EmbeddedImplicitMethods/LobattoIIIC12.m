%
%> Class container for Lobatto IIIC 1(2) method.
%
classdef LobattoIIIC12 < ImplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIC 1(2) method.
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
      tbl.A   = [1/2, -1/2; 1/2, 1/2];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [1, 0];
      tbl.c   = [0, 1]';
      this@ImplicitRungeKutta('LobattoIIIC12', 2, tbl);
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
