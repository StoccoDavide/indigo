
.. _program_listing_file_+Indigo_@RungeKutta_set_tableau.m:

Program Listing for File set_tableau.m
======================================

|exhale_lsh| :ref:`Return to documentation for file <file_+Indigo_@RungeKutta_set_tableau.m>` (``+Indigo/@RungeKutta/set_tableau.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %> Set the Butcher tableau.
   %>
   %> \param tbl.A   Matrix \f$ \mathbf{A} \f$ (lower triangular matrix).
   %> \param tbl.b   Weights vector \f$ \mathbf{b} \f$ (row vector).
   %> \param tbl.b_e [optional] Embedded weights vector \f$ \hat{\mathbf{b}} \f$
   %>                (row vector).
   %> \param tbl.c   Nodes vector \f$ \mathbf{c} \f$ (column vector).
   %
   function set_tableau( this, tbl )
   
     CMD = 'Indigo.RungeKutta.set_tableau(...): ';
   
     % Check the Butcher tableau
     [ok, ~, ~] = this.check_tableau(tbl);
     assert(ok, [CMD, 'invalid tableau detected.']);
   
     % Set the tableau
     this.m_A   = tbl.A;
     this.m_b   = tbl.b;
     this.m_b_e = tbl.b_e;
     this.m_c   = tbl.c;
   
     % Set boolean flags
     if istril(this.m_A)
       if all(diag(this.m_A)==0)
         % Explicit tableau
         this.m_rk_type = 'ERK';
       elseif (length(this.m_c) > 1)
         % Diagonally implicit tableau
         this.m_rk_type = 'DIRK';
       else
         % Mixed case, threat it as implicit
         this.m_rk_type = 'IRK';
       end
     else
       this.m_rk_type = 'IRK';
     end
     this.m_is_embedded = ~isempty(this.m_b_e);
   
     % Update the solver properties
     this.m_adaptive_step = this.m_is_embedded;
   end
