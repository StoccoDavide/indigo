%
%> Class container for The Sarafyan 4(5) method of fourth- and fifth-order method.
%
classdef Sarafyan45 < RKexplicit
%
methods
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%> Sarafyan 4(5) method of fourth- and fifth-order method.
%>
%> \rst
%> .. math::
%>
%>   \begin{array}{c|ccccc}
%>       0 &    0 &    0 &    0 &   0 & 0 \\
%>       1 &    1 &    0 &    0 &   0 & 0 \\
%>     3/2 &  3/4 &  1/2 &    0 &   0 & 0 \\
%>       2 &    1 & -4/3 &  5/3 &   0 & 0 \\
%>     5/2 & -5/2 & 15/4 & -5/2 & 3/4 & 0 \\
%>     \hline
%>         & 1/6 & 2/3 & 2/3 & 1/6 & 0 \\
%>         &   0 &   0 &   0 &   0 & 1 \\
%>   \end{array}
%>
%> \endrst
%
function this = Sarafyan45()
this@RKexplicit( ...
'Sarafyan45', ...
[0, 0, 0, 0, 0, 0; ...
1, 0, 0, 0, 0, 0; ...
3/4, 1/2, 0, 0, 0, 0; ...
1, -4/3, 5/3, 0, 0, 0; ...
-5/2, 15/4, -5/2, 3/4, 0, 0; ...
], ...
[1/6, 2/3, 2/3, 1/6, 0, 0], ...
[0, 0, 0, 0, 1, 0], ...
[0, 1, 3/2, 2, 5/2]' ...
);
end
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
end
%
end