%
%> Class container for Explicit midpoint method.
%
classdef ExplicitMidpoint < ExplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Explicit midpoint method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0   &   0 & 0 \\
    %>     1/2 & 1/2 & 0 \\
    %>     \hline
    %>         &   0 & 1
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = ExplicitMidpoint()
      tbl.A   = [0, 0; 1/2, 0];
      tbl.b   = [0, 1];
      tbl.b_e = [];
      tbl.c   = [0, 1/2]';
      this@ExplicitRungeKutta('ExplicitMidpoint', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
