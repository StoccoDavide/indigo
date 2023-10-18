%
%> Class container for Lobatto IIID method.
%
classdef LobattoIIID2 < Indigo.RungeKutta.Method
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIID method.
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>   0 &  1/2 & 1/2 \\
    %>   1 & -1/2 & 1/2 \\
    %>   \hline
    %>     &  1/2 & 1/2
    %> \end{array}
    %> \f]
    %
    function this = LobattoIIID2()
      tbl.A   = [ 1/2, 1/2; ...
                 -1/2, 1/2];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [];
      tbl.c   = [1, 0].';
      this@Indigo.RungeKutta.Method( 'LobattoIIID2', 2, tbl );
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
