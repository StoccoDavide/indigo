
.. _program_listing_file_ODE_ExplicitMethods_Heun2.m:

Program Listing for File Heun2.m
================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ExplicitMethods_Heun2.m>` (``ODE/ExplicitMethods/Heun2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Heun's second-order method.
   %
   classdef Heun2 < RKexplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Heun's second-order method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     0 &   0 &   0 \\
       %>     1 &   1 &   0 \\
       %>     \hline
       %>       & 1/2 & 1/2
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = Heun2()
         this@RKexplicit( ...
           'Heun2', ...
           [0, 0; 1, 0], ...
           [1/2, 1/2], ...
           [0, 1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
