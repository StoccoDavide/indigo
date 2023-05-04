
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+Implicit_LobattoIIIA4.m:

Program Listing for File LobattoIIIA4.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+Implicit_LobattoIIIA4.m>` (``+Indigo/+RungeKutta/+Methods/+Implicit/LobattoIIIA4.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIA method.
   %
   classdef LobattoIIIA4 < Indigo.RungeKutta.Implicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIA method.
       %>
       %> \f[
       %> \begin{array}{c|ccc}
       %>     0 &    0 &   0 &     0 \\
       %>   1/2 & 5/24 & 1/3 & -1/24 \\
       %>     1 &  1/6 & 2/3 &   1/6 \\
       %>   \hline
       %>       &  1/6 & 2/3 &   1/6
       %> \end{array}
       %> \f[
       %
       function this = LobattoIIIA4()
         tbl.A   = [0,    0,   0; ...
                    5/24, 1/3, -1/24; ...
                    1/6,  2/3, 1/6];
         tbl.b   = [1/6, 2/3, 1/6];
         tbl.b_e = [];
         tbl.c   = [0, 1/2, 1]';
         this@Indigo.RungeKutta.Implicit('LobattoIIIA4', 4, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
