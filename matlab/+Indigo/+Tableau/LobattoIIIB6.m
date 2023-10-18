%
%> Class container for Lobatto IIIB method.
%
classdef LobattoIIIB6 < Indigo.RungeKutta.Method
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIB method.
    %>
    % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
    % Journal of Applied Analysis and Computation
    % Volume 7, Number 3, August 2017, 1185-1199
    % SYMPLECTIC RUNGE-KUTTA METHODS OF HIGH ORDER BASED ON W-TRANSFORMATION
    %>
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
      this@Indigo.RungeKutta.Method( 'LobattoIIIB6', 6, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
