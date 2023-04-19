%
%> Class container for Ralston's method.
%
classdef Ralston2 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Ralston's method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>       0 &   0 &   0 \\
    %>     2/3 & 2/3 &   0 \\
    %>     \hline
    %>         & 1/4 & 3/4
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Ralston2()
      tbl.A   = [0, 0; 2/3, 0];
      tbl.b   = [1/4, 3/4];
      tbl.b_e = [];
      tbl.c   = [0, 2/3]';
      this@RKexplicit('Ralston2', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
