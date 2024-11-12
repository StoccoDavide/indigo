VARS := [x__1(t), y__1(t), u__1(t), v__1(t), lambda__1(t), x__2(t), y__2(t), 
u__2(t), v__2(t), lambda__2(t), x__3(t), y__3(t), u__3(t), v__3(t), lambda__3(t
)];
DAES := [diff(x__1(t),t)-u__1(t) = 0, diff(y__1(t),t)-v__1(t) = 0, diff(u__1(t)
,t)+2*x__1(t)*lambda__1(t) = 0, diff(v__1(t),t)+2*y__1(t)*lambda__1(t)+g = 0, 
x__1(t)^2+y__1(t)^2-ell^2 = 0, diff(x__2(t),t)-u__2(t) = 0, diff(y__2(t),t)-
v__2(t) = 0, diff(u__2(t),t)+2*x__2(t)*lambda__2(t) = 0, diff(v__2(t),t)+2*y__2
(t)*lambda__2(t)+g = 0, x__2(t)^2+y__2(t)^2-(ell+c*lambda__1(t))^2 = 0, diff(
x__3(t),t)-u__3(t) = 0, diff(y__3(t),t)-v__3(t) = 0, diff(u__3(t),t)+2*x__3(t)*
lambda__3(t) = 0, diff(v__3(t),t)+2*y__3(t)*lambda__3(t)+g = 0, x__3(t)^2+y__3(
t)^2-(ell+c*lambda__2(t))^2 = 0];
ICS := [x__1(0) = 1, y__1(0) = 0, u__1(0) = 0, v__1(0) = 1, lambda__1(0) = 0, 
x__2(0) = 1, y__2(0) = 0, u__2(0) = 0, v__2(0) = 1, lambda__2(0) = 0, x__3(0) =
1, y__3(0) = 0, u__3(0) = 0, v__3(0) = 1, lambda__3(0) = 0];
DATA := [g = 1, ell = 1, c = .1];
P := 3;
INDEX := 7;
