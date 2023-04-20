%
%> Class container for Implicit Euler method.
%
classdef ImplicitEuler < ImplicitRungeKutta
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
    function this = ImplicitEuler()
      tbl.A   = 1;
      tbl.b   = 1;
      tbl.b_e = [];
      tbl.c   = 1;
      this@ImplicitRungeKutta('ImplicitEuler', 1, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
