%
%> Class container for Lobatto IIIB method.
%
classdef LobattoIIIB4 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIB method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 & 1/6 & -1/6 &   0 \\
    %>     1/2 & 1/6 &  1/3 &   0 \\
    %>       1 & 1/6 &  5/6 &   0 \\
    %>     \hline
    %>         & 1/6 &  2/3 & 1/6
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIB4()
      tbl.A   = [1/6, -1/6, 0; ...
                 1/6,  1/3, 0; ...
                 1/6,  5/6, 0];
      tbl.b   = [1/6, 2/3, 1/6];
      tbl.c   = [0, 1/2, 1]';
      tbl.b_e = [];
      this@RKimplicit( 'LobattoIIIB4', 4, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
