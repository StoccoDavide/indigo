%
%> Class container for Heun-Euler 2(1) method.
%
classdef Indigo_HeunEuler21 < Indigo_ExplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Heun-Euler 2(1) method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0 & 0 & 0 \\
    %>     1 & 1 & 0 \\
    %>     \hline
    %>       & 1/2 & 1/2 \\
    %>       &   1 & 0   \\
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Indigo_HeunEuler21()
      tbl.A   = [0, 0; ...
                 1, 1];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [1, 0];
      tbl.c   = [0, 1]';
      this@Indigo_ExplicitRungeKutta('HeunEuler21', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
