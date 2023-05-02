%
%> Class container for Lobatto IIIB 1(2) method.
%
classdef Indigo_LobattoIIIB12 < Indigo_ImplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIB 1(2) method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0 & 0   &  0 \\
    %>     1 & 1/2 & 1/2 \\
    %>     \hline
    %>       & 1/2 & 1/2 \\
    %>       & 1   & 0
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Indigo_LobattoIIIB12()
      tbl.A   = [0, 0; ...
                 1, 0];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [1, 0];
      tbl.c   = [1/2, 1/2]';
      this@Indigo_ImplicitRungeKutta('LobattoIIIB12', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
