
.. _program_listing_file_ODE_EmbeddedMethods_RKF45I.m:

Program Listing for File RKF45I.m
=================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_EmbeddedMethods_RKF45I.m>` (``ODE/EmbeddedMethods/RKF45I.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for The Runge–Kutta–Fehlberg (Table I) method of fourth- and
   %> fifth-order method.
   %
   classdef RKF45I < RKexplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Runge–Kutta–Fehlberg (Table I) method of fourth- and fifth-order method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccccc}
       %>       0  &      0 &        0 &      0 &     0 &     0 & 0 & 0 \\
       %>     2/9  &    2/9 &        0 &      0 &     0 &     0 & 0 & 0 \\
       %>     1/3  &   1/12 &      1/4 &      0 &     0 &     0 & 0 & 0 \\
       %>     3/4  & 69/128 & -243/128 & 135/64 &     0 &     0 & 0 & 0 \\
       %>       1  & -17/12 &     27/4 &  -27/5 & 16/15 &     0 & 0 & 0 \\
       %>     5/6  & 65/432 &    -5/16 &  13/16 &  4/27 & 5/144 & 0 & 0 \\
       %>     \hline
       %>        & 47/450 & 0 & 12/25 & 32/225 & 1/30 & 6/25 \\
       %>        &    1/9 & 0 &  9/20 &  16/45 & 1/12 &    0 \\
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = RKF45I()
           this@RKexplicit( ...
           'RKF45I', ...
           [0,      0,        0,      0,     0,     0; ...
            2/9,    0,        0,      0,     0,     0; ...
            1/12,   1/4,      0,      0,     0,     0; ...
            69/128, -243/128, 135/64, 0,     0,     0; ...
            -17/12, 27/4,     -27/5,  16/15, 0,     0; ...
            65/432, -5/16,    13/16,  4/27,  5/144, 0; ...
           ], ...
           [47/450, 0, 12/25, 32/225, 1/30, 6/25], ...
           [1/9,    0,  9/20,  16/45, 1/12, 0], ...
           [0, 2/9, 1/3, 3/4, 1, 5/6]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
