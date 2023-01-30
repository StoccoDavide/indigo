
.. _program_listing_file_ODE_ImplicitMethods_LobattoIIIC2.m:

Program Listing for File LobattoIIIC2.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ImplicitMethods_LobattoIIIC2.m>` (``ODE/ImplicitMethods/LobattoIIIC2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIC second-order method (2 stages)
   %
   classdef LobattoIIIC2 < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIC second-order method (2 stages)
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     0 & 1/2 & -1/2 \\
       %>     1 & 1/2 &  1/2 \\
       %>     \hline
       %>       & 1/2 &  1/2
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIIC2()
         this@RKimplicit( ...
           'LobattoIIIC2', ...
           [1/2, -1/2; 1/2, 1/2], ...
           [1/2, 1/2], ...
           [0, 1]' ...
         );
       end
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     end
   end
