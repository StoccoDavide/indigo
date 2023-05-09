%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% Instantiate system object

% Pendulum parameters
data.m   = 1.0;  % mass (kg)
data.ell = 0.1;  % length (m)
data.g   = 9.81; % gravity (m/s^2)

% Initial conditions
theta_0   = 0.1;
x_0       = data.ell/2*cos(theta_0);
y_0       = data.ell/2*sin(theta_0);
omega_0   = 0.0;
u_0       = -data.ell/2*sin(theta_0)*omega_0;
v_0       = +data.ell/2*cos(theta_0)*omega_0;
lambda1_0 = 0.0;
lambda2_0 = 0.0;
X_0 = [x_0; y_0; theta_0; u_0; v_0; omega_0; lambda1_0; lambda2_0];

ODE = DoubleSlider(data);

%% Initialize the solver and set the ODE

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
  'GaussLegendre34', ...
  'GaussLegendre56', ...
  'LobattoIIIA12',   ...
  'LobattoIIIA34',   ...
  'LobattoIIIB12',   ...
  'LobattoIIIB34',   ...
  'LobattoIIIC12',   ...
  'LobattoIIIC34',   ...
};

solver_name = { ...
  explicit_solver{1}, ...
  implicit_solver{1}, ...
  explicit_embedded_solver{1}, ...
  implicit_embedded_solver{1}, ...
};

solver = cell(length(solver_name), 1);
for k = 1:length(solver_name)
  solver{k} = IndigoSolver(solver_name{k});
  solver{k}.set_system(ODE);
end

%% Integrate the system of ODE

% Set integration interval
d_t   = 0.01;
t_ini = 0.0;
t_end = 5.0;
T_vec = t_ini:d_t:t_end;

% Project the initial condition
X_0 = solver{1}.project_initial_conditions(X_0, t_ini);

% Allocate solution arrays
X = cell(1, length(T_vec));
D = cell(1, length(T_vec));
T = cell(1, length(T_vec));
H = cell(1, length(T_vec));
V = cell(1, length(T_vec));

% Solve the system of ODEs for each solver
for i = 1:length(solver_name)
  solver{i}.disable_projection();
  [X{i}, D{i}, T{i}, V{i}, H{i}] = solver{i}.solve(T_vec, X_0);
end

%% Plot results

linewidth = 1.1;
%title_str = 'Test 1 -- Pendulum ODE';

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
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
  % title(title_str);
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
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$\theta$ (rad)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(3,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$u$ (m/s)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(4,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$v$ (m/s)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(5,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$\omega$ (rad/s)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(6,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$h_1$ (m$^2$)');
  for i = 1:length(solver_name)
    plot(T{i}, H{i}(1,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$h_2$ (m$^2$/s$^2$)');
  for i = 1:length(solver_name)
    plot(T{i}, H{i}(2,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

%% Integrate the system of ODE (using projection)

% Allocate solution arrays
X = cell(1, length(T_vec));
D = cell(1, length(T_vec));
T = cell(1, length(T_vec));
H = cell(1, length(T_vec));
V = cell(1, length(T_vec));

% Solve the system of ODEs for each solver
for i = 1:length(solver_name)
  solver{i}.enable_projection();
  [X{i}, D{i}, T{i}, V{i}, H{i}] = solver{i}.solve(T_vec, X_0);
end

%% Plot results

linewidth = 1.1;
%title_str = 'Test 1 -- Pendulum ODE';

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
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
  % title(title_str);
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
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$\theta$ (rad)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(3,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$u$ (m/s)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(4,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$v$ (m/s)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(5,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$\omega$ (rad/s)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(6,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$h_1$ (m$^2$)');
  for i = 1:length(solver_name)
    plot(T{i}, H{i}(1,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$h_2$ (m$^2$/s$^2$)');
  for i = 1:length(solver_name)
    plot(T{i}, H{i}(2,:), 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;
%% That's All Folks!
