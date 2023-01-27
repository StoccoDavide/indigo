%
%> Class container for The Zonneveld method of thind- and fourth-order method.
%
classdef Zonnenveld45 < RKembedded
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Zonneveld method of thind- and fourth-order method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccccc}
    %>       0 &    0 &    0 &     0 &     0 & 0 \\
    %>     1/2 &  1/2 &    0 &     0 &     0 & 0 \\
    %>     1/2 &    0 &  1/2 &     0 &     0 & 0 \\
    %>       1 &    0 &    0 &     1 &     0 & 0 \\
    %>     3/4 & 5/32 & 7/32 & 13/32 & -1/32 & 0 \\
    %>     \hline
    %>        &  1/6 & 1/3 & 1/3 &  1/6 &     0 \\
    %>        & -1/2 & 7/3 & 7/3 & 13/6 & -16/3 \\
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Zonnenveld45()
        this@RKembedded( ...
        'Zonneveld34', ...
        [0,    0,    0,     0,     0; ...
         1/2,  0,    0,     0,     0; ...
         0,    1/2,  0,     0,     0; ...
         0,    0,    1,     0,     0; ...
         5/32, 7/32, 13/32, -1/32, 0; ...
        ], ...
        [1/6,  1/3, 1/3, 1/6,  0], ...
        [-1/2, 7/3, 7/3, 13/6, -16/3], ...
        [0, 1/2, 1/2, 1, 3/4]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
