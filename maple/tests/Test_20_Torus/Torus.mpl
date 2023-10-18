VARS := [x__1(t), x__2(t), x__3(t), u__1(t), u__2(t), u__3(t), lambda(t)];
DAES := [diff(x__1(t),t) = u__1(t), diff(x__2(t),t) = u__2(t), diff(x__3(t),t)
= u__3(t), diff(u__1(t),t) = u__3(t)*cos(t)-x__3(t)*sin(t)-u__2(t)+2*(1-r/(x__1
(t)^2+x__2(t)^2)^(1/2))*x__1(t)*lambda(t), diff(u__2(t),t) = u__3(t)*sin(t)+
x__3(t)*cos(t)+u__1(t)+2*(1-r/(x__1(t)^2+x__2(t)^2)^(1/2))*x__2(t)*lambda(t), 
diff(u__3(t),t) = -x__3(t)+2*x__3(t)*lambda(t), x__1(t)^2+x__2(t)^2+x__3(t)^2-2
*r*(x__1(t)^2+x__2(t)^2)^(1/2)+r^2-rho^2 = 0];
ICS := [x__1(0) = 15.0, x__2(0) = 0., x__3(0) = 0., u__1(0) = 0., u__2(0) = 15.\
0, u__3(0) = -5.0, lambda(0) = 0.];
DATA := [r = 10.0, rho = 5.0];
