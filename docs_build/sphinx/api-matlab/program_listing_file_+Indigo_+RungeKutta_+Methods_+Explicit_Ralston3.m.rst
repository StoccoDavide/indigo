
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+Explicit_Ralston3.m:

Program Listing for File Ralston3.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+Explicit_Ralston3.m>` (``+Indigo/+RungeKutta/+Methods/+Explicit/Ralston3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Ralston's method.
   %
   classdef Ralston3 < Indigo.RungeKutta.Explicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Ralston's method.
       %>
       %> \f[
       %> \begin{array}{c|ccc}
       %>     0 &   0 &   0 &   0 \\
       %>   1/2 & 1/2 &   0 &   0 \\
       %>   3/4 &   0 & 3/4 &   0 \\
       %>   \hline
       %>       & 2/9 & 1/3 & 4/9
       %> \end{array}
       %> \f[
       %
       function this = Ralston3()
         tbl.A   = [0,   0,   0; ...
                    1/2, 0,   0; ...
                    0,   3/4, 0];
         tbl.b   = [2/9, 1/3, 4/9];
         tbl.b_e = [];
         tbl.c   = [0, 1/2, 3/4]';
         this@Indigo.RungeKutta.Explicit('Ralston3', 3, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
