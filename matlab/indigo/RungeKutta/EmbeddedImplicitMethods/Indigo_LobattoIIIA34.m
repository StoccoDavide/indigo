...
 %
%> Class container for Lobatto IIIA 3(4) method.
%
classdef Indigo_LobattoIIIA34 < Indigo_ImplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIA 3(4) method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 &    0 &   0 &     0 \\
    %>     1/2 & 5/24 & 1/3 & -1/24 \\
    %>       1 &  1/6 & 2/3 &   1/6 \\
    %>     \hline
    %>         &  1/6 & 2/3 &   1/6 \\
    %>         & -1/2 & 2   &  -1/2 \\
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Indigo_LobattoIIIA34()
      tbl.A   = [0,    0,   0; ...
                 5/24, 1/3, -1/24; ...
                 1/6,  2/3, 1/6];
      tbl.b   = [1/6, 2/3, 1/6];
      tbl.b_e = [-1/2, 2, -1/2];
      tbl.c   = [0, 1/2, 1]';
      this@Indigo_ImplicitRungeKutta('LobattoIIIA34', 4, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
