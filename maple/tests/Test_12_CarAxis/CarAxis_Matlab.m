%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% The DAE system

% L L__0 y__b varepsilon M h tau omega
syms x__l(t) y__l(t) x__r(t) y__r(t) u__l(t) v__l(t) u__r(t) v__r(t) lambda__1(t) lambda__2(t)

VARS = [x__l(t), y__l(t), x__r(t), y__r(t), u__l(t), v__l(t), u__r(t), v__r(t), lambda__1(t), lambda__2(t)];

L=1.0; 
L__0=0.5; 
varepsilon=1e-2; 
M=10.0; 
h=1e-1; 
tau=pi/5; 
omega=10.0; 

y__b = h*sin(omega*t);
x__b = sqrt(L^2 - y__b^2);  
L__l = sqrt(x__l(t)^2 + y__l(t)^2);
L__r = sqrt((x__r(t) - x__b)^2 + (y__r(t) - y__b)^2);


DAES = [ ...
  -u__l(t) + diff(x__l(t)) == 0, ...
  -v__l(t) + diff(y__l(t)) == 0, ...
  -u__r(t) + diff(x__r(t)) == 0, ...
  -v__r(t) + diff(y__r(t)) == 0, ...
  -(L__0 - sqrt(x__l(t)^2 + y__l(t)^2))*x__l(t)/sqrt(x__l(t)^2 + y__l(t)^2) - lambda__1(t)*sqrt(L^2 - h^2*sin(omega*t)^2) - 2*lambda__2(t)*(x__l(t) - x__r(t)) + 1/2*varepsilon^2*M*diff(u__l(t)) == 0, ...
  -(L__0 - sqrt(x__l(t)^2 + y__l(t)^2))*y__l(t)/sqrt(x__l(t)^2 + y__l(t)^2) - lambda__1(t)*h*sin(omega*t) - 2*lambda__2(t)*(y__l(t) - y__r(t)) + 1/2*varepsilon^2*M + 1/2*varepsilon^2*M*diff(v__l(t)) == 0, ...
  -(L__0 - sqrt((x__r(t) - sqrt(L^2 - h^2*sin(omega*t)^2))^2 + (y__r(t) - h*sin(omega*t))^2))*(x__r(t) - sqrt(L^2 - h^2*sin(omega*t)^2))/sqrt((x__r(t) - sqrt(L^2 - h^2*sin(omega*t)^2))^2 + (y__r(t) - h*sin(omega*t))^2) + 2*lambda__2(t)*(x__l(t) - x__r(t)) + 1/2*varepsilon^2*M*diff(u__r(t)) == 0, ...
  -(L__0 - sqrt((x__r(t) - sqrt(L^2 - h^2*sin(omega*t)^2))^2 + (y__r(t) - h*sin(omega*t))^2))*(y__r(t) - h*sin(omega*t))/sqrt((x__r(t) - sqrt(L^2 - h^2*sin(omega*t)^2))^2 + (y__r(t) - h*sin(omega*t))^2) + 2*lambda__2(t)*(y__l(t) - y__r(t)) + 1/2*varepsilon^2*M + 1/2*varepsilon^2*M*diff(v__r(t)) == 0, ...
  x__l(t)*sqrt(L^2 - h^2*sin(omega*t)^2) + y__l(t)*h*sin(omega*t) == 0, ...
  -L^2 + y__r(t)^2 - 2*y__l(t)*y__r(t) + x__r(t)^2 - 2*x__l(t)*x__r(t) + y__l(t)^2 + x__l(t)^2 == 0 ...
];

%[newEqs, newVars, R, oldIndex] = reduceDAEIndex(DAES, VARS)
[newEqs, constraintEqs, oldIndex] = reduceDAEToODE(DAES, VARS);



implicitDAE = @(t,y,yp) newEqs; %M(t,y)*yp - F(t,y);

ODEsNumeric = subs(implicitDAE);
constraintsNumeric = subs(constraintEqs);
opt = odeset('RelTol', 10.0^(-7), 'AbsTol' , 10.0^(-7));


%% Instantiate system object

% Parameters
% Class default

% Initial conditions

 IC = [ ...
0, 1/2, 1, 1/2, -1/2, 0, -1/2, 0, 0, 0
 ]';

[y0, yp0] = decic(ODEsNumeric, VARS, constraintsNumeric, 0,...
                IC, [0, 0, 0, 0, 0, 0, 1, 1, 1, 1], 0*IC, opt);

%opt = odeset(opt, 'InitialSlope', yp0);

%% Integrate the system

% Set integration interval
d_t   = 0.025;
t_ini = 0.0;
t_end = 200.0*pi;
T_vec = t_ini:d_t:t_end;


[tSol,ySol] = ode15i(ODEsNumeric, [t_ini, t_end], y0, yp0);
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
