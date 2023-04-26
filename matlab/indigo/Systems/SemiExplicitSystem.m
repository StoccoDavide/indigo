%
%> Class container for a semi explicit system of ODEs of the form:
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
%> with *optional* invariants/hidden constraints of the form:
%>
%> \f[
%> \mathbf{h}( \mathbf{x}, t ) = \mathbf{0}
%> \f]
%>
%> where \f$ \mathbf{x} \f$ are the unknown functions (states) of the
%> independent variable \f$ t \f$.
%
classdef SemiExplicitSystem < BaseSystem
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor for a system.
    %>
    %> \param t_name Name of the system.
    %> \param t_neqn Number of equations of the system.
    %> \param t_ninv Number of invariants/hidden contraints of the system.
    %
    function this = SemiExplicitSystem( t_name, t_neqn, t_ninv )
      this@BaseSystem(t_name, t_neqn, t_ninv);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the function \f$ \mathbf{F} \f$ of the system.
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The value of the system function \f$ \mathbf{F} \f$.
    %
    function out = F( this, x, x_dot, t )
      out = x_dot - this.f(x,t);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobians with respect to the states \f$ \mathbf{x} \f$ and
    %> the states defivatives \f$ \mathbf{x}' \f$ of the system:
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
    %>         \mathbf{JF}_{\mathbf{x}'} \f$ of the system with respect to the
    %>         states \f$ \mathbf{x} \f$ and the states derivatives \f$
    %>         \mathbf{x}' \f$.
    %
    function [JF_x, JF_x_dot] = JF( this, x, x_dot, t )
      JF_x     = -this.Jf(x, x_dot, t);
      JF_x_dot = eye(length(x));
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the function \f$ \mathbf{f} \f$ of the system as:
    %>
    %> \f[
    %> \mathbf{f}( \mathbf{x}, t ) = \mathbf{A}(\mathbf{x}, t)^{-1} \mathbf{b}(
    %> \mathbf{x}, t )
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The value of the system function \f$ \mathbf{F} \f$.
    %
    function out = f( this, x, t )
      out = this.A(x,t) \ this.b(x,t);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian with respect to the states \f$ \mathbf{x} \f$ of
    %> the system:
    %>
    %> \f[
    %> \mathbf{Jf}_{\mathbf{x}}( \mathbf{x}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{f}( \mathbf{x}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> } =
    %> \dfrac{
    %>   \partial \mathbf{A}^{-1} \mathbf{b}
    %> }{
    %>   \partial \mathbf{x}
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jf}_{\mathbf{x}} \f$ of the system with
    %>         respect to the states \f$ \mathbf{x} \f$.
    %
    function out = Jf( this, x, x_dot, t )
      TA = this.TA(x,t);
      out = zeros(length(x));
      for i = 1:size(TA, 3)
        out(:,i) = TA(:,:,i) * x_dot;
      end
      out = this.A(x,t) \ (this.Jb(x,t) - out);
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
    %> Evaluate the sytem matrix \f$ \mathbf{A} \f$ of the system.
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The system matrix \f$ \mathbf{A} \f$ of the system.
    %
    A( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the tensor with respect to the states \f$ \mathbf{x} \f$ of
    %> the system matrix \f$ \mathbf{A} \f$:
    %>
    %> \f[
    %> \mathbf{TA}_{\mathbf{x}}( \mathbf{x}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{A}( \mathbf{x}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The tensor \f$ \mathbf{TA}_{\mathbf{x}} \f$ of the system
    %>         with respect to the states \f$ \mathbf{x} \f$.
    %
    TA( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the sytem matrix \f$ \mathbf{b} \f$ of the system.
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The system matrix \f$ \mathbf{b} \f$ of the system.
    %
    b( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian with respect to the states \f$ \mathbf{x} \f$ of
    %> the system matrix \f$ \mathbf{b} \f$:
    %>
    %> \f[
    %> \mathbf{TM}_{\mathbf{x}}( \mathbf{x}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{b}( \mathbf{x}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jb}_{\mathbf{x}} \f$ of the system with
    %>         respect to the states \f$ \mathbf{x} \f$.
    %
    Jb( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the invariants/hidden contraints of the system:
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
    %> Evaluate the Jacobian of the invariants/hidden contraints of the system:
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
    %> \return The value of the Jacobian of the invariants/hidden contraints \f$
    %>         \mathbf{Jh}_{\mathbf{x}} \f$.
    %
    Jh( this, x, t )
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
      out = 'semiexplicit';
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the system is explicit.
    %>
    %> \return True if the system is explicit, false otherwise.
    %
    function out = is_explicit()
      out = false;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the system is semiexplicit.
    %>
    %> \return True if the system is semiexplicit, false otherwise.
    %
    function out = is_semiexplicit()
      out = true;
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
