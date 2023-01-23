
.. _program_listing_file_ODE_ExplicitMethods_ExplicitMidpoint.m:

Program Listing for File ExplicitMidpoint.m
===========================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ExplicitMethods_ExplicitMidpoint.m>` (``ODE/ExplicitMethods/ExplicitMidpoint.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Explicit midpoint second-order method (2 stages)
   %
   classdef ExplicitMidpoint < RKexplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Explicit midpoint second-order method (2 stages)
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     0   &   0 & 0 \\
       %>     1/2 & 1/2 & 0 \\
       %>     \hline
       %>         &   0 & 1
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = ExplicitMidpoint( ~ )
         this@RKexplicit( ...
           'ExplicitMidpoint', ...
           [0, 0; 1/2, 0], ...
           [0, 1], ...
           [0, 1/2]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
