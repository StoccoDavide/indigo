
.. _program_listing_file_indigo_RungeKutta_ImplicitMethods_GaussLegendre2.m:

Program Listing for File GaussLegendre2.m
=========================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ImplicitMethods_GaussLegendre2.m>` (``indigo/RungeKutta/ImplicitMethods/GaussLegendre2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Gauss-Legendre method.
   %
   classdef GaussLegendre2 < ImplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Gauss-Legendre method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|c}
       %>     1/2 & 1/2 \\
       %>     \hline
       %>         &   1
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = GaussLegendre2()
         tbl.A   = [1/2];
         tbl.b   = 1;
         tbl.b_e = [];
         tbl.c   = 1/2;
         this@ImplicitRungeKutta('GaussLegendre2', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
