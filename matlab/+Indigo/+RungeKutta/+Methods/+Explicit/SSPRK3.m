%
%> Class container for third-order strong stability preserving Runge-Kutta
%> method.
%
classdef SSPRK3 < Indigo.RungeKutta.Explicit
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
    %> \f[
    %
    function this = SSPRK3()
      tbl.A   = [0,   0,   0; ...
                 1,   0,   0; ...
                 1/4, 1/4, 0];
      tbl.b   = [1/6, 1/6, 2/3];
      tbl.b_e = [];
      tbl.c   = [0, 1, 1/2]';
      this@Indigo.RungeKutta.Explicit('SSPRK3', 3, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
