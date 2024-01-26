%
%> Class container for Heun-Euler 2(1) method.
%
classdef HeunEuler21 < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Heun-Euler 2(1) method.
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>   0 & 0 & 0 \\
    %>   1 & 1 & 0 \\
    %>   \hline
    %>     & 1/2 & 1/2 \\
    %>     &   1 & 0   \\
    %> \end{array}
    %> \f]
    %
    function this = HeunEuler21()
      tbl.A   = [0, 0; ...
                 1, 0];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [1, 0];
      tbl.c   = [0, 1].';
      this@Indigo.RungeKutta('HeunEuler21', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
