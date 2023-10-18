%
%> Class container for Crank-Nicolson method.
%
classdef CrankNicolson < Indigo.RungeKutta.Method
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Crank-Nicolson method.
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>   0 &   0 &   0 \\
    %>   1 & 1/2 & 1/2 \\
    %>   \hline
    %>     & 1/2 & 1/2
    %> \end{array}
    %> \f]
    %
    function this = CrankNicolson()
      tbl.A   = [0, 0; 1/2, 1/2];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [];
      tbl.c   = [0, 1]';
      this@Indigo.RungeKutta.Method('CrankNicolson', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
