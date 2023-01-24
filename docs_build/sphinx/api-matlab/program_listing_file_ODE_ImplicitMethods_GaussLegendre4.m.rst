
.. _program_listing_file_ODE_ImplicitMethods_GaussLegendre4.m:

Program Listing for File GaussLegendre4.m
=========================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ImplicitMethods_GaussLegendre4.m>` (``ODE/ImplicitMethods/GaussLegendre4.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Gauss–Legendre fouth-order (2 stages)
   %
   classdef GaussLegendre4 < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Gauss–Legendre fourth-order (2 stages)
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>     1/2-t &   1/4 & 1/4-t \\
       %>     1/2+t & 1/4+t &   1/4 \\
       %>     \hline
       %>           &   1/2 &   1/2
       %>   \end{array}
       %>   \qquad t = \dfrac{\sqrt{3}}{6}
       %>
       %> \endrst
       %
       function this = GaussLegendre4()
         t = sqrt(3)/6;
         this@RKimplicit( ...
           'GaussLegendre4', ...
           [1/4, 1/4-t; 1/4+t, 1/4], ...
           [1/2, 1/2], ...
           [1/2-t, 1/2+t]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
