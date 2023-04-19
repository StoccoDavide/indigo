%
%> Class container for Crank-Nicolson method.
%
classdef CrankNicolson < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Crank-Nicolson method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>     0 &   0 &   0 \\
    %>     1 & 1/2 & 1/2 \\
    %>     \hline
    %>       & 1/2 & 1/2
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = CrankNicolson()
      tbl.A   = [0, 0; 1/2, 1/2];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [];
      tbl.c   = [0, 1]';
      this@RKimplicit('CrankNicolson', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
