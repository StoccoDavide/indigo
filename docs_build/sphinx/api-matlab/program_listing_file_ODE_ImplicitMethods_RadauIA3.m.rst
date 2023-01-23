
.. _program_listing_file_ODE_ImplicitMethods_RadauIA3.m:

Program Listing for File RadauIA3.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ImplicitMethods_RadauIA3.m>` (``ODE/ImplicitMethods/RadauIA3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Radau IA third-order method (2 stages)
   %
   classdef RadauIA3 < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> RadauIA third-order method (2 stages)
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
       function this = RadauIA3( ~ )
         this@RKimplicit( ...
           'RadauIA3', ...
           [1/4, -1/4; 1/4, 5/12], ...
           [1/4, 3/4], ...
           [0, 2/3]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
