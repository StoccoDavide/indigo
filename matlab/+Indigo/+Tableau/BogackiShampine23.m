%
%> Class container for Bogacki-Shampine 2(3) method.
%
classdef BogackiShampine23 < Lime.RungeKutta
  %
  methods
  %
  % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  %
  %> Bogacki-Shampine 2(3) method.
  %>
  %> \f[
  %> \begin{array}{c|ccc}
  %>     0 &   0 &   0 &   0 \\
  %>   1/2 & 1/2 &   0 &   0 \\
  %>   3/4 &   0 & 3/4 &   0 \\
  %>     1 & 2/9 & 1/3 & 4/9 \\
  %>   \hline
  %>       &  2/9 & 1/3 & 4/9 \\
  %>       & 7/24 & 1/4 & 1/3 \\
  %> \end{array}
  %> \f]
  %
  function this = BogackiShampine23()
    tbl.A   = [0,   0,   0,   0; ...
               1/2, 0,   0,   0; ...
               0,   3/4, 0,   0; ...
               2/9, 1/3, 4/9, 0];
    tbl.b   = [2/9, 1/3, 4/9, 0];
    tbl.b_e = [7/24, 1/4, 1/3, 1/8];
    tbl.c   = [0, 1/2, 3/4, 1]';
    this@Lime.RungeKutta('BogackiShampine23', 3, tbl);
  end
  %
  % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  %
  end
  %
end
