%
%> Class container for Gauss–Legendre second-order method (1 stage)
%
classdef GaussLegendre2 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Gauss–Legendre second-order method (1 stage)
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
    function this = GaussLegendre2( ~ )
      this@RKimplicit( ...
        'GaussLegendre2', ...
        [1/2], ...
        [1], ...
        [1/2]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
