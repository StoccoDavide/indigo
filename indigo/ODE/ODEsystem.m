%
%> Class container for a system of Ordinary Differential Equations (ODEs).
%
classdef ODEsystem < Base
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor for a system of ODEs that requires the following\n
    %> inputs:
    %>
    %> - *name* Name of the system of ODEs/DAEs;
    %> - *neqn* Number of equations of the system of ODEs/DAEs;
    %> - *ninv* Number of invariants/contraints of the system of ODEs/DAEs\n
    %>   [optional, default = 0].
    %
    function this = ODEsystem( name, neqn, ninv )
      this@Base( name, neqn, ninv );
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
  methods (Abstract)
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Definition of the system of ODEs:
    %>
    %> \f[
    %> \mathbf{F}( \mathbf{x}, \mathbf{x}', t ) = \mathbf{0}
    %> \f]
    %>
    %> with optional invariants of the form:
    %>
    %> \f[
    %> \mathbf{H}( \mathbf{x}, t ) = \mathbf{0}
    %> \f]
    %>
    %> The derived function must define an implicit system of ODEs of the form
    %> \f$ \mathbf{F}( \mathbf{x}, \mathbf{x}', t ) = \mathbf{0} \f$ where
    %> \f$ \mathbf{x} \f$ are the unknown functions of the independent variable
    %> \f$ \mathbf{t} \f$.
    %
    F( this, x, x_dot, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the of the system of ODEs:
    %>
    %> \f[
    %> \dfrac{
    %> \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', t )
    %> }{
    %> \hat{\mathbf{x}}
    %> }
    %> \f]
    %>
    %> where \f$ \hat{\mathbf{x}} = \left[ \mathbf{x}, \mathbf{x}' \right]^T \f$
    %> is the concatenation of the unknown functions and their derivatives.
    %
    JF( this, x, x_dot, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the invariants of the system of ODEs:
    %>
    %> \f[
    %> \mathbf{H}( t, \mathbf{x} ) = \mathbf{0}.
    %> \f]
    %
    H( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the invariants of the system of ODEs:
    %>
    %> \f[
    %> \partial \mathbf{H}( t, \mathbf{x} ) / \partial \hat{\mathbf{x}}
    %> \f]
    %>
    %> where \f$ \hat{\mathbf{x}} = \left[ \mathbf{x}, \mathbf{x}' \right]^T \f$
    %> is the concatenation of the unknown functions and their derivatives.
    %
    JH( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
