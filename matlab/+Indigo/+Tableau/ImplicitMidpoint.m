%
%> Class container for Implicit midpoint method.
%
classdef ImplicitMidpoint < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Implicit midpoint method.
    %>
    %> \f[
    %> \begin{array}{c|c}
    %>   1/2 & 1/2 \\
    %>   \hline
    %>       &   1
    %> \end{array}
    %> \f]
    %
    function this = ImplicitMidpoint()
      tbl.A   = 1/2;
      tbl.b   = 1;
      tbl.b_e = [];
      tbl.c   = 1/2;
      this@Indigo.RungeKutta('ImplicitMidpoint', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
