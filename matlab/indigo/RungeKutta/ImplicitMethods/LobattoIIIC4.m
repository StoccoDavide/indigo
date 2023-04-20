%
%> Class container for Lobatto IIIC method.
%
classdef LobattoIIIC4 < ImplicitRungeKutta
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
    %>   \begin{array}{c|ccc}
    %>       0 & 1/6 & -1/3 & 1/6  \\
    %>     1/2 & 1/6 & 5/12 & -1/12 \\
    %>       1 & 1/6 & 2/3  &  1/6  \\
    %>     \hline
    %>         & 1/6 & 2/3 & 1/6
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIC4()
      tbl.A   = [1/6, -1/3,   1/6; ...
                 1/6,  5/12, -1/12; ...
                 1/6,  2/3,   1/6];
      tbl.b   = [1/6, 2/3, 1/6];
      tbl.b_e = [];
      tbl.c   = [0, 1/2, 1]';
      this@ImplicitRungeKutta('LobattoIIIC4', 4, tbl);
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
