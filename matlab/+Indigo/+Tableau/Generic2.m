%
%> Class container for Generic method.
%
classdef Generic2 < Lime.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Generic method.
    %>
    %> \f[
    %> \begin{array}{c|cc}
    %>        0 &      0 &    0 \\
    %>   \alpha & \alpha &    0 \\
    %>   \hline
    %>        & 1-\frac{1}{2\alpha}
    %>        & \frac{1}{2\alpha}
    %> \end{array}
    %> \f]
    %
    function this = Generic2( varargin )
      if nargin > 0
        alpha = varargin{1};
      else
        alpha = 1;
      end
      tbl.A   = [0, 0; alpha, 0];
      tbl.b   = [1-alpha/2, alpha/2];
      tbl.b_e = [];
      tbl.c   = [0, alpha].';
      this@Lime.RungeKutta('Generic2', 2, tbl);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
