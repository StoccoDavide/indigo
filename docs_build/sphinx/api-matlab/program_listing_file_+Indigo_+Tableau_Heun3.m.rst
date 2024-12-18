
.. _program_listing_file_+Indigo_+Tableau_Heun3.m:

Program Listing for File Heun3.m
================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_Heun3.m>` (``+Indigo/+Tableau/Heun3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Heun's method.
   %
   classdef Heun3 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Heun's method.
       %>
       %> \f[
       %> \begin{array}{c|ccc}
       %>     0 &   0 &   0 &   0 \\
       %>   1/3 & 1/3 &   0 &   0 \\
       %>   2/3 &   0 & 2/3 &   0 \\
       %>   \hline
       %>       & 1/4 &   0 & 3/4
       %> \end{array}
       %> \f]
       %
       function this = Heun3()
         tbl.A   = [0,   0,   0; ...
                    1/3, 0,   0; ...
                    0,   2/3, 0];
         tbl.b   = [1/4, 0, 3/4];
         tbl.b_e = [];
         tbl.c   = [0, 1/3, 2/3]';
         this@Indigo.RungeKutta('Heun3', 3, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
