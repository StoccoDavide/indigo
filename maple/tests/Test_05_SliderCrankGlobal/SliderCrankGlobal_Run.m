%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% Instantiate system object

% System parameters
l_1 = 1.0;
l_2 = 2.0;
m_1 = 1.0;
m_2 = 1.0;
m_3 = 2.0;
g   = 9.8;
J_1 = 4.5;
J_2 = 5.5;

% Initial conditions
theta_1  = 0.0;
x_1      = 0.0;
y_1      = 0.0;
theta_2  = 0.0;
x_2      = l_1;
y_2      = 0.0;
omega_1  = 1.0;
u_1      = 0.0;
v_1      = 0.0;
omega_2  = 0.5;
u_2      = 0.0;
v_2      = 0.0;
lambda_1 = 0.0;
lambda_2 = 0.5*g*m_1;
lambda_3 = 0.5*g*m_1+g*m_2+g*m_3;
lambda_4 = 0.0;
lambda_5 = 0.5*g*m_1;

ics = [ ...
  x_1;      y_1;      theta_1;  x_2;      y_2;     theta_2; ...
  u_1;      v_1;      omega_1;  u_2;      v_2;     omega_2; ...
  lambda_1; lambda_2; lambda_3; lambda_4; lambda_5 ...
];
prj_ics = [ ...
  false; false; false; false; false; false; ...
  true;  true;  false; true;  true;  false; ...
  true;  true;  true;  true;  true ...
];

sys = SliderCrankGlobal(l_1, l_2, m_1, m_2, m_3, g, J_1, J_2);

%% Initialize the solver and set the system

% IndigoSolversList()'

% Instantiate solver
solver = IndigoSolver('RK4');
solver.set_system(sys);

% Set integration interval
d_t   =  0.1;
t_ini =  0.0;
t_end = 30.0;
t_vec = t_ini:d_t:t_end;

% Project the initial conditions
ics = solver.project_initial_conditions(ics, t_ini, prj_ics);

%% Integrate the system (no projection)

solver.disable_projection();
[X_d, T_d, V_d, H_d] = solver.adaptive_solve(t_vec, ics);

%% Integrate the system (with projection)

solver.enable_projection();
[X_e, T_e, V_e, H_e] = solver.adaptive_solve(t_vec, ics);

%% Plot results

linewidth = 1.1;

figure();
hold on;
grid on;
grid minor;
xlabel('$t$ (s)');
ylabel('$\theta_1(t)$ (rad)');
t   = T_d;
t1_d = X_d(3,:);
t1_e = X_e(3,:);
plot(t, t1_d, 'LineWidth', linewidth);
plot(t, t1_e, 'LineWidth', linewidth);
hold off;

figure();
hold on;
grid on;
grid minor;
xlabel('$t$ (s)');
ylabel('$\theta_2(t)$ (rad)');
t   = T_d;
t2_d = X_d(6,:);
t2_e = X_e(6,:);
plot(t, t2_d, 'LineWidth', linewidth);
plot(t, t2_e, 'LineWidth', linewidth);
hold off;

figure();
hold on;
grid on;
grid minor;
xlabel('$t$ (s)');
ylabel('$y_2(t)$ (m)');
t  = T_d;
h1_d = H_d(1,:);
h1_e = H_e(1,:);
plot(t, h1_d, 'LineWidth', linewidth);
plot(t, h1_e, 'LineWidth', linewidth);
hold off;

%% That's All Folks!
