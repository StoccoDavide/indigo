%
%> Class container for the system of Ordinary Differential Equations (ODEs)
%> or Differential Algebraic Equations (DAEs). This class is the base class
%> for more specific systems, such as the explicit, semi-explicit and implicit
%> systems. The system *must* define the abstract methods. The system is defined
%> by the following equations:
%>
%> \f[
%> \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{y}, t ) = \mathbf{0}
%> \f]
%>
%> with *optional* linear states \f$ \mathbf{y}( \mathbf{x}, t ) \f$ of the form:
%>
%> \f[
%> \mathbf{A}( \mathbf{x}, t ) \mathbf{y}( \mathbf{x}, t ) = \mathbf{b}( \mathbf{x}, t )
%> \end{array}\right.
%> \f]
%>
%> And *optional* invariants of the form:
%>
%> \f[
%> \mathbf{h}( \mathbf{x}, \mathbf{y}, t ) = \mathbf{0}
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
    %> Number of linear equations of the system.
    %
    m_num_sysy;
    %
    %> Number of invariants of the system.
    %
    m_num_invs;
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
    %> \param t_num_sysy The number of linear equations of the system.
    %> \param t_num_invs The number of invariants of the system.
    %
    function this = System( t_name, t_num_eqns, t_num_sysy, t_num_invs )
      this.m_name     = t_name;
      this.m_num_eqns = t_num_eqns;
      this.m_num_sysy = t_num_sysy;
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
    %> Get the number of linear states of the system.
    %>
    %> \return The number of linear states of the system.
    %
    function t_num_sysy = get_num_sysy( this )
      t_num_sysy = this.m_num_sysy;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the number of linear states of the system.
    %>
    %> \param t_num_sysy The number of linear states of the system.
    %
    function set_num_sysy( this, t_num_sysy )
      this.m_num_sysy = t_num_sysy;
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
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The linear states \f$ \mathbf{y} \f$.
    %
    function out = y( this, x, t )
      out = this.A(x, t)\this.b(x, t);
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Calculate the derivative of the linear states \f$ \mathbf{y} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \dfrac{\partial}{\partial\mathbf{x}} \left[ \mathbf{A}( \mathbf{x}, \mathbf{v}, t )
    %> \mathbf{y} - \mathbf{b}( \mathbf{x}, \mathbf{v}, t ) \right] = \mathbf{0}
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
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The linear states derivative \f$ \mathbf{y}' \f$.
    %
    function out = Jy_x( this, x, y, t )
      TA_x = this.TA_x(x, t);
      Jb_x = this.Jb_x(x, t);
      out  = zeros(this.m_num_sysy, this.m_num_eqns);
      for i = 1:size(TA_x, 3)
        out(:,i) = TA_x(:,:,i) * y;
      end
      out = this.A(x, t) \ (Jb_x - out);
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
    %> \param y     Linear states \f$ \mathbf{y} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The system function \f$ \mathbf{F} \f$.
    %
    F( this, x, x_dot, y, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{F} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{JF}_{\mathbf{x}}( \mathbf{x}, \mathbf{x}', \mathbf{y}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{y}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param y     Linear states \f$ \mathbf{y} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{JF}_{\mathbf{x}} \f$.
    %
    JF_x( this, x, x_dot, y, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{F} \f$ with
    %> respect to the linear states \f$ \mathbf{y} \f$:
    %>
    %> \f[
    %> \mathbf{JF}_{\mathbf{y}}( \mathbf{x}, \mathbf{x}', \mathbf{y}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{y}, t )
    %> }{
    %>   \partial \mathbf{y}
    %> }.
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param y     Linear states \f$ \mathbf{y} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{JF}_{\mathbf{y}} \f$.
    %
    JF_y( this, x, x_dot, y, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system function \f$ \mathbf{F} \f$ with
    %> respect to the states derivative \f$ \mathbf{x}' \f$:
    %>
    %> \f[
    %> \mathbf{JF}_{\mathbf{x}'}( \mathbf{x}, \mathbf{x}', \mathbf{y}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{y}, t )
    %> }{
    %>   \partial \mathbf{x}'
    %> }.
    %> \f]
    %>
    %> \param x     States \f$ \mathbf{x} \f$.
    %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
    %> \param y     Linear states \f$ \mathbf{y} \f$.
    %> \param t     Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{JF}_{\mathbf{x}'} \f$.
    %
    JF_x_dot( this, x, x_dot, y, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the system matrix \f$ \mathbf{A} \f$ of the linear states
    %> \f$ \mathbf{y} \f$.
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The system matrix \f$ \mathbf{A} \f$.
    %
    A( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the tensor of the linear system matrix \f$ \mathbf{A} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{TA}_{\mathbf{x}}( \mathbf{x}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{\A}( \mathbf{x}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The tensor \f$ \mathbf{TA}_{\mathbf{x}} \f$.
    %
    TA_x( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the system vector \f$ \mathbf{b} \f$ of the linear states
    %> \f$ \mathbf{y} \f$.
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The system vector \f$ \mathbf{b} \f$.
    %
    b( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system vector \f$ \mathbf{b} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{Jb}_{\mathbf{x}}( \mathbf{x}, t ) =
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
    %> \return The Jacobian \f$ \mathbf{Jb}_{\mathbf{x}} \f$.
    %
    Jb_x( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the system invariants \f$ \mathbf{h} \f$:
    %>
    %> \f[
    %> \mathbf{h}( \mathbf{x}, \mathbf{y}, t ) = \mathbf{0}.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param y Linear states \f$ \mathbf{y} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The invariants \f$ \mathbf{h} \f$.
    %
    h( this, x, y, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system invariants \f$ \mathbf{h} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{Jh}_{\mathbf{x}}( \mathbf{x}, \mathbf{y}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{h}( \mathbf{x}, \mathbf{y}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param y Linear states \f$ \mathbf{y} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jh}_{\mathbf{x}} \f$.
    %
    Jh_x( this, x, y, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system invariants \f$ \mathbf{h} \f$ with
    %> respect to the linear states \f$ \mathbf{y} \f$:
    %>
    %> \f[
    %> \mathbf{Jh}_{\mathbf{y}}( \mathbf{x}, \mathbf{y}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{h}
    %> }{
    %>   \partial \mathbf{y}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param y Linear states \f$ \mathbf{y} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jh}_{\mathbf{y}} \f$.
    %
    Jh_y( this, x, y, t )
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
