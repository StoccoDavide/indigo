%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% Instantiate system object

% Parameters
data.m   = 1.0;  % mass (kg)
data.ell = 1.0;  % length (m)
data.g   = 9.81; % gravity (m/s^2)

% Initial conditions
theta  = -0.1-pi/2;
omega  = -0.1;
x      = data.ell*cos(theta);
y      = data.ell*sin(theta);
u      = -data.ell*sin(theta)*omega;
v      = +data.ell*cos(theta)*omega;
lambda = data.m/2*(u^2 + v^2 - y*data.g)/(x^2 + y^2);

IC = [x; y; u; v; lambda];

data.x__0 = x;
data.y__0 = y;
data.u__0 = u;
data.v__0 = v;

ODE = Pendulum(data);

%% Initialize the solver and set the system

explicit_solver = {
  'ExplicitEuler',    ...
  'ExplicitMidpoint', ...
  'Heun2',            ...
  'Wray3',            ...
  'Heun3'             ...
  'Ralston2',         ...
  'Ralston3',         ...
  'Ralston4',         ...
  'RK3',              ...
  'RK4',              ...
  'RK38',             ...
  'SSPRK3',           ...
};

implicit_solver = {
  'CrankNicolson',    ...
  'GaussLegendre2',   ...
  'GaussLegendre4',   ...
  'GaussLegendre6',   ...
  'ImplicitEuler',    ...
  'ImplicitMidpoint', ...
  'LobattoIIIA2',     ...
  'LobattoIIIA4',     ...
  'LobattoIIIB2',     ...
  'LobattoIIIB4',     ...
  'LobattoIIIC2',     ...
  'LobattoIIIC4',     ...
  'LobattoIIICS2',    ...
  'LobattoIIICS4',    ...
  'LobattoIIID2',     ...
  'LobattoIIID4',     ...
  'RadauIA3',         ...
  'RadauIA5',         ...
  'RadauIIA3',        ...
  'RadauIIA5',        ...
  'SunGeng5',         ...
};

explicit_embedded_solver = {
  'BogackiShampine23', ...
  'CashKarp45',        ...
  'DormandPrince45',   ...
  'Fehlberg12',        ...
  'Fehlberg45I',       ...
  'Fehlberg45II',      ...
  'Fehlberg78',        ...
  'HeunEuler21',       ...
  'Merson45',          ...
  'Verner65',          ...
  'Zonnenveld45',      ...
};

implicit_embedded_solver = {
  'GaussLegendre4', ...
  'GaussLegendre6', ...
  'LobattoIIIA12',   ...
  'LobattoIIIA34',   ...
  'LobattoIIIB12',   ...
  'LobattoIIIB34',   ...
  'LobattoIIIC12',   ...
  'LobattoIIIC34',   ...
};

solver_name = { ...
  explicit_solver{end}, ...
  implicit_solver{end}, ...
  explicit_embedded_solver{1}, ...
  implicit_embedded_solver{1}, ...
};

solver = cell(length(solver_name), 1);
for k = 1:length(solver_name)
  solver{k} = IndigoSolver(solver_name{k});
  solver{k}.set_system(ODE);
end

%% Integrate the system

% Set integration interval
d_t   = 0.1;
t_ini = 0.0;
t_end = 5.0;
T_vec = t_ini:d_t:t_end;

% Project the initial condition
IC = solver{1}.project_initial_conditions(IC, t_ini);

% Allocate solution arrays
X = cell(1, length(T_vec));
D = cell(1, length(T_vec));
T = cell(1, length(T_vec));
H = cell(1, length(T_vec));
V = cell(1, length(T_vec));

% Solve the system for each solver
for i = 1:length(solver_name)
  solver{i}.disable_projection();
  [X{i}, D{i}, T{i}, V{i}, H{i}] = solver{i}.solve(T_vec, IC);
end

%% Plot results

linewidth = 1.1;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$x$ (m)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(1,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$y$ (m)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(2,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$u$ (m/s)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(3,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$v$ (m/s)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(4,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$E$ (J)');
  for i = 1:length(solver_name)
    plot(T{i}, H{i}(1,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$h_1$ (m$^2$)');
  for i = 1:length(solver_name)
    plot(T{i}, H{i}(2,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$h_2$ (m$^2$/s$^2$)');
  for i = 1:length(solver_name)
    plot(T{i}, H{i}(3,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

  figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$h_3$ (m$^2$/s$^2$)');
  for i = 1:length(solver_name)
    plot(T{i}, H{i}(4,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

%% Integrate the system (using projection)

% Allocate solution arrays
X = cell(1, length(T_vec));
D = cell(1, length(T_vec));
T = cell(1, length(T_vec));
H = cell(1, length(T_vec));
V = cell(1, length(T_vec));

% Solve the system for each solver
for i = 1:length(solver_name)
  solver{i}.enable_projection();
  %olver{i}.set_projected_invs([false; true; false(2,1)]); % Project only position hidden constraints
  %solver{i}.set_projected_invs([true; false(3,1)]); % Project only energy
  solver{i}.set_projected_invs([false; true(3,1)]); % Project only hidden constraints
  %solver{i}.set_projected_invs([true; true(3,1)]); % Project all invariants
  [X{i}, D{i}, T{i}, V{i}, H{i}] = solver{i}.solve(T_vec, IC);
end

%% Plot results

linewidth = 1.1;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$x$ (m)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(1,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$y$ (m)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(2,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$u$ (m/s)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(3,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$v$ (m/s)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(4,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$E$ (J)');
  for i = 1:length(solver_name)
    plot(T{i}, H{i}(1,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$h_1$ (m$^2$)');
  for i = 1:length(solver_name)
    plot(T{i}, H{i}(2,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$h_2$ (m$^2$/s$^2$)');
  for i = 1:length(solver_name)
    plot(T{i}, H{i}(3,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

  figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$h_3$ (m$^2$/s$^2$)');
  for i = 1:length(solver_name)
    plot(T{i}, H{i}(4,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

%% That's All Folks!
