%
%> Class container for an explicit system of ODEs/DAEs of the form:
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
%> \mathbf{x}' - \mathbf{f}( \mathbf{x}, \mathbf{v}, t ) = \mathbf{0}
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
classdef Explicit < Indigo.DAE.System
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor for a explicit system.
    %>
    %> \param t_name     The name of the system.
    %> \param t_num_eqns The number of equations of the system.
    %> \param t_num_veil The number of (user-defined) veils of the system.
    %> \param t_num_invs The number of invariants of the system.
    %
    function this = Explicit( t_name, t_num_eqns, t_num_veil, t_num_invs )
      this@Indigo.DAE.System(t_name, t_num_eqns, t_num_veil, t_num_invs);
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
    %> Evaluate the Jacobian of the system function \f$ \mathbf{F} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{JF}_{\mathbf{x}}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param v     Veils \f$ \mathbf{v} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{JF}_{\mathbf{x}} \f$.
    %
    function out = JF_x( this, x, ~, v, t )
      out = -(this.Jf_x(x, v, t) + this.Jf_v(x, v, t)*this.Jv_x(x, v, t));
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{F} \f$ with
    %> respect to the states derivative \f$ \mathbf{x}' \f$:
    %>
    %> \f[
    %> \mathbf{JF}_{\mathbf{x}'}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{x}'
    %> }.
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param v     Veils \f$ \mathbf{v} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{JF}_{\mathbf{x}'} \f$.
    %
    function out = JF_x_dot( this, ~, ~, ~, ~ )
      out = eye(this.m_num_eqns);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{F} \f$ with
    %> respect to the veils \f$ \mathbf{v} \f$:
    %>
    %> \f[
    %> \mathbf{JF}_{\mathbf{v}}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{v}
    %> }.
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param v     Veils \f$ \mathbf{v} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{JF}_{\mathbf{v}} \f$.
    %
    function out = JF_v( this, x, ~, v, t )
      out = -this.Jf_v(x, v, t);
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
    %> Evaluate the system function \f$ \mathbf{f} \f$:
    %>
    %> \f[
    %> \mathbf{f}( \mathbf{x}, \mathbf{v}, t ) = \mathbf{0}.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The function \f$ \mathbf{f} \f$.
    %
    f( this, x, v, t )
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
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jf}_{\mathbf{x}} \f$.
    %
    Jf_x( this, x, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{f} \f$ with
    %> respect to the veils \f$ \mathbf{v} \f$:
    %>
    %> \f[
    %> \mathbf{Jf}_{\mathbf{v}}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{f}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{v}
    %> }
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param v     Veils \f$ \mathbf{v} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jf}_{\mathbf{v}} \f$.
    %
    Jf_v( this, x, x_dot, v, t )
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
