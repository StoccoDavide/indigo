%
%> Class container for Heun's method.
%
classdef Heun3 < Indigo.RungeKutta.Method
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Heun's method.
    %>
    %> \f[
    %> \begin{array}{c|ccc}
    %>     0 &   0 &   0 &   0 \\
    %>   1/3 & 1/3 &   0 &   0 \\
    %>   2/3 &   0 & 2/3 &   0 \\
    %>   \hline
    %>       & 1/4 &   0 & 3/4
    %> \end{array}
    %> \f]
    %
    function this = Heun3()
      tbl.A   = [0,   0,   0; ...
                 1/3, 0,   0; ...
                 0,   2/3, 0];
      tbl.b   = [1/4, 0, 3/4];
      tbl.b_e = [];
      tbl.c   = [0, 1/3, 2/3]';
      this@Indigo.RungeKutta.Method( 'Heun3', 3, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
