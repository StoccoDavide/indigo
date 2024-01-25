%
%> Class container for Lobatto IIIA method.
%
classdef LobattoIIIA4 < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIA method.
    %>
    % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
    % Journal of Applied Analysis and Computation
    % Volume 7, Number 3, August 2017, 1185-1199
    % SYMPLECTIC RUNGE-KUTTA METHODS OF HIGH ORDER BASED ON W-TRANSFORMATION
    %>
    %>
    %> \f[
    %> \begin{array}{c|ccc}
    %>     0 &    0 &   0 &     0 \\
    %>   1/2 & 5/24 & 1/3 & -1/24 \\
    %>     1 &  1/6 & 2/3 &   1/6 \\
    %>   \hline
    %>       &  1/6 & 2/3 &   1/6
    %> \end{array}
    %> \f]
    %
    function this = LobattoIIIA4()
      tbl.A   = [0,    0,   0; ...
                 5/24, 1/3, -1/24; ...
                 1/6,  2/3, 1/6];
      tbl.b   = [1/6, 2/3, 1/6];
      tbl.b_e = [-1/2, 2, -1/2]; % ordine 2!
      tbl.c   = [0, 1/2, 1]';
      this@Indigo.RungeKutta( 'LobattoIIIA4', 4, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
