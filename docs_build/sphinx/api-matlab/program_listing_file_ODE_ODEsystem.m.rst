
.. _program_listing_file_ODE_ODEsystem.m:

Program Listing for File ODEsystem.m
====================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ODEsystem.m>` (``ODE/ODEsystem.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for a system of Ordinary Differential Equations (ODEs).
   %
   classdef ODEsystem < Base
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Class constructor
       %>
       %> - *name* Name of the system of ODEs/DAEs;
       %> - *neqn* Number of equations of the system of ODEs/DAEs;
       %> - *ninv* Number of invariants/contraints of the system of ODEs/DAEs [optional, default = 0].
       %
       function this = ODEsystem( name, neqn, ninv )
         this@Base( name, neqn, ninv );
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
     methods (Abstract)
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> (Abstract) Definition of the system of ODEs:
       %>
       %> \f[ \mathbf{x}' = \mathbf{f}( t, \mathbf{x} ) \quad\oplus\quad [\textrm{invariants}] \f]
       %>
       %> invariants are of the form:
       %>
       %> \f[ \mathbf{h}( t, \mathbf{x} ) = \mathbf{0} \f]
       %>
       %> The derived function must define the r.h.s. of the ODE
       %> \f$ \mathbf{f}( t, \mathbf{x} ) \f$ where
       %> \f$ \mathbf{x} \f$ are the states of the model described by the ODE.
       %
       f( this, t, x )
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> (Abstract) Evaluate the jacobian of the r.h.s. of the system of ODEs:
       %>
       %> \f[ \partial \mathbf{f}( t, \mathbf{x} ) / \partial \mathbf{x} \f]
       %>
       %> Used only in implicit Runge-Kutta methods
       %
       DfDx( this, t, x )
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> (Abstract) Evaluate the invariants/hidden constraints of the system of ODEs:
       %>
       %> \f[ \mathbf{h}( t, \mathbf{x} ) = \mathbf{0} \f]
       %
       h( this, t, x )
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> (Abstract) Evaluate the Jacobian of the hidden constraints of the system of ODEs:
       %>
       %> \f[ \partial \mathbf{h}( t, \mathbf{x} ) / \partial \mathbf{x} \f]
       %>
       %> Used only in projection method
       %
       DhDx( this, t, x )
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
