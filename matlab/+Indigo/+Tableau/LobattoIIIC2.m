%
%> Class container for Lobatto IIIC method.
%
classdef LobattoIIIC2 < Lime.RungeKutta
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
    %> \f[
    %> \begin{array}{c|cc}
    %>   0 & 1/2 & -1/2 \\
    %>   1 & 1/2 &  1/2 \\
    %>   \hline
    %>     & 1/2 &  1/2
    %> \end{array}
    %> \f]
    %
    function this = LobattoIIIC2()
      tbl.A   = [1/2, -1/2; ...
                 1/2,  1/2];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [1, 0];
      tbl.c   = [0, 1]';
      this@Lime.RungeKutta( 'LobattoIIIC2', 2, tbl );
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
