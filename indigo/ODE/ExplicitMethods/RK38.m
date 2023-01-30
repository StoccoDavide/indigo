%
%> Class container for Runge-Kutta 3/8-rule third-order method.
%
classdef RK38 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Runge-Kutta 3/8-rule fourth-order method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccccc}
    %>       0 &    0 &   0 &   0 &   0 \\
    %>     1/3 &  1/3 &   0 &   0 &   0 \\
    %>     2/3 & -1/3 &   1 &   0 &   0 \\
    %>       1 &    1 &  -1 &   1 &   0 \\
    %>     \hline
    %>         &  1/8 & 3/8 & 3/8 & 1/8
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = RK38()
      this@RKexplicit( ...
        'RK38',...
        [0,    0,  0, 0; ...
         1/3,  0,  0, 0; ...
         -1/3, 1,  0, 0; ...
         1,    -1, 1, 0], ...
        [1/8, 3/8, 3/8, 1/8], ...
        [0, 1/3, 2/3, 1]' ...
      );
    end
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end
