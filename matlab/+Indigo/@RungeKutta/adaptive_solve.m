%> Solve the system and calculate the approximate solution over the
%> suggested mesh of time points with adaptive step size control.
%>
%> \param t     Time mesh points \f$ \mathbf{t} = \left[ t_0, t_1, \ldots,
%>              t_n \right]^T \f$.
%> \param x_0   Initial states value \f$ \mathbf{x}(t_0) \f$.
%> \param t_min [optional] Minimum timestep \f$ \Delta t_{\mathrm{min}} \f$.
%> \param t_max [optional] Maximum timestep \f$ \Delta t_{\mathrm{max}} \f$.
%>
%> \return A matrix \f$ \left[(\mathrm{size}(\mathbf{x}) \times \mathrm{size}
%>         (\mathbf{t})\right] \f$ containing the approximated solution
%>         \f$ \mathbf{x}(t) \f$ and \f$ \mathbf{x}^\prime(t) \f$ of the
%>         system. Additionally, the veils \f$ \mathbf{v}(t) \f$ and
%>         invariants \f$ \mathbf{h}(\mathbf{x}, \mathbf{v}, t) \f$ are also
%>         returned.
%
function [x_out, t_out, v_out, h_out] = adaptive_solve( this, t, x_0, varargin )

  CMD = 'Indigo.RungeKutta.adaptive_solve(...): ';

  % Collect optional arguments
  d_t = t(2) - t(1);
  if (nargin == 3)
    scale = 100.0;
    t_min = max(this.m_d_t_min, d_t/scale);
    t_max = scale*d_t;
  elseif (nargin == 4)
    [t_min, t_max] = varargin{1};
  elseif (nargin == 5)
    t_min = varargin{1};
    t_max = varargin{2};
  else
    error([CMD, 'invalid number of inputs detected.']);
  end
  assert(t_max > t_min && t_min > 0, [CMD, 'invalid time bounds detected.']);
  d_t = max(min(d_t, t_max), t_min);

  % Check initial conditions
  num_eqns = this.m_sys.get_num_eqns();
  num_veil = this.m_sys.get_num_veil();
  num_invs = this.m_sys.get_num_invs();
  assert(num_eqns == length(x_0), ...
    [CMD, 'in %s solver, length(x_0) is %d, expected %d.'], ...
    this.m_name, length(x_0), num_eqns);

  % Instantiate output
  safety_length = ceil(1.5/this.m_factor_min)*length(t);
  t_out = zeros(1, safety_length);
  x_out = zeros(num_eqns, safety_length);
  v_out = zeros(num_veil, safety_length);
  h_out = zeros(num_invs, safety_length);

  % Store first step
  t_out(1)   = t(1);
  x_out(:,1) = x_0(:);
  v_out(:,1) = this.m_sys.v(x_0, t(1));
  y_out(:,1) = this.m_sys.y(x_0, v_out(:,1), t(1));
  h_out(:,1) = this.m_sys.h(x_0, y_out(:,1), v_out(:,1), t(1));

  % Instantiate temporary variables
  s = 1; % Current step

  % Start progress bar
  if (this.m_progress_bar)
    Indigo.Utils.progress_bar('_start');
  end

  while (true)
    % Print percentage of solution completion
    if (this.m_progress_bar)
      Indigo.Utils.progress_bar(ceil(100*t_out(s)/t(end)))
    end

    % Integrate system
    [x_new, d_t_star, ~] = this.advance(x_out(:,s), t_out(s), d_t);

    % Store solution
    t_out(s+1)   = t_out(s) + d_t;
    x_out(:,s+1) = x_new;
    v_out(:,s+1) = this.m_sys.v(x_new,  t_out(s+1));
    y_out(:,s+1) = this.m_sys.y(x_new, v_out(:,s+1), t_out(s+1));
    h_out(:,s+1) = this.m_sys.h(x_new, y_out(:,s+1), v_out(:,s+1), t_out(s+1));

    % Saturate the suggested timestep
    d_t = max(min(d_t_star, t_max), t_min);

    % Check if the current step is the last one
    if (t_out(s+1) + d_t > t(end))
      break;
    end

    % Update steps counter
    s = s+1;
  end

  % End progress bar
  if (this.m_progress_bar)
    Indigo.Utils.progress_bar(100);
    if (this.m_projection)
      bar_str = sprintf('Projected-%s completed! (%d steps)', this.m_name, s);
    else
      bar_str = sprintf('%s completed! (%d steps)', this.m_name, s);
    end
    Indigo.Utils.progress_bar(bar_str);
  end

  % Resize the output
  t_out = t_out(:,1:s-1);
  x_out = x_out(:,1:s-1);
  v_out = v_out(:,1:s-1);
  h_out = h_out(:,1:s-1);
end
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%