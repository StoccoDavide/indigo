
.. _program_listing_file_+Indigo_+RungeKutta_+Methods_+Implicit_GaussLegendre4.m:

Program Listing for File GaussLegendre4.m
=========================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+RungeKutta_+Methods_+Implicit_GaussLegendre4.m>` (``+Indigo/+RungeKutta/+Methods/+Implicit/GaussLegendre4.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Gauss-Legendre method.
   %
   classdef GaussLegendre4 < Indigo.RungeKutta.Implicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Gauss-Legendre method.
       %>
       %> \f[
       %> \begin{array}{c|cc}
       %>   1/2-t &   1/4 & 1/4-t \\
       %>   1/2+t & 1/4+t &   1/4 \\
       %>   \hline
       %>         &   1/2 &   1/2
       %> \end{array}
       %> \qquad t = \dfrac{\sqrt{3}}{6}
       %> \f[
       %
       function this = GaussLegendre4()
         t = sqrt(3)/6;
         tbl.A   = [1/4, 1/4-t; 1/4+t, 1/4];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [];
         tbl.c   = [1/2-t, 1/2+t]';
         this@Indigo.RungeKutta.Implicit('GaussLegendre4', 4, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
