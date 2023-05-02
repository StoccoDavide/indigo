
.. _program_listing_file_indigo_RungeKutta_EmbeddedImplicitMethods_LobattoIIIC12.m:

Program Listing for File LobattoIIIC12.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_EmbeddedImplicitMethods_LobattoIIIC12.m>` (``indigo/RungeKutta/EmbeddedImplicitMethods/LobattoIIIC12.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIC 1(2) method.
   %
   classdef LobattoIIIC12 < ImplicitRungeKutta
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
         tbl.A   = [1/2, -1/2; 1/2, 1/2];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [1, 0];
         tbl.c   = [0, 1]';
         this@ImplicitRungeKutta('LobattoIIIC12', 2, tbl);
       end
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     end
   end
