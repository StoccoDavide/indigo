%
%> Class container for Merson's 4(5) method.
%
classdef Merson34 < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Merson's 3(4) method.
    %>
    %> \f[
    %> \begin{array}{c|ccccc}
    %>     0 &   0 &   0 &    0 & 0 & 0 \\
    %>   1/3 & 1/3 &   0 &    0 & 0 & 0 \\
    %>   1/3 & 1/6 & 1/6 &    0 & 0 & 0 \\
    %>   1/2 & 1/8 &   0 &  3/8 & 0 & 0 \\
    %>     1 & 1/2 &   0 & -3/2 & 2 & 0 \\
    %>   \hline
    %>      &  1/6 & 0 &  2/3 & 1/6 &   0 \\
    %>      & 1/10 & 0 & 3/10 & 2/5 & 1/5 \\
    %> \end{array}
    %> \f]
    %
    % P.M. Lukehart, "Algorithm 218. Kutta Merson". Comm. Assoc. Comput. Mach.,
    % 6 : 12 (1963) pp. 737-738.
    %
    function this = Merson34()
      tbl.A   = [0,   0,   0,    0, 0; ...
                 1/3, 0,   0,    0, 0; ...
                 1/6, 1/6, 0,    0, 0; ...
                 1/8, 0,   3/8,  0, 0; ...
                 1/2, 0,   -3/2, 2, 0];
      tbl.b   = [1/6, 0, 0, 2/3, 1/6];
      tbl.b_e = [1/2, 0, -3/2, 2, 0];
      tbl.c   = [0, 1/3, 1/3, 1/2, 1]';
      this@Indigo.RungeKutta('Merson34', 4, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    function err = error_estimate( this, x1, x2 )
      err = 0.2*max(abs(x1-x2));
    end
  end
  %
end
