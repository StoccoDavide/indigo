
.. _program_listing_file_indigo_RungeKutta_EmbeddedExplicitMethods_BogackiShampine23.m:

Program Listing for File BogackiShampine23.m
============================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_EmbeddedExplicitMethods_BogackiShampine23.m>` (``indigo/RungeKutta/EmbeddedExplicitMethods/BogackiShampine23.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Bogacki-Shampine 2(3) method.
   %
   classdef BogackiShampine23 < ExplicitRungeKutta
     %
     methods
     %
     % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     %
     %> Bogacki-Shampine 2(3) method.
     %>
     %> \rst
     %> .. math::
     %>
     %>   \begin{array}{c|ccc}
     %>       0 &   0 &   0 &   0 \\
     %>     1/2 & 1/2 &   0 &   0 \\
     %>     3/4 &   0 & 3/4 &   0 \\
     %>       1 & 2/9 & 1/3 & 4/9 \\
     %>     \hline
     %>         &  2/9 & 1/3 & 4/9 \\
     %>         & 7/24 & 1/4 & 1/3 \\
     %>   \end{array}
     %>
     %> \endrst
     %
     function this = BogackiShampine23()
       tbl.A   = [0,   0,   0,   0; ...
                  1/2, 0,   0,   0; ...
                  0,   3/4, 0,   0; ...
                  2/9, 1/3, 4/9, 0];
       tbl.b   = [7/24, 1/4, 1/3, 1/8];
       tbl.b_e = [2/9, 1/3, 4/9, 0];
       tbl.c   = [0, 1/2, 3/4, 1]';
       this@ExplicitRungeKutta('BogackiShampine23', 3, tbl);
     end
     %
     % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     %
     end
     %
   end
