POSITION_VARS := [theta__1(t), theta__2(t)];
VELOCITY_VARS := [omega__1(t), omega__2(t)];
LAMBDA_VARS := [lambda(t)];
VARS := [theta__1(t), theta__2(t), omega__1(t), omega__2(t), lambda(t)];
DAES := [-omega__1(t)+diff(theta__1(t),t) = 0, -omega__2(t)+diff(theta__2(t),t)
= 0, 2*omega__2(t)^2*l__1*l__2*sin(theta__2(t)+theta__1(t))*m__2+4*omega__2(t)^
2*l__1*l__2*sin(theta__2(t)+theta__1(t))*m__3-2*diff(omega__2(t),t)*l__1*l__2*
cos(theta__2(t)+theta__1(t))*m__2-4*diff(omega__2(t),t)*l__1*l__2*cos(theta__2(
t)+theta__1(t))*m__3+2*cos(theta__1(t))*l__1*g*m__1+4*cos(theta__1(t))*l__1*g*
m__2+4*cos(theta__1(t))*l__1*g*m__3+diff(omega__1(t),t)*l__1^2*m__1+4*diff(
omega__1(t),t)*l__1^2*m__2+4*diff(omega__1(t),t)*l__1^2*m__3+4*cos(theta__1(t))
*l__1*lambda(t)+4*J__1*diff(omega__1(t),t) = 0, 2*omega__1(t)^2*l__1*l__2*sin(
theta__2(t)+theta__1(t))*m__2+4*omega__1(t)^2*l__1*l__2*sin(theta__2(t)+
theta__1(t))*m__3-2*diff(omega__1(t),t)*l__1*l__2*cos(theta__2(t)+theta__1(t))*
m__2-4*diff(omega__1(t),t)*l__1*l__2*cos(theta__2(t)+theta__1(t))*m__3-2*cos(
theta__2(t))*l__2*g*m__2-4*cos(theta__2(t))*l__2*g*m__3+diff(omega__2(t),t)*
l__2^2*m__2+4*diff(omega__2(t),t)*l__2^2*m__3-4*cos(theta__2(t))*l__2*lambda(t)
+4*J__2*diff(omega__2(t),t) = 0, -sin(theta__2(t))*l__2+sin(theta__1(t))*l__1 =
0];
FIRST_ORDER := [diff(theta__1(t),t) = omega__1(t), diff(theta__2(t),t) = 
omega__2(t)];
