%
%> Class container for Explicit Euler method.
%
classdef ExplicitEuler < RKexplicit
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
    function this = ExplicitEuler()
      tbl.A   = 0;
      tbl.b   = 1;
      tbl.b_e = [];
      tbl.c   = 0;
      this@RKexplicit('ExplicitEuler', 1, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
