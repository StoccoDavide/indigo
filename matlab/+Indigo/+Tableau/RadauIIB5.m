%
%> Class container for Radau IIB method.
%
classdef RadauIIB5 < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Radau IIB5 method.
    %>
    % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
    % Symplectic Runge-Kutta Methods of High Order Based on W-Transformation,
    % Kaifeng Xia, Yuhao Cong1 and Geng Sun. Journal of Applied Analysis and
    % Computation, Volume 7, Number 3, August 2017, 1185-1199
    %>
    %
    function this = RadauIIB5()
      s6 = sqrt(6);
      tbl.A   = [(16-s6)/72,        (328-167*s6)/1800, (3*s6-2)/450;  ...
                 (328+167*s6)/1800, (16+s6)/72,        -(3*s6+2)/450; ...
                 (17-2*s6)/36,      (17+2*s6)/36,       1/18];
      tbl.b   = [(16-s6)/36, (16+s6)/36, 1/9];
      tbl.b_e = [];
      tbl.c   = tbl.A*ones(3,1);
      this@Indigo.RungeKutta('RadauIIB5', 5, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
