%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% Instantiate system object

IC = [ ...
  -0.01308973356, ...
  1.095863207, ...
  264039.3280, ...
  3.101765061, ...
  0.5592347076, ...
  24317.07980, ...
  0.7173428600 ...
]';

ODES = ShuttleTrajectory_Index3();


%% Initialize the solver and set the system

% IndigoSolversList()'

solver_name = { ...
  %'RK4', ...
  'Fehlberg45I', ...
};

solver = cell(length(solver_name), 1);
for k = 1:length(solver_name)
  solver{k} = IndigoSolver(solver_name{k});
  solver{k}.set_system(ODES);
end
color = colormap(lines(length(solver_name)+5));

%% Integrate the system

% Set integration interval
d_t   = 0.05;
t_ini = 332.868734542;
t_end = 419.868734542;
T_vec = t_ini:d_t:t_end;

%Project the initial condition
IC = solver{1}.project_initial_conditions(IC, t_ini);

% Allocate solution arrays
X = cell(1, length(T_vec));
T = cell(1, length(T_vec));
H = cell(1, length(T_vec));
V = cell(1, length(T_vec));

% Solve the system for each solver
for i = 1:length(solver_name)
  solver{i}.enable_projection();
  [X{i}, T{i}, V{i}, H{i}] = solver{i}.solve(T_vec, IC);
end

%% Plot results

linewidth = 1.1;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\theta(t)$ (-)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(1,:), 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$A(t)$ (-)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(2,:), 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$H(t)$ (-)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(3,:), 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\lambda(t)$ (-)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(4,:), 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\xi(t)$ (-)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(5,:), 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$V_R(t)$ (-)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(6,:), 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\beta(t)$ (-)');
  for i = 1:length(solver_name)
    plot(T{i}, X{i}(6,:), 'LineWidth', linewidth, 'Color', color(i,:));
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

%% 3D plot

H     = X{1}(3,:);
A     = X{1}(2,:);
theta = X{1}(1,:);
a_e = 20902900;

lat = X{1}(4,:);
lon = X{1}(5,:);

figure; grid on; grid minor;
plot3(lat, lon, H);
return
%%

Rx = @(t) [1 0 0; 0 cos(t) -sin(t); 0 sin(t) cos(t)];
Ry = @(t) [cos(t) 0 sin(t); 0 1 0; -sin(t) 0 cos(t)];
Rz = @(t) [cos(t) -sin(t) 0; sin(t) cos(t) 0; 0 0 1];

v = zeros(3, length(A));
for i = 1:length(A)
  R = Rz(A(i))*Ry(theta(i));
  v(:,i) = R*[(a_e + H(i)); 0; 0];
end

figure; hold on; axis equal; grid on; grid minor;
plot3(v(1,:), v(2,:), v(3,:), 'r', 'LineWidth',2.0);
plot3(v(1,end), v(2,end), v(3,end), '.');
xlabel('x'); ylabel('y'); zlabel('z');
[Xs,Ys,Zs] = sphere(50);
Xs = Xs*a_e;
Ys = Ys*a_e;
Zs = Zs*a_e;
earth = imread('landOcean.jpg');
clouds = imread('cloudCombined.jpg');
sEarth = surface(Xs, Ys ,flip(Zs));
sEarth.FaceColor = 'texturemap';
sEarth.EdgeColor = 'none';
sEarth.CData = earth;
hold on
sCloud = surface(Xs*1.001,Ys*1.001,flip(Zs)*1.001); 

sCloud.FaceColor = 'texturemap'; 
sCloud.EdgeColor = 'none';
sCloud.CData = clouds;

sCloud.FaceAlpha = 'texturemap';
sCloud.AlphaData = max(clouds,[],3);

%% That's All Folks!