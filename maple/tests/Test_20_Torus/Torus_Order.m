%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% Instantiate system object

ICS = [ ...
   15.0, ...
   0.0, ...
   0.0, ...
   0.0, ...
   15.0, ...
  -5.0, ...
   0.0 ...
];

ODES = Torus();

rho = 5.0;
r   = 10.0;

%% Initialize the solver and set the system

% IndigoSolversList()'

solver_name = { ...
  'ImplicitEuler', ...
  'RK4', ...
  'RadauIIA5', ...
};

solver = cell(length(solver_name), 1);
for k = 1:length(solver_name)
  solver{k} = IndigoSolver(solver_name{k});
  solver{k}.set_system(ODES);
end

%% Exact solution

X_1_exact = @(t) (rho*cos(2*pi-t)+r).*cos(t);
X_2_exact = @(t) (rho*cos(2*pi-t)+r).*sin(t);
X_3_exact = @(t)  rho*sin(2*pi-t);
X_exact   = @(t) [X_1_exact(t); X_2_exact(t); X_3_exact(t)];

%% Integrate the system

% Set integration interval
d_vec = linspace(0.02, 0.2, 5);
t_ini = 0.0;
t_end = 2.0*pi;

for i = 1:length(d_vec)
  T_vec{i,:} = t_ini:d_vec(i):t_end; %#ok<SAGROW>
end

% Allocate solution arrays
X = cell(length(solver_name), length(d_vec));
V = cell(length(solver_name), length(d_vec));
T = cell(length(solver_name), length(d_vec));
H = cell(length(solver_name), length(d_vec));
E = cell(length(solver_name), length(d_vec));

% Solve the system for each solver
for i = 1:length(solver_name)
  solver{i}.set_max_projection_iter(100);
  solver{i}.set_projection_tolerance(1e-12, 1e-10, 1e-8);
  solver{i}.enable_projection();
  for j = 1:length(d_vec)
    [X{i,j}, T{i,j}, V{i,j}, H{i,j}] = solver{i}.solve(T_vec{j}, ICS);
    for k = 1:length(T{i,j})
      H{i,j}(:,k) = norm(ODES.h(X{i,j}(:,k), V{i,j}(:,k), T{i,j}(k)), 2);
    end
  E{i,j} = max(abs(X{i,j}(1,:) - X_1_exact(T{i,j})), [], 'all');
  end
end

%% Plot order

linewidth = 1.1;
color = colormap(lines(length(solver_name)));

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{h}$ (-)');
  for i = 1:length(solver_name)
    t  = T{i,2};
    h1 = H{i,2}(1,:);
    %h2 = H{i,2}(2,:);
    %h3 = H{i,2}(1:3,:);
    plot(t, h1,  '-', 'LineWidth', linewidth, 'Color', color(i,:));
    %plot(t, h2, '--', 'LineWidth', linewidth, 'Color', color(i,:));
    %plot(t, h3, '-.', 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  set(gca, 'XScale', 'log', 'YScale', 'log');
  hold on;
  grid on;
  grid minor;
  xlabel('$h$ (s)');
  ylabel('$\varepsilon$');
  for i = 1:length(solver_name)
    loglog(d_vec, [E{i,1:end}], '-o', 'LineWidth', linewidth, 'Color', color(i,:));
  end
  d_h = 0.01;
  patch('XData', d_vec(1)+[0.0, d_h, d_h], 'YData', E{1,1}+[0.0, 0.0, d_h*(E{1,2}-E{1,1})/(d_vec(2)-d_vec(1))], 'FaceColor', color(1,:), 'FaceAlpha', 0.5, 'EdgeColor', 'none');
  patch('XData', d_vec(1)+[0.0, d_h, d_h], 'YData', E{2,1}+[0.0, 0.0, d_h*(E{2,2}-E{2,1})/(d_vec(2)-d_vec(1))], 'FaceColor', color(2,:), 'FaceAlpha', 0.5, 'EdgeColor', 'none');
  patch('XData', d_vec(1)+[0.0, d_h, d_h], 'YData', E{3,1}+[0.0, 0.0, d_h*(E{3,2}-E{3,1})/(d_vec(2)-d_vec(1))], 'FaceColor', color(3,:), 'FaceAlpha', 0.5, 'EdgeColor', 'none');
  xlim([min(d_vec), max(d_vec)]);
  legend(solver_name, 'Location', 'southeast');
  hold off;

%% Print order

for i = 1:length(solver_name)
  b = polyfit(log(d_vec), log([E{i,1:end}]), 1);
  fprintf( ...
    '%s: order = %.3f, expected = %d\n', ...
    solver_name{i}, b(1), solver{i}.get_order() ...
  );
end

%% That's All Folks!
