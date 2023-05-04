
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+Implicit_LobattoIIIC4.m:

Program Listing for File LobattoIIIC4.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+Implicit_LobattoIIIC4.m>` (``+Indigo/+RungeKutta/+Methods/+Implicit/LobattoIIIC4.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIC method.
   %
   classdef LobattoIIIC4 < Indigo.RungeKutta.Implicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIC method.
       %>
       %> \f[
       %> \begin{array}{c|ccc}
       %>     0 & 1/6 & -1/3 & 1/6  \\
       %>   1/2 & 1/6 & 5/12 & -1/12 \\
       %>     1 & 1/6 & 2/3  &  1/6  \\
       %>   \hline
       %>       & 1/6 & 2/3 & 1/6
       %> \end{array}
       %> \f[
       %
       function this = LobattoIIIC4()
         tbl.A   = [1/6, -1/3,   1/6; ...
                    1/6,  5/12, -1/12; ...
                    1/6,  2/3,   1/6];
         tbl.b   = [1/6, 2/3, 1/6];
         tbl.b_e = [];
         tbl.c   = [0, 1/2, 1]';
         this@Indigo.RungeKutta.Implicit('LobattoIIIC4', 4, tbl);
       end
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     end
   end
