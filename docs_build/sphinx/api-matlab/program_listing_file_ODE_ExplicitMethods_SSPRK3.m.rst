
.. _program_listing_file_ODE_ExplicitMethods_SSPRK3.m:

Program Listing for File SSPRK3.m
=================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ExplicitMethods_SSPRK3.m>` (``ODE/ExplicitMethods/SSPRK3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for third-order strong stability preserving Runge-Kutta
   %> method.
   %
   classdef SSPRK3 < RKexplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Third-order strong stability preserving Runge-Kutta method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccc}
       %>       0 &   0 &   0 &   0 \\
       %>       1 &   1 &   0 &   0 \\
       %>     1/2 & 1/4 & 1/4 &   0 \\
       %>     \hline
       %>         & 1/6 & 1/6 & 2/3
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = SSPRK3()
         this@RKexplicit( ...
           'SSPRK3',...
           [0, 0, 0; 1, 0, 0; 1/4, 1/4, 0], ...
           [1/6, 1/6, 2/3], ...
           [0, 1, 1/2]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
