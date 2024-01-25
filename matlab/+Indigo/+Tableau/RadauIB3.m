%
%> Class container for Radau IB method.
%
classdef RadauIB3 < Indigo.RungeKutta
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
    %>     0 & 1/8  & -1/8 \\
    %>   2/3 & 7/24 & 3/8 \\
    %>   \hline
    %>       & 1/4 &  3/4
    %> \end{array}
    %> \f]
    %
    function this = RadauIB3()
      tbl.A   = [1/8, -1/8; ...
                 7/24, 3/8];
      tbl.b   = [1/4, 3/4];
      tbl.b_e = [];
      tbl.c   = tbl.A*ones(2,1);
      this@Indigo.RungeKutta( 'RadauIB3', 3, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
