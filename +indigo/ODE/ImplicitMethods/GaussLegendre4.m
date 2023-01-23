%
%> Class container for Gauss–Legendre fouth-order (2 stages)
%
classdef GaussLegendre4 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Gauss–Legendre fourth-order (2 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     1/2-t &   1/4 & 1/4-t \\
    %>     1/2+t & 1/4+t &   1/4 \\
    %>     \hline
    %>           &   1/2 &   1/2
    %>   \end{array}
    %>   \qquad t = \dfrac{\sqrt{3}}{6}
    %>
    %> \endrst
    %
    function this = GaussLegendre4()
      t = sqrt(3)/6;
      this@RKimplicit( ...
        'GaussLegendre4', ...
        [1/4, 1/4-t; 1/4+t, 1/4], ...
        [1/2, 1/2], ...
        [1/2-t, 1/2+t]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
