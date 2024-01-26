%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
%> Solve the system and calculate the approximate solution over the mesh of
%> time points.
%>
%> \param t   Time mesh points \f$ \mathbf{t} = \left[ t_0, t_1, \ldots, t_n
%>            \right]^T \f$.
%> \param x_0 Initial states value \f$ \mathbf{x}(t_0) \f$.
%>
%> \return A matrix \f$ \left[(\mathrm{size}(\mathbf{x}) \times \mathrm{size}
%>         (\mathbf{t})\right] \f$ containing the approximated solution
%>         \f$ \mathbf{x}(t) \f$ and \f$ \mathbf{x}^\prime(t) \f$ of the
%>         system. Additionally, the veils \f$ \mathbf{v}(t) \f$ and
%>         invariants \f$ \mathbf{h}(\mathbf{x}, \mathbf{v}, t) \f$ are
%>         also returned.
%
function [x_out, t, v_out, h_out] = solve( this, t, x_0 )

  CMD = 'Indigo.RungeKutta.solve(...): ';

  % Check initial conditions
  num_eqns = this.m_sys.get_num_eqns();
  num_veil = this.m_sys.get_num_veil();
  num_invs = this.m_sys.get_num_invs();
  assert(num_eqns == length(x_0), ...
    [CMD, 'in %s solver, length(x_0) is %d, expected %d.'], ...
    this.m_name, length(x_0), num_eqns);

  % Instantiate output
  x_out = zeros(num_eqns, length(t));
  v_out = zeros(num_veil, length(t));
  h_out = zeros(num_invs, length(t));

  % Store first step
  x_out(:,1) = x_0(:);
  v_out(:,1) = this.m_sys.v(x_out(:,1), t(1));
  h_out(:,1) = this.m_sys.h(x_out(:,1), v_out(:,1), t(1));

  % Instantiate temporary variables
  s   = 1;         % Current step
  tol = sqrt(eps); % Tolerance

  % Update the current step
  x_s     = x_out(:,1);
  t_s     = t(1);
  d_t_s   = t(2) - t(1);
  d_t_tmp = d_t_s;

  % Start progress bar
  if (this.m_progress_bar)
    Indigo.Utils.progress_bar('_start');
  end

  while (true)
    % Print percentage of solution completion
    if (this.m_progress_bar)
      Indigo.Utils.progress_bar(ceil(100*t_s/t(end)))
    end

    % Integrate system
    [x_s, d_t_star, ierr ] = this.do_step( x_s, t_s, d_t_s);

    % Update the current step
    t_s = t_s + d_t_s;

    % Saturate the suggested timestep
    mesh_point_bool = abs(t_s - t(s+1)) < tol;
    saturation_bool = t_s + d_t_star > t(s+1) + tol;
    if (this.m_adaptive_step && ~mesh_point_bool && saturation_bool)
      d_t_tmp = d_t_star;
      d_t_s   = t(s+1) - t_s;
    else
      d_t_s = d_t_star;
    end

    % Store solution if the step is a mesh point
    if (~this.m_adaptive_step || mesh_point_bool)

      % Update temporaries
      s     = s+1;
      d_t_s = d_t_tmp;

      % Update outputs
      x_out(:,s) = x_s;
      v_out(:,s) = this.m_sys.v(x_out(:,s), t(s));
      h_out(:,s) = this.m_sys.h(x_out(:,s), v_out(:,s), t(s));

      % Check if the current step is the last one
      if (abs(t_s - t(end)) < tol)
        break;
      end
    end
  end

  % End progress bar
  if (this.m_progress_bar)
    Indigo.Utils.progress_bar(100);
    if (this.m_projection)
      bar_str = sprintf('Projected-%s completed! [nstep=%d]', this.m_name, s);
    else
      bar_str = sprintf('%s completed! [nstep=%d]', this.m_name, s);
    end
    Indigo.Utils.progress_bar(bar_str);
  end
end
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%