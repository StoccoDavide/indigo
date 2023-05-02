
.. _program_listing_file_indigo_RungeKutta_ExplicitMethods_Generic3.m:

Program Listing for File Generic3.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_RungeKutta_ExplicitMethods_Generic3.m>` (``indigo/RungeKutta/ExplicitMethods/Generic3.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Generic method.
   %
   classdef Generic3 < ExplicitRungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Generic method (\f$ \alpha \neq 0, 2/3, 1 \f$).
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|ccc}
       %>     0      & 0      & 0  & 0 \\
       %>     \alpha & \alpha & 0  & 0 \\
       %>     1      & 1+\frac{1-\alpha}{\alpha(3\alpha-2)}
       %>                     & -\frac{1-\alpha}{\alpha(3\alpha-2)}
       %>                          & 0 \\
       %>     \hline
       %>      & \frac{1}{2}-\frac{1}{6\alpha}
       %>      & \frac{1}{6\alpha(1-\alpha)}
       %>      & \frac{2-3\alpha}{6(1-\alpha)} \\
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = Generic3( alpha )
         tbl.A   = [0,     0, 0; ...
                    alpha, 0, 0; ...
                    1+(1-alpha)/(alpha*(3*alpha-2)), -(1-alpha)/(alpha*(3*alpha-2)), 0];
         tbl.b   = [0, alpha, 1];
         tbl.b_e = [];
         tbl.c   = [1/2-1/(6*alpha), 1/(6*alpha(1-alpha)), (2-3*alpha)/(6*(1-alpha))]';
         this@ExplicitRungeKutta('Generic3', 3, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
