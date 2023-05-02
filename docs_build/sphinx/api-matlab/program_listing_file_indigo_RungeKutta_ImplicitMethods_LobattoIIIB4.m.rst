
.. _program_listing_file_indigo_RungeKutta_ImplicitMethods_LobattoIIIB4.m:

Program Listing for File LobattoIIIB4.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ImplicitMethods_LobattoIIIB4.m>` (``indigo/RungeKutta/ImplicitMethods/LobattoIIIB4.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIB method.
   %
   classdef LobattoIIIB4 < ImplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIB method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccc}
       %>       0 & 1/6 & -1/6 &   0 \\
       %>     1/2 & 1/6 &  1/3 &   0 \\
       %>       1 & 1/6 &  5/6 &   0 \\
       %>     \hline
       %>         & 1/6 &  2/3 & 1/6
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIIB4()
         tbl.A   = [1/6, -1/6, 0; ...
                    1/6,  1/3, 0; ...
                    1/6,  5/6, 0];
         tbl.b   = [1/6, 2/3, 1/6];
         tbl.b_e = [];
         tbl.c   = [0, 1/2, 1]';
         this@ImplicitRungeKutta('LobattoIIIB4', 4, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
