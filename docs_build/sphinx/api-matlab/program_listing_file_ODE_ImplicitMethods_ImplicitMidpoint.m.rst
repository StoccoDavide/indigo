
.. _program_listing_file_ODE_ImplicitMethods_ImplicitMidpoint.m:

Program Listing for File ImplicitMidpoint.m
===========================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ImplicitMethods_ImplicitMidpoint.m>` (``ODE/ImplicitMethods/ImplicitMidpoint.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Implicit midpoint second-order method (1 stage)
   %
   classdef ImplicitMidpoint < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Implicit midpoint second-order method (1 stage)
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
         this@RKimplicit( ...
           'ImplicitMidpoint', ...
           [1/2], ...
           [1], ...
           [1/2]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
