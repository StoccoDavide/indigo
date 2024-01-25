%
%> Class container for Lobatto IIIB method.
%
classdef LobattoIIIB2 < Indigo.RungeKutta
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
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>   1/2 & 1/2 &   0 \\
    %>   1   & 1/2 & 1/2 \\
    %>   \hline
    %>     & 1/2 & 1/2
    %> \end{array}
    %> \f]
    %
    function this = LobattoIIIB2()
      tbl.A   = [1/2, 0; ...
                 1/2, 1/2];
      tbl.b   = [1, 0];
      tbl.b_e = [1/2, 1/2];
      tbl.c   = [1/2, 1].';
      this@Indigo.RungeKutta( 'LobattoIIIB2', 2, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
