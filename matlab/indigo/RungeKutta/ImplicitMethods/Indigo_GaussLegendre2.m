%
%> Class container for Gauss-Legendre method.
%
classdef Indigo_GaussLegendre2 < Indigo_ImplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Gauss-Legendre method.
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
    function this = Indigo_GaussLegendre2()
      tbl.A   = [1/2];
      tbl.b   = 1;
      tbl.b_e = [];
      tbl.c   = 1/2;
      this@Indigo_ImplicitRungeKutta('GaussLegendre2', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
