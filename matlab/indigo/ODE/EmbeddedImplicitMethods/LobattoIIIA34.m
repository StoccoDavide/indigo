...
 %
%> Class container for Lobatto IIIA 3(4) method.
%
classdef LobattoIIIA34 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIA 3(4) method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 &    0 &   0 &     0 \\
    %>     1/2 & 5/24 & 1/3 & -1/24 \\
    %>       1 &  1/6 & 2/3 &   1/6 \\
    %>     \hline
    %>         &  1/6 & 2/3 &   1/6 \\
    %>         & -1/2 & 2   &  -1/2 \\
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIA34()
      this@RKimplicit( ...
        'LobattoIIIA34', ...
        [0,    0,   0; ...
         5/24, 1/3, -1/24; ...
         1/6,  2/3, 1/6], ...
        [1/6, 2/3, 1/6], ...
        [-1/2, 2, -1/2], ...
        [0, 1/2, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
