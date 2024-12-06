%
%> Class container for a semi explicit system of ODEs/DAEs of the form:
%>
%> \f[
%> \mathbf{x}' = \mathbf{f}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
%> \mathbf{M}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )^{-1}
%> \mathbf{f}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )
%> \f]
%>
%> or equivalently:
%>
%> \f[
%> \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t ) =
%> \mathbf{x}' - \mathbf{f}( \mathbf{x}, \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
%> \mathbf{0}
%> \f]
%>
%> with *optional* veils \f$ \mathbf{v}( \mathbf{x}, t ) \f$ of the form:
%>
%> \f[
%> \mathbf{v}( \mathbf{x}, t ) = \left{\begin{array}{c}
%>   v_1( \mathbf{x}, t ) \\
%>   v_2( \mathbf{x}, v_1, t ) \\
%>   v_3( \mathbf{x}, v_1, v_2, t ) \\
%>   \vdots \\
%>   v_n( \mathbf{x}, v_1, \dots, v_{n-1}, t )
%> \end{array}\right.
%> \f]
%>
%> *optional* linear system for index-1 variables \mathbf{y} of the form:
%>
%> \f[
%> \mathbf{M}( \mathbf{x}, \mathbf{v}, t ) \mathbf{y} = \mathbf{f}( \mathbf{x}, \mathbf{v}, t )
%> \f]
%>
%> and *optional* invariants of the form:
%>
%> \f[
%> \mathbf{h}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) = \mathbf{0}
%> \f]
%>
%> where \f$ \mathbf{x} \f$ are the unknown functions (states) of the
%> independent variable \f$ t \f$.
%
classdef SemiExplicit < Indigo.DAE.System
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor for a semi-explicit system.
    %>
    %> \param t_name     The name of the system.
    %> \param t_num_eqns The number of equations of the system.
    %> \param t_num_sysy The number of linear index-1 variables of the system.
    %> \param t_num_veil The number of (user-defined) veils of the system.
    %> \param t_num_invs The number of invariants of the system.
    %
    function this = SemiExplicit( t_name, t_num_eqns, t_num_sysy, t_num_veil, t_num_invs )
      this@Indigo.DAE.System(t_name, t_num_eqns, t_num_sysy, t_num_veil, t_num_invs);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the system function \f$ \mathbf{F} \f$.
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param y     Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param v     Veils \f$ \mathbf{v} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The system function \f$ \mathbf{F} \f$.
    %
    function out = F( this, x, x_dot, y, v, t )
      out = x_dot - this.f(x, y, v, t);
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
    %> \param y     Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param v     Veils \f$ \mathbf{v} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{JF}_{\mathbf{x}} \f$.
    %
    function out = JF_x( this, x, x_dot, y, v, t )
      out = -this.Jf_x(x, x_dot, y, v, t) - ...
            this.Jf_y(x, x_dot, y, v, t) * this.Jy_x(x, v, t) - ...
            this.Jf_v(x, x_dot, y, v, t) * this.Jv_x(x, v, t);
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
    %> \param y     Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param v     Veils \f$ \mathbf{v} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{JF}_{\mathbf{x}'} \f$.
    %
    function out = JF_x_dot( this, ~, ~, ~, ~, ~ )
      out = eye(this.m_num_eqns);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{F} \f$ with
    %> respect to the veils \f$ \mathbf{y} \f$:
    %>
    %> \f[
    %> \mathbf{JF}_{\mathbf{y}}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{y}
    %> }.
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param v     Veils \f$ \mathbf{v} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{JF}_{\mathbf{y}} \f$.
    %
    function out = JF_y( this, x, x_dot, v, t )
      out = -this.Jf_y(x, x_dot, v, t);
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
    function out = JF_v( this, x, x_dot, v, t )
      out = -this.Jf_v(x, x_dot, v, t);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the system function \f$ \mathbf{f} \f$ as:
    %>
    %> \f[
    %> \mathbf{f}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
    %> \mathbf{M}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )^{-1}
    %> \mathbf{f}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param y Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The system function \f$ \mathbf{f} \f$.
    %
    function out = f( this, x, v, y, t )
      out = this.Ms(x, v, y, t) \ this.fs(x, v, y, t);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{f} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{Jf}_{\mathbf{x}}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{f}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> } =
    %> \dfrac{
    %>   \partial \mathbf{M}^{-1} \mathbf{f}
    %> }{
    %>   \partial \mathbf{x}
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param v     Veils \f$ \mathbf{v} \f$.
    %> \param y     Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jf}_{\mathbf{x}} \f$..
    %
    function out = Jf_x( this, x, x_dot, y, v, t )
      TMs_x = this.TMs_x(x, v, y, t);
      TMs_y = this.TMs_y(x, v, y, t);
      TMs_v = this.TMs_v(x, v, y, t);
      Jfs_x = this.Jfs_x(x, y, v, t);
      Jfs_y = this.Jfs_y(x, y, v, t);
      Jfs_v = this.Jfs_v(x, y, v, t);
      Jv_x = this.Jv_x(x, v, t);
      out  = zeros(this.m_num_eqns);
      rsh  = [size(TMs_v, 1), size(TMs_v, 3)];
      for i = 1:size(TMs_x, 3)
        out(:,i) = (TMs_x(:,:,i) + reshape(TMs_v(:,i,:), rsh) * Jv_x) * x_dot;
      end
      out = this.Ms(x, y, v, t) \ (Jfs_x + Jfs_v * Jv_x - out);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{f} \f$ with
    %> respect to the states \f$ \mathbf{y} \f$:
    %>
    %> \f[
    %> \mathbf{Jf}_{\mathbf{y}}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{f}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{y}
    %> } =
    %> \dfrac{
    %>   \partial \mathbf{M}^{-1} \mathbf{f}
    %> }{
    %>   \partial \mathbf{v}
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param y     Linear states \f$ \mathbf{y} \f$.
    %> \param v     Veils \f$ \mathbf{v} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jf}_{\mathbf{y}} \f$..
    %
    function out = Jf_y( this, x, x_dot, y, v, t )
      TMs_y = this.TMs_y(x, y, v, t);
      Jfs_y = this.Jfs_y(x, y, v, t);
      out  = zeros(this.m_num_eqns, this.m_num_veil);
      for i = 1:size(TMs_y, 3)
        out(:,i) = TMs_y(:,:,i) * x_dot;
      end
      out = this.Ms(x, v, t) \ (Jfs_y - out);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{f} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{Jf}_{\mathbf{v}}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{f}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{v}
    %> } =
    %> \dfrac{
    %>   \partial \mathbf{M}^{-1} \mathbf{f}
    %> }{
    %>   \partial \mathbf{v}
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param y     Linear states \f$ \mathbf{y} \f$.
    %> \param v     Veils \f$ \mathbf{v} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jf}_{\mathbf{v}} \f$..
    %
    function out = Jf_v( this, x, x_dot, y, v, t )
      TMs_v = this.TMs_v(x, y, v, t);
      Jfs_v = this.Jfs_v(x, y, v, t);
      out  = zeros(this.m_num_eqns, this.m_num_veil);
      for i = 1:size(TMs_v, 3)
        out(:,i) = TMs_v(:,:,i) * x_dot;
      end
      out = this.M(x, y, v, t) \ (Jfs_v - out);
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
    %> Evaluate the sytem matrix \f$ \mathbf{M} \f$.
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param y Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The system matrix \f$ \mathbf{M} \f$.
    %
    Ms( this, x, y, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the tensor of the system matrix \f$ \mathbf{M} \f$ with respect
    %> to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{TM}_{\mathbf{x}}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{M}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param y Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The tensor \f$ \mathbf{TM}_{\mathbf{x}} \f$.
    %
    TMs_x( this, x, y, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the tensor of the system matrix \f$ \mathbf{M} \f$ with respect
    %> to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{TM}_{\mathbf{y}}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{M}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{y}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param y Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The tensor \f$ \mathbf{TM}_{\mathbf{y}} \f$.
    %
    TMs_y( this, x, y, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the tensor of the system matrix \f$ \mathbf{M} \f$ with respect
    %> to the states \f$ \mathbf{v} \f$:
    %>
    %> \f[
    %> \mathbf{TM}_{\mathbf{y}}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{M}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{v}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param y Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The tensor \f$ \mathbf{TM}_{\mathbf{v}} \f$.
    %
    TMs_v( this, x, y, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the sytem vector \f$ \mathbf{f} \f$.
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param y Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The system vector \f$ \mathbf{f} \f$.
    %
    fs( this, x, v, y, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system vector \f$ \mathbf{f} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{Jf}_{\mathbf{x}}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{f}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param y Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jf}_{\mathbf{x}} \f$..
    %
    Jfs_x( this, x, v, y, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system vector \f$ \mathbf{f} \f$ with
    %> respect to the veils \f$ \mathbf{y} \f$:
    %>
    %> \f[
    %> \mathbf{Jf}_{\mathbf{y}}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{f}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{y}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param y Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jf}_{\mathbf{y}} \f$..
    %
    Jfs_y( this, x, v, y, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system vector \f$ \mathbf{f} \f$ with
    %> respect to the veils \f$ \mathbf{v} \f$:
    %>
    %> \f[
    %> \mathbf{Jf}_{\mathbf{v}}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{f}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{v}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param y Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jf}_{\mathbf{v}} \f$..
    %
    Jfs_v( this, x, v, y, t )
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
