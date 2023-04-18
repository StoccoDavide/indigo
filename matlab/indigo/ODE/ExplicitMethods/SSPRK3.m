%
%> Class container for third-order strong stability preserving Runge-Kutta
%> method.
%
classdef SSPRK3 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Third-order strong stability preserving Runge-Kutta method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 &   0 &   0 &   0 \\
    %>       1 &   1 &   0 &   0 \\
    %>     1/2 & 1/4 & 1/4 &   0 \\
    %>     \hline
    %>         & 1/6 & 1/6 & 2/3
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = SSPRK3()
      tbl.A   = [0,   0,   0; ...
                 1,   0,   0; ...
                 1/4, 1/4, 0];
      tbl.b   = [1/6, 1/6, 2/3];
      tbl.c   = [0, 1, 1/2]';
      tbl.b_e = [];
      this@RKexplicit( 'SSPRK3', 3, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
