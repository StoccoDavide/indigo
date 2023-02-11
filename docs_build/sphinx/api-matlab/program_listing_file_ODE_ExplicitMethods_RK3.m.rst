
.. _program_listing_file_ODE_ExplicitMethods_RK3.m:

Program Listing for File RK3.m
==============================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ExplicitMethods_RK3.m>` (``ODE/ExplicitMethods/RK3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Runge-Kutta 3 method.
   %
   classdef RK3 < RKexplicit
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
         this@RKexplicit( ...
           'RK3', ...
           [0,   0, 0;
            1/2, 0, 0;
            -1,  2, 0], ...
           [1/6, 2/3, 1/6], ...
           [0, 1/2, 1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
