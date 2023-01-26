% Plot settings
set(0,     'DefaultFigurePosition', [5000, 5000, 560, 420]);
set(0,     'DefaultFigureWindowStyle',        'normal');
set(0,     'defaultTextInterpreter',          'latex' );
set(groot, 'defaultAxesTickLabelInterpreter', 'latex' );
set(groot, 'defaulttextinterpreter',          'latex' );
set(groot, 'defaultLegendInterpreter',        'latex' );
set(0,     'defaultAxesFontSize',             18      );

% Library folder
addpath('./indigo');
addpath('./indigo/ODE');
addpath('./indigo/ODE/ExplicitMethods/');
addpath('./indigo/ODE/ImplicitMethods/');

% Tests folder
addpath('./tests');
