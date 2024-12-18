
.. _program_listing_file_+Indigo_+Tableau_Verner65.m:

Program Listing for File Verner65.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_Verner65.m>` (``+Indigo/+Tableau/Verner65.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Verner's 6(5) method.
   %
   classdef Verner65 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Verner's 6(5) method.
       %>
       % https://www.sfu.ca/~jverner/
       %>
       %> \f[
       %> \begin{array}{c|ccccccc}
       %>      0 &           0 &       0 &            0 &         0 &           0 & 0 &          0 & 0 \\
       %>    1/6 &         1/6 &       0 &            0 &         0 &           0 & 0 &          0 & 0 \\
       %>    4/5 &        4/75 &   16/75 &            0 &         0 &           0 & 0 &          0 & 0 \\
       %>    2/3 &         5/6 &    -8/3 &          5/2 &         0 &           0 & 0 &          0 & 0 \\
       %>    5/6 &     -165/64 &    55/6 &      -425/64 &     85/96 &           0 & 0 &          0 & 0 \\
       %>      1 &        12/5 &      -8 &     4015/612 &    -11/36 &      88/255 & 0 &          0 & 0 \\
       %>   1/15 & -8263/15000 &  124/75 &     -643/680 &   -81/250 &  2484/10625 & 0 &          0 & 0 \\
       %>      1 &   3501/1720 & -300/43 & 297275/52632 & -319/2322 & 24068/84065 & 0 & 3850/26703 & 0 \\
       %>     \hline
       %>        &   3/40 & 0 &  875/2244 & 23/72 & 264/1955 &    0 & 125/11592 & 43/616 \\
       %>        & 13/160 & 0 & 2375/5984 &  5/16 &    12/85 & 3/44 &         0 &      0 \\
       %> \end{array}
       %> \f]
       %
       function this = Verner65()
         tbl.A   = zeros(9,9);
         tbl.b   = zeros(1,9);
         tbl.b_e = zeros(1,9);
         tbl.c   = zeros(9,1);
   
         tbl.A(2,1) =  9/50;
         tbl.A(3,1) =  29/324;
         tbl.A(3,2) =  25/324;
         tbl.A(4,1) =  1/16;
         tbl.A(4,3) =  3/16;
         tbl.A(5,1) =  79129/250000;
         tbl.A(5,3) = -261237/250000;
         tbl.A(5,4) =  19663/15625;
         tbl.A(6,1) =  1336883/4909125;
         tbl.A(6,3) = -25476/30875;
         tbl.A(6,4) =  194159/185250;
         tbl.A(6,5) =  8225/78546;
         tbl.A(7,1) = -2459386/14727375;
         tbl.A(7,3) =  19504/30875;
         tbl.A(7,4) =  2377474/13615875;
         tbl.A(7,5) = -6157250/5773131;
         tbl.A(7,6) =  902/735;
         tbl.A(8,1) =  2699/7410;
         tbl.A(8,3) = -252/1235;
         tbl.A(8,4) = -1393253/3993990;
         tbl.A(8,5) =  236875/72618;
         tbl.A(8,6) = -135/49;
         tbl.A(8,7) =  15/22;
         tbl.A(9,1) =  11/144;
         tbl.A(9,4) =  256/693;
         tbl.A(9,6) =  125/504;
         tbl.A(9,7) =  125/528;
         tbl.A(9,8) =  5/72;
   
         tbl.b(1) =  11/144;
         tbl.b(4) =  256/693;
         tbl.b(6) =  125/504;
         tbl.b(7) =  125/528;
         tbl.b(8) =  5/72;
   
         tbl.b_e(1) = 28/477;
         tbl.b_e(4) = 212/441;
         tbl.b_e(5) = -312500/366177;
         tbl.b_e(6) = 2125/1764;
         tbl.b_e(8) = -2105/35532;
         tbl.b_e(9) =  2995/17766;
   
         tbl.c(2) =  9/50;
         tbl.c(3) =  1/6;
         tbl.c(4) =  1/4;
         tbl.c(5) =  53/100;
         tbl.c(6) =  3/5;
         tbl.c(7) =  4/5;
         tbl.c(8) =  1;
         tbl.c(9) =  1;
         this@Indigo.RungeKutta('Verner65', 6, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
