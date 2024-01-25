%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%> Compute the Jacobian of the system of equations:
%>
%> \f[
%> \mathbf{F}_i\left(\mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^s
%>   a_{ij} \mathbf{K}_j, \, \mathbf{K}_i, \, t_k + c_i \Delta t
%> \right) = \mathbf{0}
%> \f]
%>
%> to be solved in the \f$ \mathbf{K} \f$ variable:
%>
%> \f[
%> \dfrac{\partial \mathbf{F}_i}{\partial \mathbf{K}_i} \left(
%>   \mathbf{x}_k + \Delta t \displaystyle\sum_{j=1}^s a_{ij} \mathbf{K}_j,
%>   \, \mathbf{K}_i, \, t_k + c_i \Delta t
%> \right)
%> \f]
%>
%> \param i   Index of the step to be computed.
%> \param x_i States value at \f$ i \f$-th node.
%> \param K   Variable \f$ \mathbf{K} \f$ of the system to be solved.
%> \param t_k Time step \f$ t_k \f$.
%> \param d_t Advancing time step \f$ \Delta t\f$.
%>
%> \return The Jacobian of the system of equations to be solved.
%
function out = implicit_jacobian( this, x_k, K, t_k, d_t )

  % Get the number of veils
  num_veil = this.m_sys.get_num_veil();

  % Extract lengths
  nc = length(this.m_c);
  nx = length(x_k);

  % The Jacobian is a square nc*nx (i.e., length(K)) matrix
  out = eye(nc*nx);

  % Loop through each equation of the system
  idx = 1:nx;
  for i = 1:nc
    % Compute x_k + sum(a_ij*Kj, j)
    x_tmp = x_k;
    jdx = 1:nx;
    for j = 1:nc
      x_tmp = x_tmp + d_t * this.m_A(i,j) * K(jdx);
      jdx = jdx + nx;
    end
    jdx = 1:nx;
    for j = 1:nc
      % Mask for the Jacobian with respect to x_dot
      mask = 0;
      if (i == j)
        mask = 1;
      end

      % Compute the Jacobians with respect to x and x_dot
      t_tmp    = t_k + d_t * this.m_c(i);
      v_tmp    = this.m_sys.v(x_tmp, t_tmp);
      JF_x     = this.m_sys.JF_x(x_tmp, K(idx), v_tmp, t_tmp);%
      JF_x_dot = this.m_sys.JF_x_dot(x_tmp, K(idx), v_tmp, t_tmp);

      % Add the contribution of veils to the Jacobian
      if (num_veil > 0)
        JF_x = JF_x + this.m_sys.JF_v(x_tmp, K(idx), v_tmp, t_tmp) * ...
                      this.m_sys.Jv_x(x_tmp, v_tmp, t_tmp);
      end

      % Combine the Jacobians with respect to x and x_dot to obtain the
      % Jacobian with respect to K
      out(idx, jdx) = d_t * this.m_A(i,j) * JF_x  + JF_x_dot * mask;

      jdx = jdx + nx;
    end
    idx = idx + nx;
  end
end
