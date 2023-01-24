%
%> Class container for Lobatto IIIB second-order method (2 stages)
%
classdef LobattoIIIB2 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIB second-order method (2 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0 & 1/2 &   0 \\
    %>     1 & 1/2 &   0 \\
    %>     \hline
    %>       & 1/2 & 1/2
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIB2()
      this@RKimplicit( ...
        'LobattoIIIB2', ...
        [1/2, 0; 1/2, 0], ...
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
