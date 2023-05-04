
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+Explicit_RK38.m:

Program Listing for File RK38.m
===============================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+Explicit_RK38.m>` (``+Indigo/+RungeKutta/+Methods/+Explicit/RK38.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Runge-Kutta 3/8-rule method.
   %
   classdef RK38 < Indigo.RungeKutta.Explicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Runge-Kutta 3/8-rule method.
       %>
       %> \f[
       %> \begin{array}{c|ccccc}
       %>     0 &    0 &   0 &   0 &   0 \\
       %>   1/3 &  1/3 &   0 &   0 &   0 \\
       %>   2/3 & -1/3 &   1 &   0 &   0 \\
       %>     1 &    1 &  -1 &   1 &   0 \\
       %>   \hline
       %>       &  1/8 & 3/8 & 3/8 & 1/8
       %> \end{array}
       %> \f[
       %
       function this = RK38()
         tbl.A   = [0,    0,  0, 0; ...
                    1/3,  0,  0, 0; ...
                    -1/3, 1,  0, 0; ...
                    1,    -1, 1, 0];
         tbl.b   = [1/8, 3/8, 3/8, 1/8];
         tbl.b_e = [];
         tbl.c   = [0, 1/3, 2/3, 1]';
         this@Indigo.RungeKutta.Explicit('RK38', 4, tbl);
       end
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     end
   end
