%
%> Class container for Runge-Kutta 4 method.
%
classdef RK4 < ExplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Runge-Kutta 4 method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccccc}
    %>       0 &   0 &   0 &   0 &   0 \\
    %>     1/2 & 1/2 &   0 &   0 &   0 \\
    %>     1/2 &   0 & 1/2 &   0 &   0 \\
    %>       1 &   0 &   0 &   1 &   0 \\
    %>     \hline
    %>         & 1/6 & 1/3 & 1/3 & 1/6
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = RK4()
      tbl.A   = [0,   0,   0, 0; ...
                 1/2, 0,   0, 0; ...
                 0,   1/2, 0, 0; ...
                 0,   0,   1, 0];
      tbl.b   = [1/6, 1/3, 1/3, 1/6];
      tbl.b_e = [];
      tbl.c   = [0, 1/2, 1/2, 1]';
      this@ExplicitRungeKutta('RK4', 4, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end