
.. _program_listing_file_ODE_EmbeddedMethods_LobattoIIIC34.m:

Program Listing for File LobattoIIIC34.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_EmbeddedMethods_LobattoIIIC34.m>` (``ODE/EmbeddedMethods/LobattoIIIC34.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIC 3(4) method.
   %
   classdef LobattoIIIC34 < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIC 3(4) method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccc}
       %>       0 & 1/6 & -1/3 & 1/6  \\
       %>     1/2 & 1/6 & 5/12 & -1/12 \\
       %>       1 & 1/6 & 2/3  &  1/6  \\
       %>     \hline
       %>         & 1/6  & 2/3 & 1/6 \\
       %>         & -1/2 & 2   & -1/2
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIIC34()
         this@RKimplicit( ...
           'LobattoIIIC34', ...
           [1/6, -1/3, 1/6; ...
            1/6, 5/12, -1/12; ...
            1/6, 2/3,  1/6], ...
           [1/6, 2/3, 1/6], ...
           [-1/2, 2, 1/2], ...
           [0, 1/2, 1]' ...
         );
       end
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     end
   end
