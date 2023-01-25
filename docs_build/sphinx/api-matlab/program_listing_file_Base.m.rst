
.. _program_listing_file_Base.m:

Program Listing for File Base.m
===============================

|exhale_lsh| :ref:`Return to documentation for file <file_Base.m>` (``Base.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

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
       %> \param name The name of the system of ODEs/DAEs;
       %> \param neqn The number of equations of the system of ODEs/DAEs;
       %> \param ninv The number of invariants/hidden contraints of the system of
       %>             ODEs/DAEs.
       %
       function this = Base( t_name, t_num_eqns, t_num_invs )
         this.m_name     = t_name;
         this.m_num_eqns = t_num_eqns;
         this.m_num_invs = t_num_invs;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Get the number of equations of the system of ODEs/DAEs.
       %>
       %> \return The number of equations of the system of ODEs/DAEs.
       %
       function out = get_num_eqns( this )
         out = this.m_num_eqns;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Set the number of equations of the system of ODEs/DAEs.
       %>
       %> \param num_eqns The number of equations of the system of ODEs/DAEs.
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
       function out = get_num_invs( this )
         out = this.m_num_invs;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Set the number of invariants/hidden constraints of the system of ODEs/DAEs.
       %>
       %> \param num_invs The number of invariants/hidden constraints of the system
       %>                 of ODEs/DAEs.
       %
       function set_num_invs( this, t_num_invs )
         this.m_num_invs = t_num_invs;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
   end
