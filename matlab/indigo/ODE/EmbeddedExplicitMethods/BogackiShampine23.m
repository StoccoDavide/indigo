%
%> Class container for Bogacki-Shampine 2(3) method.
%
classdef BogackiShampine23 < RKexplicit
  %
  methods
  %
  % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  %
  %> Bogacki-Shampine 2(3) method.
  %>
  %> \rst
  %> .. math::
  %>
  %>   \begin{array}{c|ccc}
  %>       0 &   0 &   0 &   0 \\
  %>     1/2 & 1/2 &   0 &   0 \\
  %>     3/4 &   0 & 3/4 &   0 \\
  %>       1 & 2/9 & 1/3 & 4/9 \\
  %>     \hline
  %>         &  2/9 & 1/3 & 4/9 \\
  %>         & 7/24 & 1/4 & 1/3 \\
  %>   \end{array}
  %>
  %> \endrst
  %
  function this = BogackiShampine23()
    A = [0,   0,   0,   0; ...
         1/2, 0,   0,   0; ...
         0,   3/4, 0,   0; ...
         2/9, 1/3, 4/9, 0];
    b  = [7/24, 1/4, 1/3, 1/8];
    bt = [2/9,  1/3, 4/9, 0];
    c  = [0,    1/2, 3/4, 1]';
    this@RKexplicit('BogackiShampine23', A, b, bt, c );
  end
  %
  % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  %
  end
  %
end
