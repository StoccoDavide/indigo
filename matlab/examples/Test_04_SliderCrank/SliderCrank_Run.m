%% Prepare worspace

clc;
clear all; %#ok<CLALL>
close all;

%% Instantiate system object

% Slider Crank parameters
Fa = 10.0; % force (N)
Ta = 10.0; % torque (Nm)
m  = 1.0;  % mass (kg)
l  = 1.0;  % length (m)
g  = 9.81; % gravity (m/s^2)

data.Fa = Fa;
data.Ta = Ta;
data.m  = m;
data.l  = l;
data.g  = g;

X_0 = initial_conditions( pi / 3, 0.0, data );

ODE = SliderCrank(Fa, Ta, m, l, g, X_0);

%% Initialize the solver and set the ODE

explicit_solver = {
  ... % 'ExplicitEuler',    ...
  ... % 'ExplicitMidpoint', ...
  ... % 'Heun2',            ...
  ... % 'Wray3',            ...
  ... % 'Heun3'             ...
  ... % 'Ralston2',         ...
  ... % 'Ralston3',         ...
  ... % 'Ralston4',         ...
  ... % 'RK3',              ...
  ... % 'RK4',              ...
  ... % 'RK38',             ...
  ... % 'SSPRK3',           ...
};

implicit_solver = {
  ... % 'CrankNicolson',    ...
  ... % 'GaussLegendre2',   ...
  ... % 'GaussLegendre4',   ...
  ... % 'GaussLegendre6',   ...
  'ImplicitEuler',    ...
  ... % 'ImplicitMidpoint', ...
  ... % 'LobattoIIIA2',     ...
  ... % 'LobattoIIIA4',     ...
  ... % 'LobattoIIIB2',     ...
  ... % 'LobattoIIIB4',     ...
  ... % 'LobattoIIIC2',     ...
  ... % 'LobattoIIIC4',     ...
  ... % 'LobattoIIICS2',    ...
  ... % 'LobattoIIICS4',    ...
  ... % 'LobattoIIID2',     ...
  ... % 'LobattoIIID4',     ...
  ... % 'RadauIA3',         ...
  ... % 'RadauIA5',         ...
  ... % 'RadauIIA3',        ...
  ... % 'RadauIIA5',        ...
  ... % 'SunGeng5',         ...
};

explicit_embedded_solver = {
  ... % 'BogackiShampine23', ...
  ... % 'CashKarp45',        ...
  ... % 'DormandPrince45',   ...
  ... % 'Fehlberg12',        ...
  ... % 'Fehlberg45I',       ...
  ... % 'Fehlberg45II',      ...
  ... % 'Fehlberg78',        ...
  ... % 'HeunEuler21',       ...
  ... % 'Merson45',          ...
  ... % 'Verner65',          ...
  ... % 'Zonnenveld45',      ...
};

implicit_embedded_solver = {
  ... % 'GaussLegendre34', ...
  ... % 'GaussLegendre56', ...
  ... % 'LobattoIIIA12',   ...
  ... % 'LobattoIIIA34',   ...
  ... % 'LobattoIIIB12',   ...
  ... % 'LobattoIIIB34',   ...
  ... % 'LobattoIIIC12',   ...
  ... % 'LobattoIIIC34',   ...
};

solver_name = [ ...
  explicit_solver, ...
  implicit_solver, ...
  explicit_embedded_solver, ...
  implicit_embedded_solver, ...
  ];

for i = 1:length(solver_name)
  eval(strcat(['solver', solver_name{i}, '=', solver_name{i}, '();']));
  eval(strcat(['solver', solver_name{i}, '.set_ode(ODE);']));
end

%% Integrate the system of ODE

% Set integration interval
d_t   = 0.05;
t_ini = 0.0;
t_end = 10.0;
T_vec = t_ini:d_t:t_end;

