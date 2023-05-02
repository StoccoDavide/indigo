
.. _program_listing_file_indigo_RungeKutta_ImplicitMethods_LobattoIIIC2.m:

Program Listing for File LobattoIIIC2.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ImplicitMethods_LobattoIIIC2.m>` (``indigo/RungeKutta/ImplicitMethods/LobattoIIIC2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIC method.
   %
   classdef LobattoIIIC2 < ImplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIC method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     0 & 1/2 & -1/2 \\
       %>     1 & 1/2 &  1/2 \\
       %>     \hline
       %>       & 1/2 &  1/2
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIIC2()
         tbl.A   = [1/2, -1/2; 1/2, 1/2];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [];
         tbl.c   = [0, 1]';
         this@ImplicitRungeKutta('LobattoIIIC2', 2, tbl);
       end
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     end
   end
