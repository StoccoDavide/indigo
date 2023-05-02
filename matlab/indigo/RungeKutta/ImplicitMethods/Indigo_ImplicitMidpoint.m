%
%> Class container for Implicit midpoint method.
%
classdef Indigo_ImplicitMidpoint < Indigo_ImplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Implicit midpoint method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|c}
    %>     1/2 & 1/2 \\
    %>     \hline
    %>         &   1
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Indigo_ImplicitMidpoint()
      tbl.A   = 1/2;
      tbl.b   = 1;
      tbl.b_e = [];
      tbl.c   = 1/2;
      this@Indigo_ImplicitRungeKutta('ImplicitMidpoint', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
