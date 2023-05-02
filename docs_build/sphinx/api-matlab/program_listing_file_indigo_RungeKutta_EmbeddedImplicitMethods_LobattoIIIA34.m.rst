
.. _program_listing_file_indigo_RungeKutta_EmbeddedImplicitMethods_LobattoIIIA34.m:

Program Listing for File LobattoIIIA34.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_EmbeddedImplicitMethods_LobattoIIIA34.m>` (``indigo/RungeKutta/EmbeddedImplicitMethods/LobattoIIIA34.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   ...
    %
   %> Class container for Lobatto IIIA 3(4) method.
   %
   classdef LobattoIIIA34 < ImplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIA 3(4) method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccc}
       %>       0 &    0 &   0 &     0 \\
       %>     1/2 & 5/24 & 1/3 & -1/24 \\
       %>       1 &  1/6 & 2/3 &   1/6 \\
       %>     \hline
       %>         &  1/6 & 2/3 &   1/6 \\
       %>         & -1/2 & 2   &  -1/2 \\
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIIA34()
         tbl.A   = [0,    0,   0; ...
                    5/24, 1/3, -1/24; ...
                    1/6,  2/3, 1/6];
         tbl.b   = [1/6, 2/3, 1/6];
         tbl.b_e = [-1/2, 2, -1/2];
         tbl.c   = [0, 1/2, 1]';
         this@ImplicitRungeKutta('LobattoIIIA34', 4, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
