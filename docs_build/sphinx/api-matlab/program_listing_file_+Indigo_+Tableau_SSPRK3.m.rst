
.. _program_listing_file_+Indigo_+Tableau_SSPRK3.m:

Program Listing for File SSPRK3.m
=================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_SSPRK3.m>` (``+Indigo/+Tableau/SSPRK3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for third-order strong stability preserving Runge-Kutta
   %> method.
   %
   classdef SSPRK3 < Indigo.RungeKutta
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
       function this = SSPRK3()
         tbl.A   = [0,   0,   0; ...
                    1,   0,   0; ...
                    1/4, 1/4, 0];
         tbl.b   = [1/6, 1/6, 2/3];
         tbl.b_e = [];
         tbl.c   = [0, 1, 1/2]';
         this@Indigo.RungeKutta('SSPRK3', 3, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
