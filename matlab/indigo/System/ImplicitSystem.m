%
%> Class container for an implicit system of ODEs of the form:
%>
%> \f[
%> \mathbf{F}( \mathbf{x}, \mathbf{x}', t ) = \mathbf{0}
%> \f]
%>
%> with *optional* invariants/hidden constraints of the form:
%>
%> \f[
%> \mathbf{h}( \mathbf{x}, t ) = \mathbf{0}
%> \f]
%>
%> where \f$ \mathbf{x} \f$ are the unknown functions (states) of the
%> independent variable \f$ t \f$.
%
classdef ImplicitSystem < BaseSystem
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor for a implicit system of ODEs.
    %>
    %> \param t_name Name of the implicit system of ODEs.
    %> \param t_neqn Number of equations of the implicit system of ODEs.
    %> \param t_ninv Number of invariants/hidden contraints of the implicit
    %>              system of ODEs.
    %
    function this = ImplicitSystem( t_name, t_neqn, t_ninv )
      this@BaseSystem(t_name, t_neqn, t_ninv);
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
    %> Evaluate the function \f$ \mathbf{F} \f$ of the system of ODEs.
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
    %> Evaluate the Jacobians with respect to the states \f$ \mathbf{x} \f$ of
    %> the system of ODEs:
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
    %> \mathbf{h}( \mathbf{x}, t ) = \mathbf{0}.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The value of the invariants/hidden contraints \f$ \mathbf{h} \f$.
    %
    h( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the invariants/hidden contraints of the system
    %> of ODEs:
    %>
    %> \f[
    %> \mathbf{Jh}_{\mathbf{x}}( \mathbf{x}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{h}( \mathbf{x}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The value of the Jacobian of the invariants/hidden contraints
    %>         \f$ \mathbf{Jh}_{\mathbf{x}} \f$.
    %
    Jh( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
  methods (Static)
    %
    %> Get the system of ODEs/DAEs type.
    %>
    %> \return The system of ODEs/DAEs type.
    %
    function out = type()
      out = 'implicit';
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the system of ODEs/DAEs is explicit.
    %>
    %> \return True if the system of ODEs/DAEs is explicit, false otherwise.
    %
    function out = is_explicit()
      out = false;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the system of ODEs/DAEs is implicit.
    %>
    %> \return True if the system of ODEs/DAEs is implicit, false otherwise.
    %
    function out = is_implicit()
      out = true;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
