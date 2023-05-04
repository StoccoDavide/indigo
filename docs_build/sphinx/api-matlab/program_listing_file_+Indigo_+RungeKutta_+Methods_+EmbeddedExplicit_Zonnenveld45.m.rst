
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+EmbeddedExplicit_Zonnenveld45.m:

Program Listing for File Zonnenveld45.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+EmbeddedExplicit_Zonnenveld45.m>` (``+Indigo/+RungeKutta/+Methods/+EmbeddedExplicit/Zonnenveld45.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Zonneveld's 4(5) method.
   %
   classdef Zonnenveld45 < Indigo.RungeKutta.Explicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Zonneveld's 4(5) method.
       %>
       %> \f[
       %> \begin{array}{c|ccccc}
       %>     0 &    0 &    0 &     0 &     0 & 0 \\
       %>   1/2 &  1/2 &    0 &     0 &     0 & 0 \\
       %>   1/2 &    0 &  1/2 &     0 &     0 & 0 \\
       %>     1 &    0 &    0 &     1 &     0 & 0 \\
       %>   3/4 & 5/32 & 7/32 & 13/32 & -1/32 & 0 \\
       %>   \hline
       %>      &  1/6 & 1/3 & 1/3 &  1/6 &     0 \\
       %>      & -1/2 & 7/3 & 7/3 & 13/6 & -16/3 \\
       %> \end{array}
       %> \f[
       %
       function this = Zonnenveld45()
         tbl.A   = [0,    0,    0,     0,     0; ...
                    1/2,  0,    0,     0,     0; ...
                    0,    1/2,  0,     0,     0; ...
                    0,    0,    1,     0,     0; ...
                    5/32, 7/32, 13/32, -1/32, 0 ];
         tbl.b   = [1/6, 1/3, 1/3, 1/6, 0];
         tbl.b_e = [-1/2, 7/3, 7/3, 13/6, -16/3];
         tbl.c   = [0, 1/2, 1/2, 1, 3/4]';
         this@Indigo.RungeKutta.Explicit('Zonneveld34', 4, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
