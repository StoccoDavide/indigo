
.. _program_listing_file_indigo_RungeKutta_EmbeddedImplicitMethods_LobattoIIIA12.m:

Program Listing for File LobattoIIIA12.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_EmbeddedImplicitMethods_LobattoIIIA12.m>` (``indigo/RungeKutta/EmbeddedImplicitMethods/LobattoIIIA12.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIA 1(2) method.
   %
   classdef LobattoIIIA12 < ImplicitRungeKutta
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
         tbl.A   = [0, 0; 1/2, 1/2];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [1, 0];
         tbl.c   = [0, 1]';
         this@ImplicitRungeKutta('LobattoIIIA12', 2, tbl); % order = 2*s-2
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
