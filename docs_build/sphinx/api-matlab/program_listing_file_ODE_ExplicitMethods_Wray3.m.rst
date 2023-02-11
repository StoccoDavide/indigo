
.. _program_listing_file_ODE_ExplicitMethods_Wray3.m:

Program Listing for File Wray3.m
================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ExplicitMethods_Wray3.m>` (``ODE/ExplicitMethods/Wray3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Wray's method.
   %
   classdef Wray3 < RKexplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Wray's method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccc}
       %>        0 &    0 &    0 &   0 \\
       %>     8/15 & 8/15 &    0 &   0 \\
       %>      2/3 &  1/4 & 5/12 &   0 \\
       %>     \hline
       %>          &  1/4 &    0 & 3/4
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = Wray3()
         this@RKexplicit( ...
           'Wray3', ...
           [0,    0,    0; ...
            8/15, 0,    0; ...
            1/4,  5/12, 0], ...
           [1/4, 0, 3/4], ...
           [0, 8/15, 2/3]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
