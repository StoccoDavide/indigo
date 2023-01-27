%
%> Class container for Lobatto IIIA fourth-order method (3 stages)
%
classdef LobattoIIIA4 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIA fourth-order method (3 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 &    0 &   0 &     0 \\
    %>     1/2 & 5/24 & 1/3 & -1/24 \\
    %>       1 &  1/6 & 2/3 &   1/6 \\
    %>     \hline
    %>         &  1/6 & 2/3 &   1/6
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIA4()
      this@RKimplicit( ...
        'LobattoIIIA4', ...
        [0, 0, 0; 5/24, 1/3, -1/24; 1/6, 2/3, 1/6], ...
        [1/6, 2/3, 1/6], ...
        [0, 1/2, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
