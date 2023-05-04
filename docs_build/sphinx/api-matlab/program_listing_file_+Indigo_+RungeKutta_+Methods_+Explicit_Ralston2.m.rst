
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+Explicit_Ralston2.m:

Program Listing for File Ralston2.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+Explicit_Ralston2.m>` (``+Indigo/+RungeKutta/+Methods/+Explicit/Ralston2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Ralston's method.
   %
   classdef Ralston2 < Indigo.RungeKutta.Explicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Ralston's method.
       %>
       %> \f[
       %> \begin{array}{c|cc}
       %>     0 &   0 &   0 \\
       %>   2/3 & 2/3 &   0 \\
       %>   \hline
       %>       & 1/4 & 3/4
       %> \end{array}
       %> \f[
       %
       function this = Ralston2()
         tbl.A   = [0, 0; 2/3, 0];
         tbl.b   = [1/4, 3/4];
         tbl.b_e = [];
         tbl.c   = [0, 2/3]';
         this@Indigo.RungeKutta.Explicit('Ralston2', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
