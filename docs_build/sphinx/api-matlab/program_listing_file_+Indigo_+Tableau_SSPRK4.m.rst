
.. _program_listing_file_+Indigo_+Tableau_SSPRK4.m:

Program Listing for File SSPRK4.m
=================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_SSPRK4.m>` (``+Indigo/+Tableau/SSPRK4.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for third-order strong stability preserving Runge-Kutta
   %> method.
   %
   classdef SSPRK4 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Third-order strong stability preserving Runge-Kutta method.
       %>
       %> \f[
       %> \begin{array}{c|ccc}
       %>     0 &   0 &   0 &   0 \\
       %>     1 &   1 &   0 &   0 \\
       %>   1/2 & 1/4 & 1/4 &   0 \\
       %>   \hline
       %>       & 1/6 & 1/6 & 2/3
       %> \end{array}
       %> \f]
       %
       function this = SSPRK4()
         tbl.A = [...
           0,    0,    0,    0,    0,    0,   0,   0,   0,   0;...
           1/6,  0,    0,    0,    0,    0,   0,   0,   0,   0;...
           1/6,  1/6,  0,    0,    0,    0,   0,   0,   0,   0;...
           1/6,  1/6,  1/6,  0,    0,    0,   0,   0,   0,   0;...
           1/6,  1/6,  1/6,  1/6,  0,    0,   0,   0,   0,   0;...
           1/15, 1/15, 1/15, 1/15, 1/15, 0,   0,   0,   0,   0;...
           1/15, 1/15, 1/15, 1/15, 1/15, 1/6, 0,   0,   0,   0;...
           1/15, 1/15, 1/15, 1/15, 1/15, 1/6, 1/6, 0,   0,   0;...
           1/15, 1/15, 1/15, 1/15, 1/15, 1/6, 1/6, 1/6, 0,   0;...
           1/15, 1/15, 1/15, 1/15, 1/15, 1/6, 1/6, 1/6, 1/6, 0 ...
         ];
         tbl.b   = ones(1,10)/10;
         tbl.b_e = [];
         tbl.c   = [0, 1/6, 1/3, 1/2, 2/3, 1/3, 1/2, 2/3, 5/6, 1]';
         this@Indigo.RungeKutta('SSPRK4', 4, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
