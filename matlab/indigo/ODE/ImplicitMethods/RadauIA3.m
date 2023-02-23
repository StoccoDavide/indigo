%
%> Class container for Radau IA method.
%
classdef RadauIA3 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Radau IA method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>       0 & 1/4 & -1/4 \\
    %>     2/3 & 1/4 & 5/12 \\
    %>     \hline
    %>         & 1/4 &  3/4
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = RadauIA3()
      this@RKimplicit( ...
        'RadauIA3', ...
        [1/4, -1/4; 1/4, 5/12], ...
        [1/4, 3/4], ...
        [0, 2/3]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
