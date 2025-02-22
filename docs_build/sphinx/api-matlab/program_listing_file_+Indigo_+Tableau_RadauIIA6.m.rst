
.. _program_listing_file_+Indigo_+Tableau_RadauIIA6.m:

Program Listing for File RadauIIA6.m
====================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_RadauIIA6.m>` (``+Indigo/+Tableau/RadauIIA6.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Radau IIA method.
   %
   classdef RadauIIA6 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Radau IIA method.
       %
       function this = RadauIIA6()
         s3 = sqrt(3);
         tbl.A   = [(1276-397*s3)/9360,    81*(13-8*s3)/5200, 7*(100-53*s3)/9360,    (24*s3-49)/3600; ...
                    25*(140+121*s3)/50544, 115/624,           25*(140-121*s3)/50544, 41/3888; ...
                    7*(100+53*s3)/9360,    81*(13+8*s3)/5200, (1276+397*s3)/9360,    -(24*s3+49)/3600; ...
                    125*(4-s3)/1872,       81/208,            125*(4+s3)/1872,       11/144];
         tbl.b   = [125*(4-s3)/1872,       81/208,            125*(4+s3)/1872,       11/144 ];
         tbl.b_e = [];;
         tbl.c   = [(2-s3)/5, 1/3, (2+s3)/5, 1]';
         this@Indigo.RungeKutta('RadauIIA6', 6, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
