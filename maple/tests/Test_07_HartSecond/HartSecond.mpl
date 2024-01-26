POSITION_VARS := [x__AC(t), y__AC(t), theta__AC(t), x__BD(t), y__BD(t), 
theta__BD(t), x__fg(t), y__fg(t), theta__fg(t), x__CE(t), y__CE(t), theta__CE(t
), x__ED(t), y__ED(t), theta__ED(t)];
VELOCITY_VARS := [u__AC(t), v__AC(t), omega__AC(t), u__BD(t), v__BD(t), 
omega__BD(t), u__fg(t), v__fg(t), omega__fg(t), u__CE(t), v__CE(t), omega__CE(t
), u__ED(t), v__ED(t), omega__ED(t)];
LAMBDA_VARS := [lambda__1(t), lambda__2(t), lambda__3(t), lambda__4(t), 
lambda__5(t), lambda__6(t), lambda__7(t), lambda__8(t), lambda__9(t), 
lambda__10(t), lambda__11(t), lambda__12(t), lambda__13(t), lambda__14(t)];
VARS := [x__AC(t), y__AC(t), theta__AC(t), x__BD(t), y__BD(t), theta__BD(t), 
x__fg(t), y__fg(t), theta__fg(t), x__CE(t), y__CE(t), theta__CE(t), x__ED(t), 
y__ED(t), theta__ED(t), u__AC(t), v__AC(t), omega__AC(t), u__BD(t), v__BD(t), 
omega__BD(t), u__fg(t), v__fg(t), omega__fg(t), u__CE(t), v__CE(t), omega__CE(t
), u__ED(t), v__ED(t), omega__ED(t), lambda__1(t), lambda__2(t), lambda__3(t),
lambda__4(t), lambda__5(t), lambda__6(t), lambda__7(t), lambda__8(t), lambda__9
(t), lambda__10(t), lambda__11(t), lambda__12(t), lambda__13(t), lambda__14(t)]
;
DAES := [-u__AC(t)+diff(x__AC(t),t) = 0, -v__AC(t)+diff(y__AC(t),t) = 0, -
omega__AC(t)+diff(theta__AC(t),t) = 0, -u__BD(t)+diff(x__BD(t),t) = 0, -v__BD(t
)+diff(y__BD(t),t) = 0, -omega__BD(t)+diff(theta__BD(t),t) = 0, -u__fg(t)+diff(
x__fg(t),t) = 0, -v__fg(t)+diff(y__fg(t),t) = 0, -omega__fg(t)+diff(theta__fg(t
),t) = 0, -u__CE(t)+diff(x__CE(t),t) = 0, -v__CE(t)+diff(y__CE(t),t) = 0, -
omega__CE(t)+diff(theta__CE(t),t) = 0, -u__ED(t)+diff(x__ED(t),t) = 0, -v__ED(t
)+diff(y__ED(t),t) = 0, -omega__ED(t)+diff(theta__ED(t),t) = 0, 4*diff(u__AC(t)
,t)*m+lambda__1(t)-lambda__5(t)-lambda__9(t) = 0, 4*diff(v__AC(t),t)*m+4*g*m+
lambda__2(t)-lambda__6(t)-lambda__10(t) = 0, -l*(-64*diff(omega__AC(t),t)*l*m+
12*lambda__6(t)*cos(theta__AC(t))+9*lambda__10(t)*cos(theta__AC(t))-12*
lambda__5(t)*sin(theta__AC(t))-9*lambda__9(t)*sin(theta__AC(t))) = 0, 4*diff(
u__BD(t),t)*m+lambda__3(t)-lambda__7(t)+lambda__11(t) = 0, 4*diff(v__BD(t),t)*m
+lambda__4(t)-lambda__8(t)+lambda__12(t)+4*g*m = 0, -l*(-64*diff(omega__BD(t),t
)*l*m+12*lambda__8(t)*cos(theta__BD(t))-9*lambda__12(t)*cos(theta__BD(t))-12*
lambda__7(t)*sin(theta__BD(t))+9*lambda__11(t)*sin(theta__BD(t))) = 0, 2*diff(
u__fg(t),t)*m-lambda__11(t)+lambda__9(t) = 0, 2*diff(v__fg(t),t)*m+lambda__10(t
)-lambda__12(t)+2*g*m = 0, -2*l*(-4*diff(omega__fg(t),t)*l*m+3*lambda__12(t)*
cos(theta__fg(t))-3*lambda__11(t)*sin(theta__fg(t))) = 0, 2*diff(u__CE(t),t)*m+
lambda__5(t)-lambda__13(t) = 0, 2*diff(v__CE(t),t)*m-lambda__14(t)+lambda__6(t)
+2*g*m = 0, -2*l*(-4*diff(omega__CE(t),t)*l*m+3*cos(theta__CE(t))*lambda__14(t)
-3*sin(theta__CE(t))*lambda__13(t)) = 0, 2*diff(u__ED(t),t)*m+lambda__7(t)+
lambda__13(t) = 0, 2*diff(v__ED(t),t)*m+2*g*m+lambda__14(t)+lambda__8(t) = 0, 2
*l*(4*diff(omega__ED(t),t)*l*m+3*cos(theta__ED(t))*lambda__14(t)-3*sin(
theta__ED(t))*lambda__13(t)) = 0, 2*l+x__AC(t) = 0, y__AC(t) = 0, -2*l+x__BD(t)
= 0, y__BD(t) = 0, -4*cos(theta__AC(t))*l+x__CE(t)-x__AC(t) = 0, -4*sin(
theta__AC(t))*l+y__CE(t)-y__AC(t) = 0, -4*cos(theta__BD(t))*l-x__BD(t)+x__ED(t)
= 0, -4*sin(theta__BD(t))*l-y__BD(t)+y__ED(t) = 0, -3*cos(theta__AC(t))*l+x__fg
(t)-x__AC(t) = 0, -3*sin(theta__AC(t))*l+y__fg(t)-y__AC(t) = 0, -2*cos(
theta__fg(t))*l+3*cos(theta__BD(t))*l+x__BD(t)-x__fg(t) = 0, -2*sin(theta__fg(t
))*l+3*sin(theta__BD(t))*l+y__BD(t)-y__fg(t) = 0, -2*cos(theta__CE(t))*l+2*l*
cos(theta__ED(t))-x__CE(t)+x__ED(t) = 0, 2*l*sin(theta__ED(t))-2*sin(theta__CE(
t))*l-y__CE(t)+y__ED(t) = 0];
FIRST_ORDER := [diff(x__AC(t),t) = u__AC(t), diff(y__AC(t),t) = v__AC(t), diff(
theta__AC(t),t) = omega__AC(t), diff(x__BD(t),t) = u__BD(t), diff(y__BD(t),t) =
v__BD(t), diff(theta__BD(t),t) = omega__BD(t), diff(x__fg(t),t) = u__fg(t), 
diff(y__fg(t),t) = v__fg(t), diff(theta__fg(t),t) = omega__fg(t), diff(x__CE(t)
,t) = u__CE(t), diff(y__CE(t),t) = v__CE(t), diff(theta__CE(t),t) = omega__CE(t
), diff(x__ED(t),t) = u__ED(t), diff(y__ED(t),t) = v__ED(t), diff(theta__ED(t),
t) = omega__ED(t)];
