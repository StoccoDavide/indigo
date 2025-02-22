
.. _program_listing_file_+Indigo_+Tableau_SunGeng5.m:

Program Listing for File SunGeng5.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_SunGeng5.m>` (``+Indigo/+Tableau/SunGeng5.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Sun Geng's method.
   %
   classdef SunGeng5 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Sun Geng's method.
       %>
       %> \f[
       %> \begin{array}{c|ccc}
       %>   \frac{4 - \sqrt{6}}{10} &
       %>   \frac{16 - \sqrt{6}}{72} &
       %>   \frac{328 - 169 \sqrt{6}}{1800} &
       %>   \frac{-2 + 3 \sqrt{6}}{450} \\
       %>   \frac{4 + \sqrt{6}}{10} &
       %>   \frac{328 + 167 \sqrt{6}}{1800} &
       %>   \frac{16 + \sqrt{6}}{72} &
       %>   \frac{-2 + 3 \sqrt{6}}{450} \\
       %>   1 &
       %>   \frac{85 - 10 \sqrt{6}}{180} &
       %>   \frac{85 + 10 \sqrt{6}}{180} &
       %>   \frac{1}{18} \\
       %>   \hline
       %>     & \frac{16-\sqrt{6}}{36} &
       %>       \frac{16+\sqrt{6}}{36} &
       %>       \frac{1}{9} \\
       %> \end{array}
       %> \f]
       %
       function this = SunGeng5()
         s6 = sqrt(6);
         tbl.A   = [(16-s6)/72,        (328-167*s6)/1800, (-2+3*s6)/450; ...
                    (328+167*s6)/1800, (16+s6)/72,        (-2-3*s6)/450; ...
                    (85-10*s6)/180,    (85+10*s6)/180,    1/18];
         tbl.b   = [(16-s6)/36, (16+s6)/36, 1/9];
         tbl.b_e = [];
         tbl.c   = [(4-s6)/10, (4+s6)/10, 1]';
         this@Indigo.RungeKutta('SunGeng5', 5, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
