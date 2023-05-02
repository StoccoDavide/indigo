
.. _program_listing_file_indigo_RungeKutta_EmbeddedExplicitMethods_Verner65.m:

Program Listing for File Verner65.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_EmbeddedExplicitMethods_Verner65.m>` (``indigo/RungeKutta/EmbeddedExplicitMethods/Verner65.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Verner's 6(5) method.
   %
   classdef Verner65 < ExplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Verner's 6(5) method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccccccc}
       %>        0 &           0 &       0 &            0 &         0 &           0 & 0 &          0 & 0 \\
       %>      1/6 &         1/6 &       0 &            0 &         0 &           0 & 0 &          0 & 0 \\
       %>      4/5 &        4/75 &   16/75 &            0 &         0 &           0 & 0 &          0 & 0 \\
       %>      2/3 &         5/6 &    -8/3 &          5/2 &         0 &           0 & 0 &          0 & 0 \\
       %>      5/6 &     -165/64 &    55/6 &      -425/64 &     85/96 &           0 & 0 &          0 & 0 \\
       %>        1 &        12/5 &      -8 &     4015/612 &    -11/36 &      88/255 & 0 &          0 & 0 \\
       %>     1/15 & -8263/15000 &  124/75 &     -643/680 &   -81/250 &  2484/10625 & 0 &          0 & 0 \\
       %>        1 &   3501/1720 & -300/43 & 297275/52632 & -319/2322 & 24068/84065 & 0 & 3850/26703 & 0 \\
       %>       \hline
       %>          &   3/40 & 0 &  875/2244 & 23/72 & 264/1955 &    0 & 125/11592 & 43/616 \\
       %>          & 13/160 & 0 & 2375/5984 &  5/16 &    12/85 & 3/44 &         0 &      0 \\
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = Verner65()
         tbl.A   = [0,           0,       0,            0,         0,           0, 0,          0; ...
                    1/6,         0,       0,            0,         0,           0, 0,          0; ...
                    4/75,        16/75,   0,            0,         0,           0, 0,          0; ...
                    5/6,         -8/3,    5/2,          0,         0,           0, 0,          0; ...
                    -165/64,     55/6,    -425/64,      85/96,     0,           0, 0,          0; ...
                    12/5,        -8,      4015/612,     -11/36,    88/255,      0, 0,          0; ...
                    -8263/15000, 124/75,  -643/680,     -81/250,   2484/10625,  0, 0,          0; ...
                    3501/1720,   -300/43, 297275/52632, -319/2322, 24068/84065, 0, 3850/26703, 0];
         tbl.b   = [3/40, 0, 875/2244, 23/72, 264/1955, 0, 125/11592, 43/616];
         tbl.b_e = [13/160, 0, 2375/5984, 5/16, 12/85,3/44, 0, 0];
         tbl.c   = [0, 1/6, 4/5, 2/3, 5/6, 1, 1/15, 1]';
         this@ExplicitRungeKutta('Verner65', 6, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
