
.. _program_listing_file_+Indigo_+Tableau_LobattoIIID4.m:

Program Listing for File LobattoIIID4.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_LobattoIIID4.m>` (``+Indigo/+Tableau/LobattoIIID4.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIID method.
   %
   classdef LobattoIIID4 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIID method.
       %>
       %> \f[
       %> \begin{array}{c|ccc}
       %>     0 &  1/6 &    0 & -1/6 \\
       %>   1/2 & 1/12 & 5/12 &    0 \\
       %>     1 &  1/2 &  1/3 &  1/6 \\
       %>   \hline
       %>       &  1/6 &  2/3 & 1/6
       %> \end{array}
       %> \f]
       %
       function this = LobattoIIID4()
         tbl.A   = [1/6,  0,    -1/6; ...
                    1/12, 5/12, 0; ...
                    1/2,  1/3,  1/6];
         tbl.b   = [1/6, 2/3, 1/6];
         tbl.b_e = [];
         tbl.c   = [0, 1/2, 1]';
         this@Indigo.RungeKutta('LobattoIIID4', 4, tbl);
       end
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     end
   end
