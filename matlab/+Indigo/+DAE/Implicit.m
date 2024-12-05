%
%> Class container for an implicit system of ODEs/DAEs of the form:
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
classdef Implicit < Indigo.DAE.System
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor for a implicit system.
    %>
    %> \param t_name     The name of the system.
    %> \param t_num_eqns The number of equations of the system.
    %> \param t_num_sysy The number of linear index-1 variables of the system.
    %> \param t_num_veil The number of (user-defined) veils of the system.
    %> \param t_num_invs The number of invariants of the system.
    %
    function this = Implicit( t_name, t_num_eqns, t_num_sysy, t_num_veil, t_num_invs )
      this@Indigo.DAE.System(t_name, t_num_eqns, t_num_sysy, t_num_veil, t_num_invs);
    end
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
