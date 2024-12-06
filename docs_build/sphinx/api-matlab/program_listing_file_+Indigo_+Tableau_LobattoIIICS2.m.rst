
.. _program_listing_file_+Indigo_+Tableau_LobattoIIICS2.m:

Program Listing for File LobattoIIICS2.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_LobattoIIICS2.m>` (``+Indigo/+Tableau/LobattoIIICS2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIC$^\star$ method.
   %
   classdef LobattoIIICS2 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIC$^\star$ method.
       %>
       %> \f[
       %> \begin{array}{c|cc}
       %>   0 &   0 &   0 \\
       %>   1 &   1 &   0 \\
       %>   \hline
       %>     & 1/2 & 1/2
       %> \end{array}
       %> \f]
       %
       function this = LobattoIIICS2()
         tbl.A   = [0, 0; 1, 0];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [];
         tbl.c   = [0, 1]';
         this@Indigo.RungeKutta('LobattoIIICS2', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
