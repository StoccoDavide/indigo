
.. _program_listing_file_+Indigo_+Tableau_CrankNicolson.m:

Program Listing for File CrankNicolson.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_CrankNicolson.m>` (``+Indigo/+Tableau/CrankNicolson.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Crank-Nicolson method.
   %
   classdef CrankNicolson < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Crank-Nicolson method.
       %>
       %> \f[
       %> \begin{array}{c|cc}
       %>   0 &   0 &   0 \\
       %>   1 & 1/2 & 1/2 \\
       %>   \hline
       %>     & 1/2 & 1/2
       %> \end{array}
       %> \f]
       %
       function this = CrankNicolson()
         tbl.A   = [0, 0; 1/2, 1/2];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [];
         tbl.c   = [0, 1]';
         this@Indigo.RungeKutta('CrankNicolson', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
