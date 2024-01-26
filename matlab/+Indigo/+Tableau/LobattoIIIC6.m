%
%> Class container for Lobatto IIIC6 method.
%
classdef LobattoIIIC6 < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIC6 method.
    %>
    % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
    % Symplectic Runge-Kutta Methods of High Order Based on W-Transformation,
    % Kaifeng Xia, Yuhao Cong1 and Geng Sun. Journal of Applied Analysis and
    % Computation, Volume 7, Number 3, August 2017, 1185-1199
    %>
    %
    function this = LobattoIIIC6()
      s5 = sqrt(5);
      tbl.A   = [1/12, -s5/12,       s5/12,        -1/12; ...
                 1/12, 1/4,          (10-7*s5)/60, s5/60; ...
                 1/12, (10+7*s5)/60,  1/4,         -s5/60; ...
                 1/12,  5/12,         5/12,        1/12];
      tbl.b   = [1/12,  5/12,         5/12,        1/12];
      tbl.b_e = [];
      tbl.c   = tbl.A*ones(4,1);
      this@Indigo.RungeKutta('LobattoIIIC6', 6, tbl);
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
