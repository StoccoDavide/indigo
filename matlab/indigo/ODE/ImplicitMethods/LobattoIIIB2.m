%
%> Class container for Lobatto IIIB method.
%
classdef LobattoIIIB2 < RKimplicit
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
    %>   \begin{array}{c|cc}
    %>     0 & 1/2 &   0 \\
    %>     1 & 1/2 &   0 \\
    %>     \hline
    %>       & 1/2 & 1/2
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIB2()
      tbl.A   = [1/2, 0; 1/2, 0];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [];
      tbl.c   = [0, 1]';
      this@RKimplicit('LobattoIIIB2', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
