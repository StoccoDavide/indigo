
.. _program_listing_file_indigo_RungeKutta_ImplicitMethods_RadauIIA5.m:

Program Listing for File RadauIIA5.m
====================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ImplicitMethods_RadauIIA5.m>` (``indigo/RungeKutta/ImplicitMethods/RadauIIA5.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Radau IIA method.
   %
   classdef RadauIIA5 < ImplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Radau IIA method.
       %>
       %> \rst
       %> .. math::
       %>
       %>  \begin{array}{c|ccc}
       %>    \frac{2}{5} - \frac{\sqrt{6}}{10} &
       %>    \frac{11}{45} - \frac{7 \sqrt{6}}{360} &
       %>    \frac{37}{225} - \frac{169 \sqrt{6}}{1800}  &
       %>    -\frac{2}{225} + \frac{\sqrt{6}}{75}  \\
       %>    \frac{2}{5} + \frac{\sqrt{6}}{10} &
       %>    \frac{37}{225} + \frac{169 \sqrt{6}}{1800} &
       %>    \frac{11}{45} + \frac{7 \sqrt{6}}{360} &
       %>    -\frac{2}{225} - \frac{\sqrt{6}}{75} \\
       %>    1 &
       %>    \frac{4}{9} - \frac{\sqrt{6}}{36} &
       %>    \frac{4}{9} + \frac{\sqrt{6}}{36} &
       %>    \frac{1}{9} \\
       %>    \hline
       %>      & \frac{4}{9} - \frac{\sqrt{6}}{36} &
       %>        \frac{4}{9} + \frac{\sqrt{6}}{36} &
       %>        \frac{1}{9} \\
       %>  \end{array}
       %>
       %> \endrst
       %
       function this = RadauIIA5()
         tbl.A   = [11/45-7*sqrt(6)/360,     37/225-169*sqrt(6)/1800, -2/225+sqrt(6)/75; ...
                    37/225+169*sqrt(6)/1800, 11/45+7*sqrt(6)/360,     -2/225-sqrt(6)/75; ...
                    4/9-sqrt(6)/36,          4/9+sqrt(6)/36,          1/9];
         tbl.b   = [4/9-sqrt(6)/36, 4/9+sqrt(6)/36, 1/9];
         tbl.b_e = [];
         tbl.c   = [2/5-sqrt(6)/10, 2/5+sqrt(6)/10, 1]';
         this@ImplicitRungeKutta('RadauIIA5', 5, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
