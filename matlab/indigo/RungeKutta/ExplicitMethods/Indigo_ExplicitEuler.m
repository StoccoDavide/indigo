%
%> Class container for Explicit Euler method.
%
classdef Indigo_ExplicitEuler < Indigo_ExplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Explicit Euler method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|c}
    %>     0 & 0 \\
    %>     \hline
    %>       & 1
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Indigo_ExplicitEuler()
      tbl.A   = 0;
      tbl.b   = 1;
      tbl.b_e = [];
      tbl.c   = 0;
      this@Indigo_ExplicitRungeKutta('ExplicitEuler', 1, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
