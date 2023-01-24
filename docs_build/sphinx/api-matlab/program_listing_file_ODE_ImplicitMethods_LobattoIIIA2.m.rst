
.. _program_listing_file_ODE_ImplicitMethods_LobattoIIIA2.m:

Program Listing for File LobattoIIIA2.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ImplicitMethods_LobattoIIIA2.m>` (``ODE/ImplicitMethods/LobattoIIIA2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIA second-order method (2 stages)
   %
   classdef LobattoIIIA2 < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIIA second-order method (2 stages)
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     0 &   0 &   0 \\
       %>     1 & 1/2 & 1/2 \\
       %>     \hline
       %>       & 1/2 & 1/2
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIIA2()
         this@RKimplicit( ...
           'LobattoIIIA2', ...
           [0, 0; 1/2, 1/2], ...
           [1/2, 1/2], ...
           [0, 1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
