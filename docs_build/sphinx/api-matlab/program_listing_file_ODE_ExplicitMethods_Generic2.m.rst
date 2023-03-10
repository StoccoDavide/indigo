
.. _program_listing_file_ODE_ExplicitMethods_Generic2.m:

Program Listing for File Generic2.m
===================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ExplicitMethods_Generic2.m>` (``ODE/ExplicitMethods/Generic2.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for Generic method.
   %
   classdef Generic2 < RKexplicit
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Generic method.
       %>
       %> \rst
       %> .. math::
       %>
       %>   \begin{array}{c|cc}
       %>          0 &      0 &    0 \\
       %>     \alpha & \alpha &    0 \\
       %>     \hline
       %>          & 1-\frac{1}{2\alpha}
       %>          & \frac{1}{2\alpha}
       %>   \end{array}
       %>
       %> \endrst
       %
       function this = Generic2( alpha )
   
         this@RKexplicit( ...
           'Generic2', ...
           [0,     0; ...
            alpha, 0], ...
           [0, alpha], ...
           [1-alpha/2, alpha/2]' ...
         );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
