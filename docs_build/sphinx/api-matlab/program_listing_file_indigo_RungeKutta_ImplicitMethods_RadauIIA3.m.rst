
.. _program_listing_file_indigo_RungeKutta_ImplicitMethods_RadauIIA3.m:

Program Listing for File RadauIIA3.m
====================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ImplicitMethods_RadauIIA3.m>` (``indigo/RungeKutta/ImplicitMethods/RadauIIA3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Radau IIA method.
   %
   classdef RadauIIA3 < ImplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Radau IIA method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     1/3 & 5/12 & -1/12 \\
       %>       1 &  3/4 &   1/4 \\
       %>     \hline
       %>         &  3/4 &   1/4
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = RadauIIA3()
         tbl.A   = [5/12, -1/12; ...
                    3/4,   1/4];
         tbl.b   = [3/4, 1/4];
         tbl.b_e = [];
         tbl.c   = [1/3, 1]';
         this@ImplicitRungeKutta('RadauIIA3', 3, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
