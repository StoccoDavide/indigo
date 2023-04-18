%
%> Class container for Runge-Kutta 3 method.
%
classdef RK3 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Runge-Kutta 3 method.
    %>
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 &   0 &   0 &   0 \\
    %>     1/2 & 1/2 &   0 &   0 \\
    %>       1 &  -1 &   2 &   0 \\
    %>     \hline
    %>         & 1/6 & 2/3 & 1/6
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = RK3()
      tbl.A   = [0,   0, 0; ...
                 1/2, 0, 0; ...
                 -1,  2, 0];
      tbl.b   = [1/6, 2/3, 1/6];
      tbl.c   = [0, 1/2, 1]';
      tbl.b_e = [];
      this@RKexplicit( 'RK3', 3, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
