
.. _program_listing_file_ODE_EmbeddedMethods_LobattoIIIB34.m:

Program Listing for File LobattoIIIB34.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_EmbeddedMethods_LobattoIIIB34.m>` (``ODE/EmbeddedMethods/LobattoIIIB34.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIB 3(4) method.
   %
   classdef LobattoIIIB34 < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIB 3(4) method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccc}
       %>       0 & 1/6 & -1/6 &   0 \\
       %>     1/2 & 1/6 &  1/3 &   0 \\
       %>       1 & 1/6 &  5/6 &   0 \\
       %>     \hline
       %>         & 1/6  &  2/3 & 1/6 \\
       %>         & -1/2 &  2   & -1/2
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIIB34()
         this@RKimplicit( ...
           'LobattoIIIB34', ...
           [1/6, -1/6, 0; ...
            1/6, 1/3,  0; ...
            1/6, 5/6,  0], ...
           [1/6, 2/3, 1/6], ...
           [-1/2, 2, 1/2], ...
           [0, 1/2, 1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
