%
%> Class container for the system of Ordinary Differential Equations (ODEs)
%> or Differential Algebraic Equations (DAEs).
%
classdef Base < handle
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
    %> Number of invariants/contraints of the system of ODEs/DAEs.
    %
    m_num_invs;
  end
  %
  methods
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Class constructor that initializes the following properties:
    %> - *name* Name of the system of ODEs/DAEs;
    %> - *neqn* Number of equations of the system of ODEs/DAEs;
    %> - *ninv* Number of invariants/contraints of the system of ODEs/DAEs.
    %
    function this = Base( name, num_eqns, num_invs )
      this.m_name     = name;
      this.m_num_eqns = num_eqns;
      this.m_num_invs = num_invs;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the number of equations of the system of ODEs/DAEs.
    %
    function out = get_num_eqns( this )
      out = this.m_num_eqns;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Get the number of invariants/contraints of the system of ODEs/DAEs.
    %
    function out = get_num_invs( this )
      out = this.m_num_invs;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the number of equations of the system of ODEs/DAEs.
    %
    function set_num_eqns( this, num_eqns )
      this.m_num_eqns = num_eqns;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
    %> Set the number of invariants/hidden constraints of the system of ODEs/DAEs.
    %
    function set_num_invs( this, num_invs )
      this.m_num_invs = num_invs;
    end
    %
    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    %
  end
end
