
.. _program_listing_file_ODE_ImplicitMethods_LobattoIIIC4.m:

Program Listing for File LobattoIIIC4.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ImplicitMethods_LobattoIIIC4.m>` (``ODE/ImplicitMethods/LobattoIIIC4.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIC fourth-order method (3 stages)
   %
   classdef LobattoIIIC4 < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIC fourth-order method (3 stages)
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccc}
       %>       0 & 1/6 & -1/3 & 1/6  \\
       %>     1/2 & 1/6 & 5/12 & -1/12 \\
       %>       1 & 1/6 & 2/3  &  1/6  \\
       %>     \hline
       %>         & 1/6 & 2/3 & 1/6
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIIC4()
         this@RKimplicit( ...
           'LobattoIIIC4', ...
           [1/6, -1/3, 1/6; 1/6, 5/12, -1/12; 1/6, 2/3, 1/6], ...
           [1/6, 2/3, 1/6], ...
           [0, 1/2, 1]' ...
         );
       end
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     end
   end
