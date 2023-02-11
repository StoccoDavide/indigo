
.. _program_listing_file_ODE_EmbeddedMethods_LobattoIIIB12.m:

Program Listing for File LobattoIIIB12.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_EmbeddedMethods_LobattoIIIB12.m>` (``ODE/EmbeddedMethods/LobattoIIIB12.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIB 1(2) method.
   %
   classdef LobattoIIIB12 < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIB 1(2) method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     0 & 1/2 &   0 \\
       %>     1 & 1/2 &   0 \\
       %>     \hline
       %>       & 1/2 & 1/2 \\
       %>       & 1   & 0
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIIB12()
         this@RKimplicit( ...
           'LobattoIIIB12', ...
           [1/2, 0; ...
            1/2, 0], ...
           [1/2, 1/2], ...
           [1, 0], ...
           [0, 1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
