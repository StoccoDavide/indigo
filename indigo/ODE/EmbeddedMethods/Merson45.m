%
%> Class container for The Merson method of fourth- and fifth-order method.
%
classdef Merson45 < RKembedded
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Merson method of fourth- and fifth-order method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccccc}
    %>       0 &   0 &   0 &    0 & 0 & 0 \\
    %>     1/3 & 1/3 &   0 &    0 & 0 & 0 \\
    %>     1/3 & 1/6 & 1/6 &    0 & 0 & 0 \\
    %>     1/2 & 1/8 &   0 &  1/8 & 0 & 0 \\
    %>       1 & 1/2 &   0 & -3/2 & 2 & 0 \\
    %>     \hline
    %>        &  1/6 & 0 &  2/3 & 1/6 &   0 \\
    %>        & 1/10 & 0 & 3/10 & 2/5 & 1/5 \\
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Merson45()
        this@RKembedded( ...
        'Merson45', ...
        [0,   0,   0,    0, 0; ...
         1/3, 0,   0,    0, 0; ...
         1/6, 1/6, 0,    0, 0; ...
         1/8, 0,   1/8,  0, 0; ...
         1/2, 0,   -3/2, 2, 0; ...
        ], ...
        [1/9,  0, 9/20, 16/45, 1/12, 0], ...
        [1/10, 0, 3/10,   2/5,  1/5, 0], ...
        [0, 1/3, 1/3, 1/2, 1, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
