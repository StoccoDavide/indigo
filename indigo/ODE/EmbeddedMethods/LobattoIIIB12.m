%
%> Class container for Lobatto IIIB second-order embedded method (2 stages)
%
classdef LobattoIIIB12 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIB second-order embedded method (2 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0 & 1/2 &   0 \\
    %>     1 & 1/2 &   0 \\
    %>     \hline
    %>       & 1/2 & 1/2 \\
    %>       & 1   & 0
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIIB12()
      this@RKimplicit( ...
        'LobattoIIIB12', ...
        [1/2, 0; ...
         1/2, 0], ...
        [1/2, 1/2], ...
        [1, 0], ...
        [0, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
