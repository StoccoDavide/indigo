
.. _program_listing_file_+Indigo_+Tableau_GaussLegendre2.m:

Program Listing for File GaussLegendre2.m
=========================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_GaussLegendre2.m>` (``+Indigo/+Tableau/GaussLegendre2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Gauss-Legendre method.
   %
   classdef GaussLegendre2 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Gauss-Legendre method.
       %>
       %> \f[
       %> \begin{array}{c|c}
       %>   1/2 & 1/2 \\
       %>   \hline
       %>       &   1
       %> \end{array}
       %> \f]
       %
       function this = GaussLegendre2()
         tbl.A   = [1/2];
         tbl.b   = 1;
         tbl.b_e = [];
         tbl.c   = 1/2;
         this@Indigo.RungeKutta('GaussLegendre2', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
