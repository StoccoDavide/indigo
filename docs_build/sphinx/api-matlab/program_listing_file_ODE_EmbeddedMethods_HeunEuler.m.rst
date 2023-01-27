
.. _program_listing_file_ODE_EmbeddedMethods_HeunEuler.m:

Program Listing for File HeunEuler.m
====================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_EmbeddedMethods_HeunEuler.m>` (``ODE/EmbeddedMethods/HeunEuler.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for The Heun-Euler method of first- and second-order method.
   %
   classdef HeunEuler < RKembedded
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Heun-Euler method of first- and second-order method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     0 & 0 & 0 \\
       %>     1 & 1 & 0 \\
       %>     \hline
       %>       & 1/2 & 1/2 \\
       %>       &   1 & 1   \\
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = HeunEuler()
           this@RKembedded( ...
           'RKF12', ...
           [0, 0; ...
            1, 1], ...
           [1/2, 1/2], ...
           [1, 1], ...
           [0, 1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
