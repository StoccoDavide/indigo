%
%> Class container for Radau IIB method.
%
classdef RadauIIB5 < Indigo.RungeKutta.Method
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Radau IIB method.
    %>
    % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
    % Journal of Applied Analysis and Computation
    % Volume 7, Number 3, August 2017, 1185-1199
    % SYMPLECTIC RUNGE-KUTTA METHODS OF HIGH ORDER BASED ON W-TRANSFORMATION
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
      this@Indigo.RungeKutta.Method( 'RadauIIB5', 5, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
