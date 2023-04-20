%
%> Class container for the system of Ordinary Differential Equations (ODEs)
%> or Differential Algebraic Equations (DAEs).
%
classdef BaseODE < handle
  %
  properties (SetAccess = protected, Hidden = true)
    %
    %> Name of the system of ODEs/DAEs (used in warning/error messages).
    %
    m_name;
    %
    %> Number of equations of the system of ODEs/DAEs.
    %
    m_num_eqns;
    %
    %> Number of invariants/hidden contraints of the system of ODEs/DAEs.
    %
    m_num_invs;
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor for a system of ODEs/DAEs that requires the following
    %> inputs:
    %>
    %> \param t_num_ame The name of the system of ODEs/DAEs.
    %> \param t_num_eqn The number of equations of the system of ODEs/DAEs.
    %> \param t_num_inv The number of invariants/hidden contraints of the system
    %>                  of ODEs/DAEs.
    %
    function this = BaseODE( t_name, t_num_eqns, t_num_invs )
      this.m_name     = t_name;
      this.m_num_eqns = t_num_eqns;
      this.m_num_invs = t_num_invs;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the system of ODEs/DAEs name.
    %>
    %> \return The system of ODEs/DAEs name.
    %
    function out = get_name( this )
      out = this.m_name;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the number of equations of the system of ODEs/DAEs.
    %>
    %> \return The number of equations of the system of ODEs/DAEs.
    %
    function t_num_eqns = get_num_eqns( this )
      t_num_eqns = this.m_num_eqns;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the number of equations of the system of ODEs/DAEs.
    %>
    %> \param t_num_eqns The number of equations of the system of ODEs/DAEs.
    %
    function set_num_eqns( this, t_num_eqns )
      this.m_num_eqns = t_num_eqns;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the number of invariants/hidden contraints of the system of ODEs/DAEs.
    %>
    %> \return The number of invariants/hidden contraints of the system of
    %>         ODEs/DAEs.
    %
    function t_num_invs = get_num_invs( this )
      t_num_invs = this.m_num_invs;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the number of invariants/hidden constraints of the system of ODEs/DAEs.
    %>
    %> \param t_num_invs The number of invariants/hidden constraints of the system
    %>                   of ODEs/DAEs.
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
    %> Get the system of ODEs/DAEs type.
    %>
    %> \return The system of ODEs/DAEs type.
    %
    type()
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the system of ODEs/DAEs is explicit.
    %>
    %> \return True if the system of ODEs/DAEs is explicit, false otherwise.
    %
    is_explicit()
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Check if the system of ODEs/DAEs is implicit.
    %>
    %> \return True if the system of ODEs/DAEs is implicit, false otherwise.
    %
    is_implicit()
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
  %
end
