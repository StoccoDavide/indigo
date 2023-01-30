%
%> Class container for Lobatto IIID second-order method (2 stages)
%
classdef LobattoIIID2 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIID second-order method (2 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0 &  1/2 & 1/2 \\
    %>     1 & -1/2 & 1/2 \\
    %>     \hline
    %>       &  1/2 & 1/2
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIID2()
      this@RKimplicit( ...
        'LobattoIIID2', ...
        [1/2, 1/2; -1/2, 1/2], ...
        [1/2, 1/2], ...
        [0, 1]' ...
      );
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
