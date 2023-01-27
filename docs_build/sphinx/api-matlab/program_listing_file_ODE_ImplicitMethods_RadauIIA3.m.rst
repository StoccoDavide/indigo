
.. _program_listing_file_ODE_ImplicitMethods_RadauIIA3.m:

Program Listing for File RadauIIA3.m
====================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ImplicitMethods_RadauIIA3.m>` (``ODE/ImplicitMethods/RadauIIA3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Radau IIA third-order method (2 stages)
   %
   classdef RadauIIA3 < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Radau IIA third-order method (2 stages)
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
         this@RKimplicit( ...
           'RadauIIA3', ...
           [5/12, -1/12; 3/4, 1/4], ...
           [3/4, 1/4], ...
           [1/3, 1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
