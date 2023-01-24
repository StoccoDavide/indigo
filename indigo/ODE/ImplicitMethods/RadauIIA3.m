%
%> Class container for Radau IIA third-order method (2 stages)
%
classdef RadauIIA3 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Radau IIA third-order method (2 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     1/3 & 5/12 & -1/12 \\
    %>       1 &  3/4 &   1/4 \\
    %>     \hline
    %>         &  3/4 &   1/4
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = RadauIIA3()
      this@RKimplicit( ...
        'RadauIIA3', ...
        [5/12, -1/12; 3/4, 1/4], ...
        [3/4, 1/4], ...
        [1/3, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
