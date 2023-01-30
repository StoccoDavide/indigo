%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% Instantiate system object

m = 1.0;  % mass (kg)
l = 1.0;  % length (m)
g = 9.81; % gravity (m/s^2)

ODE = LinearPendulumODE(m, l, g);

%% Initialize the solver and set the ODE

solver_name = {
  'Exact', ...
  ... % Explict methods
  'ExplicitEuler', ...
%   'ExplicitMidpoint', ...
%   'Heun2', ...
%   'Wray3', ...
%   'Heun3' ...
%   'Ralston2', ...
%   'Ralston3', ...
%   'Ralston4', ...
%   'RK3', ...
%   'RK4', ...
%   'RK38', ...
%   'SSPRK3', ...
%   ... % Implict methods
%   'Exact', ...
%   'CrankNicolson', ...
%   'GaussLegendre2', ...
%   'GaussLegendre4', ...
%   'GaussLegendre6', ...
%   'ImplicitEuler', ...
%   'ImplicitMidpoint', ...
%   'LobattoIIIA2', ...
%   'LobattoIIIA4', ...
%   'LobattoIIIB2', ...
%   'LobattoIIIB4', ...
%   'LobattoIIIC2', ...
%   'LobattoIIIC4', ...
%   'LobattoIIICS2', ...
%   'LobattoIIICS4', ...
%   'LobattoIIID2', ...
%   'LobattoIIID4', ...
%   'RadauIA3', ...
%   'RadauIA5', ...
%   'RadauIIA3', ...
%   'RadauIIA5' ...
};

for i = 2:length(solver_name)
  eval(strcat(['solver', solver_name{i}, '=', solver_name{i}, '();']));
  eval(strcat(['solver', solver_name{i}, '.set_ode( ODE );']));
end

%% Integrate the system of ODE

% Set integration interval
d_t   = 0.1;
t_ini = 0.0;
t_end = 5.0;
T_vec = t_ini:d_t:t_end;

% Set initial conditions
theta_0 = 5*pi/180;
omega_0 = 0.0;
X_ini   = [theta_0, omega_0];

% Solve the system of ODEs for each solver
for i = 2:length(solver_name)
  eval(strcat(['[X_', solver_name{i}, ', T_', solver_name{i}, '] =', ...
    'solver', solver_name{i}, '.solve( T_vec, X_ini, false, false, 20.0e+03 );']));
end

%% Calculate exact solution of the ODE

X_Exact = ODE.exact( X_ini, T_vec );

%% Plot results

linewidth = 1.1;
title_str = 'Test 1 -- Pendulum ODE (Linear)';

figure();
hold on; grid on; grid minor;
% title(title_str);
xlabel('$t$ (s)');
ylabel('$\omega$ (rad/s)');
plot( T_vec, X_Exact(1,:), 'LineWidth', 1.5*linewidth );
for i = 2:length(solver_name)
  eval(strcat(['plot( T_', solver_name{i}, ', X_', solver_name{i}, '(1,:), ''--'', ''LineWidth'', linewidth );']));
end
legend(solver_name, 'Location', 'southwest');
hold off;

figure();
hold on; grid on; grid minor;
% title(title_str);
xlabel('$t$ (s)');
ylabel('$\theta$ (rad)');
plot( T_vec, X_Exact(2,:), 'LineWidth', 1.5*linewidth );
for i = 2:length(solver_name)
  eval(strcat(['plot( T_', solver_name{i}, ', X_', solver_name{i}, '(2,:), ''--'', ''LineWidth'', linewidth );' ]));
end
legend(solver_name, 'Location', 'southwest');
hold off;

figure();
hold on; grid on; grid minor;
% title(title_str);
xlabel('$t$ (s)');
ylabel('$\theta-\theta_{e}$ (--)');
for i = 2:length(solver_name)
  eval(strcat(['plot( T_', solver_name{i}, ', abs(X_Exact(1,:) - X_', solver_name{i}, '(1,:)), ''--'', ''LineWidth'', linewidth );' ]));
end
set(gca,'yscale','log');
legend(solver_name{2:length(solver_name)}, 'Location', 'southwest');
hold off;

figure();
hold on; grid on; grid minor;
% title(title_str);
xlabel('$t$ (s)');
ylabel('$\omega-\omega_{e}$ (--)');
for i = 2:length(solver_name)
  eval(strcat(['plot( T_', solver_name{i}, ', abs(X_Exact(2,:) - X_', solver_name{i}, '(2,:)), ''--'', ''LineWidth'', linewidth );' ]));
end
set(gca,'yscale','log');
legend(solver_name{2:length(solver_name)}, 'Location', 'southwest');
hold off;

%% Test 1 workout

% Extract solution
time  = T_ExplicitEuler;
theta = X_ExplicitEuler(1,:);
omega = X_ExplicitEuler(2,:);
x =  l*sin(theta);
y = -l*cos(theta);

% Plot the solution
figure();
hold on; grid on; grid minor;
% title(title_str);
xlabel('$x$ (m)');
ylabel('$y$ (m)');
xx = l*cos(0:pi/100:2*pi);
yy = l*sin(0:pi/100:2*pi);
plot(xx, yy, '-', 'Linewidth', 1);
axis equal
plot(x, y, '-o', 'MarkerSize', 6, 'Linewidth', 2);
hold off;

%% That's All Folks!
