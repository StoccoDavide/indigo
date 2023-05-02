
.. _program_listing_file_indigo_Systems_ImplicitSystem.m:

Program Listing for File ImplicitSystem.m
=========================================

|exhale_lsh| :ref:`Return to documentation for file <file_indigo_Systems_ImplicitSystem.m>` (``indigo/Systems/ImplicitSystem.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for an implicit system of ODEs/DAEs of the form:
   %>
   %> \f[
   %> \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t ) = \mathbf{0}
   %> \f]
   %>
   %> with *optional* index-1 variables \f$ \mathbf{v}( \mathbf{x}, t ) \f$, and
   %> invariants of the form:
   %>
   %> \f[
   %> \mathbf{h}( \mathbf{x}, \mathbf{v}, t ) = \mathbf{0}
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
       %> Class constructor for a implicit system.
       %>
       %> \param t_name Name of the system.
       %> \param t_neqn Number of equations of the system.
       %> \param t_ninv Number of invariants of the system.
       %
       function this = ImplicitSystem( t_name, t_neqn, t_ninv )
         this@BaseSystem(t_name, t_neqn, t_ninv);
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Evaluate the Jacobians of the system function \f$ \mathbf{F} \f$ with
       %> respect to the states \f$ \mathbf{x} \f$ and states derivatives of
       %> \f$ \mathbf{x}' \f$:
       %>
       %> \f[
       %> \mathbf{JF}_{\mathbf{x}}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t ) =
       %> \dfrac{
       %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t )
       %> }{
       %>   \partial \mathbf{x}
       %> },
       %> \qquad
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
       %> \param v     Index-1 variables \f$ \mathbf{v} \f$.
       %> \param t     Independent variable \f$ t \f$.
       %>
       %> \return The Jacobians \f$ \mathbf{JF}_{\mathbf{x}} \f$ and \f$
       %>         \mathbf{JF}_{\mathbf{x}'} \f$.
       %
       function [JF_x, JF_x_dot] = JF( this, x, x_dot, v, t )
         JF_x = this.JF_x(x, x_dot, v, t) + ...
                this.JF_v(x, x_dot, v, t) * this.Jv_x(x, t);
         JF_x_dot = this.JF_x_dot(x, x_dot, v, t);
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
       %> \param v     Index-1 variables \f$ \mathbf{v} \f$.
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
       %> \param v     Index-1 variables \f$ \mathbf{v} \f$.
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
       %> \param v     Index-1 variables \f$ \mathbf{v} \f$.
       %> \param t     Independent variable \f$ t \f$.
       %>
       %> \return The Jacobian \f$ \mathbf{JF}_{\mathbf{x}'} \f$.
       %
       JF_x_dot( this, x, x_dot, v, t )
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Evaluate the Jacobian of the system function \f$ \mathbf{F} \f$ with
       %> respect to the index-1 variables \f$ \mathbf{v} \f$:
       %>
       %> \f[
       %> \mathbf{JF}_{\mathbf{v}}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t ) =
       %> \dfrac{
       %>   \partial \mathbf{F}( \mathbf{x}, \mathbf{x}', \mathbf{v}, t )
       %> }{
       %>   \partial \mathbf{v}
       %> }
       %> \f]
       %>
       %> \param x     States \f$ \mathbf{x} \f$.
       %> \param x_dot States derivatives \f$ \mathbf{x}' \f$.
       %> \param v     Index-1 variables \f$ \mathbf{v} \f$.
       %> \param t     Independent variable \f$ t \f$.
       %>
       %> \return The Jacobian \f$ \mathbf{JF}_{\mathbf{v}} \f$.
       %
       JF_v( this, x, x_dot, v, t )
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
         out = 'implicit';
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
         out = true;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
   end
