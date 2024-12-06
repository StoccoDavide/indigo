
.. _program_listing_file_+Indigo_+Tableau_RK3.m:

Program Listing for File RK3.m
==============================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_RK3.m>` (``+Indigo/+Tableau/RK3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Runge-Kutta 3 method.
   %
   classdef RK3 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Runge-Kutta 3 method.
       %>
       %> \f[
       %> \begin{array}{c|ccc}
       %>     0 &   0 &   0 &   0 \\
       %>   1/2 & 1/2 &   0 &   0 \\
       %>     1 &  -1 &   2 &   0 \\
       %>   \hline
       %>       & 1/6 & 2/3 & 1/6
       %> \end{array}
       %> \f]
       %
       function this = RK3()
         tbl.A   = [0,   0, 0; ...
                    1/2, 0, 0; ...
                    -1,  2, 0];
         tbl.b   = [1/6, 2/3, 1/6];
         tbl.b_e = [];
         tbl.c   = [0, 1/2, 1]';
         this@Indigo.RungeKutta('RK3', 3, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
