
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+Implicit_ImplicitEuler.m:

Program Listing for File ImplicitEuler.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+Implicit_ImplicitEuler.m>` (``+Indigo/+RungeKutta/+Methods/+Implicit/ImplicitEuler.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Implicit Euler method.
   %
   classdef ImplicitEuler < Indigo.RungeKutta.Implicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Implicit Euler method.
       %>
       %> \f[
       %> \begin{array}{c|c}
       %>   1 & 1 \\
       %>   \hline
       %>     & 1
       %> \end{array}
       %> \f[
       %
       function this = ImplicitEuler()
         tbl.A   = 1;
         tbl.b   = 1;
         tbl.b_e = [];
         tbl.c   = 1;
         this@Indigo.RungeKutta.Implicit('ImplicitEuler', 1, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
