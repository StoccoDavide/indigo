%
%> Class container for the system of Ordinary Differential Equations (ODEs)
%> or Differential Algebraic Equations (DAEs). This class is the base class
%> for more specific systems, such as the explicit, semi-explicit and implicit
%> systems. The system *must* define the abstract methods. The system is defined
%> by the following equations:
%>
%> \f[
%> \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{y}, \mathbf{v}, t ) = \mathbf{0}
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
%> \mathbf{A}( \mathbf{x}, \mathbf{v}, t ) \mathbf{y} = \mathbf{b}( \mathbf{x}, \mathbf{v}, t )
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
classdef System < handle
  %
  properties (SetAccess = protected, Hidden = true)
    %
    %> Name of the system.
    %
    m_name;
    %
    %> Number of equations of the system.
    %
    m_num_eqns;
    %
    %> Number of linear index-1 variables of the system.
    %
    m_num_sysy
    %
    %> Number of veils of the system.
    %
    m_num_veil;
    %
    %> Number of invariants of the system.
    %
    m_num_invs;
    %
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor for a system that requires the following inputs:
    %>
    %> \param t_name     The name of the system.
    %> \param t_num_eqns The number of equations of the system.
    %> \param t_num_sysy The number of linear index-1 variables of the system.
    %> \param t_num_veil The number of (user-defined) veils of the system.
    %> \param t_num_invs The number of invariants of the system.
    %
    function this = System( t_name, t_num_eqns, t_num_sysy, t_num_veil, t_num_invs )
      this.m_name     = t_name;
      this.m_num_eqns = t_num_eqns;
      this.m_num_sysy = t_num_sysy;
      this.m_num_veil = t_num_veil;
      this.m_num_invs = t_num_invs;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the system name.
    %>
    %> \return The system name.
    %
    function out = get_name( this )
      out = this.m_name;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the number of equations of the system.
    %>
    %> \return The number of equations of the system.
    %
    function t_num_eqns = get_num_eqns( this )
      t_num_eqns = this.m_num_eqns;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the number of equations of the system.
    %>
    %> \param t_num_eqns The number of equations of the system.
    %
    function set_num_eqns( this, t_num_eqns )
      this.m_num_eqns = t_num_eqns;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the number of linear index-1 variables of the system.
    %>
    %> \return The number of linear index-1 variables of the system.
    %
    function t_num_sysy = get_num_sysy( this )
      t_num_sysy = this.m_num_sysy;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the number of linear index-1 variables of the system.
    %>
    %> \param t_num_sysy The number of linear index-1 variables of the system.
    %
    function set_num_sysy( this, t_num_sysy )
      this.m_num_sysy = t_num_sysy;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the number of veils of the system.
    %>
    %> \return The number of veils of the system.
    %
    function t_num_veil = get_num_veil( this )
      t_num_veil = this.m_num_veil;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the number of veils of the system.
    %>
    %> \param t_num_veil The number of veils of the system.
    %
    function set_num_veil( this, t_num_veil )
      this.m_num_veil = t_num_veil;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the number of invariants of the system.
    %>
    %> \return The number of invariants of the system.
    %
    function t_num_invs = get_num_invs( this )
      t_num_invs = this.m_num_invs;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the number of invariants of the system.
    %>
    %> \param t_num_invs The number of invariants of the
    %>                   system.
    %
    function set_num_invs( this, t_num_invs )
      this.m_num_invs = t_num_invs;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Calculate the linear states \f$ \mathbf{y} \f$.
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The linear states \f$ \mathbf{y} \f$.
    %
    function out = y( this, x, v, t )
      out = this.A(x, v, t)\this.b(x, v, t);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Calculate the Jacobial of the linear states \f$ \mathbf{y} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \dfrac{\partial}{\partial\mathbf{x}} \left[ \mathbf{A}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )
    %> \mathbf{y} - \mathbf{b}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) \right] = \mathbf{0}
    %> \f]
    %>
    %> which, if expanded applying the chain rule, can be written as:
    %>
    %> \f[
    %> (\mathbf{TA}_{\mathbf{x}} + \mathbf{TA}_{\mathbf{v}}\mathbf{Jv}_{\mathbf{x}})\mathbf{y} + \mathbf{A}\mathbf{Jy}_\mathbf{x}
    %> = \mathbf{Jb}_{\mathbf{x}} + \mathbf{Jb}_{\mathbf{v}}\mathbf{Jv}_{\mathbf{x}}
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param y Linear states \f$ \mathbf{y} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian of the linear states with respect to the states
    %> \mathbf{Jy}_\mathbf{x}.
    %
    function out = Jy_x( this, x, y, v, t )
      if this.m_num_sysy == 0
        out = zeros(this.m_num_sysy, this.m_num_eqns);
      else
        TA_x = this.TA_x(x, v, t);
        TA_v = this.TA_v(x, v, t);
        Jb_x = this.Jb_x(x, v, t);
        Jb_v = this.Jb_v(x, v, t);
        Jv_x = this.Jv_x(x, v, t);
        TA_v_Jv_x = zeros(this.m_num_sysy, this.m_num_eqns);
        if this.m_num_sysy ~= 0
          for i = 1:size(TA_v, 3)
            TA_v_Jv_x(:,i) = TA_v(:,:,i)*Jv_x;
          end
        end
        out = zeros(this.m_num_sysy, this.m_num_eqns);
        for i = 1:size(TA_x, 3)
          out(:,i) = (TA_x(:,:,i) + TA_v_Jv_x) * y;
        end
        out = this.A(x, t) \ (Jb_x + Jb_v*Jv_x - out);
      end
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
    F( this, x, x_dot, y, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{F} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{JF}_{\mathbf{x}}( \mathbf{x}, \mathbf{x}', \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{y}, \mathbf{v}, t )
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
    JF_x( this, x, x_dot, y, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{F} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{JF}_{\mathbf{x}}( \mathbf{x}, \mathbf{x}', \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{y}, \mathbf{v}, t )
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
    JF_y( this, x, x_dot, y, v, t )
    %
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{F} \f$ with
    %> respect to the states derivative \f$ \mathbf{x}' \f$:
    %>
    %> \f[
    %> \mathbf{JF}_{\mathbf{x}'}( \mathbf{x}, \mathbf{x}', \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{y}, \mathbf{v}, t )
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
    JF_x_dot( this, x, x_dot, y, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{F} \f$ with
    %> respect to the veils \f$ \mathbf{v} \f$:
    %>
    %> \f[
    %> \mathbf{JF}_{\mathbf{v}}( \mathbf{x}, \mathbf{x}', \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{y}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{v}
    %> }.
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param y     Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param v     Veils \f$ \mathbf{v} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{JF}_{\mathbf{v}} \f$.
    %
    JF_v( this, x, x_dot, y, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the system veils \f$ \mathbf{v} \f$:
    %>
    %> \f[
    %> \mathbf{v}( \mathbf{x}, t ) = \mathbf{0}.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The system veils \f$ \mathbf{v} \f$..
    %
    v( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system veils \f$ \mathbf{v} \f$
    %> with respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{Jv}_{\mathbf{x}}( \mathbf{x}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{v}( \mathbf{x}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jv}_{\mathbf{x}} \f$.
    %
    Jv_x( this, x, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the system invariants \f$ \mathbf{h} \f$:
    %>
    %> \f[
    %> \mathbf{h}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) = \mathbf{0}.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param y Linear index-1 variables \f$ \mathbf{y} \f$.
    %> \param v Veils \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The invariants \f$ \mathbf{h} \f$..
    %
    h( this, x, y, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system invariants \f$ \mathbf{h} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{Jh}_{\mathbf{x}}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{h}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t )
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
    %> \return The Jacobian \f$ \mathbf{Jh}_{\mathbf{x}} \f$.
    %
    Jh_x( this, x, y, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system invariants \f$ \mathbf{h} \f$ with
    %> respect to the veils \f$ \mathbf{v} \f$:
    %>
    %> \f[
    %> \mathbf{Jh}_{\mathbf{v}}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{h}
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
    %> \return The Jacobian \f$ \mathbf{Jh}_{\mathbf{v}} \f$.
    %
    Jh_y( this, x, y, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system invariants \f$ \mathbf{h} \f$ with
    %> respect to the veils \f$ \mathbf{v} \f$:
    %>
    %> \f[
    %> \mathbf{Jh}_{\mathbf{v}}( \mathbf{x}, \mathbf{y}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{h}
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
    %> \return The Jacobian \f$ \mathbf{Jh}_{\mathbf{v}} \f$.
    %
    Jh_v( this, x, y, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the system type.
    %>
    %> \return The system type.
    %
    whattype()
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the system is explicit.
    %>
    %> \return True if the system is explicit, false otherwise.
    %
    is_explicit()
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the system is explicit.
    %>
    %> \return True if the system is explicit, false otherwise.
    %
    is_semiexplicit()
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the system is implicit.
    %>
    %> \return True if the system is implicit, false otherwise.
    %
    is_implicit()
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Return true if (x,t) is in the domain of the DAE system
    %
    in_domain( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
