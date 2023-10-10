%
%> Class container for Ralston's method.
%
classdef Ralston2 < Lime.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Ralston's method.
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>     0 &   0 &   0 \\
    %>   2/3 & 2/3 &   0 \\
    %>   \hline
    %>       & 1/4 & 3/4
    %> \end{array}
    %> \f]
    %
    function this = Ralston2()
      tbl.A   = [0, 0; 2/3, 0];
      tbl.b   = [1/4, 3/4];
      tbl.b_e = [];
      tbl.c   = [0, 2/3]';
      this@Lime.RungeKutta( 'Ralston2', 2, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
