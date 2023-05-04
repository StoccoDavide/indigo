
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+EmbeddedImplicit_LobattoIIIB34.m:

Program Listing for File LobattoIIIB34.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+EmbeddedImplicit_LobattoIIIB34.m>` (``+Indigo/+RungeKutta/+Methods/+EmbeddedImplicit/LobattoIIIB34.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIB 3(4) method.
   %
   classdef LobattoIIIB34 < Indigo.RungeKutta.Implicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIB 3(4) method.
       %>
       %> \f[
       %> \begin{array}{c|ccc}
       %>     0 & 1/6 & -1/6 &   0 \\
       %>   1/2 & 1/6 &  1/3 &   0 \\
       %>     1 & 1/6 &  5/6 &   0 \\
       %>   \hline
       %>       & 1/6  &  2/3 & 1/6 \\
       %>       & -1/2 &  2   & -1/2
       %> \end{array}
       %> \f[
       %
       function this = LobattoIIIB34()
         tbl.A   = [1/6, -1/6,  0; ...
                    1/6,  1/3,  0; ...
                    1/6,  5/6,  0];
         tbl.b   = [1/6, 2/3, 1/6];
         tbl.b_e = [-1/2, 2, -1/2];
         tbl.c   = [0, 1/2, 1]';
         this@Indigo.RungeKutta.Implicit('LobattoIIIB34', 4, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
