
.. _program_listing_file_ODE_ODEsolver.m:

Program Listing for File ODEsolver.m
====================================

|exhale_lsh| :ref:`Return to documentation for file <file_ODE_ODEsolver.m>` (``ODE/ODEsolver.m``)

.. |exhale_lsh| unicode:: U+021B0 .. UPWARDS ARROW WITH TIP LEFTWARDS

.. code-block:: MATLAB

   %
   %> Class container for solver of  the system of Ordinary Differential Equations
   %> (ODEs) or Differential Algebraic Equations (DAEs).
   %
   classdef ODEsolver < handle
     %
     properties (SetAccess = protected, Hidden = true)
       %
       %> Name of the solver.
       %
       m_name;
       %
       %> System of ODEs/DAEs to be solved.
       %
       m_ode;
       %
       %> Maximum number of iterations in the projection process.
       %
       m_max_iter;
       %
     end
     %
     methods
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Class constructor for ODEsolver, which requires the name of the solver
       %> used to integrate the system of ODEs as input.
       %>
       %> \param name The name of the solver.
       %
       function this = ODEsolver( t_name )
         this.m_name = t_name;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Get the name of the method used to integrate the system of ODEs.
       %>
       %> \return The name of the solver.
       %
       function out = get_name( this )
         out = this.m_name;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Set the name of the method used to integrate the system of ODEs.
       %>
       %> \param name The name of the solver.
       %
       function out = set_name( this, t_name )
         this.m_name = t_name;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Get the system of ODEs to be solved.
       %>
       %> \return The system of ODEs to be solved.
       %
       function out = get_ode( this )
         out = this.m_ode;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Set the system of ODEs to be solved.
       %>
       %> \param ode The system of ODEs to be solved.
       %
       function set_ode( this, t_ode )
         this.m_ode = t_ode;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Get the maximum number of iterations in the projection process.
       %>
       %> \return The maximum number of iterations in the projection process.
       %
       function out = get_max_iter( this )
         out = this.m_max_iter;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Set the maximum number of iterations in the projection process.
       %>
       %> \param max_iter The maximum number of iterations in the projection process.
       %
       function set_max_iter( this, t_max_iter )
   
         CMD = 'indigo::ODEsolver::set_max_iter(...)'
   
         assert(t_max_iter > 0, ...
           [CMD, 'invalid maximum number of iterations.']);
   
         this.m_max_iter = t_max_iter;
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Solve the ODEs system through the problem:
       %>
       %> \f[
       %> \textrm{minimize} \quad
       %> \dfrac{1}{2}\left(\mathbf{x} - \tilde{\mathbf{x}}\right)^2 \quad
       %> \textrm{subject to} \quad \mathbf{H}(\mathbf{x}, t) = \mathbf{0}
       %> \f]
       %>
       %> given the Lagrangian \f$ \mathcal{L}(\mathbf{x}, \boldsymbol{\lambda}) \f$
       %> of the form:
       %>
       %> \f[
       %> \mathcal{L}(\mathbf{x}, \boldsymbol{\lambda}) =
       %> \frac{1}{2}\left(\mathbf{x} - \widetilde{\mathbf{x}}\right)^2 +
       %> \boldsymbol{\lambda} \cdot \mathbf{H}(\mathbf{x}, t).
       %> \f]
       %>
       %> The solution of the problem is obtained by solving the following:
       %>
       %> \f[
       %> \left\{\begin{array}{l}
       %> \mathbf{x} + \mathbf{JH}_\mathbf{x}^T \boldsymbol{\lambda} =
       %> \widetilde{\mathbf{x}} \\[0.5em]
       %> \mathbf{H}(\mathbf{x}, t) = \mathbf{0}
       %> \end{array}\right.
       %> \f]
       %>
       %> **Solution algorithm**
       %>
       %> Using the Taylor expansion of the Lagrangian:
       %>
       %> \f[
       %> \mathbf{H}(\mathbf{x}, t) + \mathbf{JH}_\mathbf{x} \delta\mathbf{x} +
       %> \mathcal{O}\left(\left\| \delta\mathbf{x} \right\|^2\right) = \mathbf{0}
       %> \f]
       %>
       %> define the iterative method as:
       %>
       %> \f[
       %> \mathbf{x} = \widetilde{\mathbf{x}} + \delta\mathbf{x}.
       %> \f]
       %>
       %> Notice that \f$ \delta\mathbf{x} \f$ is the solution of the linear system:
       %>
       %> \f[
       %> \begin{bmatrix}
       %> \mathbf{I}             & \mathbf{JH}_\mathbf{x}^T \\[0.5em]
       %> \mathbf{JH}_\mathbf{x} & \mathbf{0}
       %> \end{bmatrix}
       %> \begin{bmatrix}
       %> \delta\mathbf{x} \\[0.5em]
       %> \boldsymbol{\lambda}
       %> \end{bmatrix}
       %> =
       %> \begin{bmatrix}
       %> \widetilde{\mathbf{x}} - \mathbf{x} \\[0.5em]
       %> -\mathbf{H}(\mathbf{x}, t)
       %> \end{bmatrix}
       %> \f]
       %>
       %> where \f$ \mathbf{JH}_\mathbf{x} \f$ is the Jacobian of the invariants/
       %> hidden constraints with respect to the states \f$ \mathbf{x} \f$.
       %>
       %> \param x_tilde The initial guess for the states \f$ \widetilde{\mathbf{x}} \f$.
       %> \param t The time \f$ t \f$ at which the states are evaluated.
       %>
       %> \return The solution of the projection problem \f$ \mathbf{x} \f$.
       %
       function x = project( this, x_tilde, t )
   
         CMD = 'indigo::ODEsolver::project(...): ';
   
         % Get the number of states, equations and invariants
         num_eqns = this.m_ode.get_num_eqns();
         num_invs = this.m_ode.get_num_invs();
         x        = x_tilde;
   
         assert(length(x_tilde) == num_eqns, ...
           [CMD, 'the number of states does not match the number of equations.']);
   
         % Check if there are any constraints
         if num_invs > 0
   
           % Calculate and scale the tolerance
           tolerance = max(1, norm(x_tilde, inf)) * sqrt(eps);
   
           % Iterate until the projected solution is found
           for k = 1:this.m_max_iter
   
             %     [A]         {x}    =        {b}
             % / I  JH^T \ /   dx   \   / x_tilde - x_k \
             % |         | |        | = |               |
             % \ JH   0  / \ lambda /   \      -H       /
   
             % Evaluate the invariants/hidden constraints vector and its Jacobian
             J  = this.m_ode.H(x, t);
             JH = this.m_ode.JH(x, t);
   
             % Compute the solution of the linear system
             A   = [eye(num_eqns), JH.'; ...
                    JH, zeros(num_invs, num_invs)];
             b   = [x_tilde - x; -H];
             sol = A\b;
   
             % Update the solution
             dx = sol(1:num_eqns);
             x  = x + dx;
   
             % Check if the solution is found
             if (max(abs(dx)) < tolerance && max(abs(H)) < tolerance)
               break;
             else if (k == MAX_ITER)
               warning([CMD, 'maximum number of iterations reached.']);
             end
             end
           end
         end
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Solve the system of ODEs and calculate the approximate solution.
       %>
       %> \param t       Time vector \f$ \left[ t_0, t_1, \ldots, t_n \right]^T \f$.
       %> \param x_0     Initial states value \f$ \mathbf{x}(t_0) \f$.
       %> \param project [optional, default = false] Apply projection to invariants
       %>                 at each step.
       %> \param verbose [optional, default = \f$ \mathrm{false} \f$] Activate
       %>                vebose mode.
       %> \param epsilon [optional, default = \f$ 1.0\mathrm{e}3 \f$] If
       %>                \f$ || \mathbf{x} ||_{\infty} > \varepsilon \f$
       %>                the computation is interrupted.
       %>
       %> \return A matrix \f$ \left[(\mathrm{size}(\mathbf{x}) \times \mathrm{size}
       %>         (t)\right] \f$ containing the approximated solution \f$ \mathbf{x}
       %>         (t) \f$ of the system of ODEs.
       %>
       %> **Usage:**
       %>
       %> Solve without the solution projection on invariants/hidden constraints and
       %> disabled verbose mode.
       %>
       %> \rst
       %> .. code-block:: none
       %>
       %>   sol = obj.solve(t, x_0);
       %>
       %> \endrst
       %>
       %> Solve with the solution projection on invariants/hidden constraints and
       %> disabled verbose mode.
       %>
       %> \rst
       %> .. code-block:: none
       %>
       %>   sol = obj.solve(t, x_0, true);
       %>
       %> \endrst
       %>
       %> Solve without the solution projection on invariants/hidden constraints and
       %> enabled verbose mode.
       %>
       %> \rst
       %> .. code-block:: none
       %>
       %>   sol = obj.solve(t, x_0, false, true);
       %>
       %> \endrst
       %>
       %> Plot the first component of the solution.
       %>
       %> \rst
       %> .. code-block:: none
       %>
       %>   plot(t, sol(1,:));
       %>
       %> \endrst
       %
       function out = solve( this, t, x_0, varargin )
   
         CMD = 'indigo::ODEsolver::solve(...): ';
   
         % Check initial conditions
         num_eqns = this.m_ode.get_num_eqns();
         if num_eqns ~= length(x_0)
           error([CMD, 'in %s solver, length(x_0) is %d, expected %d.'], ...
             this.m_name, length(x_0), num_eqns);
         end
   
         % Collect optional projection flag
         if nargin > 3
           project = varargin{1};
         else
           project = false;
         end
   
         % Collect optional verbose flag
         if nargin > 4
           verbose = varargin{2};
         else
           verbose = false;
         end
   
         % Collect optional epsilon value
         if nargin > 5
           epsilon = varargin{3};
         else
           epsilon = 1.0e3;
         end
   
         % Check number of input arguments
         if nargin > 6
           error([CMD, 'in %s solver, too many input arguments.'], this.m_name);
         end
   
         out      = zeros(num_eqns, length(t));
         out(:,1) = x_0(:);
         perc     = 0.0;
         nt       = length(t)-1;
         for k = 1:nt
           if verbose
             newpp = ceil(100*k/nt);
             if newpp > perc+4
               perc = newpp;
               fprintf('%3d%%\n', perc);
             end
           end
   
           % Integrate system of ODEs
           x_new = this.step(t(k), out(:,k), t(k+1)-t(k));
   
           % Project solution on the invariants/hidden constraints
           if project
             x_new = this.project(t(k+1), x_new);
           end
   
           % Check the infinity norm of the projected solution
           norm_x_new = norm(x_new, inf);
           if norm_x_new > epsilon
             fprintf([CMD, 'in %s solver, at t(%d) = %g, ||x||_inf = %g, computation interrupted.\n'], ...
               this.m_name, k, t(k), norm_xnew);
             break;
           end
           out(:,k+1) = x_new;
         end
       end
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
     %
     methods (Abstract)
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
       %> Generic advancing step for a generic solver.
       %>
       %> \f[
       %> \mathbf{x}_{k+1}(t_{k}+\Delta t) = \mathbf{x}_k(t_{k}) +
       %> \mathcal{S}(\mathbf{x}_k(t_k), \mathbf{x}'_k(t_k), t_k, \Delta t)
       %> \f]
       %>
       %> where \f$ \mathcal{S} \f$ is the advancing step of the solver.
       %>
       %> \param x_k     States value at \f$ k \f$-th time step \f$ \mathbf{x}(t_k) \f$.
       %> \param x_dot_k States derivative at \f$ k \f$-th time step \f$ \mathbf{x}'(t_k) \f$.
       %> \param t_k     Time step \f$ t_k \f$.
       %> \param d_t     Advancing time step \f$ \Delta t\f$.
       %>
       %> \return The approximation of \f$ \mathbf{x_{k+1}}(t_{k}+\Delta t) \f$.
       %
       step( this, x_k, x_dot_k, t_k, d_t )
       %
       % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       %
     end
   end
