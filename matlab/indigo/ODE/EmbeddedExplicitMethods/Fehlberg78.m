%
%> Class container for Fehlberg 7(8) method.
%
classdef Fehlberg78 < RKexplicit
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Fehlberg 7(8) method.
    %>
    %> \rst
    %> .. math::
    %>
    %>   \begin{array}{c|ccccccccccccc}
    %>        0 &          0 &    0 &        0 &         0 &       0 &         0 &      0 &      0 &     0 &    0 & 0 & 0 \\
    %>     2/27 &       2/27 &    0 &        0 &         0 &       0 &         0 &      0 &      0 &     0 &    0 & 0 & 0 \\
    %>      1/9 &       1/36 & 1/12 &        0 &         0 &       0 &         0 &      0 &      0 &     0 &    0 & 0 & 0 \\
    %>      1/6 &       1/24 &    0 &      1/8 &         0 &       0 &         0 &      0 &      0 &     0 &    0 & 0 & 0 \\
    %>     5/12 &       5/12 &    0 &   -25/16 &     25/16 &       0 &         0 &      0 &      0 &     0 &    0 & 0 & 0 \\
    %>      1/2 &       1/20 &    0 &        0 &       1/4 &     1/5 &         0 &      0 &      0 &     0 &    0 & 0 & 0 \\
    %>      5/6 &    -25/108 &    0 &  125/108 &    -65/27 &  125/54 &         0 &      0 &      0 &     0 &    0 & 0 & 0 \\
    %>      1/6 &     31/300 &    0 &        0 &    61/225 &    -2/9 &    13/900 &      0 &      0 &     0 &    0 & 0 & 0 \\
    %>      2/3 &          2 &    0 &    -53/6 &    704/45 &  -107/9 &     67/90 &      3 &      0 &     0 &    0 & 0 & 0 \\
    %>      1/3 &    -91/108 &    0 &   23/108 &  -976/135 &  311/54 &    -19/60 &   17/6 &  -1/12 &     0 &    0 & 0 & 0 \\
    %>        1 &  2383/4100 &    0 & -341/164 & 4496/1025 & -301/82 & 2133/4100 &  45/82 & 45/164 & 18/41 &    0 & 0 & 0 \\
    %>        0 &      3/205 &    0 &        0 &         0 &       0 &     -6/41 & -3/205 &  -3/41 &  3/41 & 6/41 & 0 & 0 \\
    %>        1 & -1777/4100 &    0 & -341/164 & 4496/1025 & -289/82 & 2193/4100 &  51/82 & 33/164 & 12/41 &    0 & 1 & 0 \\
    %>     \hline
    %>       & 41/840 & 0 & 0 & 0 & 0 & 34/105 & 9/35 & 9/35 & 9/280 & 9/280 & 41/840 &      0 &      0 \\
    %>       &      0 & 0 & 0 & 0 & 0 & 34/105 & 9/35 & 9/35 & 9/280 & 9/280 &      0 & 41/840 & 41/840 \\
    %>   \end{array}
    %>
    %> \endrst
    %
    function this = Fehlberg78()
        this@RKexplicit( ...
        'Fehlberg78', ...
        [0,          0,    0,      0,        0,         0,       0,         0,     0,      0,     0, 0, 0; ...
         2/27,       0,    0,      0,        0,         0,       0,         0,     0,      0,     0, 0, 0; ...
         1/36,       1/12, 0,      0,        0,         0,       0,         0,     0,      0,     0, 0, 0; ...
         1/24,       0,    1/8,    0,        0,         0,       0,         0,     0,      0,     0, 0, 0; ...
         5/12,       0,    -25/16, 25/16,    0,         0,       0,         0,     0,      0,     0, 0, 0; ...
         1/20,       0,    0,      1/4,      1/5,       0,       0,         0,     0,      0,     0, 0, 0; ...
         -25/108,    0,    0,      125/108,  -65/27,    125/54,  0,         0,     0,      0,     0, 0, 0; ...
         31/300,     0,    0,      0,        61/225,    -2/9,    13/900,    0,     0,      0,     0, 0, 0; ...
         2,          0,    0,      -53/6,    704/45,    -107/9,  67/90,     3,     0,      0,     0, 0, 0; ...
         -91/108,    0,    0,      23/108,   -976/135,  311/54,  -19/60,    17/6,  -1/12,  0,     0, 0, 0; ...
         2383/4100,  0,    0,      -341/164, 4496/1025, -301/82, 2133/4100, 45/82, 45/164, 18/41, 0, 0, 0; ...
         3/205,      0,    0,      0,        0,         -6/41,   -3/205,    -3/41, 3/41,   6/41,  0, 0, 0; ...
         -1777/4100, 0,    0,      -341/164, 4496/1025, -289/82, 2193/4100, 51/82, 33/164, 12/41, 0, 1, 0], ...
        [41/840, 0, 0, 0, 0, 34/105, 9/35, 9/35, 9/280, 9/280, 41/840, 0,      0], ...
        [0,      0, 0, 0, 0, 34/105, 9/35, 9/35, 9/280, 9/280, 0,      41/840, 41/840], ...
        [0, 2/27, 1/9, 1/6, 5/12, 1/2, 5/6, 1/6, 2/3, 1/3, 1, 0, 1]' ...
      );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
