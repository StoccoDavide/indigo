%
%> Class container for Lobatto IIIC$^\star$ second-order method (2 stages)
%
classdef LobattoIIICS2 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIC$^\star$ second-order method (2 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0 &   0 &   0 \\
    %>     1 &   1 &   0 \\
    %>     \hline
    %>       & 1/2 & 1/2
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIICS2()
      this@RKimplicit( ...
        'LobattoIIICS2', ...
        [0, 0; 1, 0], ...
        [1/2, 1/2], ...
        [0, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
