
.. _program_listing_file_indigo_RungeKutta_ExplicitMethods_RK3.m:

Program Listing for File RK3.m
==============================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ExplicitMethods_RK3.m>` (``indigo/RungeKutta/ExplicitMethods/RK3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Runge-Kutta 3 method.
   %
   classdef RK3 < ExplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Runge-Kutta 3 method.
       %>
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccc}
       %>       0 &   0 &   0 &   0 \\
       %>     1/2 & 1/2 &   0 &   0 \\
       %>       1 &  -1 &   2 &   0 \\
       %>     \hline
       %>         & 1/6 & 2/3 & 1/6
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = RK3()
         tbl.A   = [0,   0, 0; ...
                    1/2, 0, 0; ...
                    -1,  2, 0];
         tbl.b   = [1/6, 2/3, 1/6];
         tbl.b_e = [];
         tbl.c   = [0, 1/2, 1]';
         this@ExplicitRungeKutta('RK3', 3, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
