%
%> Class container for Lobatto IIIA method.
%
classdef LobattoIIIA4 < Indigo.RungeKutta.Implicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIA method.
    %>
    %> \f[
    %> \begin{array}{c|ccc}
    %>     0 &    0 &   0 &     0 \\
    %>   1/2 & 5/24 & 1/3 & -1/24 \\
    %>     1 &  1/6 & 2/3 &   1/6 \\
    %>   \hline
    %>       &  1/6 & 2/3 &   1/6
    %> \end{array}
    %> \f[
    %
    function this = LobattoIIIA4()
      tbl.A   = [0,    0,   0; ...
                 5/24, 1/3, -1/24; ...
                 1/6,  2/3, 1/6];
      tbl.b   = [1/6, 2/3, 1/6];
      tbl.b_e = [];
      tbl.c   = [0, 1/2, 1]';
      this@Indigo.RungeKutta.Implicit('LobattoIIIA4', 4, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
