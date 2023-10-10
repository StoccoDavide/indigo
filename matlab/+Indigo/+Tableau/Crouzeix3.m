%
%> Class container for Merson's 4(5) method.
%
classdef Crouzeix3 < Lime.RungeKutta
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Crouzeix's two-stage, 3rd order Diagonally Implicit Runge-Kutta method:.
    %>
    %
    %
    function this = Crouzeix3()
      t  = sqrt(3)/6;
      tbl.A   = [1/2+t, 0; ...
                 -2*t,   1/2+t];
      tbl.b   = [1/2, 1/2];
      tbl.b_e = [];
      tbl.c   = tbl.A*ones(2,1);
      this@Lime.RungeKutta( 'Crouzeix3', 3, tbl );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
