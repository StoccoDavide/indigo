%
%> Class container for Gauss-Legendre 5(6) method.
%
classdef GaussLegendre56 < RKimplicit
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
    %>     1/2-t &     w & z-t_2 & w-t_4 \\
    %>       1/2 & w+t_3 &     z & w-t_3 \\
    %>     1/2+t & w+t_4 & z+t_2 &     w \\
    %>     \hline
    %>           &  5/18 &   4/9 &  5/18 \\
    %>           &  -5/6 &   8/3 &  -5/6
    %>   \end{array}
    %>   \quad t   = \displaystyle\frac{\sqrt{15}}{10}
    %>   \quad t_2 = \displaystyle\frac{\sqrt{15}}{15}
    %>   \quad t_3 = \displaystyle\frac{\sqrt{15}}{24}
    %>   \quad t_4 = \displaystyle\frac{\sqrt{15}}{30}
    %>   \quad w   = \displaystyle\frac{5}{36}
    %>   \quad z   = \displaystyle\frac{2}{9}
    %>
    %> \endrst
    %
    function this = GaussLegendre56()
      t  = sqrt(15)/10;
      t2 = sqrt(15)/15;
      t3 = sqrt(15)/24;
      t4 = sqrt(15)/30;
      w  = 5/36;
      z  = 2/9;
      this@RKimplicit( ...
        'GaussLegendre56', ...
        [w,    z-t2, w-t4; ...
         w+t3, z,    w-t3; ...
         w+t4, z+t2, w ], ...
        [5/18,4/9,5/18], ...
        [-5/6, 8/3, 5/6], ...
        [1/2-t,1/2,1/2+t]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
