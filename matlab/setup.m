% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%                        ___           _ _                                    %
%                       |_ _|_ __   __| (_) __ _  ___                         %
%                        | || '_ \ / _` | |/ _` |/ _ \                        %
%                        | || | | | (_| | | (_| | (_) |                       %
%                       |___|_| |_|\__,_|_|\__, |\___/                        %
%                                          |___/                              %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Plot settings
set(0,     'DefaultFigurePosition', [5000, 5000, 560, 420]);
set(0,     'DefaultFigureWindowStyle',        'normal');
set(0,     'defaultTextInterpreter',          'latex' );
set(groot, 'defaultAxesTickLabelInterpreter', 'latex' );
set(groot, 'defaulttextinterpreter',          'latex' );
set(groot, 'defaultLegendInterpreter',        'latex' );
set(0,     'defaultAxesFontSize',             18      );

% Library folders
addpath('./indigo');

% Utilities
addpath('./indigo/Utils');

% Systems classes
addpath('./indigo/Systems');

% Runge-Kutta methods
addpath('./indigo/RungeKutta');
addpath('./indigo/RungeKutta/ExplicitMethods/');
addpath('./indigo/RungeKutta/ImplicitMethods/');
addpath('./indigo/RungeKutta/EmbeddedExplicitMethods/');
addpath('./indigo/RungeKutta/EmbeddedImplicitMethods/');

% Examples folder do not add example in toolbox
% addpath('./examples');
% addpath('./examples/PendulumODE/');
% addpath('./examples/PendulumDAE/');
% addpath('./examples/ThreeBodyProblem/');
