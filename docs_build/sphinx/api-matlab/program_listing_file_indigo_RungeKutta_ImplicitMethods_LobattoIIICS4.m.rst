
.. _program_listing_file_indigo_RungeKutta_ImplicitMethods_LobattoIIICS4.m:

Program Listing for File LobattoIIICS4.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ImplicitMethods_LobattoIIICS4.m>` (``indigo/RungeKutta/ImplicitMethods/LobattoIIICS4.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIC$^\star$ method.
   %
   classdef LobattoIIICS4 < ImplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIC$^\star$ method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccc}
       %>       0 &   0 &   0 &   0 \\
       %>     1/2 & 1/4 & 1/4 &   0 \\
       %>       1 &   0 &   1 &   0 \\
       %>     \hline
       %>         & 1/6 & 2/3 & 1/6
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIICS4()
         tbl.A   = [0,   0,   0; ...
                    1/4, 1/4, 0; ...
                    0,   1,   0];
         tbl.b   = [1/6, 2/3, 1/6];
         tbl.b_e = [];
         tbl.c   = [0, 1/2, 1]';
         this@ImplicitRungeKutta('LobattoIIICS4', 4, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
