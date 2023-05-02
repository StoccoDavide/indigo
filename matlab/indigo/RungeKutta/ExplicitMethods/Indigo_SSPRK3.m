%
%> Class container for third-order strong stability preserving Runge-Kutta
%> method.
%
classdef Indigo_SSPRK3 < Indigo_ExplicitRungeKutta
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
    function this = Indigo_SSPRK3()
      tbl.A   = [0,   0,   0; ...
                 1,   0,   0; ...
                 1/4, 1/4, 0];
      tbl.b   = [1/6, 1/6, 2/3];
      tbl.b_e = [];
      tbl.c   = [0, 1, 1/2]';
      this@Indigo_ExplicitRungeKutta('SSPRK3', 3, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
