POSITION_VARS := [theta__A1(t), theta__B2(t), theta__C3(t), theta__12(t), 
theta__23(t)];
VELOCITY_VARS := [omega__A1(t), omega__B2(t), omega__C3(t), omega__12(t), 
omega__23(t)];
LAMBDA_VARS := [lambda__1(t), lambda__2(t), lambda__3(t), lambda__4(t)];
VARS := [theta__A1(t), theta__B2(t), theta__C3(t), theta__12(t), theta__23(t),
omega__A1(t), omega__B2(t), omega__C3(t), omega__12(t), omega__23(t), lambda__1
(t), lambda__2(t), lambda__3(t), lambda__4(t)];
FIRST_ORDER := [diff(theta__A1(t),t) = omega__A1(t), diff(theta__B2(t),t) = 
omega__B2(t), diff(theta__C3(t),t) = omega__C3(t), diff(theta__12(t),t) = 
omega__12(t), diff(theta__23(t),t) = omega__23(t)];
DAES := [-omega__A1(t)+diff(theta__A1(t),t) = 0, -omega__B2(t)+diff(theta__B2(t
),t) = 0, -omega__C3(t)+diff(theta__C3(t),t) = 0, -omega__12(t)+diff(theta__12(
t),t) = 0, -omega__23(t)+diff(theta__23(t),t) = 0, -l*(-4*diff(omega__A1(t),t)*
l*m-3*cos(theta__A1(t))*g*m+3*lambda__1(t)*sin(theta__A1(t))-3*lambda__2(t)*cos
(theta__A1(t))) = 0, l*(3*cos(theta__B2(t))*g*m+4*diff(omega__B2(t),t)*l*m+3*
lambda__1(t)*sin(theta__B2(t))-3*lambda__3(t)*sin(theta__B2(t))-3*cos(theta__B2
(t))*lambda__2(t)+3*cos(theta__B2(t))*lambda__4(t)) = 0, -l*(-diff(omega__C3(t)
,t)*l*m+3*lambda__4(t)*cos(theta__C3(t))-3*lambda__3(t)*sin(theta__C3(t))) = 0,
-l*(-diff(omega__12(t),t)*l*m+3*lambda__1(t)*sin(theta__12(t))-3*lambda__2(t)*
cos(theta__12(t))) = 0, l*(diff(omega__23(t),t)*l*m+3*lambda__4(t)*cos(
theta__23(t))-3*lambda__3(t)*sin(theta__23(t))) = 0, -l*(-cos(theta__A1(t))-cos
(theta__12(t))+1+cos(theta__B2(t))) = 0, l*(sin(theta__A1(t))+sin(theta__12(t))
-sin(theta__B2(t))) = 0, l*(cos(theta__B2(t))+cos(theta__23(t))-1-cos(theta__C3
(t))) = 0, l*(sin(theta__23(t))+sin(theta__B2(t))-sin(theta__C3(t))) = 0];
