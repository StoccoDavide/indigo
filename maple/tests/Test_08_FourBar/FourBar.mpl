POSITION_VARS := [theta__0(t), theta__1(t), theta__2(t)];
VELOCITY_VARS := [omega__0(t), omega__1(t), omega__2(t)];
LAMBDA_VARS := [lambda__1(t), lambda__2(t)];
VARS := [theta__0(t), theta__1(t), theta__2(t), omega__0(t), omega__1(t), 
omega__2(t), lambda__1(t), lambda__2(t)];
FIRST_ORDER := [diff(theta__0(t),t) = omega__0(t), diff(theta__1(t),t) = 
omega__1(t), diff(theta__2(t),t) = omega__2(t)];
DAES := [-omega__0(t)+diff(theta__0(t),t) = 0, -omega__1(t)+diff(theta__1(t),t)
= 0, -omega__2(t)+diff(theta__2(t),t) = 0, -(3*omega__1(t)^2*cos(theta__0(t))*
sin(theta__1(t))*l*m-3*omega__1(t)^2*cos(theta__1(t))*sin(theta__0(t))*l*m-3*
cos(theta__0(t))*cos(theta__1(t))*diff(omega__1(t),t)*l*m-3*sin(theta__1(t))*
sin(theta__0(t))*diff(omega__1(t),t)*l*m-6*cos(theta__0(t))*g*m-7*diff(omega__0
(t),t)*l*m+3*lambda__2(t)*cos(theta__0(t))-3*lambda__1(t)*sin(theta__0(t)))*l =
0, (3*omega__0(t)^2*cos(theta__0(t))*sin(theta__1(t))*l*m-3*omega__0(t)^2*cos(
theta__1(t))*sin(theta__0(t))*l*m+3*cos(theta__0(t))*cos(theta__1(t))*diff(
omega__0(t),t)*l*m+3*sin(theta__1(t))*sin(theta__0(t))*diff(omega__0(t),t)*l*m+
3*cos(theta__1(t))*g*m+4*diff(omega__1(t),t)*l*m-3*lambda__2(t)*cos(theta__1(t)
)+3*lambda__1(t)*sin(theta__1(t)))*l = 0, -l*(-diff(omega__2(t),t)*l*m+3*
lambda__2(t)*cos(theta__2(t))-3*lambda__1(t)*sin(theta__2(t))) = 0, -l*(cos(
theta__0(t))+cos(theta__1(t))-1+cos(theta__2(t))) = 0, -l*(sin(theta__1(t))+sin
(theta__0(t))+sin(theta__2(t))) = 0];
