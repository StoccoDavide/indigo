%
%> Class container for Lobatto IIIA2 method.
%
classdef LobattoIIIA2 < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIA2 method.
    %>
    % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
    % Symplectic Runge-Kutta Methods of High Order Based on W-Transformation,
    % Kaifeng Xia, Yuhao Cong1 and Geng Sun. Journal of Applied Analysis and
    % Computation, Volume 7, Number 3, August 2017, 1185-1199
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>   0 &   0 &   0 \\
    %>   1 & 1/2 & 1/2 \\
    %>   \hline
    %>     & 1/2 & 1/2
    %> \end{array}
    %> \f]
    %
    function this = LobattoIIIA2()
      tbl.A   = [0,   0; ...
                 1/2, 1/2];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [1, 0];
      tbl.c   = [0, 1]';
      this@Indigo.RungeKutta('LobattoIIIA2', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
