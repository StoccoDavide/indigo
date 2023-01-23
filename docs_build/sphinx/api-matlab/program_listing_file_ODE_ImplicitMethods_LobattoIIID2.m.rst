
.. _program_listing_file_ODE_ImplicitMethods_LobattoIIID2.m:

Program Listing for File LobattoIIID2.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ImplicitMethods_LobattoIIID2.m>` (``ODE/ImplicitMethods/LobattoIIID2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIID second-order method (2 stages)
   %
   classdef LobattoIIID2 < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Lobatto IIID second-order method (2 stages)
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     0 &  1/2 & 1/2 \\
       %>     1 & -1/2 & 1/2 \\
       %>     \hline
       %>       &  1/2 & 1/2
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIID2( ~ )
         this@RKimplicit( ...
           'LobattoIIID2', ...
           [1/2, 1/2; -1/2, 1/2], ...
           [1/2, 1/2], ...
           [0, 1]' ...
         );
       end
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     end
   end
