%
%> Class container for Implicit Euler method.
%
classdef Indigo_ImplicitEuler < Indigo_ImplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Implicit Euler method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|c}
    %>     1 & 1 \\
    %>     \hline
    %>       & 1
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Indigo_ImplicitEuler()
      tbl.A   = 1;
      tbl.b   = 1;
      tbl.b_e = [];
      tbl.c   = 1;
      this@Indigo_ImplicitRungeKutta('ImplicitEuler', 1, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
