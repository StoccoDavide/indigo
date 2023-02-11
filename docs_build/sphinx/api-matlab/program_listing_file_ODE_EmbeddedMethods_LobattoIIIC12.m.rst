
.. _program_listing_file_ODE_EmbeddedMethods_LobattoIIIC12.m:

Program Listing for File LobattoIIIC12.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_EmbeddedMethods_LobattoIIIC12.m>` (``ODE/EmbeddedMethods/LobattoIIIC12.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIC 1(2) method.
   %
   classdef LobattoIIIC12 < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIC 1(2) method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     0 & 1/2 & -1/2 \\
       %>     1 & 1/2 &  1/2 \\
       %>     \hline
       %>       & 1/2 &  1/2 \\
       %>       & 1   &  0
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIIC12()
         this@RKimplicit( ...
           'LobattoIIIC12', ...
           [1/2, -1/2; ...
            1/2, 1/2], ...
           [1/2, 1/2], ...
           [1, 0], ...
           [0, 1]' ...
         );
       end
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     end
   end
