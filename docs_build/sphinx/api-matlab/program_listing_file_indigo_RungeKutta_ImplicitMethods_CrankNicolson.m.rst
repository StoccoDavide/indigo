
.. _program_listing_file_indigo_RungeKutta_ImplicitMethods_CrankNicolson.m:

Program Listing for File CrankNicolson.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ImplicitMethods_CrankNicolson.m>` (``indigo/RungeKutta/ImplicitMethods/CrankNicolson.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Crank-Nicolson method.
   %
   classdef CrankNicolson < ImplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Crank-Nicolson method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     0 &   0 &   0 \\
       %>     1 & 1/2 & 1/2 \\
       %>     \hline
       %>       & 1/2 & 1/2
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = CrankNicolson()
         tbl.A   = [0, 0; 1/2, 1/2];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [];
         tbl.c   = [0, 1]';
         this@ImplicitRungeKutta('CrankNicolson', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
