%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% Instantiate system object

% Parameters
% Class default

% Initial conditions
IC = [ ...
  1.0, ...
  0.0, ...
  0.0, ...
  0.0, ...
  0.0, ...
  1.0, ...
  0.0, ...
  0.0, ...
  0.0, ...
  0.0, ...
  1.0, ...
  0.0, ...
  0.0, ...
  0.0, ...
  0.0, ...
  ]';

ODE = N3Pendulum_i2();

%% Initialize the solver and set the system

% IndigoSolversList()'

solver_name = { ...
  'RadauIIA5', ...
  %'Fehlberg45I', ...
  %'GaussLegendre6', ...
};

solver = cell(length(solver_name), 1);
for k = 1:length(solver_name)
  solver{k} = IndigoSolver(solver_name{k});
  solver{k}.set_system(ODE);
end
color = colormap(lines(length(solver_name)));

%% Integrate the system

% Set integration interval
d_t   = 0.1;
t_ini = 0.0;
t_end = 60.0;
T_vec = t_ini:d_t:t_end;

% Project the initial condition
IC = solver{1}.project_initial_conditions(IC, t_ini);

% Allocate solution arrays
X = cell(1, length(T_vec));
T = cell(1, length(T_vec));
H = cell(1, length(T_vec));
V = cell(1, length(T_vec));

% Solve the system for each solver
for i = 1:length(solver_name)
  %solver{i}.disable_projection();
  [X{i}, T{i}, V{i}, H{i}] = solver{i}.adaptive_solve(T_vec, IC);
end

%% Plot results

linewidth = 1.1;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{x}$ (-)');
  for i = 1:length(solver_name)
    t = T{i};
    l1 = sqrt(X{i}(1,:).^2 + X{i}(2,:).^2);
    l2 = sqrt(X{i}(6,:).^2 + X{i}(7,:).^2);
    l3 = sqrt(X{i}(11,:).^2 + X{i}(12,:).^2);
    plot(t, l1, t, l2, t, l3, 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

  return;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{x}$ (-)');
  for i = 1:length(solver_name)
    t = T{i};
    x1 = X{i}(1,:);
    x2 = X{i}(2,:);
    x3 = X{i}(3,:);
    x4 = X{i}(2,:);
    x5 = X{i}(3,:);
    plot(t, x1, t, x2, t, x3, t, x4, t, x5, 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{h}$ (-)');
  for i = 1:length(solver_name)
    t  = T{i};
    h1 = H{i}(1,:);
    h2 = H{i}(2,:);
    h3 = H{i}(3,:);
    plot(t, h1, t, h2, t, h3, 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

%% Integrate the system (using projection)

% Allocate solution arrays
X = cell(1, length(T_vec));
T = cell(1, length(T_vec));
H = cell(1, length(T_vec));
V = cell(1, length(T_vec));

% Solve the system for each solver
for i = 1:length(solver_name)
  solver{i}.enable_projection();
  [X{i}, T{i}, V{i}, H{i}] = solver{i}.adaptive_solve(T_vec, IC);
end

%% Plot results

linewidth = 1.1;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{x}$ (-)');
  for i = 1:length(solver_name)
    t = T{i};
    x1 = X{i}(1,:);
    x2 = X{i}(2,:);
    x3 = X{i}(3,:);
    x4 = X{i}(2,:);
    x5 = X{i}(3,:);
    plot(t, x1, t, x2, t, x3, t, x4, t, x5, 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{h}$ (-)');
  for i = 1:length(solver_name)
    t  = T{i};
    h1 = H{i}(1,:);
    h2 = H{i}(2,:);
    h3 = H{i}(3,:);
    plot(t, h1, t, h2, t, h3, 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

%% That's All Folks!