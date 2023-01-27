
.. _program_listing_file_ODE_ImplicitMethods_ImplicitEuler.m:

Program Listing for File ImplicitEuler.m
========================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ImplicitMethods_ImplicitEuler.m>` (``ODE/ImplicitMethods/ImplicitEuler.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Implicit Euler first-order method (1 stage)
   %
   classdef ImplicitEuler < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Implicit Euler first-order method (1 stage)
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|c}
       %>     1 & 1 \\
       %>     \hline
       %>       & 1
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = ImplicitEuler()
         this@RKimplicit( ...
           'ImplicitEuler', ...
           [1], ...
           [1], ...
           [1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
