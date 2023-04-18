%
%> Class container for Ralston's method.
%
classdef Ralston3 < RKexplicit
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
    %>   \begin{array}{c|ccc}
    %>       0 &   0 &   0 &   0 \\
    %>     1/2 & 1/2 &   0 &   0 \\
    %>     3/4 &   0 & 3/4 &   0 \\
    %>     \hline
    %>         & 2/9 & 1/3 & 4/9
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Ralston3()
      tbl.A   = [0,   0,   0; ...
                 1/2, 0,   0; ...
                 0,   3/4, 0];
      tbl.b   = [2/9, 1/3, 4/9];
      tbl.c   = [0, 1/2, 3/4]';
      tbl.b_e = [];
      this@RKexplicit( 'Ralston3', 3, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
