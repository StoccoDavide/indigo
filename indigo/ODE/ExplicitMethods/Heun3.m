%
%> Calss container for Heun's third-order method.
%
classdef Heun3 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Heun's third-order method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 &   0 &   0 &   0 \\
    %>     1/3 & 1/3 &   0 &   0 \\
    %>     2/3 &   0 & 2/3 &   0 \\
    %>     \hline
    %>         & 1/4 &   0 & 3/4
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Heun3()
      this@RKexplicit( ...
        'Heun3', ...
        [0, 0, 0; 1/3, 0, 0; 0, 2/3, 0], ...
        [1/4, 0, 3/4], ...
        [0, 1/3, 2/3]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
