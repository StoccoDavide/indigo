
.. _program_listing_file_indigo_RungeKutta_ImplicitMethods_ImplicitEuler.m:

Program Listing for File ImplicitEuler.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ImplicitMethods_ImplicitEuler.m>` (``indigo/RungeKutta/ImplicitMethods/ImplicitEuler.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Implicit Euler method.
   %
   classdef ImplicitEuler < ImplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Implicit Euler method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|c}
       %>     1 & 1 \\
       %>     \hline
       %>       & 1
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = ImplicitEuler()
         tbl.A   = 1;
         tbl.b   = 1;
         tbl.b_e = [];
         tbl.c   = 1;
         this@ImplicitRungeKutta('ImplicitEuler', 1, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
