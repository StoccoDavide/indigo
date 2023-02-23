%
%> Class container for Gauss-Legendre 3(4) method.
%
classdef GaussLegendre34 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Gauss-Legendre 3(4) method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     1/2-t &   1/4 & 1/4-t \\
    %>     1/2+t & 1/4+t &   1/4 \\
    %>     \hline
    %>           &   1/2       &   1/2 \\
    %>           &   1/2 + 3 t &   1/2 - 3 t
    %>   \end{array}
    %>   \qquad t = \dfrac{\sqrt{3}}{6}
    %>
    %> \endrst
    %
    function this = GaussLegendre34()
      t = sqrt(3)/6;
      this@RKimplicit( ...
        'GaussLegendre34', ...
        [1/4, 1/4-t; 1/4+t, 1/4], ...
        [1/2, 1/2], ...
        [1/2 + 3*t, 1/2 - 3*t], ...
        [1/2-t, 1/2+t]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
