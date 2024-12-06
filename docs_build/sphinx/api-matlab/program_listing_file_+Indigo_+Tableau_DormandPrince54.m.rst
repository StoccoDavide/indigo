
.. _program_listing_file_+Indigo_+Tableau_DormandPrince54.m:

Program Listing for File DormandPrince54.m
==========================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_DormandPrince54.m>` (``+Indigo/+Tableau/DormandPrince54.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Dormand-Prince 5(4) method.
   %
   classdef DormandPrince54 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Dormand-Prince 5(4) method.
       %>
       %> \f[
       %> \begin{array}{c|cccccc}
       %>      0 &          0 &           0 &          0 &        0 &           0 &     0 & 0 \\
       %>    1/5 &        1/5 &           0 &          0 &        0 &           0 &     0 & 0 \\
       %>   3/10 &       3/40 &        9/40 &          0 &        0 &           0 &     0 & 0 \\
       %>    4/5 &      44/45 &      -56/15 &       32/9 &        0 &           0 &     0 & 0 \\
       %>    8/9 & 19372/6561 & -25360/2187 & 64448/6561 & -212/729 &           0 &     0 & 0 \\
       %>      1 &  9017/3168 &     -355/33 & 46732/5247 &   49/176 & -5103/18656 &     0 & 0 \\
       %>      1 &     35/384 &           0 &   500/1113 &  125/192 &  -2187/6784 & 11/84 & 0 \\
       %>   \hline
       %>        &     35/384 & 0 &   500/1113 & 125/192 &    -2187/6784 &    11/84 &    0 \\
       %>        & 5179/57600 & 0 & 7571/16695 & 393/640 & -92097/339200 & 187/2100 & 1/40 \\
       %> \end{array}
       %> \f]
       %
       function this = DormandPrince54()
         tbl.A   = [0,          0,           0,          0,        0,           0,     0; ...
                    1/5,        0,           0,          0,        0,           0,     0; ...
                    3/40,       9/40,        0,          0,        0,           0,     0; ...
                    44/45,      -56/15,      32/9,       0,        0,           0,     0; ...
                    19372/6561, -25360/2187, 64448/6561, -212/729, 0,           0,     0; ...
                    9017/3168,  -355/33,     46732/5247, 49/176,   -5103/18656, 0,     0; ...
                    35/384,     0,           500/1113,   125/192,  -2187/6784,  11/84, 0];
         tbl.b   = [35/384, 0, 500/1113, 125/192, -2187/6784, 11/84, 0];
         tbl.b_e = [5179/57600, 0, 7571/16695, 393/640, -92097/339200, 187/2100, 1/40];
         tbl.c   = [0, 1/5, 3/10, 4/5, 8/9, 1, 1]';
         this@Indigo.RungeKutta('DormandPrince54', 5, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
