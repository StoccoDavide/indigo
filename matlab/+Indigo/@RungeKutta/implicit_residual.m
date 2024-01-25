%> Compute the residual of system to be solved:
%>
%> \f[
%> \mathbf{F}_i\left(\mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^{s}
%>   a_{ij} \mathbf{K}_j, \, \mathbf{K}_i, \, t_k + c_i \Delta t
%> \right) = \mathbf{0}.
%> \f]
%>
%> \param x_k States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
%> \param K   Variable \f$ \mathbf{K} \f$ of the system to be solved.
%> \param t_k Time step \f$ t_k \f$.
%> \param d_t Advancing time step \f$ \Delta t\f$.
%>
%> \return The residual of system to be solved.
%
function out = implicit_residual( this, x_k, K, t_k, d_t )

  % Extract lengths
  nc = length(this.m_c);
  nx = length(x_k);

  % There are as many residuals as equations in the system
  out = zeros(nc*nx, 1);

  % Loop through each equation of the system
  idx = 1:nx;
  for i = 1:nc
    % Compute x_k + sum(a_ij*Kj, j)
    x_i = x_k;
    jdx = 1:nx;
    for j = 1:nc
      x_i = x_i + d_t * this.m_A(i,j) * K(jdx);
      jdx = jdx + nx;
    end

    % Compute the residuals
    t_i = t_k + this.m_c(i) * d_t;
    v_i = this.m_sys.v(x_i, t_i);
    out(idx) = this.m_sys.F(x_i, K(idx), v_i, t_i);
    idx = idx + nx;
  end
end
