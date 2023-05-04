%
%> Class container for Lobatto IIIB method.
%
classdef LobattoIIIB2 < Indigo.RungeKutta.Implicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIB method.
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>   0 & 1/2 &   0 \\
    %>   1 & 1/2 &   0 \\
    %>   \hline
    %>     & 1/2 & 1/2
    %> \end{array}
    %> \f[
    %
    function this = LobattoIIIB2()
      tbl.A   = [1/2, 0; 1/2, 0];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [];
      tbl.c   = [0, 1]';
      this@Indigo.RungeKutta.Implicit('LobattoIIIB2', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
