%
%> Class container for Lobatto IIIA 1(2) method.
%
classdef Indigo_LobattoIIIA12 < Indigo_ImplicitRungeKutta
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
    function this = Indigo_LobattoIIIA12()
      tbl.A   = [0, 0; 1/2, 1/2];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [1, 0];
      tbl.c   = [0, 1]';
      this@Indigo_ImplicitRungeKutta('LobattoIIIA12', 2, tbl); % order = 2*s-2
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
