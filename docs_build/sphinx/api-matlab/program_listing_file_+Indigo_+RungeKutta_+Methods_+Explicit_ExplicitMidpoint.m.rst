
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+Explicit_ExplicitMidpoint.m:

Program Listing for File ExplicitMidpoint.m
===========================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+Explicit_ExplicitMidpoint.m>` (``+Indigo/+RungeKutta/+Methods/+Explicit/ExplicitMidpoint.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Explicit midpoint method.
   %
   classdef ExplicitMidpoint < Indigo.RungeKutta.Explicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Explicit midpoint method.
       %>
       %> \f[
       %> \begin{array}{c|cc}
       %>   0   &   0 & 0 \\
       %>   1/2 & 1/2 & 0 \\
       %>   \hline
       %>       &   0 & 1
       %> \end{array}
       %> \f[
       %
       function this = ExplicitMidpoint()
         tbl.A   = [0, 0; 1/2, 0];
         tbl.b   = [0, 1];
         tbl.b_e = [];
         tbl.c   = [0, 1/2]';
         this@Indigo.RungeKutta.Explicit('ExplicitMidpoint', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
