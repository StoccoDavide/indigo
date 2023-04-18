%
%> Class container for Wray's method.
%
classdef Wray3 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Wray's method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>        0 &    0 &    0 &   0 \\
    %>     8/15 & 8/15 &    0 &   0 \\
    %>      2/3 &  1/4 & 5/12 &   0 \\
    %>     \hline
    %>          &  1/4 &    0 & 3/4
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Wray3()
      tbl.A   = [0,    0,    0; ...
                 8/15, 0,    0; ...
                 1/4,  5/12, 0];
      tbl.b   = [1/4, 0, 3/4];
      tbl.c   = [0, 8/15, 2/3]';
      tbl.b_e = [];
      this@RKexplicit( 'Wray3', 3, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
