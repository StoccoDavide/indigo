
.. _program_listing_file_indigo_RungeKutta_ImplicitMethods_RadauIA3.m:

Program Listing for File RadauIA3.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ImplicitMethods_RadauIA3.m>` (``indigo/RungeKutta/ImplicitMethods/RadauIA3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Radau IA method.
   %
   classdef RadauIA3 < ImplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Radau IA method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>       0 & 1/4 & -1/4 \\
       %>     2/3 & 1/4 & 5/12 \\
       %>     \hline
       %>         & 1/4 &  3/4
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = RadauIA3()
         tbl.A   = [1/4, -1/4; ...
                    1/4, 5/12];
         tbl.b   = [1/4, 3/4];
         tbl.b_e = [];
         tbl.c   = [0, 2/3]';
         this@ImplicitRungeKutta('RadauIA3', 3, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
