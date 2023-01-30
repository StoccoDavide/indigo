%
%> Class container for The Bogacki–Shampine 2(3) embedded Runge-Kutta method of
%> second- and third-order.
%
classdef BogackiShampine23 < RKexplicit
  %
  methods
  %
  % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  %
  %> Bogacki–Shampine 2(3) embedded Runge-Kutta method of second- and third-order.
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
    this@RKexplicit( ...
    'BogackiShampine23', ...
    [0,   0,   0,   0; ...
     1/2, 0,   0,   0; ...
     0,   3/4, 0,   0; ...
     2/9, 1/3, 4/9, 0], ...
    [2/9,  1/3, 4/9], ...
    [7/24, 1/4, 1/3], ...
    [0, 1/2, 3/4, 1]' ...
    );
  end
  %
  % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  %
  end
  %
end