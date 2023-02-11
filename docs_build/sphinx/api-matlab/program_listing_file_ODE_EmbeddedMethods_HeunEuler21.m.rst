
.. _program_listing_file_ODE_EmbeddedMethods_HeunEuler21.m:

Program Listing for File HeunEuler21.m
======================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_EmbeddedMethods_HeunEuler21.m>` (``ODE/EmbeddedMethods/HeunEuler21.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Heun-Euler 2(1) method.
   %
   classdef HeunEuler21 < RKexplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Heun-Euler 2(1) method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     0 & 0 & 0 \\
       %>     1 & 1 & 0 \\
       %>     \hline
       %>       & 1/2 & 1/2 \\
       %>       &   1 & 0   \\
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = HeunEuler21()
           this@RKexplicit( ...
           'HeunEuler21', ...
           [0, 0; ...
            1, 1], ...
           [1/2, 1/2], ...
           [1, 0], ...
           [0, 1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
