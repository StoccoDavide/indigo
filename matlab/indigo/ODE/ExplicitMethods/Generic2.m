%
%> Class container for Generic method.
%
classdef Generic2 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Generic method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>          0 &      0 &    0 \\
    %>     \alpha & \alpha &    0 \\
    %>     \hline
    %>          & 1-\frac{1}{2\alpha}
    %>          & \frac{1}{2\alpha}
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Generic2( alpha )
      tbl.A   = [0, 0; alpha, 0];
      tbl.b   = [0, alpha];
      tbl.b_e = []
      tbl.c   = [1-alpha/2, alpha/2]'
      this@RKexplicit('Generic2', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
