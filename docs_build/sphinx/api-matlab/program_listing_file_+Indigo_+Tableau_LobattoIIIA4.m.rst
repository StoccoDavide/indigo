
.. _program_listing_file_+Indigo_+Tableau_LobattoIIIA4.m:

Program Listing for File LobattoIIIA4.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_LobattoIIIA4.m>` (``+Indigo/+Tableau/LobattoIIIA4.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIA3 method.
   %
   classdef LobattoIIIA4 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIA3 method.
       %>
       % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
       % Symplectic Runge-Kutta Methods of High Order Based on W-Transformation,
       % Kaifeng Xia, Yuhao Cong1 and Geng Sun. Journal of Applied Analysis and
       % Computation, Volume 7, Number 3, August 2017, 1185-1199
       %>
       %> \f[
       %> \begin{array}{c|ccc}
       %>     0 &    0 &   0 &     0 \\
       %>   1/2 & 5/24 & 1/3 & -1/24 \\
       %>     1 &  1/6 & 2/3 &   1/6 \\
       %>   \hline
       %>       &  1/6 & 2/3 &   1/6
       %> \end{array}
       %> \f]
       %
       function this = LobattoIIIA4()
         tbl.A   = [0,    0,   0; ...
                    5/24, 1/3, -1/24; ...
                    1/6,  2/3, 1/6];
         tbl.b   = [1/6, 2/3, 1/6];
         tbl.b_e = [-1/2, 2, -1/2]; % ordine 2!
         tbl.c   = [0, 1/2, 1]';
         this@Indigo.RungeKutta('LobattoIIIA4', 4, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
