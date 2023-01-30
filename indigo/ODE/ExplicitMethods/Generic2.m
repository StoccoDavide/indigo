%
%> Class container for Generic second-order method.
%
classdef Generic2 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Van der Generic second-order method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>          0 &      0 &    0 \\
    %>     \alpha & \alpha &    0 \\
    %>     \hline
    %>          & 1-\frac{1}{2\alpha}
    %>          & \frac{1}{2\alpha}
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Generic2( alpha )

      this@RKexplicit( ...
        'Generic2', ...
        [0,     0; ...
         alpha, 0], ...
        [0, alpha], ...
        [1-alpha/2, alpha/2]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
