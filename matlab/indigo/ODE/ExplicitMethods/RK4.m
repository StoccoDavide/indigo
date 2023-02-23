%
%> Class container for Runge-Kutta 4 method.
%
classdef RK4 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Runge-Kutta 4 method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccccc}
    %>       0 &   0 &   0 &   0 &   0 \\
    %>     1/2 & 1/2 &   0 &   0 &   0 \\
    %>     1/2 &   0 & 1/2 &   0 &   0 \\
    %>       1 &   0 &   0 &   1 &   0 \\
    %>     \hline
    %>         & 1/6 & 1/3 & 1/3 & 1/6
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = RK4()
      this@RKexplicit( ...
        'RK4', ...
        [0,   0,   0, 0; ...
         1/2, 0,   0, 0; ...
         0,   1/2, 0, 0; ...
         0,   0,   1, 0], ...
        [1/6, 1/3, 1/3, 1/6], ...
        [0, 1/2, 1/2, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
