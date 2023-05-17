POSITION_VARS := [theta__0(t), theta__1(t), theta__2(t), theta__3(t), theta__4(
t)];
VELOCITY_VARS := [omega__0(t), omega__1(t), omega__2(t), omega__3(t), omega__4(
t)];
LAMBDA_VARS := [lambda__1(t), lambda__2(t), lambda__3(t)];
VARS := [theta__0(t), theta__1(t), theta__2(t), theta__3(t), theta__4(t), 
omega__0(t), omega__1(t), omega__2(t), omega__3(t), omega__4(t), lambda__1(t),
lambda__2(t), lambda__3(t)];
FIRST_ORDER := [diff(theta__0(t),t) = omega__0(t), diff(theta__1(t),t) = 
omega__1(t), diff(theta__2(t),t) = omega__2(t), diff(theta__3(t),t) = omega__3(
t), diff(theta__4(t),t) = omega__4(t)];
DAES := [-omega__0(t)+diff(theta__0(t),t) = 0, -omega__1(t)+diff(theta__1(t),t)
= 0, -omega__2(t)+diff(theta__2(t),t) = 0, -omega__3(t)+diff(theta__3(t),t) = 0
, -omega__4(t)+diff(theta__4(t),t) = 0, -l*(sin(theta__0(t))*cos(theta__3(t))*
omega__3(t)^2*l*m-3*sin(theta__0(t))*omega__1(t)^2*sin(theta__1(t))*l*m-cos(
theta__0(t))*sin(theta__3(t))*omega__3(t)^2*l*m-2*cos(theta__0(t))*omega__2(t)^
2*cos(theta__2(t))*l*m+3*sin(theta__0(t))*cos(theta__1(t))*diff(omega__1(t),t)*
l*m+sin(theta__0(t))*sin(theta__3(t))*diff(omega__3(t),t)*l*m-2*cos(theta__0(t)
)*sin(theta__2(t))*diff(omega__2(t),t)*l*m+cos(theta__0(t))*cos(theta__3(t))*
diff(omega__3(t),t)*l*m-4*diff(omega__0(t),t)*l*m-sin(theta__0(t))*lambda__1(t)
-cos(theta__0(t))*lambda__3(t)) = 0, -l*(9*cos(theta__0(t))*cos(theta__1(t))*
omega__0(t)^2*l*m-3*cos(theta__1(t))*cos(theta__3(t))*omega__3(t)^2*l*m-6*sin(
theta__2(t))*omega__2(t)^2*sin(theta__1(t))*l*m+9*sin(theta__0(t))*cos(theta__1
(t))*diff(omega__0(t),t)*l*m-3*cos(theta__1(t))*sin(theta__3(t))*diff(omega__3(
t),t)*l*m+6*diff(omega__2(t),t)*sin(theta__1(t))*cos(theta__2(t))*l*m-10*diff(
omega__1(t),t)*l*m-9*sin(theta__1(t))*g*m+3*cos(theta__1(t))*lambda__1(t)+3*sin
(theta__1(t))*lambda__2(t)) = 0, -l*(2*sin(theta__0(t))*sin(theta__2(t))*
omega__0(t)^2*l*m+2*cos(theta__1(t))*omega__1(t)^2*cos(theta__2(t))*l*m-sin(
theta__3(t))*sin(theta__2(t))*omega__3(t)^2*l*m-2*cos(theta__0(t))*sin(theta__2
(t))*diff(omega__0(t),t)*l*m+sin(theta__2(t))*cos(theta__3(t))*diff(omega__3(t)
,t)*l*m+2*diff(omega__1(t),t)*sin(theta__1(t))*cos(theta__2(t))*l*m-2*diff(
omega__2(t),t)*l*m+2*cos(theta__2(t))*g*m-sin(theta__2(t))*lambda__3(t)-cos(
theta__2(t))*lambda__2(t)) = 0, -l*(-sin(theta__0(t))*cos(theta__3(t))*omega__0
(t)^2*l*m+cos(theta__0(t))*sin(theta__3(t))*omega__0(t)^2*l*m+sin(theta__3(t))*
omega__1(t)^2*sin(theta__1(t))*l*m+cos(theta__3(t))*omega__2(t)^2*cos(theta__2(
t))*l*m+sin(theta__0(t))*sin(theta__3(t))*diff(omega__0(t),t)*l*m+cos(theta__0(
t))*cos(theta__3(t))*diff(omega__0(t),t)*l*m-cos(theta__1(t))*sin(theta__3(t))*
diff(omega__1(t),t)*l*m+sin(theta__2(t))*cos(theta__3(t))*diff(omega__2(t),t)*l
*m-diff(omega__3(t),t)*l*m+sin(theta__3(t))*lambda__1(t)+cos(theta__3(t))*
lambda__3(t)) = 0, l*(diff(omega__4(t),t)*l*m+3*cos(theta__4(t))*lambda__1(t)+3
*sin(theta__4(t))*lambda__2(t)) = 0, -l*(sin(theta__1(t))+cos(theta__0(t))-cos(
theta__3(t))-sin(theta__4(t))) = 0, l*(cos(theta__1(t))+sin(theta__2(t))-cos(
theta__4(t))) = 0, l*(1-sin(theta__3(t))+sin(theta__0(t))-cos(theta__2(t))) = 0
];
