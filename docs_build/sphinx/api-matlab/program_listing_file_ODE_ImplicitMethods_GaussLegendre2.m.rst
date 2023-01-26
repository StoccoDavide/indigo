
.. _program_listing_file_ODE_ImplicitMethods_GaussLegendre2.m:

Program Listing for File GaussLegendre2.m
=========================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ImplicitMethods_GaussLegendre2.m>` (``ODE/ImplicitMethods/GaussLegendre2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Gauss-Legendre second-order method (1 stage)
   %
   classdef GaussLegendre2 < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Gauss-Legendre second-order method (1 stage)
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
       function this = GaussLegendre2()
         this@RKimplicit( ...
           'GaussLegendre2', ...
           [1/2], ...
           [1], ...
           [1/2]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
