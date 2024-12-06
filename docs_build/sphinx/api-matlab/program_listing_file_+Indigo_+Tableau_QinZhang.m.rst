
.. _program_listing_file_+Indigo_+Tableau_QinZhang.m:

Program Listing for File QinZhang.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Tableau_QinZhang.m>` (``+Indigo/+Tableau/QinZhang.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Merson's 4(5) method.
   %
   classdef QinZhang < Indigo.RungeKutta
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Qin and Zhang's two-stage, 2nd order, symplectic Diagonally Implicit Runge-Kutta method:.
       %>
       %> \f[
       %> \begin{array}{c|cc}
       %>   1/4 & 1/4 &     \\
       %>   3/4 & 1/2 & 1/4 \\
       %>   \hline
       %>      &  1/2 & 1/2 \\
       %> \end{array}
       %> \f]
       %
       %
       function this = QinZhang()
         gamma = 1-1/sqrt(2);
         %tbl.A   = [1/2,  0,   0; ...
         %           -1/2, 1/2, 0; ...
         %           0,    1/2, 1/2];
         %tbl.b   = [0,    1/2, 1/2];
         lambda = 0.4358665215084589994160194511935568425292;
         b1     = (lambda*(16-6*lambda)-1)/4;
         b2     = (5+lambda*(6*lambda-20))/4;
         tbl.A   = [lambda,       0,      0; ...
                    (1-lambda)/2, lambda, 0; ...
                    b1,           b2,     lambda];
         tbl.b   = [b1, b2, lambda];
         tbl.b_e = [];
         tbl.c   = tbl.A*ones(3,1);
         this@Indigo.RungeKutta('QinZhang', 3, tbl);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
