%
%> Class container for Gauss-Legendre 5(6) method.
%
classdef GaussLegendre56 < ImplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Gauss-Legendre 5(6) method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>     1/2-t_1 &     w & z-t_2 & w-t_4 \\
    %>         1/2 & w+t_3 &     z & w-t_3 \\
    %>     1/2+t_1 & w+t_4 & z+t_2 &     w \\
    %>     \hline
    %>           &  5/18 &   4/9 &  5/18 \\
    %>           &  -5/6 &   8/3 &  -5/6
    %>   \end{array}
    %>   \quad t_1 = \displaystyle\frac{\sqrt{15}}{10}
    %>   \quad t_2 = \displaystyle\frac{\sqrt{15}}{15}
    %>   \quad t_3 = \displaystyle\frac{\sqrt{15}}{24}
    %>   \quad t_4 = \displaystyle\frac{\sqrt{15}}{30}
    %>   \quad w   = \displaystyle\frac{5}{36}
    %>   \quad z   = \displaystyle\frac{2}{9}
    %>
    %> \endrst
    %
    function this = GaussLegendre56()
      t_1 = sqrt(15)/10;
      t_2 = sqrt(15)/15;
      t_3 = sqrt(15)/24;
      t_4 = sqrt(15)/30;
      w   = 5/36;
      z   = 2/9;
      tbl.A   = [w,     z-t_2, w-t_4; ...
                 w+t_3, z,     w-t_3; ...
                 w+t_4, z+t_2, w];
      tbl.b   = [5/18, 4/9, 5/18];
      tbl.b_e = [-5/6, 8/3, -5/6];
      tbl.c   = [1/2-t_1, 1/2, 1/2+t_1]';
      this@ImplicitRungeKutta('GaussLegendre56', 6, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
