
.. _program_listing_file_+Indigo_+Tableau_LobattoIIIA6.m:

Program Listing for File LobattoIIIA6.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_LobattoIIIA6.m>` (``+Indigo/+Tableau/LobattoIIIA6.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIA6 method.
   %
   classdef LobattoIIIA6 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIA6 method.
       %>
       % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
       % Symplectic Runge-Kutta Methods of High Order Based on W-Transformation,
       % Kaifeng Xia, Yuhao Cong1 and Geng Sun. Journal of Applied Analysis and
       % Computation, Volume 7, Number 3, August 2017, 1185-1199
       %
       function this = LobattoIIIA6()
         s5      = sqrt(5);
         tbl.A   = [0,           0,              0,              0; ...
                    (11+s5)/120, (25-s5)/120,    (25-13*s5)/120, (-1+s5)/120; ...
                    (11-s5)/120, (25+13*s5)/120, (25+s5)/120,    (-1-s5)/120; ...
                    1/12,        5/12,           5/12,           1/12];
         tbl.b   = [1/12,        5/12,           5/12,           1/12];
         tbl.b_e = [];
         tbl.c   = tbl.A*ones(4,1);
         this@Indigo.RungeKutta('LobattoIIIA6', 6, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
