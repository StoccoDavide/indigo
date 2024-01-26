%
%> Class container for Wray's method.
%
classdef Wray3 < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Wray's method.
    %>
    %> \f[
    %> \begin{array}{c|ccc}
    %>      0 &    0 &    0 &   0 \\
    %>   8/15 & 8/15 &    0 &   0 \\
    %>    2/3 &  1/4 & 5/12 &   0 \\
    %>   \hline
    %>        &  1/4 &    0 & 3/4
    %> \end{array}
    %> \f]
    %
    function this = Wray3()
      tbl.A   = [0,    0,    0; ...
                 8/15, 0,    0; ...
                 1/4,  5/12, 0];
      tbl.b   = [1/4, 0, 3/4];
      tbl.b_e = [];
      tbl.c   = [0, 8/15, 2/3]';
      this@Indigo.RungeKutta('Wray3', 3, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
