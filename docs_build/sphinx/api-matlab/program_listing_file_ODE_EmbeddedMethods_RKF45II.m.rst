
.. _program_listing_file_ODE_EmbeddedMethods_RKF45II.m:

Program Listing for File RKF45II.m
==================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_EmbeddedMethods_RKF45II.m>` (``ODE/EmbeddedMethods/RKF45II.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for The Runge–Kutta–Fehlberg (Table II) method of fourth- and
   %> fifth-order method.
   %
   classdef RKF45II < RKembedded
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Runge–Kutta–Fehlberg (Table II) method of fourth- and fifth-order method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cccccc}
       %>       0 & 0           &          0 &          0 &         0 &      0 & 0 \\
       %>       1/4 &       1/4 &          0 &          0 &         0 &      0 & 0 \\
       %>       3/8 &      3/32 &       9/32 &          0 &         0 &      0 & 0 \\
       %>     12/13 & 1932/2197 & -7200/2197 &  7296/2197 &         0 &      0 & 0 \\
       %>         1 &   439/216 &         -8 &   3680/513 & -845/4104 &      0 & 0 \\
       %>       1/2 &     -8/27 &          2 & -3544/2565 & 1859/4104 & -11/40 & 0 \\
       %>     \hline
       %>     & 16/135 & 0 & 6656/12825 & 28561/56430 & -9/50 & 2/55 \\
       %>     & 25/216 & 0 &  1408/2565 &   2197/4104 &  -1/5 &    0 \\
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = RKF45II()
           this@RKembedded( ...
           'RKF45II', ...
           [0,         0,          0,          0,         0,      0; ...
            1/4,       0,          0,          0,         0,      0; ...
            3/32,      9/32,       0,          0,         0,      0; ...
            1932/2197, -7200/2197, 7296/2197,  0,         0,      0; ...
            439/216,   -8,         3680/513,   -845/4104, 0,      0; ...
            -8/27,     2,          -3544/2565, 1859/4104, -11/40, 0; ...
           ], ...
           [16/135, 0, 6656/12825, 28561/56430, -9/50, 2/55], ...
           [25/216, 0,  1408/2565, 2197/4104,   -1/5,  0], ...
           [0, 1/4, 3/8, 12/13, 1, 1/2]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
