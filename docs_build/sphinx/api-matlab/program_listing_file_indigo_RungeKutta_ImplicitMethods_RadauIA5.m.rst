
.. _program_listing_file_indigo_RungeKutta_ImplicitMethods_RadauIA5.m:

Program Listing for File RadauIA5.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ImplicitMethods_RadauIA5.m>` (``indigo/RungeKutta/ImplicitMethods/RadauIA5.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Radau IA method.
   %
   classdef RadauIA5 < ImplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Radau IA method.
       %>
       %> \rst
       %> .. math::
       %>
       %>  \begin{array}{c|ccc}
       %>    0 & \frac{1}{9} &
       %>    \frac{-1 - \sqrt{6}}{18} &
       %>    \frac{-1 + \sqrt{6}}{18} \\
       %>    \frac{3}{5} - \frac{\sqrt{6}}{10} & \frac{1}{9} &
       %>    \frac{11}{45} + \frac{7\sqrt{6}}{360} &
       %>    \frac{11}{45} - \frac{43\sqrt{6}}{360} \\
       %>    \frac{3}{5} + \frac{\sqrt{6}}{10} & \frac{1}{9} &
       %>    \frac{11}{45} + \frac{43\sqrt{6}}{360} &
       %>    \frac{11}{45} - \frac{7\sqrt{6}}{360} \\
       %>    \hline
       %>      & \frac{1}{9} &
       %>        \frac{4}{9} + \frac{\sqrt{6}}{36} &
       %>        \frac{4}{9} - \frac{\sqrt{6}}{36} \\
       %>  \end{array}
       %>
       %> \endrst
       %
       function this = RadauIA5()
         tbl.A   = [1/9,  (-1-sqrt(6))/18,       (-1+sqrt(6))/18; ...
                    1/9,  11/45+7*sqrt(6)/360,   11/45-43*sqrt(6)/360; ...
                    1/9,  11/45+43*sqrt(6)/360,  11/45-7*sqrt(6)/360 ];
         tbl.b   = [1/9, 4/9+sqrt(6)/36, 4/9-sqrt(6)/36] ;
         tbl.b_e = [];
         tbl.c   = [0,   3/5-sqrt(6)/10, 3/5+sqrt(6)/10]';
         this@ImplicitRungeKutta('RadauIA5', 5, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
