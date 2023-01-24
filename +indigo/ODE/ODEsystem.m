%
%> Class container for a system of Ordinary Differential Equations (ODEs).
%
classdef ODEsystem < Base
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor for a system of ODEs.
    %>
    %> \param name Name of the system of ODEs.
    %> \param neqn Number of equations of the system of ODEs.
    %> \param ninv Number of invariants/hidden contraints of the system of ODEs.
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
    %> Definition of an implicit system of ODEs of the form:
    %>
    %> \f[
    %> \mathbf{F}( \mathbf{x}, \mathbf{x}', t ) = \mathbf{0}
    %> \f]
    %>
    %> with *optional* invariants/hidden constraints of the form:
    %>
    %> \f[
    %> \mathbf{H}( \mathbf{x}, \mathbf{x}', t ) = \mathbf{0}
    %> \f]
    %>
    %> where \f$ \mathbf{x} \f$ are the unknown functions (states) of the
    %> independent variable \f$ t \f$.
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param t     Independent variable \f$ t \f$.
    %> \return      Value of the system of ODEs function \f$ \mathbf{F} \f$.
    %
    F( this, x, x_dot, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the of the system of ODEs:
    %>
    %> \f[
    %> \mathbf{JF}( \mathbf{x}, \mathbf{x}', t ) =
    %> \left[
    %> \dfrac{
    %> \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', t )
    %> }{
    %> \partial \mathbf{x}
    %> },
    %> \dfrac{
    %> \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', t )
    %> }{
    %> \partial \mathbf{x}'
    %> }
    %> \right].
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param t     Independent variable \f$ t \f$.
    %> \return      Value of the Jacobian of the system of ODEs function
    %>              \f$ \mathbf{JF} \f$.
    %
    JF( this, x, x_dot, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the invariants/hidden contraints of the system of ODEs:
    %>
    %> \f[
    %> \mathbf{H}( \mathbf{x}, \mathbf{x}', t ) = \mathbf{0}.
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param t     Independent variable \f$ t \f$.
    %> \return      Value of the invariants/hidden contraints \f$ \mathbf{H} \f$.
    %
    H( this, x, x_dot, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the invariants/hidden contraints of the system
    %> of ODEs:
    %>
    %> \f[
    %> \mathbf{JH}( \mathbf{x}, \mathbf{x}', t ) =
    %> \left[
    %> \dfrac{
    %> \partial \mathbf{H}( \mathbf{x}, \mathbf{x}', t )
    %> }{
    %> \partial \mathbf{x}
    %> },
    %> \dfrac{
    %> \partial \mathbf{H}( \mathbf{x}, \mathbf{x}', t )
    %> }{
    %> \partial \mathbf{x}'
    %> }
    %> \right].
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param t     Independent variable \f$ t \f$.
    %> \return      Value of the Jacobian of the invariants/hidden contraints
    %>              \f$ \mathbf{JH} \f$.
    %
    JH( this, x, x_dot, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
