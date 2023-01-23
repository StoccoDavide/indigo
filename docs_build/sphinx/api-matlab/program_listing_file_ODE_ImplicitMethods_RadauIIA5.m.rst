
.. _program_listing_file_ODE_ImplicitMethods_RadauIIA5.m:

Program Listing for File RadauIIA5.m
====================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ImplicitMethods_RadauIIA5.m>` (``ODE/ImplicitMethods/RadauIIA5.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Radau IIA fifth-order method (3 stages)
   %
   classdef RadauIIA5 < RKimplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Radau IIA fifth-order method (3 stages)
       %>
       %> \rst
       %> .. math::
       %>
       %>  \begin{array}{c|ccc}
       %>    0 & \frac{1}{9} & \frac{-1 - \sqrt{6}}{18} & \frac{-1 + \sqrt{6}}{18} \\
       %>    \frac{3}{5} - \frac{\sqrt{6}}{10} & \frac{1}{9} & \frac{11}{45} + \frac{7\sqrt{6}}{360} & \frac{11}{45} - \frac{43\sqrt{6}}{360} \\
       %>    \frac{3}{5} + \frac{\sqrt{6}}{10} & \frac{1}{9} & \frac{11}{45} + \frac{43\sqrt{6}}{360} & \frac{11}{45} - \frac{7\sqrt{6}}{360} \\
       %>    \hline
       %>      & \frac{1}{9} & \frac{4}{9} + \frac{\sqrt{6}}{36} & \frac{4}{9} - \frac{\sqrt{6}}{36} \\
       %>  \end{array}
       %>
       %> \endrst
       %
       function this = RadauIIA5( ~ )
         this@RKimplicit( ...
           'RadauIIA5', ...
           [11/45-7*sqrt(6)/360,    37/225-169*sqrt(6)/1800, -2/225+sqrt(6)/75; ...
            37/45+169*sqrt(6)/1800, 11/45+7*sqrt(6)/360,     -2/225-sqrt(6)/75; ...
            4/9-sqrt(6)/36,         4/9+sqrt(6)/36,          1/9 ], ...
           [4/9-sqrt(6)/36, 4/9+sqrt(6)/36, 1/9], ...
           [2/5-sqrt(6)/10, 2/5+sqrt(6)/10, 1]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
