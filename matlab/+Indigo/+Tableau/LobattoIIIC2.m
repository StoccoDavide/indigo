%
%> Class container for Lobatto IIIC2 method.
%
classdef LobattoIIIC2 < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIC2 method.
    %>
    % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
    % Symplectic Runge-Kutta Methods of High Order Based on W-Transformation,
    % Kaifeng Xia, Yuhao Cong1 and Geng Sun. Journal of Applied Analysis and
    % Computation, Volume 7, Number 3, August 2017, 1185-1199
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>   0 & 1/2 & -1/2 \\
    %>   1 & 1/2 &  1/2 \\
    %>   \hline
    %>     & 1/2 &  1/2
    %> \end{array}
    %> \f]
    %
    function this = LobattoIIIC2()
      tbl.A   = [1/2, -1/2; ...
                 1/2,  1/2];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [1, 0];
      tbl.c   = [0, 1]';
      this@Indigo.RungeKutta('LobattoIIIC2', 2, tbl);
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
