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
    %> \param t_name Name of the system of ODEs.
    %> \param t_neqn Number of equations of the system of ODEs.
    %> \param t_ninv Number of invariants/hidden contraints of the system of ODEs.
    %
    function this = ODEsystem( t_name, t_neqn, t_ninv )
      this@Base(t_name, t_neqn, t_ninv);
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
    %> \mathbf{H}( \mathbf{x}, t ) = \mathbf{0}
    %> \f]
    %>
    %> where \f$ \mathbf{x} \f$ are the unknown functions (states) of the
    %> independent variable \f$ t \f$.
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The value of the system of ODEs function \f$ \mathbf{F} \f$.
    %
    F( this, x, x_dot, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobians with respect to the states \f$ \mathbf{x} \f$ and
    %> the states defivatives \f$ \mathbf{x}' \f$ of the system of ODEs:
    %>
    %> \f[
    %> \mathbf{JF}_{\mathbf{x}}( \mathbf{x}, \mathbf{x}', t ) =
    %> \dfrac{
    %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', t )
    %> }{
    %>   \partial \mathbf{x}
    %> },
    %> \qquad
    %> \mathbf{JF}_{\mathbf{x}'}( \mathbf{x}, \mathbf{x}', t ) =
    %> \dfrac{
    %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', t )
    %> }{
    %>   \partial \mathbf{x}'
    %> }.
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobians \f$ \mathbf{JF}_{\mathbf{x}} \f$ and \f$
    %>         \mathbf{JF}_{\mathbf{x}'} \f$ of the ODEs system with respect to
    %>         the states \f$ \mathbf{x} \f$ and the states derivatives
    %>         \f$ \mathbf{x}' \f$.
    %
    JF( this, x, x_dot, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the invariants/hidden contraints of the system of ODEs:
    %>
    %> \f[
    %> \mathbf{H}( \mathbf{x}, t ) = \mathbf{0}.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The value of the invariants/hidden contraints \f$ \mathbf{H} \f$.
    %
    H( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the invariants/hidden contraints of the system
    %> of ODEs:
    %>
    %> \f[
    %> \mathbf{JH}_{\mathbf{x}}( \mathbf{x}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{H}( \mathbf{x}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The value of the Jacobian of the invariants/hidden contraints
    %>         \f$ \mathbf{JH}_{\mathbf{x}} \f$.
    %
    JH( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
