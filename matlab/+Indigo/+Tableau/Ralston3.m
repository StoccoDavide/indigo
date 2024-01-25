%
%> Class container for Ralston's method.
%
classdef Ralston3 < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Ralston's method.
    %>
    %> \f[
    %> \begin{array}{c|ccc}
    %>     0 &   0 &   0 &   0 \\
    %>   1/2 & 1/2 &   0 &   0 \\
    %>   3/4 &   0 & 3/4 &   0 \\
    %>   \hline
    %>       & 2/9 & 1/3 & 4/9
    %> \end{array}
    %> \f]
    %
    function this = Ralston3()
      tbl.A   = [0,   0,   0; ...
                 1/2, 0,   0; ...
                 0,   3/4, 0];
      tbl.b   = [2/9, 1/3, 4/9];
      tbl.b_e = [];
      tbl.c   = [0, 1/2, 3/4]';
      this@Indigo.RungeKutta( 'Ralston3', 3, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
