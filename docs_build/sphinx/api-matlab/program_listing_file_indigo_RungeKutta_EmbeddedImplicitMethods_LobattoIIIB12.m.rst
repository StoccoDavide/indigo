
.. _program_listing_file_indigo_RungeKutta_EmbeddedImplicitMethods_LobattoIIIB12.m:

Program Listing for File LobattoIIIB12.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_EmbeddedImplicitMethods_LobattoIIIB12.m>` (``indigo/RungeKutta/EmbeddedImplicitMethods/LobattoIIIB12.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIB 1(2) method.
   %
   classdef LobattoIIIB12 < ImplicitRungeKutta
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
       %>     0 & 0   &  0 \\
       %>     1 & 1/2 & 1/2 \\
       %>     \hline
       %>       & 1/2 & 1/2 \\
       %>       & 1   & 0
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIIB12()
         tbl.A   = [0, 0; ...
                    1, 0];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [1, 0];
         tbl.c   = [1/2, 1/2]';
         this@ImplicitRungeKutta('LobattoIIIB12', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
