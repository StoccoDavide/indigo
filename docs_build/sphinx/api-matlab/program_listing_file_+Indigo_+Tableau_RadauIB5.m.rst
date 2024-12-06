
.. _program_listing_file_+Indigo_+Tableau_RadauIB5.m:

Program Listing for File RadauIB5.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_RadauIB5.m>` (``+Indigo/+Tableau/RadauIB5.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Radau IB5 method.
   %
   classdef RadauIB5 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Radau IB5 method.
       %>
       % http://www.jaac-online.com/data/article/jaac/preview/pdf/20170325.pdf
       % Symplectic Runge-Kutta Methods of High Order Based on W-Transformation,
       % Kaifeng Xia, Yuhao Cong1 and Geng Sun. Journal of Applied Analysis and
       % Computation, Volume 7, Number 3, August 2017, 1185-1199
       %>
       %
       function this = RadauIB5()
         s6 = sqrt(6);
         tbl.A   = [1/18,          -(1+s6)/36,        (-1+s6)/36;        ...
                    (52+3*s6)/450, (16+s6)/72,        (472-217*s6)/1800; ...
                    (52-3*s6)/450, (472+217*s6)/1800, (16-s6)/72];
         tbl.b   = [1/9, (16+s6)/36, (16-s6)/36];
         tbl.b_e = [];
         tbl.c   = tbl.A*ones(3,1);
         this@Indigo.RungeKutta('RadauIB5', 5, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
