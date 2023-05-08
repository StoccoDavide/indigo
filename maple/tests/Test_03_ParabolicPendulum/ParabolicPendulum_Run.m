%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% Instantiate system object

% Pendulum parameters
g = 9.81; % gravity (m/s^2)

% Initial conditions
x_0      = 1.0;
y_0      = x_0^2;
u_0      = 0.0;
v_0      = 0.0;
lambda_0 = (64*u_0^2*x_0^4 - 64*u_0^2*y_0*x_0^2 + 32*u_0^2*x_0^2 + x_0^2*g - ...
  8*v_0*u_0*x_0 - 8*u_0^2*y_0 + 2*u_0^2 - y_0*g + 2*v_0^2)/ ...
  (4*(16*x_0^6 - 32*y_0*x_0^4 + 9*x_0^4 + 16*y_0^2*x_0^2 - 10*y_0*x_0^2 + ...
  x_0^2 + y_0^2));
X_0 = [x_0; y_0; u_0; v_0; lambda_0];

ODE = ParabolicPendulum(g);

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
  explicit_solver{end}, ...
  implicit_solver{end}, ...
  %explicit_embedded_solver{1}, ...
  %implicit_embedded_solver{1}, ...
};

solver = cell(length(solver_name),1);
for k = 1:length(solver_name)
  solver{k} = IndigoSolver(solver_name{k});
  solver{k}.set_system( ODE );
end

%% Integrate the system of ODE

% Set integration interval
d_t   = 0.0025;
t_ini = 0.0;
t_end = 10.0;
T_vec = t_ini:d_t:t_end;

X = {};
T = {};
H = {};

% Solve the system of ODEs for each solver
for i = 1:length(solver_name)

  % Solve the system of ODEs
  solver{i}.disable_projection();
  [X{i},~, T{i}] = solver{i}.solve( T_vec, X_0 );

  % Calculate energy of the solution
  H{i} = ODE.h( X{i}, T{i} );

end

%% Plot results

linewidth = 1.1;
title_str = 'Test 1 -- Pendulum ODE'; %#ok<NASGU>

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$\theta$ (rad)');
  for i = 1:length(solver_name)
    plot( T{i}, X{i}(1,:), 'LineWidth', linewidth );
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$\omega$ (rad/s)');
  for i = 1:length(solver_name)
    plot( T{i}, X{i}(2,:), 'LineWidth', linewidth );
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$E$ (J)');
  for i = 1:length(solver_name)
    plot( T{i}, X{i}(1,:).^2+X{i}(2,:).^2, 'LineWidth', linewidth );
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

%% Integrate the system of ODE (using projection)

X = {};
T = {};
H = {};

% Solve the system of ODEs for each solver
for i = 1:length(solver_name)

  % Solve the system of ODEs
  solver{i}.enable_projection();
  [X{i},~,T{i}] = solver{i}.solve( T_vec, X_0 );

  % Calculate energy of the solution
  H{i} = ODE.h( X{i}, T{i} );
end

%% Plot results

linewidth = 1.1;
title_str = 'Test 1 -- Pendulum ODE';

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$\theta$ (rad)');
  for i = 1:length(solver_name)
    plot( T{i}, X{i}(1,:), 'LineWidth', linewidth );
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$\omega$ (rad/s)');
  for i = 1:length(solver_name)
    plot( T{i}, X{i}(2,:), 'LineWidth', linewidth );
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

figure();
  hold on;
  grid on;
  grid minor;
  % title(title_str);
  xlabel('$t$ (s)');
  ylabel('$E$ (J)');
  for i = 1:length(solver_name)
    plot( T{i}, X{i}(1,:).^2+X{i}(2,:).^2, 'LineWidth', linewidth );
  end
  legend(solver_name, 'Location', 'northwest');
  hold off;

%% That's All Folks!
