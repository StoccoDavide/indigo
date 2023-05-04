
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+Explicit_Heun2.m:

Program Listing for File Heun2.m
================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+Explicit_Heun2.m>` (``+Indigo/+RungeKutta/+Methods/+Explicit/Heun2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Heun's method.
   %
   classdef Heun2 < Indigo.RungeKutta.Explicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Heun's method.
       %>
       %> \f[
       %> \begin{array}{c|cc}
       %>   0 &   0 &   0 \\
       %>   1 &   1 &   0 \\
       %>   \hline
       %>     & 1/2 & 1/2
       %> \end{array}
       %> \f[
       %
       function this = Heun2()
         tbl.A   = [0, 0; 1, 0];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [];
         tbl.c   = [0, 1]';
         this@Indigo.RungeKutta.Explicit('Heun2', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
