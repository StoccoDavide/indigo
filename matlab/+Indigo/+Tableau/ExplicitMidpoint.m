%
%> Class container for Explicit midpoint method.
%
classdef ExplicitMidpoint < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Explicit midpoint method.
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>   0   &   0 & 0 \\
    %>   1/2 & 1/2 & 0 \\
    %>   \hline
    %>       &   0 & 1
    %> \end{array}
    %> \f]
    %
    function this = ExplicitMidpoint()
      tbl.A   = [0, 0; 1/2, 0];
      tbl.b   = [0, 1];
      tbl.b_e = [];
      tbl.c   = [0, 1/2]';
      this@Indigo.RungeKutta( 'ExplicitMidpoint', 2, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
