
.. _program_listing_file_+Indigo_+Tableau_LobattoIIIC4.m:

Program Listing for File LobattoIIIC4.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_LobattoIIIC4.m>` (``+Indigo/+Tableau/LobattoIIIC4.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIC4 method.
   %
   classdef LobattoIIIC4 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIC4 method.
       %>
       % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
       % Symplectic Runge-Kutta Methods of High Order Based on W-Transformation,
       % Kaifeng Xia, Yuhao Cong1 and Geng Sun. Journal of Applied Analysis and
       % Computation, Volume 7, Number 3, August 2017, 1185-1199
       %>
       %> \f[
       %> \begin{array}{c|ccc}
       %>     0 & 1/6 & -1/3 & 1/6  \\
       %>   1/2 & 1/6 & 5/12 & -1/12 \\
       %>     1 & 1/6 & 2/3  &  1/6  \\
       %>   \hline
       %>       & 1/6 & 2/3 & 1/6
       %> \end{array}
       %> \f]
       %
       function this = LobattoIIIC4()
         tbl.A   = [1/6, -1/3,   1/6; ...
                    1/6,  5/12, -1/12; ...
                    1/6,  2/3,   1/6];
         tbl.b   = [1/6, 2/3, 1/6];
         tbl.b_e = [-1/2, 2, -1/2];
         tbl.c   = [0, 1/2, 1]';
         this@Indigo.RungeKutta('LobattoIIIC4', 4, tbl);
       end
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     end
   end
