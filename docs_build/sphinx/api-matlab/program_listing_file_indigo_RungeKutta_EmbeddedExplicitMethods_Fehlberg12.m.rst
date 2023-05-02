
.. _program_listing_file_indigo_RungeKutta_EmbeddedExplicitMethods_Fehlberg12.m:

Program Listing for File Fehlberg12.m
=====================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_EmbeddedExplicitMethods_Fehlberg12.m>` (``indigo/RungeKutta/EmbeddedExplicitMethods/Fehlberg12.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Fehlberg 1(2) method.
   %
   classdef Fehlberg12 < ExplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Fehlberg 1(2) method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccc}
       %>       0 & 0     &       0 & 0 \\
       %>     1/2 & 1/2   &       0 & 0 \\
       %>       1 & 1/256 & 255/256 & 0 \\
       %>     \hline
       %>       & 1/512 & 255/256 & 1/512 \\
       %>       & 1/256 & 255/256 & 0     \\
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = Fehlberg12()
         tbl.A  = [0,     0,       0; ...
                   1/2,   0,       0; ...
                   1/256, 255/256, 0];
        tbl.b   = [1/512, 255/256, 1/512];
        tbl.b_e = [1/256, 255/256, 0];
        tbl.c   = [0, 1/2, 1]';
        this@ExplicitRungeKutta('Fehlberg12', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
