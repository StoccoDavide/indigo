
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+EmbeddedImplicit_LobattoIIIA12.m:

Program Listing for File LobattoIIIA12.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+EmbeddedImplicit_LobattoIIIA12.m>` (``+Indigo/+RungeKutta/+Methods/+EmbeddedImplicit/LobattoIIIA12.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIA 1(2) method.
   %
   classdef LobattoIIIA12 < Indigo.RungeKutta.Implicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIA 1(2) method.
       %>
       %> \f[
       %> \begin{array}{c|cc}
       %>   0 &   0 &   0 \\
       %>   1 & 1/2 & 1/2 \\
       %>   \hline
       %>     & 1/2 & 1/2 \\
       %>     & 1   & 0
       %> \end{array}
       %> \f[
       %
       function this = LobattoIIIA12()
         tbl.A   = [0, 0; 1/2, 1/2];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [1, 0];
         tbl.c   = [0, 1]';
         this@Indigo.RungeKutta.Implicit('LobattoIIIA12', 2, tbl); % order = 2*s-2
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
