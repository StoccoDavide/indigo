%
%> Class container for Lobatto IIIC$^\star$ method.
%
classdef LobattoIIICS2 < RKimplicit
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
    %>   \begin{array}{c|cc}
    %>     0 &   0 &   0 \\
    %>     1 &   1 &   0 \\
    %>     \hline
    %>       & 1/2 & 1/2
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIICS2()
      tbl.A   = [0, 0; 1, 0];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [];
      tbl.c   = [0, 1]';
      this@RKimplicit('LobattoIIICS2', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
