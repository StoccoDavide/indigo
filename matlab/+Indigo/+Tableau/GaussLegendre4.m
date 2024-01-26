%
%> Class container for Gauss-Legendre 3 method.
%
classdef GaussLegendre4 < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Gauss-Legendre 4 method.
    %>
    % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
    % Symplectic Runge-Kutta Methods of High Order Based on W-Transformation,
    % Kaifeng Xia, Yuhao Cong1 and Geng Sun. Journal of Applied Analysis and
    % Computation, Volume 7, Number 3, August 2017, 1185-1199
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>   1/2-t &   1/4 & 1/4-t \\
    %>   1/2+t & 1/4+t &   1/4 \\
    %>   \hline
    %>         &   1/2 &   1/2
    %> \end{array}
    %> \qquad t = \dfrac{\sqrt{3}}{6}
    %> \f]
    %
    function this = GaussLegendre4()
      t = sqrt(3)/6;
      tbl.A   = [1/4, 1/4-t; 1/4+t, 1/4];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [];
      tbl.c   = [1/2-t, 1/2+t]';
      this@Indigo.RungeKutta('GaussLegendre4', 4, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
