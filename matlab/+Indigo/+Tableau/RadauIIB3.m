%
%> Class container for Radau IB method.
%
classdef RadauIIB3 < Lime.RungeKutta
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
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>   1/3 & 3/8  & -1/24 \\
    %>     1 & 7/8 & 1/8 \\
    %>   \hline
    %>       & 3/4 &  1/4
    %> \end{array}
    %> \f]
    %
    function this = RadauIIB3()
      tbl.A   = [3/8, -1/24; ...
                 7/8,  1/8];
      tbl.b   = [3/4, 1/4];
      tbl.b_e = [];
      tbl.c   = tbl.A*ones(2,1);
      this@Lime.RungeKutta( 'RadauIIB3', 3, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
