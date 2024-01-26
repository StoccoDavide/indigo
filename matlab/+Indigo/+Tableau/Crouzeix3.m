%
%> Class container for Merson's 4(5) method.
%
classdef Crouzeix3 < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Crouzeix's two-stage, 3rd order Diagonally Implicit Runge-Kutta method:
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>   1/2+\sqrt{3}/6 & 1/2+\sqrt{3}/6 & 0 \\
    %>   1/2-\sqrt{3}/6 & -\sqrt{3}/3   & 1/2+\sqrt{3}/6 \\
    %>   \hline
    %>                   & 1/2           & 1/2
    %> \end{array}
    %> \f]
    %
    function this = Crouzeix3()
      t  = sqrt(3)/6;
      tbl.A   = [1/2+t, 0; ...
                 -2*t,   1/2+t];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [];
      tbl.c   = tbl.A*ones(2,1);
      this@Indigo.RungeKutta('Crouzeix3', 3, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
