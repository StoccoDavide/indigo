%
%> Class container for an explicit system of ODEs of the form:
%>
%> \f[
%> \mathbf{x}' = \mathbf{f}( \mathbf{x}, t )
%>             = \mathbf{A}(\mathbf{x}, t)^{-1} \mathbf{b}( \mathbf{x}, t )
%> \f]
%>
%> or equivalently:
%>
%> \f[
%> \mathbf{F}( \mathbf{x}, \mathbf{x}', t ) = \mathbf{x}' - \mathbf{f}(
%> \mathbf{x}, t ) = \mathbf{0}
%> \f]
%>
%> with *optional* invariants of the form:
%>
%> \f[
%> \mathbf{h}( \mathbf{x}, t ) = \mathbf{0}
%> \f]
%>
%> where \f$ \mathbf{x} \f$ are the unknown functions (states) of the
%> independent variable \f$ t \f$.
%
classdef ExplicitSystem < BaseSystem
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor for a explicit system.
    %>
    %> \param t_name Name of the system.
    %> \param t_neqn Number of equations of the system.
    %> \param t_ninv Number of invariants of the system.
    %
    function this = ExplicitSystem( t_name, t_neqn, t_ninv )
      this@BaseSystem(t_name, t_neqn, t_ninv);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the system function \f$ \mathbf{F} \f$.
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The system function \f$ \mathbf{F} \f$.
    %
    function out = F( this, x, x_dot, t )
      out = x_dot - this.f(x,t);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobians of the system function \f$ \mathbf{F} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$ and states derivatives of
    %> \f$ \mathbf{x}' \f$:
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
    %>         \mathbf{JF}_{\mathbf{x}'} \f$.
    %
    function [JF_x, JF_x_dot] = JF( this, x, ~, t )
      JF_x     = -this.Jf(x, t);
      JF_x_dot = eye(length(x));
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
    %> Evaluate the system invariants \f$ \mathbf{h} \f$:
    %>
    %> \f[
    %> \mathbf{h}( \mathbf{x}, t ) = \mathbf{0}.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The invariants \f$ \mathbf{h} \f$.
    %
    f( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system invariants \f$ \mathbf{h} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
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
    %> \return The Jacobian \f$ \mathbf{Jh}_{\mathbf{x}} \f$.
    %
    Jf( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
  methods (Static)
    %
    %> Get the system type.
    %>
    %> \return The system type.
    %
    function out = type()
      out = 'explicit';
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the system is explicit.
    %>
    %> \return True if the system is explicit, false otherwise.
    %
    function out = is_explicit()
      out = true;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the system is semiexplicit.
    %>
    %> \return True if the system is semiexplicit, false otherwise.
    %
    function out = is_semiexplicit()
      out = false;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the system is implicit.
    %>
    %> \return True if the system is implicit, false otherwise.
    %
    function out = is_implicit()
      out = false;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
