%
%> Class container for third-order strong stability preserving Runge-Kutta
%> method.
%
classdef SSPRK4 < Indigo.RungeKutta.Method
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Third-order strong stability preserving Runge-Kutta method.
    %>
    %> \f[
    %> \begin{array}{c|ccc}
    %>     0 &   0 &   0 &   0 \\
    %>     1 &   1 &   0 &   0 \\
    %>   1/2 & 1/4 & 1/4 &   0 \\
    %>   \hline
    %>       & 1/6 & 1/6 & 2/3
    %> \end{array}
    %> \f]
    %
    function this = SSPRK4()
      tbl.A = [...
        0,    0,    0,    0,    0,    0,   0,   0,   0,   0;...
        1/6,  0,    0,    0,    0,    0,   0,   0,   0,   0;...
        1/6,  1/6,  0,    0,    0,    0,   0,   0,   0,   0;...
        1/6,  1/6,  1/6,  0,    0,    0,   0,   0,   0,   0;...
        1/6,  1/6,  1/6,  1/6,  0,    0,   0,   0,   0,   0;...
        1/15, 1/15, 1/15, 1/15, 1/15, 0,   0,   0,   0,   0;...
        1/15, 1/15, 1/15, 1/15, 1/15, 1/6, 0,   0,   0,   0;...
        1/15, 1/15, 1/15, 1/15, 1/15, 1/6, 1/6, 0,   0,   0;...
        1/15, 1/15, 1/15, 1/15, 1/15, 1/6, 1/6, 1/6, 0,   0;...
        1/15, 1/15, 1/15, 1/15, 1/15, 1/6, 1/6, 1/6, 1/6, 0 ...
      ];
      tbl.b   = ones(1,10)/10;
      tbl.b_e = [];
      tbl.c   = [0, 1/6, 1/3, 1/2, 2/3, 1/3, 1/2, 2/3, 5/6, 1]';
      this@Indigo.RungeKutta.Method( 'SSPRK4', 4, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end