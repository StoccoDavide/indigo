%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% Instantiate system object

% Parameters
% Class default

% Initial conditions
IC = [ ...
  ... % Position variables
  0.000000000000000e+000, ...
  0.000000000000000e+000, ...
  4.500169330000000e-001, ...
  0.000000000000000e+000, ...
  0.000000000000000e+000, ...
  1.033398630000000e-005, ...
  1.693279690000000e-005, ...
  ... % Initial values velocity variables
   1.500000000000000e+002, ...
  -7.499576703969453e+001, ...
  -2.689386719979040e-006, ...
   4.448961125815990e-001, ...
   4.634339319238670e-003, ...
  -1.785910760000550e-006, ...
  -2.689386719979040e-006, ...
  ... % Lagrange multipliers
  -6.552727150584648e-008, ...
   3.824589509350831e+002, ...
  -4.635908708561371e-009, ...
]';

ODE = SliderCrankFlexible();

%% Initialize the solver and set the system

% IndigoSolversList()'

solver_name = { ...
  'RadauIIA5', ...
  %'Fehlberg45I', ...
};

solver = cell(length(solver_name), 1);
for k = 1:length(solver_name)
  solver{k} = IndigoSolver(solver_name{k});
  solver{k}.set_system(ODE);
end
color = colormap(lines(length(solver_name)));

%% Integrate the system

% Set integration interval
d_t   = 0.01;
t_ini = 0.0;
t_end = 0.1;
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
    l4 = sqrt(X{i}(16,:).^2 + X{i}(17,:).^2);
    plot(t, l1, t, l2, t, l3, t, l4, 'LineWidth', linewidth, 'Color', color(i,:));
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