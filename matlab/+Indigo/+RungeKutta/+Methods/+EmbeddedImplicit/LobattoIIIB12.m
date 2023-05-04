%
%> Class container for Lobatto IIIB 1(2) method.
%
classdef LobattoIIIB12 < Indigo.RungeKutta.Implicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIB 1(2) method.
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>   0 & 0   &  0 \\
    %>   1 & 1/2 & 1/2 \\
    %>   \hline
    %>     & 1/2 & 1/2 \\
    %>     & 1   & 0
    %> \end{array}
    %> \f[
    %
    function this = LobattoIIIB12()
      tbl.A   = [0, 0; ...
                 1, 0];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [1, 0];
      tbl.c   = [1/2, 1/2]';
      this@Indigo.RungeKutta.Implicit('LobattoIIIB12', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
