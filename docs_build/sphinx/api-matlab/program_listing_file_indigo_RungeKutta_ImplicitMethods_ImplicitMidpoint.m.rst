
.. _program_listing_file_indigo_RungeKutta_ImplicitMethods_ImplicitMidpoint.m:

Program Listing for File ImplicitMidpoint.m
===========================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ImplicitMethods_ImplicitMidpoint.m>` (``indigo/RungeKutta/ImplicitMethods/ImplicitMidpoint.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Implicit midpoint method.
   %
   classdef ImplicitMidpoint < ImplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Implicit midpoint method.
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
       function this = ImplicitMidpoint()
         tbl.A   = 1/2;
         tbl.b   = 1;
         tbl.b_e = [];
         tbl.c   = 1/2;
         this@ImplicitRungeKutta('ImplicitMidpoint', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
