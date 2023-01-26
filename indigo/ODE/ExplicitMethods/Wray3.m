%
%> Class container for Houwen's/Wray third-order method.
%
classdef Wray3 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Van der Houwen's/Wray third-order method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>        0 &    0 &    0 &   0 \\
    %>     8/15 & 8/15 &    0 &   0 \\
    %>      2/3 &  1/4 & 5/12 &   0 \\
    %>     \hline
    %>          &  1/4 &    0 & 3/4
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Wray3()
      this@RKexplicit( ...
        'Wray3', ...
        [0, 0, 0; 8/15, 0, 0; 1/4, 5/12, 0], ...
        [1/4, 0, 3/4], ...
        [0, 8/15, 2/3]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
