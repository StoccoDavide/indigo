
.. _program_listing_file_+Indigo_+Tableau_ImplicitMidpoint.m:

Program Listing for File ImplicitMidpoint.m
===========================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_ImplicitMidpoint.m>` (``+Indigo/+Tableau/ImplicitMidpoint.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Implicit midpoint method.
   %
   classdef ImplicitMidpoint < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Implicit midpoint method.
       %>
       %> \f[
       %> \begin{array}{c|c}
       %>   1/2 & 1/2 \\
       %>   \hline
       %>       &   1
       %> \end{array}
       %> \f]
       %
       function this = ImplicitMidpoint()
         tbl.A   = 1/2;
         tbl.b   = 1;
         tbl.b_e = [];
         tbl.c   = 1/2;
         this@Indigo.RungeKutta('ImplicitMidpoint', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
