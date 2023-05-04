
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+Implicit_LobattoIIID2.m:

Program Listing for File LobattoIIID2.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+Implicit_LobattoIIID2.m>` (``+Indigo/+RungeKutta/+Methods/+Implicit/LobattoIIID2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIID method.
   %
   classdef LobattoIIID2 < Indigo.RungeKutta.Implicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIID method.
       %>
       %> \f[
       %> \begin{array}{c|cc}
       %>   0 &  1/2 & 1/2 \\
       %>   1 & -1/2 & 1/2 \\
       %>   \hline
       %>     &  1/2 & 1/2
       %> \end{array}
       %> \f[
       %
       function this = LobattoIIID2()
         tbl.A   = [1/2, 1/2; -1/2, 1/2];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [];
         tbl.c   = [0, 1]';
         this@Indigo.RungeKutta.Implicit('LobattoIIID2', 2, tbl);
       end
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     end
   end
