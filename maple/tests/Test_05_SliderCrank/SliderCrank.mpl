POSITION_VARS := [x__1(t), y__1(t), theta__1(t), x__2(t), y__2(t), theta__2(t)]
;
VELOCITY_VARS := [u__1(t), v__1(t), omega__1(t), u__2(t), v__2(t), omega__2(t)]
;
LAMBDA_VARS := [lambda__1(t), lambda__2(t), lambda__3(t)];
VARS := [x__1(t), y__1(t), theta__1(t), x__2(t), y__2(t), theta__2(t), u__1(t),
v__1(t), omega__1(t), u__2(t), v__2(t), omega__2(t), lambda__1(t), lambda__2(t)
, lambda__3(t)];
DAES := [-u__1(t)+diff(x__1(t),t) = 0, -v__1(t)+diff(y__1(t),t) = 0, -omega__1(
t)+diff(theta__1(t),t) = 0, -u__2(t)+diff(x__2(t),t) = 0, -v__2(t)+diff(y__2(t)
,t) = 0, -omega__2(t)+diff(theta__2(t),t) = 0, -cos(theta__1(t))*omega__1(t)^2*
ell__1*m__1-sin(theta__1(t))*diff(omega__1(t),t)*ell__1*m__1+2*diff(u__1(t),t)*
m__1-2*lambda__1(t) = 0, -sin(theta__1(t))*omega__1(t)^2*ell__1*m__1+cos(
theta__1(t))*diff(omega__1(t),t)*ell__1*m__1+2*diff(v__1(t),t)*m__1+2*g*m__1-2*
lambda__2(t) = 0, -2*sin(theta__1(t))*diff(u__1(t),t)*ell__1*m__1+2*cos(
theta__1(t))*diff(v__1(t),t)*ell__1*m__1+2*cos(theta__1(t))*ell__1*g*m__1+diff(
omega__1(t),t)*ell__1^2*m__1+4*sin(theta__1(t))*ell__1*lambda__1(t)-4*cos(
theta__1(t))*ell__1*lambda__2(t)+4*J__1*diff(omega__1(t),t) = 0, -omega__2(t)^2
*cos(theta__2(t))*ell__2*m__2-diff(omega__2(t),t)*sin(theta__2(t))*ell__2*m__2+
2*diff(u__2(t),t)*m__2+2*lambda__1(t) = 0, -omega__2(t)^2*sin(theta__2(t))*
ell__2*m__2+diff(omega__2(t),t)*cos(theta__2(t))*ell__2*m__2+2*diff(v__2(t),t)*
m__2+2*g*m__2-2*lambda__3(t)+2*lambda__2(t) = 0, diff(omega__2(t),t)*ell__2^2*
m__2-2*diff(u__2(t),t)*sin(theta__2(t))*ell__2*m__2+2*diff(v__2(t),t)*cos(
theta__2(t))*ell__2*m__2+2*cos(theta__2(t))*ell__2*g*m__2-4*cos(theta__2(t))*
ell__2*lambda__3(t)+4*J__2*diff(omega__2(t),t) = 0, -cos(theta__1(t))*ell__1-
x__1(t)+x__2(t) = 0, -sin(theta__1(t))*ell__1-y__1(t)+y__2(t) = 0, -sin(
theta__2(t))*ell__2-y__2(t) = 0];
FIRST_ORDER := [diff(x__1(t),t) = u__1(t), diff(y__1(t),t) = v__1(t), diff(
theta__1(t),t) = omega__1(t), diff(x__2(t),t) = u__2(t), diff(y__2(t),t) = v__2
(t), diff(theta__2(t),t) = omega__2(t)];
