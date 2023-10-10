%
%> Class container for Lobatto IIIC method.
%
classdef LobattoIIIC6 < Lime.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIC method.
    %>
    % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
    % Journal of Applied Analysis and Computation
    % Volume 7, Number 3, August 2017, 1185-1199
    % SYMPLECTIC RUNGE-KUTTA METHODS OF HIGH ORDER BASED ON W-TRANSFORMATION
    %>
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
      this@Lime.RungeKutta( 'LobattoIIIC6', 6, tbl );
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
