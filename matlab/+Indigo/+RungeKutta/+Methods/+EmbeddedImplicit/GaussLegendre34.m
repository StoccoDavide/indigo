%
%> Class container for Gauss-Legendre 3(4) method.
%
classdef GaussLegendre34 < Indigo.RungeKutta.Implicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Gauss-Legendre 3(4) method.
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>   1/2-t &   1/4 & 1/4-t \\
    %>   1/2+t & 1/4+t &   1/4 \\
    %>   \hline
    %>         &   1/2       &   1/2 \\
    %>         &   1/2 + 3 t &   1/2 - 3 t
    %> \end{array}
    %> \qquad t = \dfrac{\sqrt{3}}{6}
    %> \f[
    %
    function this = GaussLegendre34()
      t       = sqrt(3)/6;
      tbl.A   = [1/4, 1/4-t; 1/4+t, 1/4];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [1/2 + 3*t, 1/2 - 3*t];
      tbl.c   = [1/2-t, 1/2+t]';
      this@Indigo.RungeKutta.Implicit('GaussLegendre34', 4, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end