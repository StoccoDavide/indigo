%
%> Class container for Zonneveld's 4(5) method.
%
classdef Zonnenveld34 < Indigo.RungeKutta.Method
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Zonneveld's 3(4) method.
    %>
    %> \f[
    %> \begin{array}{c|ccccc}
    %>     0 &    0 &    0 &     0 &     0 & 0 \\
    %>   1/2 &  1/2 &    0 &     0 &     0 & 0 \\
    %>   1/2 &    0 &  1/2 &     0 &     0 & 0 \\
    %>     1 &    0 &    0 &     1 &     0 & 0 \\
    %>   3/4 & 5/32 & 7/32 & 13/32 & -1/32 & 0 \\
    %>   \hline
    %>      &  1/6 & 1/3 & 1/3 &  1/6 &     0 \\
    %>      & -1/2 & 7/3 & 7/3 & 13/6 & -16/3 \\
    %> \end{array}
    %> \f]
    %
    function this = Zonnenveld34()
      tbl.A   = [0,    0,    0,     0,     0; ...
                 1/2,  0,    0,     0,     0; ...
                 0,    1/2,  0,     0,     0; ...
                 0,    0,    1,     0,     0; ...
                 5/32, 7/32, 13/32, -1/32, 0 ];
      tbl.b   = [1/6, 1/3, 1/3, 1/6, 0];
      tbl.b_e = [-1/2, 7/3, 7/3, 13/6, -16/3];
      tbl.c   = [0, 1/2, 1/2, 1, 3/4]';
      this@Indigo.RungeKutta.Method( 'Zonneveld34', 4, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
