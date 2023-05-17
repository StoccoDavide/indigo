POSITION_VARS := [theta__1(t), theta__2(t)];
VELOCITY_VARS := [omega__1(t), omega__2(t)];
LAMBDA_VARS := [lambda(t)];
VARS := [theta__1(t), theta__2(t), omega__1(t), omega__2(t), lambda(t)];
DAES := [-omega__1(t)+diff(theta__1(t),t) = 0, -omega__2(t)+diff(theta__2(t),t)
= 0, 6*sin(theta__1(t))*l__1*m__2*l__2*omega__2(t)^2*cos(theta__2(t))+4*l__1^2*
m__2*cos(theta__1(t))*omega__1(t)^2*sin(theta__1(t))+6*sin(theta__1(t))*l__1*
m__2*l__2*diff(omega__2(t),t)*sin(theta__2(t))-4*cos(theta__1(t))^2*diff(
omega__1(t),t)*l__1^2*m__2+2*cos(theta__1(t))*l__1*g*m__1+diff(omega__1(t),t)*
l__1^2*m__1+4*diff(omega__1(t),t)*l__1^2*m__2-4*cos(theta__1(t))*l__1*lambda(t)
+4*J__1*diff(omega__1(t),t) = 0, 8*l__2^2*m__2*cos(theta__2(t))*omega__2(t)^2*
sin(theta__2(t))+6*m__2*sin(theta__2(t))*l__2*l__1*omega__1(t)^2*cos(theta__1(t
))+6*m__2*sin(theta__2(t))*l__2*l__1*diff(omega__1(t),t)*sin(theta__1(t))-8*cos
(theta__2(t))^2*diff(omega__2(t),t)*l__2^2*m__2+2*l__2*cos(theta__2(t))*g*m__2+
9*diff(omega__2(t),t)*l__2^2*m__2+4*l__2*cos(theta__2(t))*lambda(t)+4*J__2*diff
(omega__2(t),t) = 0, -sin(theta__1(t))*l__1+l__2*sin(theta__2(t)) = 0];
FIRST_ORDER := [diff(theta__1(t),t) = omega__1(t), diff(theta__2(t),t) = 
omega__2(t)];
