
.. _program_listing_file_+Indigo_+Systems_System.m:

Program Listing for File System.m
=================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_+Systems_System.m>` (``+Indigo/+Systems/System.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for the system of Ordinary Differential Equations (ODEs)
   %> or Differential Algebraic Equations (DAEs). This class is the base class
   %> for more specific systems, such as the explicit, semi-explicit and implicit
   %> systems. The system *must* define the abstract methods. The system is defined
   %> by the following equations:
   %>
   %> \f[
   %> \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t ) = \mathbf{0}
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
       %> Number of veils of the system.
       %
       m_num_veil;
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
       %> \param t_num_veil The number of (user-defined) veils of the system.
       %> \param t_num_invs The number of invariants of the system.
       %
       function this = System( t_name, t_num_eqns, t_num_veil, t_num_invs )
         this.m_name     = t_name;
         this.m_num_eqns = t_num_eqns;
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
       %> \param v     Veils \f$ \mathbf{v} \f$.
       %> \param t     Independent variable \f$ t \f$.
       %>
       %> \return The system function \f$ \mathbf{F} \f$.
       %
       F( this, x, x_dot, v, t )
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
       JF_x( this, x, x_dot, v, t )
       %
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
       JF_x_dot( this, x, x_dot, v, t )
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
       JF_v( this, x, x_dot, v, t )
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
       %>   \partial \mathbf{h}( \mathbf{x}, t )
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
       %> Evaluate the system invariants \f$ \mathbf{h} \f$:
       %>
       %> \f[
       %> \mathbf{h}( \mathbf{x}, \mathbf{v}, t ) = \mathbf{0}.
       %> \f]
       %>
       %> \param x States \f$ \mathbf{x} \f$.
       %> \param v Veils \f$ \mathbf{v} \f$.
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
       %> }.
       %> \f]
       %>
       %> \param x States \f$ \mathbf{x} \f$.
       %> \param v Veils \f$ \mathbf{v} \f$.
       %> \param t Independent variable \f$ t \f$.
       %>
       %> \return The Jacobian \f$ \mathbf{Jh}_{\mathbf{x}} \f$.
       %
       Jh_x( this, x, v, t )
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Evaluate the Jacobian of the system invariants \f$ \mathbf{h} \f$ with
       %> respect to the veils \f$ \mathbf{v} \f$:
       %>
       %> \f[
       %> \mathbf{Jh}_{\mathbf{v}}( \mathbf{x}, \mathbf{v}, t ) =
       %> \dfrac{
       %>   \partial \mathbf{h}
       %> }{
       %>   \partial \mathbf{v}
       %> }.
       %> \f]
       %>
       %> \param x States \f$ \mathbf{x} \f$.
       %> \param v Veils \f$ \mathbf{v} \f$.
       %> \param t Independent variable \f$ t \f$.
       %>
       %> \return The Jacobian \f$ \mathbf{Jh}_{\mathbf{v}} \f$.
       %
       Jh_v( this, x, v, t )
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
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
