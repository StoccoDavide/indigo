%
%> Class container for Lobatto IIIC$^\star$ fourth-order method (3 stages)
%
classdef LobattoIIICS4 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIC$^\star$ fourth-order method (3 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 &   0 &   0 &   0 \\
    %>     1/2 & 1/4 & 1/4 &   0 \\
    %>       1 &   0 &   1 &   0 \\
    %>     \hline
    %>         & 1/6 & 2/3 & 1/6
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIICS4( ~ )
      this@RKimplicit( ...
        'LobattoIIICS4', ...
        [0, 0, 0; 1/4, 1/4, 0; 0, 1, 0], ...
        [1/6, 2/3, 1/6], ...
        [0, 1/2, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
