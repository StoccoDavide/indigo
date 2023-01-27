
.. _program_listing_file_ODE_EmbeddedMethods_RKF12.m:

Program Listing for File RKF12.m
================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_EmbeddedMethods_RKF12.m>` (``ODE/EmbeddedMethods/RKF12.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for The Runge–Kutta–Fehlberg method of first- and second-order
   %> method.
   %
   classdef RKF12 < RKembedded
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Runge–Kutta–Fehlberg method of first- and second-order method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccc}
       %>       0 & 0     &       0 & 0 \\
       %>     1/2 & 1/2   &       0 & 0 \\
       %>       1 & 1/256 & 255/256 & 0 \\
       %>     \hline
       %>       & 1/512 & 255/256 & 1/512 \\
       %>       & 1/256 & 255/256 & 0     \\
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = RKF12()
           this@RKembedded( ...
           'RKF12', ...
           [0,     0,       0; ...
            1/2,   0,       0; ...
            1/256, 255/256, 0], ...
           [1/512, 255/256, 1/512], ...
           [1/256, 255/256, 0], ...
           [0, 1/2, 1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
