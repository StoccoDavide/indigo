%
%> Class container for The Runge–Kutta–Fehlberg method of first- and second-order
%> method.
%
classdef RKF12 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Runge–Kutta–Fehlberg method of first- and second-order method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 & 0     &       0 & 0 \\
    %>     1/2 & 1/2   &       0 & 0 \\
    %>       1 & 1/256 & 255/256 & 0 \\
    %>     \hline
    %>       & 1/512 & 255/256 & 1/512 \\
    %>       & 1/256 & 255/256 & 0     \\
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = RKF12()
        this@RKexplicit( ...
        'RKF12', ...
        [0,     0,       0; ...
         1/2,   0,       0; ...
         1/256, 255/256, 0], ...
        [1/512, 255/256, 1/512], ...
        [1/256, 255/256, 0], ...
        [0, 1/2, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
