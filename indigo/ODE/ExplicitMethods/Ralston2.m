%
%> Class container for Ralston's method.
%
classdef Ralston2 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Ralston's method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>       0 &   0 &   0 \\
    %>     2/3 & 2/3 &   0 \\
    %>     \hline
    %>         & 1/4 & 3/4
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Ralston2()
      this@RKexplicit( ...
        'Ralston2', ...
        [0,   0; ...
         2/3, 0], ...
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
