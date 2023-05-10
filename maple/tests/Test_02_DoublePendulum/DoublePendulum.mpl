POSITION_VARS := [x__1(t), y__1(t), x__2(t), y__2(t)];
VELOCITY_VARS := [u__1(t), v__1(t), u__2(t), v__2(t)];
LAMBDA_VARS := [lambda__1(t), lambda__2(t)];
VARS := [x__1(t), y__1(t), x__2(t), y__2(t), u__1(t), v__1(t), u__2(t), v__2(t)
, lambda__1(t), lambda__2(t)];
FIRST_ORDER := [diff(x__1(t),t) = u__1(t), diff(y__1(t),t) = v__1(t), diff(x__2
(t),t) = u__2(t), diff(y__2(t),t) = v__2(t)];
DAES := [-u__1(t)+diff(x__1(t),t) = 0, -v__1(t)+diff(y__1(t),t) = 0, -u__2(t)+
diff(x__2(t),t) = 0, -v__2(t)+diff(y__2(t),t) = 0, diff(u__1(t),t)*m__1+2*x__1(
t)*lambda__1(t) = 0, diff(v__1(t),t)*m__1+g*m__1+2*y__1(t)*lambda__1(t) = 0, 
diff(u__2(t),t)*m__2+2*x__2(t)*lambda__2(t) = 0, diff(v__2(t),t)*m__2+g*m__2+2*
y__2(t)*lambda__2(t) = 0, x__1(t)^2+y__1(t)^2-ell__1^2 = 0, x__2(t)^2+y__2(t)^2
-ell__2^2 = 0];
