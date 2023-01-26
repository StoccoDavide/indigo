
.. _program_listing_file_ODE_ExplicitMethods_ExplicitEuler.m:

Program Listing for File ExplicitEuler.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ExplicitMethods_ExplicitEuler.m>` (``ODE/ExplicitMethods/ExplicitEuler.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Explicit Euler first-order method (1 stage)
   %
   classdef ExplicitEuler < RKexplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Explicit Euler first-order method (1 stage)
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|c}
       %>     0 & 0 \\
       %>     \hline
       %>       & 1
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = ExplicitEuler()
         this@RKexplicit( ...
           'ExplicitEuler', ...
           [0], ...
           [1], ...
           [0]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
