%
%> Class container for Sun Geng's method.
%
classdef SunGeng5 < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Sun Geng's method.
    %>
    %> \rst
    %> .. math::
    %>
    %>  \begin{array}{c|ccc}
    %>    \frac{4 - \sqrt{6}}{10} &
    %>    \frac{16 - \sqrt{6}}{72} &
    %>    \frac{328 - 169 \sqrt{6}}{1800} &
    %>    \frac{-2 + 3 \sqrt{6}}{450} \\
    %>    \frac{4 + \sqrt{6}}{10} &
    %>    \frac{328 + 167 \sqrt{6}}{1800} &
    %>    \frac{16 + \sqrt{6}}{72} &
    %>    \frac{-2 + 3 \sqrt{6}}{450} \\
    %>    1 &
    %>    \frac{85 - 10 \sqrt{6}}{180} &
    %>    \frac{85 + 10 \sqrt{6}}{180} &
    %>    \frac{1}{18} \\
    %>    \hline
    %>      & \frac{16-\sqrt{6}}{36} &
    %>        \frac{16+\sqrt{6}}{36} &
    %>        \frac{1}{9} \\
    %>  \end{array}
    %>
    %> \endrst
    %
    function this = SunGeng5()
      tbl.A   = [(16-sqrt(6))/72,        (328-167*sqrt(6))/1800, (-2+3*sqrt(6))/450; ...
                 (328+167*sqrt(6))/1800, (16+sqrt(6))/72,        (-2-3*sqrt(6))/450; ...
                 (85-10*sqrt(6))/180,    (85+10*sqrt(6))/180,    1/18];
      tbl.b   = [(16-sqrt(6))/36, (16+sqrt(6))/36, 1/9];
      tbl.b_e = [];
      tbl.c   = [(4-sqrt(6))/10, (4+sqrt(6))/10, 1]';
      this@RKimplicit('SunGeng5', 5, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
