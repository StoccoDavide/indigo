%
%> Class container for Lobatto IIIB 3(4) method.
%
classdef LobattoIIIB34 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIB 3(4) method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 & 1/6 & -1/6 &   0 \\
    %>     1/2 & 1/6 &  1/3 &   0 \\
    %>       1 & 1/6 &  5/6 &   0 \\
    %>     \hline
    %>         & 1/6  &  2/3 & 1/6 \\
    %>         & -1/2 &  2   & -1/2
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIB34()
      tbl.A   = [1/6, -1/6,  0; ...
                 1/6,  1/3,  0; ...
                 1/6,  5/6,  0];
      tbl.b   = [1/6, 2/3, 1/6];
      tbl.b_e = [-1/2, 2, -1/2];
      tbl.c   = [0, 1/2, 1]';
      this@RKimplicit('LobattoIIIB34', 4, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
