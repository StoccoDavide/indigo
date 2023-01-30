
.. _program_listing_file_ODE_ExplicitMethods_Ralston3.m:

Program Listing for File Ralston3.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ExplicitMethods_Ralston3.m>` (``ODE/ExplicitMethods/Ralston3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Ralston's third-order method.
   %
   classdef Ralston3 < RKexplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Ralston's third-order method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccc}
       %>       0 &   0 &   0 &   0 \\
       %>     1/2 & 1/2 &   0 &   0 \\
       %>     3/4 &   0 & 3/4 &   0 \\
       %>     \hline
       %>         & 2/9 & 1/3 & 4/9
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = Ralston3()
         this@RKexplicit( ...
           'Ralston3', ...
           [0,   0,   0; ...
            1/2, 0,   0; ...
            0,   3/4, 0], ...
           [2/9, 1/3, 4/9], ...
           [0, 1/2, 3/4]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
