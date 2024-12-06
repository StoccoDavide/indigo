
.. _program_listing_file_+Indigo_+Tableau_LStableDirk4.m:

Program Listing for File LStableDirk4.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_LStableDirk4.m>` (``+Indigo/+Tableau/LStableDirk4.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Merson's 4(5) method.
   %
   classdef LStableDirk4 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       % E. Hairer and G. Wanner. Vol. 2: Stiff and Differential-Algebraic Problems : Solving Ordinary Differential Equations. Volume 2. Springer, Berlin, 1999.[BibTeX]
       % L. M. Skvortsov. Diagonally implicit runge-kutta methods for stiff problems. Computational Mathematics and Mathematical Physics, 46(12):2110-2123, 2006.[BibTeX]    %>
       %
       %
       function this = LStableDirk4()
         %x       = 1-sqrt(2)/2;
         gamma   = (3+sqrt(3))/6;
         %tbl.A   = [1/4,  0,   0,   0,     0; ...
         %           -1/4, 1/4, 0,   0,     0; ...
         %           1/8,  1/8, 1/4, 0,     0; ...
         %           -3/2, 3/4, 3/2, 1/4,   0; ...
         %           0 ,   1/6  2/3, -1/12, 1/4 ];
         %tbl.b   = [0,   1/6  2/3, -1/12, 1/4];
         tbl.A   = [1/4,      0,         0,      0,       0; ...
                    1/2,      1/4,       0,      0,       0; ...
                    17/50,    -1/25,     1/4,    0,       0; ...
                    371/1360, -137/2720, 15/544, 1/4,     0; ...
                    25/24 ,   -49/48,    125/16, -85/12, 1/4 ];
         tbl.b   = [25/24 ,   -49/48,    125/16, -85/12, 1/4];
         tbl.b_e = [];
         tbl.c   = tbl.A*ones(5,1);
         this@Indigo.RungeKutta('LStableDirk4', 4, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
