
.. _program_listing_file_ODE_EmbeddedMethods_LobattoIIIA12.m:

Program Listing for File LobattoIIIA12.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_EmbeddedMethods_LobattoIIIA12.m>` (``ODE/EmbeddedMethods/LobattoIIIA12.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIA 1(2) method.
   %
   classdef LobattoIIIA12 < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIA 1(2) method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     0 &   0 &   0 \\
       %>     1 & 1/2 & 1/2 \\
       %>     \hline
       %>       & 1/2 & 1/2 \\
       %>       & 1   & 0
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIIA12()
         this@RKimplicit( ...
           'LobattoIIIA12', ...
           [0,   0; ...
            1/2, 1/2], ...
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
