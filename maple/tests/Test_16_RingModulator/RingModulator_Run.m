%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% Instantiate system object

% Parameters
% Class default

% Initial conditions
IC = zeros(15, 1);

ODE = RingModulator();

%% Initialize the solver and set the system

solver_name = { ...
  'Fehlberg45I', ...
};

solver     = cell(length(solver_name), 1);
solver_SemiExplicit = cell(length(solver_name), 1);
for k = 1:length(solver_name)
  solver{k} = IndigoSolver(solver_name{k});
  solver{k}.set_system(ODE);
end
color = colormap(lines(length(solver_name)));

%% Integrate the system

% Set integration interval
d_t   = 1e-7;
t_ini = 0.0;
t_end = 1.1e-3;
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
  ylabel('$\mathbf{x}_l$ (-)');
  for i = 1:length(solver_name)
    t = decimate(T{i}, 10);
    y = decimate(X{i}(2,:), 10);
    plot(t, y, 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

  return

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{y}_l$ (-)');
  for i = 1:length(solver_name)
    t = T{i};
    u = X{i}(3,:);
    v = X{i}(4,:);
    plot(t, u, t, v, 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

  figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{x}_r$ (-)');
  for i = 1:length(solver_name)
    t = T{i};
    x = X{i}(1,:);
    y = X{i}(2,:);
    plot(t, x, t, y, 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{y}_r$ (-)');
  for i = 1:length(solver_name)
    t = T{i};
    u = X{i}(3,:);
    v = X{i}(4,:);
    plot(t, u, t, v, 'LineWidth', linewidth, 'Color', color(i,:));
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
  ylabel('$\mathbf{x}_p$ (-)');
  for i = 1:length(solver_name)
    t = T{i};
    x = X{i}(3,:);
    y = X{i}(4,:);
    plot(t, x, t, y, 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

  return
figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{x}_v$ (-)');
  for i = 1:length(solver_name)
    t = T{i};
    u = X{i}(3,:);
    v = X{i}(4,:);
    plot(t, u, t, v, 'LineWidth', linewidth, 'Color', color(i,:));
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