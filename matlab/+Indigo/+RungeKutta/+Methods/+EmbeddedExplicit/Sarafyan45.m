%
%> Class container for Sarafyan's 4(5) method.
%
classdef Sarafyan45 < Indigo.RungeKutta.Explicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Sarafyan's 4(5) method.
    %>
    %> \f[
    %> \begin{array}{c|ccccc}
    %>     0 &    0 &    0 &    0 &   0 & 0 \\
    %>     1 &    1 &    0 &    0 &   0 & 0 \\
    %>   3/2 &  3/4 &  1/2 &    0 &   0 & 0 \\
    %>     2 &    1 & -4/3 &  5/3 &   0 & 0 \\
    %>   5/2 & -5/2 & 15/4 & -5/2 & 3/4 & 0 \\
    %>   \hline
    %>       & 1/6 & 2/3 & 2/3 & 1/6 & 0 \\
    %>       &   0 &   0 &   0 &   0 & 1 \\
    %> \end{array}
    %> \f[
    %
    function this = Sarafyan45()
      tbl.A   = [0,    0,    0,    0,   0, 0; ...
                 1,    0,    0,    0,   0, 0; ...
                 3/4,  1/2,  0,    0,   0, 0; ...
                 1,    -4/3, 5/3,  0,   0, 0; ...
                 -5/2, 15/4, -5/2, 3/4, 0, 0];
      tbl.b   = [1/6, 2/3, 2/3, 1/6, 0, 0];
      tbl.b_e = [0, 0, 0, 0, 1, 0];
      tbl.c   = [0, 1, 3/2, 2, 5/2]';
    this@Indigo.RungeKutta.Explicit('Sarafyan45', 5, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end