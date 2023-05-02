
.. _program_listing_file_indigo_RungeKutta_ImplicitMethods_LobattoIIIB2.m:

Program Listing for File LobattoIIIB2.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ImplicitMethods_LobattoIIIB2.m>` (``indigo/RungeKutta/ImplicitMethods/LobattoIIIB2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIB method.
   %
   classdef LobattoIIIB2 < ImplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIB method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     0 & 1/2 &   0 \\
       %>     1 & 1/2 &   0 \\
       %>     \hline
       %>       & 1/2 & 1/2
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIIB2()
         tbl.A   = [1/2, 0; 1/2, 0];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [];
         tbl.c   = [0, 1]';
         this@ImplicitRungeKutta('LobattoIIIB2', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
