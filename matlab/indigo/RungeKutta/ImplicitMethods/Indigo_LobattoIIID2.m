%
%> Class container for Lobatto IIID method.
%
classdef Indigo_LobattoIIID2 < Indigo_ImplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIID method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0 &  1/2 & 1/2 \\
    %>     1 & -1/2 & 1/2 \\
    %>     \hline
    %>       &  1/2 & 1/2
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Indigo_LobattoIIID2()
      tbl.A   = [1/2, 1/2; -1/2, 1/2];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [];
      tbl.c   = [0, 1]';
      this@Indigo_ImplicitRungeKutta('LobattoIIID2', 2, tbl);
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