% Solve the system of ODEs for each solver
for i = 1:length(solver_name)

  % Solve the system of ODEs
  eval(strcat(['[X_', solver_name{i}, ', ~, T_', solver_name{i}, '] =', ...
    'solver', solver_name{i}, '.solve( T_vec, X_0 );']));

end

%% Plot results

linewidth = 1.1;
title_str = 'Test 1 -- Slider Crank DAE';

figure();
hold on; grid on; grid minor;
% title(title_str);
xlabel('$t$ (s)');
ylabel('$\theta_1$ (rad)');
for i = 1:length(solver_name)
  eval(strcat(['plot( T_', solver_name{i}, ', X_', solver_name{i}, '(1,:), ''LineWidth'', linewidth );']));
end
legend(solver_name, 'Location', 'northwest');
hold off;

figure();
hold on; grid on; grid minor;
% title(title_str);
xlabel('$t$ (s)');
ylabel('$\theta_2$ (rad)');
for i = 1:length(solver_name)
  eval(strcat(['plot( T_', solver_name{i}, ', X_', solver_name{i}, '(2,:), ''LineWidth'', linewidth );' ]));
end
legend(solver_name, 'Location', 'northwest');
hold off;

figure();
hold on; grid on; grid minor;
% title(title_str);
xlabel('$t$ (s)');
ylabel('$s$ (m)');
for i = 1:length(solver_name)
  eval(strcat(['plot( T_', solver_name{i}, ', X_', solver_name{i}, '(3,:), ''LineWidth'', linewidth );']));
end
legend(solver_name, 'Location', 'northwest');
hold off;

%% Animate the mechanism

for j = 1:1%length(solver_name)
    fprintf(['Animating the mechanism with the ', solver_name{j}, ...
             ' solution.\n'])

    x1 = eval(strcat(['X_', solver_name{j}, '(1,:);'])); % theta1
    x2 = eval(strcat(['X_', solver_name{j}, '(2,:);'])); % theta1
    x3 = eval(strcat(['X_', solver_name{j}, '(3,:);'])); % s

    pad = 0.1;

    figure();
    hold on; grid on; grid minor; axis equal;
    title(solver_name{j});
    xlabel('$x$ (s)');
    ylabel('$y$ (m)');
    xlim([-l - 2 * pad, 3 * l + 2 * pad]);
    ylim([-l - 2 * pad, l + 2 * pad]);
    plot(0.0, 0.0, 'o', 'color', 'k');

    for i = 1:length(x1)
        % Crank
        a1 = plot([0.0, l * cos(x1(i))], [0.0, l * sin(x1(i))], 'color', rgb('Red'));
        a2 = plot(l * cos(x1(i)), l * sin(x1(i)), 'o', 'color', rgb('Red'));

        % Shaft
        a3 = plot([l * cos(x1(i)), l * (cos(x1(i)) + 2 * cos(x2(i)))], ...
                  [l * sin(x1(i)), l * (sin(x1(i)) + 2 * sin(x2(i)))], 'color', rgb('Green'));
        a4 = plot(l * (cos(x1(i)) + 2 * cos(x2(i))), ...
                  l * (sin(x1(i)) + 2 * sin(x2(i))), 'o', 'color', rgb('Green'));

        % Slider
        a5  = plot([x3(i) - 1.5 * pad, x3(i) + 1.5 * pad, x3(i) + 1.5 * pad, ...
                    x3(i) - 1.5 * pad, x3(i) - 1.5 * pad], ...
                   [-pad, -pad, pad, pad, -pad], ...
                   'color', rgb('Blue'));
        a6  = plot(x3(i), 0.0, 'o', 'color', rgb('Blue'));

        pause(0.05);

        if i ~= length(x1)
            delete(a1);
            delete(a2);
            delete(a3);
            delete(a4);
            delete(a5);
            delete(a6);
        end

        progress_bar(1, length(x1), 1, i, 1);
    end
    hold off;
end

%% That's All Folks!
