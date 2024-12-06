%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% The DAE system

syms x__1(t) x__2(t) x__3(t) x__4(t) x__5(t) x__6(t) u__1(t) u__2(t)

VARS = [x__1(t), x__2(t), x__3(t), x__4(t), x__5(t), x__6(t), u__1(t), u__2(t)];

p__1 = @(t) cos(exp(t) - 1) + cos(t - 1);
p__2 = @(t) sin(1 - exp(t)) + sin(1 - t);

a = @(s) 2/(2 - cos(s)^2);
b = @(s) cos(s)/(2 - cos(s)^2);
c = @(s) sin(s)/(2 - cos(s)^2);
d = @(s) cos(s)*sin(s)/(2 - cos(s)^2);

DAES = [ ...
  diff(x__1(t)) == x__4(t), ...
  diff(x__2(t)) == x__5(t), ...
  diff(x__3(t)) == x__6(t), ...
  diff(x__4(t)) == 2*c(x__3(t))*(x__4(t) + x__6(t))^2 + x__4(t)^2*d(x__3(t)) + (2*x__3(t) - x__2(t))*(a(x__3(t)) + 2*b(x__3(t))) + a(x__3(t))*(u__1(t) - u__2(t)), ...
  diff(x__5(t)) == -2*c(x__3(t))*(x__4(t) + x__6(t))^2 - x__4(t)^2*d(x__3(t)) + (2*x__3(t) - x__2(t))*(1 - 3*a(x__3(t)) - 2*b(x__3(t))) - a(x__3(t))*u__1(t) - (1 + a(x__3(t)))*u__2(t), ...
  diff(x__6(t)) == -2*c(x__3(t))*(x__4(t) + x__6(t))^2 - x__4(t)^2*d(x__3(t)) + (2*x__3(t) - x__2(t))*(a(x__3(t)) - 9*b(x__3(t))) - 2*x__4(t)^2*c(x__3(t)) - (x__4(t) + x__6(t))^2*d(x__3(t)) - (a(x__3(t)) + b(x__3(t)))*(u__1(t) - u__2(t)), ...
  cos(x__1(t)) + cos(x__1(t) + x__3(t)) - p__1(t) == 0, ...
  cos(x__1(t)) + sin(x__1(t) + x__3(t)) - p__2(t) == 0 ...
];

%[newEqs, newVars, R, oldIndex] = reduceDAEIndex(DAES, VARS)
[newEqs, constraintEqs, oldIndex] = reduceDAEToODE(DAES, VARS);

[massM,f] = massMatrixForm(newEqs,VARS);
M = @(t,Y) massM(t,Y);
F = @(t,Y) f(t,Y);
implicitDAE = @(t,y,yp) M(t,y)*yp - F(t,y);

ODEsNumeric = subs(newEqs);
constraintsNumeric = subs(constraintEqs);
opt = odeset('Mass', M, 'RelTol', 10.0^(-7), 'AbsTol' , 10.0^(-7));


%% Instantiate system object

% Parameters
% Class default

% Initial conditions

%IC = [ ...
%  0.0, ...
%  0.9537503505, ...
%  1.0, ...
%  -1.0, ...
%  -2.531916866, ...
%  0.0, ...
%  -3.311813602, ...
%  0.2225591955 ...
%]';
% 
 IC = [ ...
   -1.71, ...
   0.39, ...
   1.71, ...
   -2.71, ...
   4.29, ...
   1.71, ...
   13.59, ...
   19.33 ...
 ]';

[y0, yp0] = decic(ODEsNumeric, VARS, constraintsNumeric, 0,...
                IC, [0, 0, 0, 0, 0, 0, 0, 0], 0*IC, opt);

opt = odeset(opt, 'InitialSlope', yp0);

%% Integrate the system

% Set integration interval
d_t   = 0.001;
t_ini = 0.0;
t_end = 0.95;
T_vec = t_ini:d_t:t_end;


[tSol,ySol] = ode15s(F, [0, 0.5], y0, opt);
plot(tSol,ySol(:,1:origVars),'-o')

for k = 1:origVars
  S{k} = char(vars(k));
end

legend(S, 'Location', 'Best')
grid on

return

% Project the initial condition
IC = solver{1}.project_initial_conditions(IC, t_ini);

% Allocate solution arrays
X = cell(1, length(T_vec));
T = cell(1, length(T_vec));
H = cell(1, length(T_vec));
V = cell(1, length(T_vec));

% Solve the system for each solver
for i = 1:length(solver_name)
  solver{i}.enable_projection();
  [X{i}, T{i}] = solver{i}.adaptive_solve(T_vec, IC);
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
