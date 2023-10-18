%
%> Class container for Lobatto IIIC$^\star$ method.
%
classdef LobattoIIICS4 < Indigo.RungeKutta.Method
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Lobatto IIIC$^\star$ method.
    %>
    %> \f[
    %> \begin{array}{c|ccc}
    %>     0 &   0 &   0 &   0 \\
    %>   1/2 & 1/4 & 1/4 &   0 \\
    %>     1 &   0 &   1 &   0 \\
    %>   \hline
    %>       & 1/6 & 2/3 & 1/6
    %> \end{array}
    %> \f]
    %
    function this = LobattoIIICS4()
      tbl.A   = [0,   0,   0; ...
                 1/4, 1/4, 0; ...
                 0,   1,   0];
      tbl.b   = [1/6, 2/3, 1/6];
      tbl.b_e = [];
      tbl.c   = [0, 1/2, 1]';
      this@Indigo.RungeKutta.Method( 'LobattoIIICS4', 4, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
