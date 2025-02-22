
.. _program_listing_file_+Indigo_+Tableau_CashKarp45.m:

Program Listing for File CashKarp45.m
=====================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_CashKarp45.m>` (``+Indigo/+Tableau/CashKarp45.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Cash-Karp 4(5) method.
   %
   classdef CashKarp45 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Cash-Karp 4(5) method.
       %>
       %> \f[
       %> \begin{array}{c|ccccc}
       %>     0  &          0 &       0 &         0 &            0 &        0 & 0 \\
       %>   1/5  &        1/5 &       0 &         0 &            0 &        0 & 0 \\
       %>   3/10 &       3/40 &    9/40 &         0 &            0 &        0 & 0 \\
       %>   3/5  &       3/10 &   -9/10 &       6/5 &            0 &        0 & 0 \\
       %>   1    &     -11/54 &     5/2 &    -70/27 &        35/27 &        0 & 0 \\
       %>   7/8  & 1631/55296 & 175/512 & 575/13824 & 44275/110592 & 253/4096 & 0 \\
       %>   \hline
       %>      & 37/378     & 0 &     250/621 &     125/594 &         0 & 512/1771 \\
       %>      & 2825/27648 & 0 & 18575/48384 & 13525/55296 & 277/14336 & 1/4 \\
       %> \end{array}
       %> \f]
       %
       function this = CashKarp45()
         tbl.A   = [0,          0,       0,         0,            0,        0; ...
                    1/5,        0,       0,         0,            0,        0; ...
                    3/40,       9/40,    0,         0,            0,        0; ...
                    3/10,       -9/10,   6/5,       0,            0,        0; ...
                    -11/54,     5/2,     -70/27,    35/27,        0,        0; ...
                    1631/55296, 175/512, 575/13824, 44275/110592, 253/4096, 0];
         tbl.b   = [37/378, 0, 250/621, 125/594, 0, 512/1771];
         tbl.b_e = [2825/27648, 0, 18575/48384, 13525/55296, 277/14336, 1/4];
         tbl.c   = [0, 1/5, 3/10, 3/5, 1, 7/8].';
         this@Indigo.RungeKutta('CashKarp45', 5, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
