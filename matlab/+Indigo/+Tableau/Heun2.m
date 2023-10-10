%
%> Class container for Heun's method.
%
classdef Heun2 < Indigo.RungeKutta.Method
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Heun's method.
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>   0 &   0 &   0 \\
    %>   1 &   1 &   0 \\
    %>   \hline
    %>     & 1/2 & 1/2
    %> \end{array}
    %> \f]
    %
    function this = Heun2()
      tbl.A   = [0, 0; 1, 0];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [];
      tbl.c   = [0, 1]';
      this@Indigo.RungeKutta.Method( 'Heun2', 2, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
