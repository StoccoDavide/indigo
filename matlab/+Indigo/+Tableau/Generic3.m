%
%> Class container for Generic method.
%
classdef Generic3 < Indigo.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Generic method (\f$ \alpha \neq 0, 2/3, 1 \f$).
    %>
    %> \f[
    %> \begin{array}{c|ccc}
    %>   0      & 0      & 0  & 0 \\
    %>   \alpha & \alpha & 0  & 0 \\
    %>   1      & 1+\frac{1-\alpha}{\alpha(3\alpha-2)}
    %>                   & -\frac{1-\alpha}{\alpha(3\alpha-2)}
    %>                        & 0 \\
    %>   \hline
    %>    & \frac{1}{2}-\frac{1}{6\alpha}
    %>    & \frac{1}{6\alpha(1-\alpha)}
    %>    & \frac{2-3\alpha}{6(1-\alpha)} \\
    %> \end{array}
    %> \f]
    %
    function this = Generic3( varargin )
      if nargin > 0
        alpha = varargin{1};
      else
        alpha = 1/2;
      end
      assert( alpha ~= 0 && alpha ~= 2/3 && alpha ~= 1, 'Generic3 alpha must be <> {0, 2/3, 1}');
      tmp = alpha*(3*alpha-2);
      tbl.A   = [0,               0,             0; ...
                 alpha,           0,             0; ...
                 1+(1-alpha)/tmp, (alpha-1)/tmp, 0];
      tbl.b   = [ 1/2-1/(6*alpha), ...
                  1/(6*alpha*(1-alpha)), ...
                  (2-3*alpha)/(6*(1-alpha))];
      tbl.c   = [0, alpha, 1].';
      tbl.b_e = [];
      this@Indigo.RungeKutta( 'Generic3', 3, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
