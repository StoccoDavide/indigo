%
%> Class container for Radau IIA method.
%
classdef RadauIIA3 < ImplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Radau IIA method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     1/3 & 5/12 & -1/12 \\
    %>       1 &  3/4 &   1/4 \\
    %>     \hline
    %>         &  3/4 &   1/4
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = RadauIIA3()
      tbl.A   = [5/12, -1/12; ...
                 3/4,   1/4];
      tbl.b   = [3/4, 1/4];
      tbl.b_e = [];
      tbl.c   = [1/3, 1]';
      this@ImplicitRungeKutta('RadauIIA3', 3, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end