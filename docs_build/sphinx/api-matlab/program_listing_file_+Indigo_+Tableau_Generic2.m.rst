
.. _program_listing_file_+Indigo_+Tableau_Generic2.m:

Program Listing for File Generic2.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_Generic2.m>` (``+Indigo/+Tableau/Generic2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Generic method.
   %
   classdef Generic2 < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Generic method.
       %>
       %> \f[
       %> \begin{array}{c|cc}
       %>        0 &      0 &    0 \\
       %>   \alpha & \alpha &    0 \\
       %>   \hline
       %>        & 1-\frac{1}{2\alpha}
       %>        & \frac{1}{2\alpha}
       %> \end{array}
       %> \f]
       %
       function this = Generic2( varargin )
         if nargin > 0
           alpha = varargin{1};
         else
           alpha = 1;
         end
         tbl.A   = [0, 0; alpha, 0];
         tbl.b   = [1-alpha/2, alpha/2];
         tbl.b_e = [];
         tbl.c   = [0, alpha].';
         this@Indigo.RungeKutta('Generic2', 2, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
