%
%> Class container for Ralston's third-order method.
%
classdef Ralston3 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Ralston's third-order method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 &   0 &   0 &   0 \\
    %>     1/2 & 1/2 &   0 &   0 \\
    %>     3/4 &   0 & 3/4 &   0 \\
    %>     \hline
    %>         & 2/9 & 1/3 & 4/9
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Ralston3()
      this@RKexplicit( ...
        'Ralston3', ...
        [0,   0,   0; ...
         1/2, 0,   0; ...
         0,   3/4, 0], ...
        [2/9, 1/3, 4/9], ...
        [], ...
        [0, 1/2, 3/4]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
