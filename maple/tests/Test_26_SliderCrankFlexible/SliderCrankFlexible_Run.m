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
   6.552727150584648e-008, ...
  -3.824589509350831e+002, ...
   4.635908708561371e-009, ...
]';
IC_l = IC;

ODE = SliderCrankFlexible_i1_p();
ODE_l = SliderCrankFlexible_Linear_p();

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

solver_l = cell(length(solver_name), 1);
for k = 1:length(solver_name)
  solver_l{k} = IndigoSolver(solver_name{k});
  solver_l{k}.set_system(ODE_l);
end
color = colormap(lines(100));

%% Integrate the system

% Set integration interval
d_t   = 0.00005;
t_ini = 0.0;
t_end = 0.1*0.525;
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
  solver{i}.enable_projection();
  [X{i}, T{i}, V{i}, H{i}] = solver{i}.adaptive_solve(T_vec, IC);
end

%% Integrate the linear system

% Set integration interval
d_t   = 0.0001;
t_ini = 0.0;
t_end = 0.1;
T_vec = t_ini:d_t:t_end;

% Project the initial condition
%IC_l = solver{1}.project_initial_conditions(IC, t_ini);

% Allocate solution arrays
X_l = cell(1, length(T_vec));
T_l = cell(1, length(T_vec));
H_l = cell(1, length(T_vec));
V_l = cell(1, length(T_vec));

% Solve the system for each solver
for i = 1:length(solver_name)
  solver{i}.enable_projection();
  [X_l{i}, T_l{i}, V_l{i}, H_l{i}] = solver_l{i}.solve(T_vec, IC_l);
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
    plot(t, x1, t, x2, 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{x}$ (-)');
  for i = 1:length(solver_name)
    t = T{i};
    x4 = X{i}(4,:);
    x5 = X{i}(5,:);
    x6 = X{i}(6,:);
    x7 = X{i}(7,:);
    plot(T_l{i}, X_l{i}(6,:)*1e6, t, x6*1e6, 'LineWidth', linewidth, 'Color', color(i,:));
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

%%

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{p}$ (-)');
  for i = 1:length(solver_name)
    t   = T{i};
    for j = 1:length(t)
      p1(:,:,j) = ODE.pivots(X{i}(:,j), V{i}(:,j), t(i));
    end
    for i_1 = 1:size(p1, 1)
      for i_2 = 1:size(p1, 2)
        tmp = p1(i_1, i_2, :);
        plot(t, reshape(tmp, [], size(tmp,1), size(tmp,2)), '--', 'LineWidth', linewidth, 'Color', color(i_1+i_2,:));
      end
    end
    t_l = T_l{i};
    for j = 1:length(t_l)
      p2(:,:,j) = ODE_l.pivots(X_l{i}(:,j), V_l{i}(:,j), t_l(i));
    end
    for i_1 = 1:size(p2, 1)
      for i_2 = 1:size(p2, 2)
        tmp = p2(i_1, i_2, :);
        plot(t_l, reshape(tmp, [], size(tmp,1), size(tmp,2)), 'LineWidth', linewidth, 'Color', color(i_1+i_2,:));
      end
    end
    xlim([t_ini, t_end])
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

%% That's All Folks!
