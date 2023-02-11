
.. _program_listing_file_ODE_ImplicitMethods_LobattoIIIB2.m:

Program Listing for File LobattoIIIB2.m
=======================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ImplicitMethods_LobattoIIIB2.m>` (``ODE/ImplicitMethods/LobattoIIIB2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIB method.
   %
   classdef LobattoIIIB2 < RKimplicit
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
       %>   \begin{array}{c|cc}
       %>     0 & 1/2 &   0 \\
       %>     1 & 1/2 &   0 \\
       %>     \hline
       %>       & 1/2 & 1/2
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = LobattoIIIB2()
         this@RKimplicit( ...
           'LobattoIIIB2', ...
           [1/2, 0; 1/2, 0], ...
           [1/2, 1/2], ...
           [0, 1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
