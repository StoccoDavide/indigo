%
%> Class container for Implicit Euler first-order method (1 stage)
%
classdef ImplicitEuler < RKimplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Implicit Euler first-order method (1 stage)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|c}
    %>     1 & 1 \\
    %>     \hline
    %>       & 1
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = ImplicitEuler()
      this@RKimplicit( ...
        'ImplicitEuler', ...
        [1], ...
        [1], ...
        [1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
