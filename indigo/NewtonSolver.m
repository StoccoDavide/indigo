%
%> Function implementing a dumped Newton's method with affine invariant step.
%>
%> **Solution Algorithm:**
%>
%> Given a zeros of a vectorial function problem of the form \f$ \mathbf{F}
%> (\mathbf{x}) = \mathbf{0} \f$, where \f$ \mathbf{F}: \mathbb{R}^n \rightarrow
%> \mathbb{R}^n \f$, then the Newton's method is defined as:
%>
%> \f[
%> \mathbf{JF}(\mathbf{x}_k)\mathbf{h} = -\mathbf{F}(\mathbf{x}_k).
%> \f]
%>
%> The dumped step is defined as:
%>
%> \f[
%> \mathbf{x}_{k+1} = \mathbf{x}_k + \alpha_k \mathbf{h}
%> \f]
%>
%> where \f$ \alpha_k \f$ is a dumping coefficient that satisfies:
%>
%> \f[
%> \left\| \mathbf{JF}(\mathbf{x}_k)^{-1} \mathbf{F}(\mathbf{x}_{k+1}) \right\|
%> \leq \left(1 - \dfrac{\alpha_k}{2}\right) \left\| \mathbf{JF}(\mathbf{x}_k)^{-1}
%> \mathbf{F}(\mathbf{x}_k) \right\| = \left(1 - \dfrac{\alpha_k}{2} \right)
%> \left\| \mathbf{h}  \right\|.
%> \f]
%>
%> **Note:**
%>
%> For more details on the Newton's method with affine invariant step refer to:
%> https://www.zib.de/deuflhard/research/algorithm/ainewton.en.html.
%>
%>  \param fun       Function handle of the vectorial function
%>                   \f$ \mathbf{F}(\mathbf{x}) \f$.
%>  \param jac       Function handle of Jacobian matrix
%>                   \f$ \mathbf{JF}(\mathbf{x}) \f$.
%>  \param x_0       Initial guess of the solution.
%>  \param VERBOSE   [optional, default = \f$ \mathrm{false} \f$] enable verbose mode.
%>  \param TOLERANCE [optional, default = \f$ 1.0e^{-8} \f$] Convergence tolerance.
%>  \param ITER_NWTN [optional, default = \f$ 50 \f$] Maximum number of Newton iterations.
%>  \param ITER_DUMP [optional, default = \f$ 50 \f$] Maximum number of Dumping iterations.
%>  \param ALPHA     [optional, default = \f$ 0.5 \f$] Dumping coefficient.
%>
%> \return The solution \f$ \mathbf{x} \f$ and the output flag: \f$ 0 \f$ =
%>         success, \f$ 1 \f$ = failed because of bad initial point, \f$ 2 \f$ =
%>         failed because of bad dumping (step got too short).
%
function [x, flag] = NewtonSolver( fun, jac, x_0, varargin )

  CMD = 'indigo::NewtonSolver(...) ';

  assert(any(isnan(x_0)), ...
    [CMD, 'invalid initial guess of the solution.']);

  flag      = 0;
  VERBOSE   = false;
  TOLERANCE = 1.0e-08;
  ITER_NWTN = 50;
  ITER_DUMP = 50;
  ALPHA     = 0.5;

  % Collect verbose flag
  if (nargin > 3)
    VERBOSE = varargin{1};
  end

  % Collect tolerance
  if (nargin > 4)
    TOLERANCE = varargin{2};
  end

  % Collect Newton's maximum number of iterations
  if (nargin > 5)
    ITER_NWTN = varargin{3};
  end

  % Collect dumping maximum number of iterations
  if (nargin > 6)
    ITER_DUMP = varargin{4};
  end

  % Collect dumping coefficient
  if (nargin > 7)
    ALPHA = varargin{5};
  end

  % Check for too many input arguments
  if (nargin > 8)
    error([CMD, 'too many input arguments!']);
  end

  if (VERBOSE == true)
    fprintf(1, 'NEWTON SOLVER\n' );
  end

  % Perform Newton iteration
  x = x_0;
  for i = 1:ITER_NWTN

    % Evaluate function and Jacobian
    F  = feval(fun, x);
    JF = feval(jac, x);

    % Check if converged
    if (norm(F, inf) < TOLERANCE)
      return;
    end

    % Evaluate search direction and its norm
    h  = -JF\F;
    nh = norm(h, 2);

    % Perform dumping iteration
    dumped = false;
    for j = 0:ITER_DUMP-1
      xd = x + ALPHA^j * h;
      if all(isfinite(xd))
        Fd = feval( fun, xd );
        hd = -JF\Fd;
        if norm(hd, 2) < sqrt(1 - ALPHA/2)*nh
          dumped = true;
          break;
        end
      end
    end

    if (dumped == false)
      if (VERBOSE == true)
        fprintf(1, 'NewtonSolver(...): alpha = %g, Failed dumping iteration!\n', ALPHA );
      end
      flag = 2;
      break;
    end

    x = xd;
    if (VERBOSE == true)
      fprintf(1, 'iter [%d]: ||F||_inf = %14g, alpha = %g\n', i, norm(F, inf), ALPHA );
    end
    if (norm(h, inf) < TOLERANCE)
      return;
    end
  end
end
