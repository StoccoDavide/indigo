%
%> Class container for Runge-Kutta 3 method.
%
classdef RK3 < Indigo.RungeKutta.Method
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Runge-Kutta 3 method.
    %>
    %>
    %> \f[
    %> \begin{array}{c|ccc}
    %>     0 &   0 &   0 &   0 \\
    %>   1/2 & 1/2 &   0 &   0 \\
    %>     1 &  -1 &   2 &   0 \\
    %>   \hline
    %>       & 1/6 & 2/3 & 1/6
    %> \end{array}
    %> \f]
    %
    function this = RK3()
      tbl.A   = [0,   0, 0; ...
                 1/2, 0, 0; ...
                 -1,  2, 0];
      tbl.b   = [1/6, 2/3, 1/6];
      tbl.b_e = [];
      tbl.c   = [0, 1/2, 1]';
      this@Indigo.RungeKutta.Method( 'RK3', 3, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
