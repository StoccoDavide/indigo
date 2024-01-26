%
%> Class container for Lobatto IIIB6 method.
%
classdef LobattoIIIB6 < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIB6 method.
    %>
    % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
    % Symplectic Runge-Kutta Methods of High Order Based on W-Transformation,
    % Kaifeng Xia, Yuhao Cong1 and Geng Sun. Journal of Applied Analysis and
    % Computation, Volume 7, Number 3, August 2017, 1185-1199
    %>
    %> \f[
    %> \begin{array}{c|cccc}
    %    1/12 & -(1+\sqrt{5})/24 & (-1+\sqrt{5})/24 & 0 \\
    %    1/12 & (25+\sqrt{5})/120 & (25-13\sqrt{5})/120 & 0 \\
    %    1/12 & (25+13\sqrt{5})/120 & (25-\sqrt{5})/120 & 0 \\
    %    1/12 & (11-\sqrt{5})/24 & (11+\sqrt{5})/24 & 0 \\
    %    \hline
    %    1/12 & 5/12 & 5/12 & 1/12
    % \end{array}
    % \f]
    %
    function this = LobattoIIIB6()
      s5 = sqrt(5);
      tbl.A   = [1/12, -(1+s5)/24,      (-1+s5)/24,     0;...
                 1/12,  (25+s5)/120,    (25-13*s5)/120, 0; ...
                 1/12,  (25+13*s5)/120, (25-s5)/120,    0; ...
                 1/12,  (11-s5)/24,     (11+s5)/24,     0];
      tbl.b   =  [1/12, 5/12, 5/12, 1/12];
      tbl.b_e = [];
      tbl.c   = tbl.A*ones(4,1);
      this@Indigo.RungeKutta('LobattoIIIB6', 6, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
