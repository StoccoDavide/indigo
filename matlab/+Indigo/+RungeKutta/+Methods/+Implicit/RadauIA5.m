%
%> Class container for Radau IA method.
%
classdef RadauIA5 < Indigo.RungeKutta.Implicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Radau IA method.
    %>
    %> \f[
    %> \begin{array}{c|ccc}
    %>   0 & \frac{1}{9} &
    %>   \frac{-1 - \sqrt{6}}{18} &
    %>   \frac{-1 + \sqrt{6}}{18} \\
    %>   \frac{3}{5} - \frac{\sqrt{6}}{10} & \frac{1}{9} &
    %>   \frac{11}{45} + \frac{7\sqrt{6}}{360} &
    %>   \frac{11}{45} - \frac{43\sqrt{6}}{360} \\
    %>   \frac{3}{5} + \frac{\sqrt{6}}{10} & \frac{1}{9} &
    %>   \frac{11}{45} + \frac{43\sqrt{6}}{360} &
    %>   \frac{11}{45} - \frac{7\sqrt{6}}{360} \\
    %>   \hline
    %>     & \frac{1}{9} &
    %>       \frac{4}{9} + \frac{\sqrt{6}}{36} &
    %>       \frac{4}{9} - \frac{\sqrt{6}}{36} \\
    %> \end{array}
    %> \f[
    %
    function this = RadauIA5()
      tbl.A   = [1/9,  (-1-sqrt(6))/18,       (-1+sqrt(6))/18; ...
                 1/9,  11/45+7*sqrt(6)/360,   11/45-43*sqrt(6)/360; ...
                 1/9,  11/45+43*sqrt(6)/360,  11/45-7*sqrt(6)/360 ];
      tbl.b   = [1/9, 4/9+sqrt(6)/36, 4/9-sqrt(6)/36] ;
      tbl.b_e = [];
      tbl.c   = [0,   3/5-sqrt(6)/10, 3/5+sqrt(6)/10]';
      this@Indigo.RungeKutta.Implicit('RadauIA5', 5, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
