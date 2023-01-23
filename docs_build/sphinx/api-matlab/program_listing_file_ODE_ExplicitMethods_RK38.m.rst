
.. _program_listing_file_ODE_ExplicitMethods_RK38.m:

Program Listing for File RK38.m
===============================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ExplicitMethods_RK38.m>` (``ODE/ExplicitMethods/RK38.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Runge-Kutta 3/8-rule third-order method (4 stages)
   %
   classdef RK38 < RKexplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Runge-Kutta 3/8-rule fourth-order method (4 stages)
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccccc}
       %>       0 &    0 &   0 &   0 &   0 \\
       %>     1/3 &  1/3 &   0 &   0 &   0 \\
       %>     2/3 & -1/3 &   1 &   0 &   0 \\
       %>       1 &    1 &  -1 &   1 &   0 \\
       %>     \hline
       %>         &  1/8 & 3/8 & 3/8 & 1/8
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = RK38( ~ )
         this@RKexplicit( ...
           'RK38',...
           [   0,  0, 0, 0; ...
             1/3,  0, 0, 0; ...
            -1/3,  1, 0, 0; ...
               1, -1, 1, 0 ], ...
           [1/8, 3/8, 3/8, 1/8], ...
           [0, 1/3, 2/3, 1]' ...
         );
       end
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     end
   end
