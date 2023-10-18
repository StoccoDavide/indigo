%
%> Class container for Gauss-Legendre method.
%
classdef GaussLegendre6 < Indigo.RungeKutta.Method
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Gauss-Legendre method.
    %>
    % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
    % Journal of Applied Analysis and Computation
    % Volume 7, Number 3, August 2017, 1185-1199
    % SYMPLECTIC RUNGE-KUTTA METHODS OF HIGH ORDER BASED ON W-TRANSFORMATION
    %>
    %> \f[
    %> \begin{array}{c|ccc}
    %>   1/2-t_1 &     w & z-t_2 & w-t_4 \\
    %>       1/2 & w+t_3 &     z & w-t_3 \\
    %>   1/2+t_1 & w+t_4 & z+t_2 &     w \\
    %>   \hline
    %>         &  5/18 &   4/9 &  5/18
    %> \end{array}
    %> \quad t_1 = \displaystyle\frac{\sqrt{15}}{10}
    %> \quad t_2 = \displaystyle\frac{\sqrt{15}}{15}
    %> \quad t_3 = \displaystyle\frac{\sqrt{15}}{24}
    %> \quad t_4 = \displaystyle\frac{\sqrt{15}}{30}
    %> \quad w   = \displaystyle\frac{5}{36}
    %> \quad z   = \displaystyle\frac{2}{9}
    %> \f]
    %
    function this = GaussLegendre6()
      t_1 = sqrt(15)/10;
      t_2 = sqrt(15)/15;
      t_3 = sqrt(15)/24;
      t_4 = sqrt(15)/30;
      w    = 5/36;
      z    = 2/9;
      tbl.A   = [w,     z-t_2, w-t_4; ...
                 w+t_3, z,     w-t_3; ...
                 w+t_4, z+t_2, w];
      tbl.b   = [5/18, 4/9, 5/18];
      tbl.b_e = [];
      tbl.c   = [1/2-t_1, 1/2, 1/2+t_1]';
      this@Indigo.RungeKutta.Method( 'GaussLegendre6', 6, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
