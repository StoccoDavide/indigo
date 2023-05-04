
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+Implicit_LobattoIIIA2.m:

Program Listing for File LobattoIIIA2.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+Implicit_LobattoIIIA2.m>` (``+Indigo/+RungeKutta/+Methods/+Implicit/LobattoIIIA2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIA method.
   %
   classdef LobattoIIIA2 < Indigo.RungeKutta.Implicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIA method.
       %>
       %> \f[
       %> \begin{array}{c|cc}
       %>   0 &   0 &   0 \\
       %>   1 & 1/2 & 1/2 \\
       %>   \hline
       %>     & 1/2 & 1/2
       %> \end{array}
       %> \f[
       %
       function this = LobattoIIIA2()
         tbl.A   = [0, 0; 1/2, 1/2];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [];
         tbl.c   = [0, 1]';
         this@Indigo.RungeKutta.Implicit('LobattoIIIA2', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
