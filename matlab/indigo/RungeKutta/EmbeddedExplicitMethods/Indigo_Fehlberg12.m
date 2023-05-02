%
%> Class container for Fehlberg 1(2) method.
%
classdef Indigo_Fehlberg12 < Indigo_ExplicitRungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Fehlberg 1(2) method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccc}
    %>       0 & 0     &       0 & 0 \\
    %>     1/2 & 1/2   &       0 & 0 \\
    %>       1 & 1/256 & 255/256 & 0 \\
    %>     \hline
    %>       & 1/512 & 255/256 & 1/512 \\
    %>       & 1/256 & 255/256 & 0     \\
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Indigo_Fehlberg12()
      tbl.A  = [0,     0,       0; ...
                1/2,   0,       0; ...
                1/256, 255/256, 0];
     tbl.b   = [1/512, 255/256, 1/512];
     tbl.b_e = [1/256, 255/256, 0];
     tbl.c   = [0, 1/2, 1]';
     this@Indigo_ExplicitRungeKutta('Fehlberg12', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
