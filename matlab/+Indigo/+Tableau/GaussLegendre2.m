%
%> Class container for Gauss-Legendre method.
%
classdef GaussLegendre2 < Indigo.RungeKutta.Method
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Gauss-Legendre method.
    %>
    %> \f[
    %> \begin{array}{c|c}
    %>   1/2 & 1/2 \\
    %>   \hline
    %>       &   1
    %> \end{array}
    %> \f]
    %
    function this = GaussLegendre2()
      tbl.A   = [1/2];
      tbl.b   = 1;
      tbl.b_e = [];
      tbl.c   = 1/2;
      this@Indigo.RungeKutta.Method( 'GaussLegendre2', 2, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
