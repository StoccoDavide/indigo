
.. _program_listing_file_ODE_ExplicitMethods_Collatz.m:

Program Listing for File Collatz.m
==================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ExplicitMethods_Collatz.m>` (``ODE/ExplicitMethods/Collatz.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Collatz's second-order method.
   %
   classdef Collatz < RKexplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Collatz's second-order method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>       0 &   0 & 0 \\
       %>     1/2 & 1/2 & 0 \\
       %>     \hline
       %>         &   0 & 1
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = Collatz()
           this@RKexplicit( ...
           'Collatz', ...
           [0, 0; 1/2, 0], ...
           [0, 1], ...
           [0, 1/2]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
