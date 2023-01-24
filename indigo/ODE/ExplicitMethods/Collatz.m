%
%> Class container for Collatz's second-order method (2 stages)
%
classdef Collatz < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Collatz's second-order method (2 stages)
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|cc}
    %>       0 &   0 & 0 \\
    %>     1/2 & 1/2 & 0 \\
    %>     \hline
    %>         &   0 & 1
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Collatz( ~ )
        this@RKexplicit( ...
        'Collatz', ...
        [0, 0; 1/2, 0], ...
        [0, 1], ...
        [0, 1/2]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
