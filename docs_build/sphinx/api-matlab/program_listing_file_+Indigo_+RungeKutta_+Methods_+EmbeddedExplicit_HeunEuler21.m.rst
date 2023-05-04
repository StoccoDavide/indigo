
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+EmbeddedExplicit_HeunEuler21.m:

Program Listing for File HeunEuler21.m
======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+EmbeddedExplicit_HeunEuler21.m>` (``+Indigo/+RungeKutta/+Methods/+EmbeddedExplicit/HeunEuler21.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Heun-Euler 2(1) method.
   %
   classdef HeunEuler21 < Indigo.RungeKutta.Explicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Heun-Euler 2(1) method.
       %>
       %> \f[
       %> \begin{array}{c|cc}
       %>   0 & 0 & 0 \\
       %>   1 & 1 & 0 \\
       %>   \hline
       %>     & 1/2 & 1/2 \\
       %>     &   1 & 0   \\
       %> \end{array}
       %> \f[
       %
       function this = HeunEuler21()
         tbl.A   = [0, 0; ...
                    1, 1];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [1, 0];
         tbl.c   = [0, 1]';
         this@Indigo.RungeKutta.Explicit('HeunEuler21', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
