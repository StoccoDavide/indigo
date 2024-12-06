
.. _program_listing_file_+Indigo_+Tableau_RadauIIA5.m:

Program Listing for File RadauIIA5.m
====================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_RadauIIA5.m>` (``+Indigo/+Tableau/RadauIIA5.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Radau IIA5 method.
   %
   classdef RadauIIA5 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Radau IIA5 method.
       %>
       % https://www.math.auckland.ac.nz/~butcher/ODE-book-2008/Tutorials/IRK.pdf
       %>
       %> \f[
       %> \begin{array}{c|ccc}
       %>   \frac{2}{5} - \frac{\sqrt{6}}{10} &
       %>   \frac{11}{45} - \frac{7 \sqrt{6}}{360} &
       %>   \frac{37}{225} - \frac{169 \sqrt{6}}{1800}  &
       %>   -\frac{2}{225} + \frac{\sqrt{6}}{75}  \\
       %>   \frac{2}{5} + \frac{\sqrt{6}}{10} &
       %>   \frac{37}{225} + \frac{169 \sqrt{6}}{1800} &
       %>   \frac{11}{45} + \frac{7 \sqrt{6}}{360} &
       %>   -\frac{2}{225} - \frac{\sqrt{6}}{75} \\
       %>   1 &
       %>   \frac{4}{9} - \frac{\sqrt{6}}{36} &
       %>   \frac{4}{9} + \frac{\sqrt{6}}{36} &
       %>   \frac{1}{9} \\
       %>   \hline
       %>     & \frac{4}{9} - \frac{\sqrt{6}}{36} &
       %>       \frac{4}{9} + \frac{\sqrt{6}}{36} &
       %>       \frac{1}{9} \\
       %> \end{array}
       %> \f]
       %
       function this = RadauIIA5()
         s6 = sqrt(6);
         tbl.A   = [11/45-7*s6/360,     37/225-169*s6/1800, -2/225+s6/75; ...
                    37/225+169*s6/1800, 11/45+7*s6/360,     -2/225-s6/75; ...
                    4/9-s6/36,          4/9+s6/36,          1/9];
         tbl.b   = [4/9-s6/36, 4/9+s6/36, 1/9];
         tbl.b_e = [];
         tbl.c   = [2/5-sqrt(6)/10, 2/5+sqrt(6)/10, 1]';
         this@Indigo.RungeKutta('RadauIIA5', 5, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
