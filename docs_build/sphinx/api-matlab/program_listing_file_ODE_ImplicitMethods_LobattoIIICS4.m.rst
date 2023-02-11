
.. _program_listing_file_ODE_ImplicitMethods_LobattoIIICS4.m:

Program Listing for File LobattoIIICS4.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ImplicitMethods_LobattoIIICS4.m>` (``ODE/ImplicitMethods/LobattoIIICS4.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Lobatto IIIC$^\star$ method.
   %
   classdef LobattoIIICS4 < RKimplicit
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
         this@RKimplicit( ...
           'LobattoIIICS4', ...
           [0, 0, 0; 1/4, 1/4, 0; 0, 1, 0], ...
           [1/6, 2/3, 1/6], ...
           [0, 1/2, 1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
