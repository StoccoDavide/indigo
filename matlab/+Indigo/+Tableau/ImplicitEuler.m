%
%> Class container for Implicit Euler method.
%
classdef ImplicitEuler < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Implicit Euler method.
    %>
    %> \f[
    %> \begin{array}{c|c}
    %>   1 & 1 \\
    %>   \hline
    %>     & 1
    %> \end{array}
    %> \f]
    %
    function this = ImplicitEuler()
      tbl.A   = 1;
      tbl.b   = 1;
      tbl.b_e = [];
      tbl.c   = 1;
      this@Indigo.RungeKutta('ImplicitEuler', 1, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
