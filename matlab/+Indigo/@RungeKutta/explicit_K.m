%> Solve the \f$ i \f$-th explicit step of the system and find the
%> \f$ \mathbf{K}_i \f$ variable:
%>
%> \f[
%> \mathbf{F}_i\left(\mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{i-1}
%>   a_{ij} \mathbf{K}_j, \, \mathbf{K}_i, \, t_k + c_i \Delta t
%> \right) = \mathbf{0}
%> \f]
%>
%> by Newton's method.
%>
%> \param x_k States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
%> \param K   Initial guess for the \f$ \mathbf{K} \f$ variable to be found.
%> \param t_k Time step \f$ t_k \f$.
%> \param d_t Advancing time step \f$ \Delta t\f$.
%>
%> \return The \f$ \mathbf{K} \f$ variables of the system to be solved and
%>         the error control flag.
%
function K = explicit_K( this, x_k, t_k, d_t )

  % Number of stages
  nc = length(this.m_c);

  % Initialize the K vector
  K  = zeros(length(x_k),nc);

  for i = 1:nc
    % Compute the time and state values for the i-th stage
    t_i = t_k + this.m_c(i) * d_t;
    x_i = x_k + K(:,1:i-1) * this.m_A(i,1:i-1).';
    v_i = this.m_sys.v(x_i,t_i);

    % If the Runge-Kutta method and the system are both explicit then calculate
    % the K values directly
    K(:,i) = d_t * this.m_sys.f( x_i, v_i, t_i );
  end
end
