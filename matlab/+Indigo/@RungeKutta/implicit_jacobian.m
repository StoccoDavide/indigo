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
function out = implicit_jacobian( this, x_k, K_in, t_k, d_t )

  % Extract lengths
  nc = length(this.m_c);
  nx = length(x_k);
  K  = reshape(K_in, nx, nc);

  % Get the number of veils
  num_veil = this.m_sys.get_num_veil();

  % The Jacobian is a square nc*nx (i.e., length(K)) matrix
  out = eye(nc*nx);

  % Loop through each equation of the system
  idx = 1:nx;
  for i = 1:nc
    t_i = t_k + this.m_c(i) * d_t;
    x_i = x_k + K * this.m_A(i,:).';
    v_i = this.m_sys.v(x_i,t_i);

    % Compute the Jacobians with respect to x and x_dot
    x_dot_i = K(:,i)./d_t;
    JF_x     = this.m_sys.JF_x     (x_i, x_dot_i, v_i, t_i);
    JF_x_dot = this.m_sys.JF_x_dot (x_i, x_dot_i, v_i, t_i);

    % Add the contribution of veils to the Jacobian
    if (num_veil > 0)
      JF_x = JF_x + this.m_sys.JF_v(x_i, x_dot_i, v_i, t_i) * ...
                    this.m_sys.Jv_x(x_i,          v_i, t_i);
    end

    % Derivative of F(x_i, K(:,i)/d_t, t_i)
    jdx = 1:nx;
    for j = 1:nc
      % Combine the Jacobians with respect to x and x_dot to obtain the
      % Jacobian with respect to K
      if (i == j)
        out(idx, jdx) = this.m_A(i,j) * JF_x + JF_x_dot./d_t;
      else
        out(idx, jdx) = this.m_A(i,j) * JF_x;
      end

      jdx = jdx + nx;
    end
    idx = idx + nx;
  end
end
