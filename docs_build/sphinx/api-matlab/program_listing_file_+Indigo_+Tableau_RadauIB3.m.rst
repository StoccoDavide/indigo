
.. _program_listing_file_+Indigo_+Tableau_RadauIB3.m:

Program Listing for File RadauIB3.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_RadauIB3.m>` (``+Indigo/+Tableau/RadauIB3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Radau IB3 method.
   %
   classdef RadauIB3 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Radau IB3 method.
       %>
       % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
       % Symplectic Runge-Kutta Methods of High Order Based on W-Transformation,
       % Kaifeng Xia, Yuhao Cong1 and Geng Sun. Journal of Applied Analysis and
       % Computation, Volume 7, Number 3, August 2017, 1185-1199
       %>
       %> \f[
       %> \begin{array}{c|cc}
       %>     0 & 1/8  & -1/8 \\
       %>   2/3 & 7/24 & 3/8 \\
       %>   \hline
       %>       & 1/4 &  3/4
       %> \end{array}
       %> \f]
       %
       function this = RadauIB3()
         tbl.A   = [1/8, -1/8; ...
                    7/24, 3/8];
         tbl.b   = [1/4, 3/4];
         tbl.b_e = [];
         tbl.c   = tbl.A*ones(2,1);
         this@Indigo.RungeKutta('RadauIB3', 3, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
