%
%> Class container for Lobatto IIIC fourth-order embedded method (3 stages)
%
classdef LobattoIIIC34 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIC fourth-order embedded method (3 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 & 1/6 & -1/3 & 1/6  \\
    %>     1/2 & 1/6 & 5/12 & -1/12 \\
    %>       1 & 1/6 & 2/3  &  1/6  \\
    %>     \hline
    %>         & 1/6  & 2/3 & 1/6 \\
    %>         & -1/2 & 2   & -1/2
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIC34()
      this@RKimplicit( ...
        'LobattoIIIC34', ...
        [1/6, -1/3, 1/6; 1/6, 5/12, -1/12; 1/6, 2/3, 1/6], ...
        [1/6, 2/3, 1/6], ...
        [-1/2, 2, 1/2], ...
        [0, 1/2, 1]' ...
      );
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
