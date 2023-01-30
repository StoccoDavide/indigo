%
%> Class container for Runge-Kutta third-order method.
%
classdef RK3 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Runge-Kutta third-order method.
    %>
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 &   0 &   0 &   0 \\
    %>     1/2 & 1/2 &   0 &   0 \\
    %>       1 &  -1 &   2 &   0 \\
    %>     \hline
    %>         & 1/6 & 2/3 & 1/6
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = RK3()
      this@RKexplicit( ...
        'RK3', ...
        [0,   0, 0;
         1/2, 0, 0;
         -1,  2, 0], ...
        [1/6, 2/3, 1/6], ...
        [0, 1/2, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
