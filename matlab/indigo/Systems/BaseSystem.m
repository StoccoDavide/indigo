%
%> Class container for the system of Ordinary Differential Equations (ODEs)
%> or Differential Algebraic Equations (DAEs).
%
classdef BaseSystem < handle
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
    %> \param t_num_ame The name of the system.
    %> \param t_num_eqn The number of equations of the system.
    %> \param t_num_inv The number of invariants of the system.
    %>                 .
    %
    function this = BaseSystem( t_name, t_num_eqns, t_num_invs )
      this.m_name     = t_name;
      this.m_num_eqns = t_num_eqns;
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
  end
  %
  methods (Abstract)
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the system invariants \f$ \mathbf{h} \f$:
    %>
    %> \f[
    %> \mathbf{h}( \mathbf{x}, \mathbf{v}, t ) = \mathbf{0}.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param v Index-1 variables \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The invariants \f$ \mathbf{h} \f$..
    %
    h( this, x, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system invariants \f$ \mathbf{h} \f$ with
    %> respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{Jh}_{\mathbf{x}}( \mathbf{x}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{h}( \mathbf{x}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> } + \dfrac{
    %>   \partial \mathbf{h}
    %> }{
    %>   \partial \mathbf{v}
    %> } \dfrac{
    %>   \partial \mathbf{v}( \mathbf{x}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param v Index-1 variables \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jh}_{\mathbf{x}} \f$.
    %
    Jh_x( this, x, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system invariants \f$ \mathbf{h} \f$ with
    %> respect to the index-1 variables \f$ \mathbf{v} \f$:
    %>
    %> \f[
    %> \mathbf{Jv}_{\mathbf{x}}( \mathbf{x}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{h}
    %> }{
    %>   \partial \mathbf{v}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param v Index-1 variables \f$ \mathbf{v} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jh}_{\mathbf{v}} \f$.
    %
    Jh_v( this, x, v, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the system index-1 variables \f$ \mathbf{v} \f$:
    %>
    %> \f[
    %> \mathbf{v}( \mathbf{x}, t ) = \mathbf{0}.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The invariants \f$ \mathbf{h} \f$..
    %
    v( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Evaluate the Jacobian of the system index-1 variables \f$ \mathbf{v} \f$
    %> with respect to the states \f$ \mathbf{x} \f$:
    %>
    %> \f[
    %> \mathbf{Jv}_{\mathbf{x}}( \mathbf{x}, \mathbf{v}, t ) =
    %> \dfrac{
    %>   \partial \mathbf{h}( \mathbf{x}, \mathbf{v}, t )
    %> }{
    %>   \partial \mathbf{x}
    %> }.
    %> \f]
    %>
    %> \param x States \f$ \mathbf{x} \f$.
    %> \param t Independent variable \f$ t \f$.
    %>
    %> \return The Jacobian \f$ \mathbf{Jv}_{\mathbf{x}} \f$.
    %
    Jv_x( this, x, t )
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %
    %> Get the system type.
    %>
    %> \return The system type.
    %
    type()
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
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
