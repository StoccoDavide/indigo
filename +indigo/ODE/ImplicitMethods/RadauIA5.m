%
%> Class container for Radau IA fifth-order method (3 stages)
%
classdef RadauIA5 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> RadauIA fifth-order method (3 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>  \begin{array}{c|ccc}
    %>    0 & \frac{1}{9} & \frac{-1 - \sqrt{6}}{18} & \frac{-1 + \sqrt{6}}{18} \\
    %>    \frac{3}{5} - \frac{\sqrt{6}}{10} & \frac{1}{9} & \frac{11}{45} + \frac{7\sqrt{6}}{360} & \frac{11}{45} - \frac{43\sqrt{6}}{360} \\
    %>    \frac{3}{5} + \frac{\sqrt{6}}{10} & \frac{1}{9} & \frac{11}{45} + \frac{43\sqrt{6}}{360} & \frac{11}{45} - \frac{7\sqrt{6}}{360} \\
    %>    \hline
    %>      & \frac{1}{9} & \frac{4}{9} + \frac{\sqrt{6}}{36} & \frac{4}{9} - \frac{\sqrt{6}}{36} \\
    %>  \end{array}
    %>
    %> \endrst
    %
    function this = RadauIA5( ~ )
      this@RKimplicit( ...
        'RadauIA5',...
        [1/9, (-1-sqrt(6))/18,      (-1+sqrt(6))/18; ...
         1/9, 11/45+7*sqrt(6)/360,  11/45-43*sqrt(6)/360; ...
         1/9, 11/45+43*sqrt(6)/360, 11/45-7*sqrt(6)/360 ], ...
        [1/9, 4/9+sqrt(6)/36, 4/9-sqrt(6)/36], ...
        [0, 3/5-sqrt(6)/10, 3/5+sqrt(6)/10]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
