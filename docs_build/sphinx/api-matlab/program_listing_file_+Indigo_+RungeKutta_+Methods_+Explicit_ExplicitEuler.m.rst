
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+Explicit_ExplicitEuler.m:

Program Listing for File ExplicitEuler.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+Explicit_ExplicitEuler.m>` (``+Indigo/+RungeKutta/+Methods/+Explicit/ExplicitEuler.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Explicit Euler method.
   %
   classdef ExplicitEuler < Indigo.RungeKutta.Explicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Explicit Euler method.
       %>
       %> \f[
       %> \begin{array}{c|c}
       %>   0 & 0 \\
       %>   \hline
       %>     & 1
       %> \end{array}
       %> \f[
       %
       function this = ExplicitEuler()
         tbl.A   = 0;
         tbl.b   = 1;
         tbl.b_e = [];
         tbl.c   = 0;
         this@Indigo.RungeKutta.Explicit('ExplicitEuler', 1, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
