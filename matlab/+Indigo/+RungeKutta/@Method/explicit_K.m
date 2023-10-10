%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
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
  nc = length(this.m_c);
  K  = zeros(length(x_k),nc);
  for i = 1:nc
    % Compute node
    t_i = t_k + this.m_c(i) * d_t;
    %x_i = this.step_node(i, x_k, K, d_t);
    % Compute node
    x_i = zeros(length(x_k), 1);
    for j = 1:i-1
      x_i = x_i + this.m_A(i,j) * K(:,j);
    end
    x_i = x_k + x_i * d_t;

    v_i = this.m_sys.v(x_i, t_i);

    % If the Runge-Kutta method  and the system are both explicit then
    % calculate the K values directly
    K(:,i) = this.m_sys.f(x_i, v_i, t_i);
  end
end
