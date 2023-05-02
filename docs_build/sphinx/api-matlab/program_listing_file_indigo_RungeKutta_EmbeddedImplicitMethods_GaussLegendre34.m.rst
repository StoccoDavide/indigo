
.. _program_listing_file_indigo_RungeKutta_EmbeddedImplicitMethods_GaussLegendre34.m:

Program Listing for File GaussLegendre34.m
==========================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_EmbeddedImplicitMethods_GaussLegendre34.m>` (``indigo/RungeKutta/EmbeddedImplicitMethods/GaussLegendre34.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Gauss-Legendre 3(4) method.
   %
   classdef GaussLegendre34 < ImplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Gauss-Legendre 3(4) method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     1/2-t &   1/4 & 1/4-t \\
       %>     1/2+t & 1/4+t &   1/4 \\
       %>     \hline
       %>           &   1/2       &   1/2 \\
       %>           &   1/2 + 3 t &   1/2 - 3 t
       %>   \end{array}
       %>   \qquad t = \dfrac{\sqrt{3}}{6}
       %>
       %> \endrst
       %
       function this = GaussLegendre34()
         t       = sqrt(3)/6;
         tbl.A   = [1/4, 1/4-t; 1/4+t, 1/4];
         tbl.b   = [1/2, 1/2];
         tbl.b_e = [1/2 + 3*t, 1/2 - 3*t];
         tbl.c   = [1/2-t, 1/2+t]';
         this@ImplicitRungeKutta('GaussLegendre34', 4, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
