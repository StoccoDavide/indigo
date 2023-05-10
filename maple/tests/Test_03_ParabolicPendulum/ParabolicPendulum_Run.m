%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% Instantiate system object

% Pendulum parameters
m = 1.0;  % mass (kg)
g = 9.81; % gravity (m/s^2)

% Initial conditions
x      = 1.0;
y      = x^2;
u      = 1.0;
v      = 2*u;
lambda = -m*(2*u^2+g)/(1+4*x^2);

IC = [x; y; u; v; lambda];

ODE = ParabolicPendulum(m, g);

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
  explicit_solver{end}, ...
  implicit_solver{end}, ...
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
d_t   = 0.025;
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
    t = T{i};
    x = X{i}(1,:);
    y = X{i}(2,:);
    plot(t, x, t, y, 'LineWidth', linewidth);
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
    t = T{i};
    u = X{i}(3,:);
    v = X{i}(4,:);
    plot(t, u, t, v, 'LineWidth', linewidth);
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
    plot(t, h1, t, h2, t, h3, 'LineWidth', linewidth);
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
    t = T{i};
    x = X{i}(1,:);
    y = X{i}(2,:);
    plot(t, x, t, y, 'LineWidth', linewidth);
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
    t = T{i};
    u = X{i}(3,:);
    v = X{i}(4,:);
    plot(t, u, t, v, 'LineWidth', linewidth);
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
    plot(t, h1, t, h2, t, h3, 'LineWidth', linewidth);
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

%% That's All Folks!