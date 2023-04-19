%
%> Class container for Lobatto IIIC 3(4) method.
%
classdef LobattoIIIC34 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIC 3(4) method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 & 1/6 & -1/3 & 1/6  \\
    %>     1/2 & 1/6 & 5/12 & -1/12 \\
    %>       1 & 1/6 & 2/3  &  1/6  \\
    %>     \hline
    %>         & 1/6  & 2/3 & 1/6 \\
    %>         & -1/2 & 2   & -1/2
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIC34()
      tbl.A   = [1/6, -1/3, 1/6; ...
                 1/6, 5/12, -1/12; ...
                 1/6, 2/3,  1/6];
      tbl.b   = [1/6, 2/3, 1/6];
      tbl.b_e = [-1/2, 2, -1/2];
      tbl.c   = [0, 1/2, 1]';
      this@RKimplicit('LobattoIIIC34', 4, tbl);
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
