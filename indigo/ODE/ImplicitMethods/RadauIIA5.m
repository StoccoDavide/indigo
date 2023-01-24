%
%> Class container for Radau IIA fifth-order method (3 stages)
%
classdef RadauIIA5 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Radau IIA fifth-order method (3 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>  \begin{array}{c|ccc}
    %>    \frac{2}{5} - \frac{\sqrt{6}}{10} & \frac{11}{45} - \frac{7 \sqrt{6}}{360} & \frac{37}{225} - \frac{169 \sqrt{6}}{1800}  & -\frac{2}{225} + \frac{\sqrt{6}}{75}  \\
    %>    \frac{2}{5} + \frac{\sqrt{6}}{10} & \frac{37}{225} + \frac{169 \sqrt{6}}{1800} & \frac{11}{45} + \frac{7 \sqrt{6}}{360} & -\frac{2}{225} - \frac{\sqrt{6}}{75} \\
    %>    1 & \frac{4}{9} - \frac{\sqrt{6}}{36} & \frac{4}{9} + \frac{\sqrt{6}}{36} & \frac{1}{9} \\
    %>    \hline
    %>      & \frac{4}{9} - \frac{\sqrt{6}}{36} & \frac{4}{9} + \frac{\sqrt{6}}{36} & \frac{1}{9} \\
    %>  \end{array}
    %>
    %> \endrst
    %
    function this = RadauIIA5()
      this@RKimplicit( ...
        'RadauIIA5', ...
        [11/45-7*sqrt(6)/360,     37/225-169*sqrt(6)/1800, -2/225+sqrt(6)/75; ...
         37/225+169*sqrt(6)/1800, 11/45+7*sqrt(6)/360,     -2/225-sqrt(6)/75; ...
         4/9-sqrt(6)/36,          4/9+sqrt(6)/36,          1/9], ...
        [4/9-sqrt(6)/36, 4/9+sqrt(6)/36, 1/9], ...
        [2/5-sqrt(6)/10, 2/5+sqrt(6)/10, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
