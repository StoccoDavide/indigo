function X_0 = initial_conditions( theta1, theta1_dot, data )
%INITIAL_CONDITIONS Compute the initial condition for the slider crank
%                   mechanism.
% Arguments
%  - theta1     -> initial condition for the angle theta1.
%  - theta1_dot -> initial condition for the derivative of the angle
%                  theta1.
%  - data       -> data of the system (i.e., g, m, l)
%
% Outputs
%  - X_0 -> set of initial conditions for the slider crank mechanism.
%

% Unpack data
Fa = data.Fa;
Ta = data.Ta;
g  = data.g;
m  = data.m;
l  = data.l;

% Rename theta1_dot to match the convention used in the Maple file
r = theta1_dot;

% Position
theta2 = -asin(sin(theta1) / 0.2e1);
s      = l * (cos(theta1) + sqrt(0.3e1 + cos(theta1) ^ 2));

if s >= 2.5
    Fa = Fa * (s - 2.5) ^ 2;
else
    Fa = 0.0;
end

% Velocity
u = -0.1e1 / cos(theta2) * r * cos(theta1) / 0.2e1;
v = l * r * (sin(theta2) * cos(theta1) - cos(theta2) * sin(theta1)) / cos(theta2);

% Lagrange multipliers
lambdas = [(-0.36e2 * l * (l * ((cos(theta1) ^ 2 + sin(theta1) ^ 2 / 0.2e1) * cos(theta2) + cos(theta1) * sin(theta2) * sin(theta1) / 0.2e1) * m * r ^ 2 + 0.2e1 * l * (cos(theta1) * cos(theta2) ^ 2 + sin(theta2) ^ 2 * cos(theta1) / 0.2e1 + cos(theta2) * sin(theta2) * sin(theta1) / 0.2e1) * m * u ^ 2 - cos(theta1) * cos(theta2) * Fa / 0.3e1) * cos(-theta2 + theta1) + 0.18e2 * l ^ 2 * m * (r ^ 2 * cos(theta1) + 0.2e1 * u ^ 2 * cos(theta2)) * (sin(theta2) * cos(theta1) - cos(theta2) * sin(theta1)) * sin(-theta2 + theta1) + 0.12e2 * l ^ 2 * (cos(theta1) ^ 3 + 0.7e1 / 0.2e1 * cos(theta1) * cos(theta2) ^ 2 + cos(theta1) * sin(theta1) ^ 2 + 0.7e1 / 0.2e1 * cos(theta2) * sin(theta2) * sin(theta1)) * m * r ^ 2 + 0.24e2 * l ^ 2 * (0.7e1 / 0.2e1 * cos(theta2) ^ 3 + (cos(theta1) ^ 2 + 0.7e1 / 0.2e1 * sin(theta2) ^ 2) * cos(theta2) + cos(theta1) * sin(theta2) * sin(theta1)) * m * u ^ 2 + (-0.27e2 * l * cos(theta1) * sin(theta1) * g * m - 0.18e2 * sin(theta1) * Ta - 0.14e2 * l * Fa) * cos(theta2) ^ 2 + 0.27e2 * (cos(theta1) * l * g * m + 0.2e1 / 0.3e1 * Ta) * sin(theta2) * cos(theta1) * cos(theta2) - 0.4e1 * l * cos(theta1) ^ 2 * Fa) / l / (0.9e1 * cos(theta2) ^ 2 * sin(theta1) ^ 2 - 0.18e2 * cos(theta1) * cos(theta2) * sin(theta1) * sin(theta2) + 0.9e1 * cos(theta1) ^ 2 * sin(theta2) ^ 2 - 0.6e1 * cos(theta1) * cos(theta2) * cos(-theta2 + theta1) + 0.7e1 * cos(theta2) ^ 2 + 0.2e1 * cos(theta1) ^ 2) / 0.2e1 (-0.18e2 * l ^ 2 * m * (r ^ 2 * sin(theta1) + 0.2e1 * u ^ 2 * sin(theta2)) * cos(-theta2 + theta1) ^ 2 + (0.18e2 * l ^ 2 * m * (r ^ 2 * cos(theta1) - 0.2e1 * u ^ 2 * cos(theta2)) * sin(-theta2 + theta1) - 0.54e2 * l ^ 2 * m * (cos(theta1) ^ 2 * sin(theta2) + cos(theta2) * sin(theta1) * cos(theta1) + 0.2e1 * sin(theta1) ^ 2 * sin(theta2)) * r ^ 2 - 0.108e3 * (sin(theta2) * cos(theta1) * cos(theta2) + sin(theta1) * (cos(theta2) ^ 2 + 0.2e1 * sin(theta2) ^ 2)) * l ^ 2 * m * u ^ 2 - 0.63e2 * l * (cos(theta2) * g * m - 0.2e1 / 0.7e1 * sin(theta2) * Fa) * cos(theta1) + 0.18e2 * cos(theta2) * (sin(theta1) * l * Fa - Ta)) * cos(-theta2 + theta1) + 0.54e2 * ((cos(theta1) * sin(theta2) * sin(theta1) + cos(theta2) * (-sin(theta1) ^ 2 - 0.7e1 / 0.9e1)) * r ^ 2 + 0.2e1 * u ^ 2 * ((sin(theta2) ^ 2 + 0.2e1 / 0.9e1) * cos(theta1) - cos(theta2) * sin(theta2) * sin(theta1))) * l ^ 2 * m * sin(-theta2 + theta1) + 0.36e2 * l ^ 2 * (cos(theta1) ^ 2 * sin(theta1) + 0.7e1 / 0.2e1 * sin(theta2) * cos(theta1) * cos(theta2) + sin(theta1) * (sin(theta1) ^ 2 + 0.7e1 / 0.2e1 * sin(theta2) ^ 2 + 0.7e1 / 0.9e1)) * m * r ^ 2 + 0.72e2 * l ^ 2 * (cos(theta2) * sin(theta1) * cos(theta1) + 0.7e1 / 0.2e1 * sin(theta2) * (cos(theta2) ^ 2 + 0.2e1 / 0.7e1 * sin(theta1) ^ 2 + sin(theta2) ^ 2 + 0.2e1 / 0.9e1)) * m * u ^ 2 + 0.135e3 * l * g * (sin(theta2) ^ 2 + 0.2e1 / 0.9e1) * m * cos(theta1) ^ 2 + (-0.189e3 * l * cos(theta2) * sin(theta1) * sin(theta2) * g * m - 0.12e2 * sin(theta1) * l * Fa + 0.54e2 * sin(theta2) ^ 2 * Ta + 0.12e2 * Ta) * cos(theta1) + 0.54e2 * cos(theta2) * (g * l * m * (sin(theta1) ^ 2 + 0.7e1 / 0.9e1) * cos(theta2) - sin(theta2) * (sin(theta1) * Ta + 0.7e1 / 0.9e1 * l * Fa))) / l / (0.9e1 * cos(theta2) ^ 2 * sin(theta1) ^ 2 - 0.18e2 * cos(theta1) * cos(theta2) * sin(theta1) * sin(theta2) + 0.9e1 * cos(theta1) ^ 2 * sin(theta2) ^ 2 - 0.6e1 * cos(theta1) * cos(theta2) * cos(-theta2 + theta1) + 0.7e1 * cos(theta2) ^ 2 + 0.2e1 * cos(theta1) ^ 2) / 0.6e1];

lambda1 = lambdas(1);
lambda2 = lambdas(2);

% Initial conditions
X_0 = [theta1, theta2, s, r, u, v, lambda1, lambda2];

end

