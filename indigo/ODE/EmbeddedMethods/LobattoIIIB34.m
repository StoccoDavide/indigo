%
%> Class container for Lobatto IIIB fourth-order embedded method (3 stages)
%
classdef LobattoIIIB34 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIB fourth-order embedded method (3 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 & 1/6 & -1/6 &   0 \\
    %>     1/2 & 1/6 &  1/3 &   0 \\
    %>       1 & 1/6 &  5/6 &   0 \\
    %>     \hline
    %>         & 1/6  &  2/3 & 1/6 \\
    %>         & -1/2 &  2   & -1/2
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIB34()
      this@RKimplicit( ...
        'LobattoIIIB34', ...
        [1/6, -1/6, 0; ...
         1/6, 1/3,  0; ...
         1/6, 5/6,  0], ...
        [1/6, 2/3, 1/6], ...
        [-1/2, 2, 1/2], ...
        [0, 1/2, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
