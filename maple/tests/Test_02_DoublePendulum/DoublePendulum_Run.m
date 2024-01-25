%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% Instantiate system object

% Parameters
m1  = 1.0;  % mass 1 (kg)
m2  = 2.0;  % mass 2 (kg)
g   = 9.81; % gravity (m/s^2)
l1  = 1.0;  % length 1 (m)
l2  = 1.5;  % length 2 (m)

% Initial conditions
theta_1  = 0.01;
omega_1  = 0;
theta_2  = 0.01;
omega_2  = 0;
x_1      = l1*cos(theta_1);
y_1      = l1*sin(theta_1);
x_2      = x_1 + l2*cos(theta_2);
y_2      = y_1 + l2*sin(theta_2);
u_1      = -l1*sin(theta_1)*omega_1;
v_1      = l1*cos(theta_1)*omega_1;
u_2      = u_1 - l2*sin(theta_2)*omega_2;
v_2      = v_1 + l2*cos(theta_2)*omega_2;
lambda_1 = m1*(v_1^2 + u_1^2 - y_1*g)/(2*(y_1^2 + x_1^2));
lambda_2 = m1*(v_2^2 + u_2^2 - y_2*g)/(2*(y_2^2 + x_2^2));

IC = [x_1; y_1; x_2; y_2; u_1; v_1; u_2; v_2; lambda_1; lambda_2];

ODE = DoublePendulum(m1, m2, g, l1, l2);

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
  implicit_solver{1}, ...
  explicit_embedded_solver{1}, ...
  implicit_embedded_solver{1}, ...
};

solver = cell(length(solver_name),1);
for k = 1:length(solver_name)
  solver{k} = IndigoSolver(solver_name{k});
  solver{k}.set_system(ODE);
end

%% Integrate the system

% Set integration interval
d_t   = 0.05;
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
  ylabel('$\mathbf{x}_p$ (-)');
  for i = 1:length(solver_name)
    t  = T{i};
    x1 = X{i}(1,:);
    y1 = X{i}(2,:);
    x2 = X{i}(3,:);
    y2 = X{i}(4,:);
    plot(t, x1, t, y1, t, x2, t, y2, 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{x}_v$ (-)');
  for i = 1:length(solver_name)
    t  = T{i};
    u1 = X{i}(5,:);
    v1 = X{i}(6,:);
    u2 = X{i}(7,:);
    v2 = X{i}(8,:);
    plot(t, u1, t, v1, t, u2, t, v2, 'LineWidth', linewidth);
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
    h4 = H{i}(4,:);
    h5 = H{i}(5,:);
    h6 = H{i}(6,:);
    plot(t, h1, t, h2, 'LineWidth', linewidth);
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
  [X{i}, D{i}, T{i}, V{i}, H{i}] = solver{i}.solve(T_vec, IC);
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
    t  = T{i};
    x1 = X{i}(1,:);
    y1 = X{i}(2,:);
    x2 = X{i}(3,:);
    y2 = X{i}(4,:);
    plot(t, x1, t, y1, t, x2, t, y2, 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{x}_v$ (-)');
  for i = 1:length(solver_name)
    t  = T{i};
    u1 = X{i}(5,:);
    v1 = X{i}(6,:);
    u2 = X{i}(7,:);
    v2 = X{i}(8,:);
    plot(t, u1, t, v1, t, u2, t, v2, 'LineWidth', linewidth);
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
    h4 = H{i}(4,:);
    h5 = H{i}(5,:);
    h6 = H{i}(6,:);
    plot(t, h1, t, h2, 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

%% That's All Folks!