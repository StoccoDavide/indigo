%
%> Class container for Lobatto IIID fourth-order method (3 stages)
%
classdef LobattoIIID4 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIID fourth-order method (3 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 &  1/6 &    0 & -1/6 \\
    %>     1/2 & 1/12 & 5/12 &    0 \\
    %>       1 &  1/2 &  1/3 &  1/6 \\
    %>     \hline
    %>         &  1/6 &  2/3 & 1/6
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = LobattoIIID4( ~ )
      this@RKimplicit( ...
        'LobattoIIID4', ...
        [1/6, 0, -1/6; 1/12, 5/12, 0; 1/2, 1/3, 1/6], ...
        [1/6, 2/3, 1/6], ...
        [0, 1/2, 1]' ...
      );
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
