%
%> Class container for Heun's method.
%
classdef Indigo_Heun3 < Indigo_ExplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Heun's method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 &   0 &   0 &   0 \\
    %>     1/3 & 1/3 &   0 &   0 \\
    %>     2/3 &   0 & 2/3 &   0 \\
    %>     \hline
    %>         & 1/4 &   0 & 3/4
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Heun3()
      tbl.A   = [0,   0,   0; ...
                 1/3, 0,   0; ...
                 0,   2/3, 0];
      tbl.b   = [1/4, 0, 3/4];
      tbl.b_e = [];
      tbl.c   = [0, 1/3, 2/3]';
      this@Indigo_ExplicitRungeKutta('Heun3', 3, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
