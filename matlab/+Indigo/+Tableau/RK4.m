%
%> Class container for Runge-Kutta 4 method.
%
classdef RK4 < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Runge-Kutta 4 method.
    %>
    %> \f[
    %> \begin{array}{c|ccccc}
    %>     0 &   0 &   0 &   0 &   0 \\
    %>   1/2 & 1/2 &   0 &   0 &   0 \\
    %>   1/2 &   0 & 1/2 &   0 &   0 \\
    %>     1 &   0 &   0 &   1 &   0 \\
    %>   \hline
    %>       & 1/6 & 1/3 & 1/3 & 1/6
    %> \end{array}
    %> \f]
    %
    function this = RK4()
      tbl.A   = [0,   0,   0, 0; ...
                 1/2, 0,   0, 0; ...
                 0,   1/2, 0, 0; ...
                 0,   0,   1, 0];
      tbl.b   = [1/6, 1/3, 1/3, 1/6];
      tbl.b_e = [];
      tbl.c   = [0, 1/2, 1/2, 1]';
      this@Indigo.RungeKutta('RK4', 4, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
