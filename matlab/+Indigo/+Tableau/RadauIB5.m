%
%> Class container for Radau IB method.
%
classdef RadauIB5 < Lime.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Radau IB method.
    %>
    % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
    % Journal of Applied Analysis and Computation
    % Volume 7, Number 3, August 2017, 1185-1199
    % SYMPLECTIC RUNGE-KUTTA METHODS OF HIGH ORDER BASED ON W-TRANSFORMATION
    %>
    %
    function this = RadauIB5()
      s6 = sqrt(6);
      tbl.A   = [1/18,          -(1+s6)/36,        (-1+s6)/36;        ...
                 (52+3*s6)/450, (16+s6)/72,        (472-217*s6)/1800; ...
                 (52-3*s6)/450, (472+217*s6)/1800, (16-s6)/72];
      tbl.b   = [1/9, (16+s6)/36, (16-s6)/36];
      tbl.b_e = [];
      tbl.c   = tbl.A*ones(3,1);
      this@Lime.RungeKutta( 'RadauIB5', 5, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
