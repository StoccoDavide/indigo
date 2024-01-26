%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% Instantiate system object

IC = [ ...
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
  'RadauIIA3', ...
  'RadauIIA5', ...
};

solver = cell(length(solver_name), 1);
for k = 1:length(solver_name)
  solver{k} = IndigoSolver(solver_name{k});
  solver{k}.set_system(ODES);
end

%% Integrate the system

% Set integration interval
d_t   = 0.025;
t_ini = 0.0;
t_end = 5.0*2.0*pi;
T_vec = t_ini:d_t:t_end;

% Allocate solution arrays
X = cell(1, length(T_vec));
V = cell(1, length(T_vec));
T = cell(1, length(T_vec));
H = cell(1, length(T_vec));

% Solve the system for each solver
for i = 1:length(solver_name)
  solver{i}.enable_projection();
  [X{i}, T{i}, V{i}, H{i}] = solver{i}.adaptive_solve(T_vec, IC);
end

%% Plot results

linewidth = 0.9;

light_blue = [68, 85, 90]/100;
dark_blue  = [53, 77, 85]/100;

Phi = @(x_1, x_2, x_3) x_1.^2 + x_2.^2 + x_3.^2 - 2*r*(x_1.^2 + x_2.^2).^(1/2) + r^2 - rho^2;

figure();
subplot(2,1,1);
  color = colormap(lines(length(solver_name)+1));
  hold on;
  grid on;
  grid minor;
  xlabel('$x_1$');
  ylabel('$x_2$');
  zlabel('$x_3$');
  theta = linspace(0.0, 2.0*pi, 100);
  x_0 = 0.0;
  y_0 = 0.0;
  r_in  = r - rho;
  r_out = r + rho;
  fs = patch([ ...
    x_0+r_out*cos(theta), ...
    x_0+r_in*cos(theta) ...
  ],[ ...
    y_0+r_out*sin(theta), ...
    y_0+r_in*sin(theta) ...
  ], 'r', 'linestyle', 'none');
  fs.FaceColor = dark_blue;
  for i = 1:length(solver_name)
    desired = 10000;
    x1 = decimate(X{i}(1,:), max(1.0, floor(length(X{i}(1,:))/desired)));
    x2 = decimate(X{i}(2,:), max(1.0, floor(length(X{i}(2,:))/desired)));
    plot(x1, x2, 'LineWidth', linewidth, 'Color', color(i+1,:));
  end
  axis equal; xlim([-15, 15]); ylim([-15, 15]);
  hold off;

subplot(2,1,2);
  color = colormap(lines(length(solver_name)+1));
  hold on;
  grid on;
  grid minor;
  xlabel('$x_1$');
  ylabel('$x_3$');
  y_0 = 0.0;
  fs = patch([ ...
      -r, -r, r, r, ...
    ],[ ...
      -rho, rho, rho, -rho, ...
    ], 'r', 'linestyle', 'none');
    fs.FaceColor = dark_blue;
  for x_0 = [-r, r]
    r_in  = 0.0;
    r_out = rho;
    fs = patch([ ...
      x_0+r_out*cos(theta), ...
      x_0+r_in*cos(theta) ...
    ],[ ...
      y_0+r_out*sin(theta), ...
      y_0+r_in*sin(theta) ...
    ], 'r', 'linestyle', 'none');
    fs.FaceColor = light_blue;
  end
  for i = 1:length(solver_name)
    desired = 10000;
    x2 = decimate(X{i}(2,:), max(1.0, floor(length(X{i}(2,:))/desired)));
    x3 = decimate(X{i}(3,:), max(1.0, floor(length(X{i}(3,:))/desired)));
    plot(x2, x3, 'LineWidth', linewidth, 'Color', color(i+1,:));
  end
  axis equal; xlim([-15, 15]); ylim([-5, 5]);
  hold off;

return

figure();
  color = colormap(lines(length(solver_name)+1));
  hold on;
  grid on;
  grid minor;
  xlabel('$x_1$');
  ylabel('$x_2$');
  zlabel('$x_3$');
  for i = 1:length(solver_name)
    desired = 10000;
    x1 = decimate(X{i}(1,:), max(1.0, floor(length(X{i}(1,:))/desired)));
    x2 = decimate(X{i}(2,:), max(1.0, floor(length(X{i}(2,:))/desired)));
    x3 = decimate(X{i}(3,:), max(1.0, floor(length(X{i}(3,:))/desired)));
    %x1 = X{i}(1,:);
    %x2 = X{i}(2,:);
    %x3 = X{i}(3,:);
    plot3(x1, x2, x3, 'LineWidth', linewidth, 'Color', color(i+1,:));
  end
  [x, y, z] = meshgrid( ...
    -15.0:2.5:15.0, ...
    -15.0:2.5:15.0, ...
    -5.0:2.5:5.0 ...
   );
  v = Phi(x,y,z);
  fs = patch(isosurface(x, y, z, v, 0));
  %fs = fimplicit3(Phi, 'MeshDensity', 30);
  fs.EdgeColor = color(1,:) + 0.1*[1.0, 1.0, 1.0];
  fs.FaceAlpha = 0.2;
  fs.FaceColor = color(1,:);
  legend({solver_name{1:end}, 'Torus'}, 'Location', 'northwest');
  axis equal; xlim([-15, 15]); ylim([-15, 15]); zlim([-5, 5]);
  hold off;

return

figure();
  color = colormap(lines(2));
  hold on;
  %grid on;
  %grid minor;
  xlabel('$x_1$');
  ylabel('$x_2$');
  zlabel('$x_3$');
  %t  = linspace(0.0, 10.0, 100);
  %x1 = (rho*cos(2*pi-t)+r).*cos(t);
  %x2 = (rho*cos(2*pi-t)+r).*sin(t);
  %x3 =  rho*sin(2*pi-t);
  x1 = X{1}(1,:);
  x2 = X{1}(2,:);
  x3 = X{1}(3,:);
  plot3(x1, x2, x3, 'LineWidth', linewidth, 'Color', color(2,:));
  fs = fimplicit3(Phi, 'MeshDensity', 20);
  fs.EdgeColor = color(1,:)+[0.1, 0.1, 0.1];
  fs.FaceAlpha = 0.2;
  fs.FaceColor = color(1,:);
  legend('Exact solution', 'Location', 'northwest');
  axis equal; xlim([-15, 15]); ylim([-15, 15]); zlim([-5, 5]);
  hold off;

  return;

figure();
  color = colormap(lines(length(solver_name)));
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{x}_l$ (-)');
  for i = 1:length(solver_name)
    theta = T{i};
    x1 = X{i}(1,:);
    x2 = X{i}(2,:);
    x3 = X{i}(3,:);
    plot(theta, x1, theta, x2, theta, x3, 'LineWidth', linewidth, 'Color', color(i,:));
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{u}_l$ (-)');
  for i = 1:length(solver_name)
    theta  = T{i};
    u1 = X{i}(1,:);
    u2 = X{i}(2,:);
    u3 = X{i}(3,:);
    plot(theta, u1, theta, u2, theta, u3, 'LineWidth', linewidth, 'Color', color(i,:));
  end
  %legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  xlabel('$t$ (s)');
  ylabel('$\mathbf{h}$ (-)');
  for i = 1:length(solver_name)
    theta  = T{i};
    h1 = H{i}(1,:);
    h2 = H{i}(2,:);
    h3 = H{i}(3,:);
    plot(theta, h1, theta, h2, theta, h3, 'LineWidth', linewidth, 'Color', color(i,:));
  end
  %legend(solver_name, 'Location', 'northwest');
  hold off;

%% That's All Folks!
