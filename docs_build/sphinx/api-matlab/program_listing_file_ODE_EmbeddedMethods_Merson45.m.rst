
.. _program_listing_file_ODE_EmbeddedMethods_Merson45.m:

Program Listing for File Merson45.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_EmbeddedMethods_Merson45.m>` (``ODE/EmbeddedMethods/Merson45.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Merson's 4(5) method.
   %
   classdef Merson45 < RKexplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Merson's 4(5) method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccccc}
       %>       0 &   0 &   0 &    0 & 0 & 0 \\
       %>     1/3 & 1/3 &   0 &    0 & 0 & 0 \\
       %>     1/3 & 1/6 & 1/6 &    0 & 0 & 0 \\
       %>     1/2 & 1/8 &   0 &  1/8 & 0 & 0 \\
       %>       1 & 1/2 &   0 & -3/2 & 2 & 0 \\
       %>     \hline
       %>        &  1/6 & 0 &  2/3 & 1/6 &   0 \\
       %>        & 1/10 & 0 & 3/10 & 2/5 & 1/5 \\
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = Merson45()
           this@RKexplicit( ...
           'Merson45', ...
           [0,   0,   0,    0, 0; ...
            1/3, 0,   0,    0, 0; ...
            1/6, 1/6, 0,    0, 0; ...
            1/8, 0,   1/8,  0, 0; ...
            1/2, 0,   -3/2, 2, 0], ...
           [1/9,  0, 9/20, 16/45, 1/12, 0], ...
           [1/10, 0, 3/10,   2/5,  1/5, 0], ...
           [0, 1/3, 1/3, 1/2, 1, 1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
