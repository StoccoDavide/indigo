
.. _program_listing_file_indigo_RungeKutta_EmbeddedExplicitMethods_Merson34.m:

Program Listing for File Merson34.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_EmbeddedExplicitMethods_Merson34.m>` (``indigo/RungeKutta/EmbeddedExplicitMethods/Merson34.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Merson's 4(5) method.
   %
   classdef Merson34 < ExplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Merson's 3(4) method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccccc}
       %>       0 &   0 &   0 &    0 & 0 & 0 \\
       %>     1/3 & 1/3 &   0 &    0 & 0 & 0 \\
       %>     1/3 & 1/6 & 1/6 &    0 & 0 & 0 \\
       %>     1/2 & 1/8 &   0 &  3/8 & 0 & 0 \\
       %>       1 & 1/2 &   0 & -3/2 & 2 & 0 \\
       %>     \hline
       %>        &  1/6 & 0 &  2/3 & 1/6 &   0 \\
       %>        & 1/10 & 0 & 3/10 & 2/5 & 1/5 \\
       %>   \end{array}
       %>
       %> \endrst
       %
       % [2]   P.M. Lukehart, "Algorithm 218. Kutta Merson" Comm. Assoc. Comput. Mach. , 6 : 12 (1963) pp. 737–738
       %
       function this = Merson34()
         tbl.A   = [0,   0,   0,    0, 0; ...
                    1/3, 0,   0,    0, 0; ...
                    1/6, 1/6, 0,    0, 0; ...
                    1/8, 0,   3/8,  0, 0; ...
                    1/2, 0,   -3/2, 2, 0];
         tbl.b   = [1/2, 0, -3/2, 2, 0];
         tbl.b_e = [1/6, 0, 0, 2/3, 1/6];
         tbl.c   = [0, 1/3, 1/3, 1/2, 1]';
         this@ExplicitRungeKutta('Merson34', 4, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
