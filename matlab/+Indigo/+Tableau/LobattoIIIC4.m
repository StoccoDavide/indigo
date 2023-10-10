%
%> Class container for Lobatto IIIC method.
%
classdef LobattoIIIC4 < Lime.RungeKutta
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
    %> \begin{array}{c|ccc}
    %>     0 & 1/6 & -1/3 & 1/6  \\
    %>   1/2 & 1/6 & 5/12 & -1/12 \\
    %>     1 & 1/6 & 2/3  &  1/6  \\
    %>   \hline
    %>       & 1/6 & 2/3 & 1/6
    %> \end{array}
    %> \f]
    %
    function this = LobattoIIIC4()
      tbl.A   = [1/6, -1/3,   1/6; ...
                 1/6,  5/12, -1/12; ...
                 1/6,  2/3,   1/6];
      tbl.b   = [1/6, 2/3, 1/6];
      tbl.b_e = [-1/2, 2, -1/2];
      tbl.c   = [0, 1/2, 1]';
      this@Lime.RungeKutta( 'LobattoIIIC4', 4, tbl );
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
