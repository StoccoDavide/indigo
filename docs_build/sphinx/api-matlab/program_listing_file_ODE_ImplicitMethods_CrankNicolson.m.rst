
.. _program_listing_file_ODE_ImplicitMethods_CrankNicolson.m:

Program Listing for File CrankNicolson.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ImplicitMethods_CrankNicolson.m>` (``ODE/ImplicitMethods/CrankNicolson.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Crank-Nicolson second-order method (2 stages)
   %
   classdef CrankNicolson < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Crank-Nicolson second-order method (2 stages)
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     0 &   0 &   0 \\
       %>     1 & 1/2 & 1/2 \\
       %>     \hline
       %>       & 1/2 & 1/2
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = CrankNicolson()
         this@RKimplicit( ...
           'CrankNicolson', ...
           [0, 0; 1/2, 1/2], ...
           [1/2, 1/2], ...
           [0, 1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
