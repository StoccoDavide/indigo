% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                                                                     %
% The DIAL project - Course of MECHATRONICS SYSTEM SIMULATION         %
%                                                                     %
% Copyright (c) 2020, Davide Stocco and Enrico Bertolazzi, Francesco  %
% Biral                                                               %
%                                                                     %
% The DIAL project and its components are supplied under the terms of %
% the open source BSD 2-Clause License. The contents of the DIAL      %
% project and its components may not be copied or disclosed except in %
% accordance with the terms of the BSD 2-Clause License.              %
%                                                                     %
% URL: https://opensource.org/licenses/BSD-2-Clause                   %
%                                                                     %
%    Davide Stocco                                                    %
%    Department of Industrial Engineering                             %
%    University of Trento                                             %
%    e-mail: davide.stocco@unitn.it                                   %
%                                                                     %
%    Enrico Bertolazzi                                                %
%    Department of Industrial Engineering                             %
%    University of Trento                                             %
%    e-mail: enrico.bertolazzi@unitn.it                               %
%                                                                     %
%    Francesco Biral                                                  %
%    Department of Industrial Engineering                             %
%    University of Trento                                             %
%    e-mail: francesco.biral@unitn.it                                 %
%                                                                     %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
%> Function implementing the Dumped Newton Solver.
%> Solve \rst ..math:`J(x_k) h = -F(x_k)` \endrst and update \rst ..math:`x_{k+1} = x_k + \alpha_k h` \endrst where \rst ..math:`\alpha_k` \endrst satisfies \rst ..math:`\norm{J(x_k)^{-1} F(x_{k+1})} \leq (1 - \frac{\alpha_k}{2}) \norm{J(x_k)^{-1} F(x_k)} = (1 - \frac{\alpha_k}{2}) \norm{h}` \endrst.
%> This is called Affine invariant Newton step (see
%> https://www.zib.de/deuflhard/research/algorithm/ainewton.en.html).
%>
%> Output flags:
%>  - flag = 0 -> solution found;
%>  - flag = 1 -> failed because of bad initial point;
%>  - flag = 2 -> failed because of step too short, filed linesearch.
%>
%> Inputs:
%>  - fun       -> function F(x) = feval( fun, x );
%>  - jac       -> Jacobian matrix of the function J(x) = feval( jac, x );
%>  - x_0       -> initial guess;
%>  - VERBOSE   -> [optional, defalut = false] enable verbose mode;
%>  - TOLERANCE -> [optional, defalut = 1.0e-08] tolerance;
%>  - ITER_NWTN -> [optional, defalut = 50] maximum number of Newton iterations;
%>  - ITER_DUMP -> [optional, defalut = 50] maximum number of Dumping iterations;
%>  - ALPHA     -> [optional, defalut = 0.5] dumping coefficient
%
function [x, flag] = NewtonSolver( fun, jac, x_0, varargin )
  flag = 0;
  x    = x_0 ;

  if any(isnan(x_0))
    fprintf(1, 'NewtonSolver: Bad initial point!\n' ) ;
    flag = 1;
    return;
  end

  VERBOSE   = false;
  TOLERANCE = 1.0e-08;
  ITER_NWTN = 50;
  ITER_DUMP = 50;
  ALPHA     = 0.5;

  if nargin > 3
    VERBOSE = varargin{1};
  end

  if nargin > 4
    TOLERANCE = varargin{2};
  end

  if nargin > 5
    ITER_NWTN = varargin{3};
  end

  if nargin > 6
    ITER_DUMP = varargin{4};
  end

  if nargin > 7
    ALPHA = varargin{5};
  end

  if VERBOSE
    fprintf(1, 'NEWTON SOLVER\n' );
  end

  % Perform Newton iteration
  for i = 1:ITER_NWTN

    % Direction search
    F  = feval( fun, x );
    JF = feval( jac, x );


    % Check if converged
    if norm(F,inf) < TOLERANCE
      return;
    end
    
    % Evaluate search direction
    h  = -JF\F;
    nh = norm(h,2);

    % Perform Dumping iteration
    dumped = false;
    for j = 0:ITER_DUMP-1
      xd = x + ALPHA^j * h;
      if all(isfinite(xd))
        Fd = feval( fun, xd );
        hd = -JF\Fd;
        if norm(hd,2) < sqrt(1-ALPHA/2)*nh
          dumped = true;
          break;
        end
      end
    end
    
    if ~dumped
      if VERBOSE
        fprintf(1, 'NewtonSolver(...): alpha = %g, Failed dumping iteration!\n', ALPHA );
      end
      flag = 2;
      break;
    end
    
    x = xd;
    if VERBOSE
      fprintf(1, 'iter [%d]: ||F||_inf = %14g, alpha = %g\n', i, norm(F,inf), ALPHA );
    end
    if norm(h,inf) < TOLERANCE
      return;
    end
  end
end