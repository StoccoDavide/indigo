%
%> Class container for Implicit midpoint method.
%
classdef ImplicitMidpoint < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Implicit midpoint method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|c}
    %>     1/2 & 1/2 \\
    %>     \hline
    %>         &   1
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = ImplicitMidpoint()
      this@RKimplicit( ...
        'ImplicitMidpoint', ...
        [1/2], ...
        [1], ...
        [1/2]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
