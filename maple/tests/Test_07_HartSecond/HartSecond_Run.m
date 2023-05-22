%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

% Plot settings
set(0,     'DefaultFigurePosition', [5000, 5000, 560, 420]);
set(0,     'DefaultFigureWindowStyle',        'normal');
set(0,     'defaultTextInterpreter',          'latex' );
set(groot, 'defaultAxesTickLabelInterpreter', 'latex' );
set(groot, 'defaulttextinterpreter',          'latex' );
set(groot, 'defaultLegendInterpreter',        'latex' );
set(0,     'defaultAxesFontSize',             18      );

%% Instantiate system object

% parameters
l = 1.0;
m = 1.0;
g = 9.81;

% Initial conditions
x__AC      = -2.0*l;
y__AC      = 0.0;
theta__AC  = 1.230959417;
x__BD      = 2.0*l;
y__BD      = 0.0;
theta__BD  = 1.910633237;
x__fg      = -1.0*l;
y__fg      = 2.828427124*l;
theta__fg  = 0.0;
x__CE      = -0.6666666667*l;
y__CE      = 3.771236166*l;
theta__CE  = 1.230959417;
x__ED      = 0.6666666667*l;
y__ED      = 3.771236166*l;
theta__ED  = 1.910633237;
u__AC      = 0.0;
v__AC      = 0.0;
omega__AC  = 0.0;
u__BD      = 0.0;
v__BD      = 0.0;
omega__BD  = 0.0;
u__fg      = 0.0;
v__fg      = 0.0;
omega__fg  = 0.0;
u__CE      = 0.0;
v__CE      = 0.0;
omega__CE  = 0.0;
u__ED      = 0.0;
v__ED      = 0.0;
omega__ED  = 0.0;
lambda__1  = -1.384750780*g*m;
lambda__2  = -7.250000000*g*m;
lambda__3  = 1.384750780*g*m;
lambda__4  = -6.750000000*g*m;
lambda__5  = 0.2651650429*g*m;
lambda__6  = -1.250000000*g*m;
lambda__7  = -0.2651650429*g*m;
lambda__8  = -2.750000000*g*m;
lambda__9  = -1.649915823*g*m;
lambda__10 = -2.0*g*m;
lambda__11 = -1.649915823*g*m;
lambda__12 = 0.0;
lambda__13 = 0.2651650429*g*m;
lambda__14 = 0.7500000000*g*m;

IC  = [
  x__AC; y__AC; theta__AC;
  x__BD; y__BD; theta__BD; ...
  x__fg; y__fg; theta__fg; ...
  x__CE; y__CE; theta__CE; ...
  x__ED; y__ED; theta__ED; ...
  u__AC; v__AC; omega__AC; ...
  u__AC; v__AC; omega__BD; ...
  u__fg; v__fg; omega__fg; ...
  u__CE; v__CE; omega__CE; ...
  u__ED; v__ED; omega__ED; ...
  lambda__1;  lambda__2;  lambda__3;  lambda__4;  lambda__5; ...
  lambda__6;  lambda__7;  lambda__8;  lambda__9;  lambda__10; ...
  lambda__11; lambda__12; lambda__13; lambda__14; ... 
];

ODE = HartSecond();

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
  %explicit_solver{1}, ...
  implicit_solver{end-1}, ...
  %implicit_embedded_solver{2}, ...
};

solver = cell(length(solver_name),1);
for k = 1:length(solver_name)
  solver{k} = IndigoSolver(solver_name{k});
  solver{k}.set_system( ODE );
end

%% Integrate the system

% Set integration interval
d_t   = 0.01;
t_ini = 0.0;
t_end = 2.0;
T_vec = t_ini:d_t:t_end;

% Project the initial condition
IC = solver{1}.project_initial_conditions(IC, t_ini, [false(30, 1); true(14, 1)]);

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
