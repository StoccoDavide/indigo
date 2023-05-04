%
%> Class container for a semi explicit system of ODEs of the form:
%>
%> \f[
%> \mathbf{x}' = \mathbf{f}( \mathbf{x}, \mathbf{v}, t ) =
%> \mathbf{A}( \mathbf{x}, \mathbf{v}, t )^{-1}
%> \mathbf{b}( \mathbf{x}, \mathbf{v}, t )
%> \f]
%>
%> or equivalently:
%>
%> \f[
%> \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t ) =
%> \mathbf{x}' - \mathbf{f}( \mathbf{x}, \mathbf{x}, \mathbf{v}, t ) =
%> \mathbf{0}
%> \f]
%>
%> with *optional* veils \f$ \mathbf{v}( \mathbf{x}, t ) \f$ of the form:
%>
%> \f[
%> \mathbf{v}( \mathbf{x}, \mathbf{v}, t ) = \left{\begin{array}{c}
%>   v_1( \mathbf{x}, t ) \\
%>   v_2( \mathbf{x}, v_1, t ) \\
%>   v_3( \mathbf{x}, v_1, v_2, t ) \\
%>   \vdots \\
%>   v_n( \mathbf{x}, v_1, \dots, v_{n-1}, t )
%> \end{array}\right.
%> \f]
%>
%> And *optional* invariants of the form:
%>
%> \f[
%> \mathbf{h}( \mathbf{x}, \mathbf{v}, t ) = \mathbf{0}
%> \f]
%>
%> where \f$ \mathbf{x} \f$ are the unknown functions (states) of the
%> independent variable \f$ t \f$.
%
classdef SemiExplicit < Indigo.Systems.System
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor for a semi-explicit system.
    %>
    %> \param t_name     The name of the system.
    %> \param t_num_eqns The number of equations of the system.
    %> \param t_num_veil The number of (user-defined) veils of the system.
    %> \param t_num_invs The number of invariants of the system.
    %
    function this = SemiExplicit( t_name, t_num_eqns, t_num_veil, t_num_invs )
      this@Indigo.Systems.System(t_name, t_num_eqns, t_num_veil, t_num_invs);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the system function \f$ \mathbf{F} \f$.
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param v     Veils \f$ \mathbf{v} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The system function \f$ \mathbf{F} \f$.
    %
    function out = F( this, x, x_dot, v, t )
      out = x_dot - this.f(x, v, t);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the system function \f$ \mathbf{f} \f$ as:
    %>
    %> \f[
    %> \mathbf{f}( \mathbf{x}, \mathbf{v}, t ) =
    %> \mathbf{A}( \mathbf{x}, \mathbf{v}, t )^{-1}
    %> \mathbf{b}( \mathbf{x}, \mathbf{v}, t )
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The system function \f$ \mathbf{f} \f$.
    %
    function out = f( this, x, v, t )
      out = this.A(x, v, t) \ this.b(x, v, t);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{f} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{Jf}_{\mathbf{x}}( \mathbf{x}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{f}( \mathbf{x}, \mathbf{v}, t )
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
    %> \param v     IVeils \f$ \mathbf{v} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jf}_{\mathbf{x}} \f$..
    %
    function out = Jf_x( this, x, x_dot, v, t )
      TA_x = this.TA_x(x, v, t);
      out  = zeros(length(x));
      for i = 1:size(TA, 3)
        out(:,i) = TA_x(:,:,i) * x_dot;
      end
      out = this.A(x, v, t) \ (this.Jb_x(x, v, t) - out);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{f} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{Jf}_{\mathbf{v}}( \mathbf{x}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{f}( \mathbf{x}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{v}
    %> } =
    %> \dfrac{
    %>   \partial \mathbf{A}^{-1} \mathbf{b}
    %> }{
    %>   \partial \mathbf{v}
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param v     IVeils \f$ \mathbf{v} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jf}_{\mathbf{x}} \f$..
    %
    function out = Jf_v( this, x, x_dot, v, t )
      TA_v = this.TA_v(x, v, t);
      out  = zeros(length(x));
      for i = 1:size(TA_v, 3)
        out(:,i) = TA_v(:,:,i) * x_dot;
      end
      out = this.A(x, v, t) \ (this.Jb_v(x, v, t) - out);
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
    %> Evaluate the sytem matrix \f$ \mathbf{A} \f$.
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The system matrix \f$ \mathbf{A} \f$.
    %
    A( this, x, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the tensor of the system matrix \f$ \mathbf{A} \f$ with respect
    %> to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{TA}_{\mathbf{x}}( \mathbf{x}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{A}( \mathbf{x}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The tensor \f$ \mathbf{TA}_{\mathbf{x}} \f$.
    %
    TA_x( this, x, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the sytem vector \f$ \mathbf{b} \f$.
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The system vector \f$ \mathbf{b} \f$.
    %
    b( this, x, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system vector \f$ \mathbf{b} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{Jb}_{\mathbf{x}}( \mathbf{x}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{b}( \mathbf{x}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jb}_{\mathbf{x}} \f$..
    %
    Jb_x( this, x, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system vector \f$ \mathbf{b} \f$ with
    %> respect to the veils \f$ \mathbf{v} \f$:
    %>
    %> \f[
    %> \mathbf{Jb}_{\mathbf{v}}( \mathbf{x}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{b}( \mathbf{x}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{v}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jb}_{\mathbf{v}} \f$..
    %
    Jb_v( this, x, v, t )
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
    function out = whattype()
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
