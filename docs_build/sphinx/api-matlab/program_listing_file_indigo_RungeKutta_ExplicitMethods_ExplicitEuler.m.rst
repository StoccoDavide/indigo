
.. _program_listing_file_indigo_RungeKutta_ExplicitMethods_ExplicitEuler.m:

Program Listing for File ExplicitEuler.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ExplicitMethods_ExplicitEuler.m>` (``indigo/RungeKutta/ExplicitMethods/ExplicitEuler.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Explicit Euler method.
   %
   classdef ExplicitEuler < ExplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Explicit Euler method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|c}
       %>     0 & 0 \\
       %>     \hline
       %>       & 1
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = ExplicitEuler()
         tbl.A   = 0;
         tbl.b   = 1;
         tbl.b_e = [];
         tbl.c   = 0;
         this@ExplicitRungeKutta('ExplicitEuler', 1, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
