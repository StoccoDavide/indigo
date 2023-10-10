
function [x_out, x_dot_out, d_t_star, ierr] = step( this, x_k, x_dot_k, t_k, d_t )
  [x_out, x_dot_out, d_t_star, ierr] = this.implicit_step( x_k, x_dot_k, t_k, d_t )
end
