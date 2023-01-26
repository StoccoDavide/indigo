
.. _program_listing_file_ODE_ExplicitMethods_Ralston2.m:

Program Listing for File Ralston2.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ExplicitMethods_Ralston2.m>` (``ODE/ExplicitMethods/Ralston2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Ralston's second-order method.
   %
   classdef Ralston2 < RKexplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Ralston's second-order method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>       0 &   0 &   0 \\
       %>     2/3 & 2/3 &   0 \\
       %>     \hline
       %>         & 1/4 & 3/4
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = Ralston2()
         this@RKexplicit( ...
           'Ralston2', ...
           [0, 0; 2/3, 0], ...
           [1/4, 3/4], ...
           [0, 2/3]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
