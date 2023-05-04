%
%> Class container for Explicit Euler method.
%
classdef ExplicitEuler < Indigo.RungeKutta.Explicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Explicit Euler method.
    %>
    %> \f[
    %> \begin{array}{c|c}
    %>   0 & 0 \\
    %>   \hline
    %>     & 1
    %> \end{array}
    %> \f[
    %
    function this = ExplicitEuler()
      tbl.A   = 0;
      tbl.b   = 1;
      tbl.b_e = [];
      tbl.c   = 0;
      this@Indigo.RungeKutta.Explicit('ExplicitEuler', 1, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
