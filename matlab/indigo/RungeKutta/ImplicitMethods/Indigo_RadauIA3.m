%
%> Class container for Radau IA method.
%
classdef Indigo_RadauIA3 < Indigo_ImplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Radau IA method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>       0 & 1/4 & -1/4 \\
    %>     2/3 & 1/4 & 5/12 \\
    %>     \hline
    %>         & 1/4 &  3/4
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Indigo_RadauIA3()
      tbl.A   = [1/4, -1/4; ...
                 1/4, 5/12];
      tbl.b   = [1/4, 3/4];
      tbl.b_e = [];
      tbl.c   = [0, 2/3]';
      this@Indigo_ImplicitRungeKutta('RadauIA3', 3, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
