%
%> Class container for Lobatto IIIC$^\star$ method.
%
classdef LobattoIIICS4 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIC$^\star$ method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 &   0 &   0 &   0 \\
    %>     1/2 & 1/4 & 1/4 &   0 \\
    %>       1 &   0 &   1 &   0 \\
    %>     \hline
    %>         & 1/6 & 2/3 & 1/6
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIICS4()
      tbl.A   = [0,   0,   0; ...
                 1/4, 1/4, 0; ...
                 0,   1,   0];
      tbl.b   = [1/6, 2/3, 1/6];
      tbl.b_e = [];
      tbl.c   = [0, 1/2, 1]';
      this@RKimplicit('LobattoIIICS4', 4, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
