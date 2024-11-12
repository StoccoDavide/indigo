VARS := [x__l(t), y__l(t), x__r(t), y__r(t), u__l(t), v__l(t), u__r(t), v__r(t)
, lambda__1(t), lambda__2(t)];
DAES := [-u__l(t)+diff(x__l(t),t) = 0, -v__l(t)+diff(y__l(t),t) = 0, -u__r(t)+
diff(x__r(t),t) = 0, -v__r(t)+diff(y__r(t),t) = 0, -(L__0-(x__l(t)^2+y__l(t)^2)
^(1/2))*x__l(t)/(x__l(t)^2+y__l(t)^2)^(1/2)-lambda__1(t)*(L^2-h^2*sin(omega*t)^
2)^(1/2)-2*lambda__2(t)*(x__l(t)-x__r(t))+1/2*varepsilon^2*M*diff(u__l(t),t) =
0, -(L__0-(x__l(t)^2+y__l(t)^2)^(1/2))*y__l(t)/(x__l(t)^2+y__l(t)^2)^(1/2)-
lambda__1(t)*h*sin(omega*t)-2*lambda__2(t)*(y__l(t)-y__r(t))+1/2*varepsilon^2*M
+1/2*varepsilon^2*M*diff(v__l(t),t) = 0, -(L__0-((x__r(t)-(L^2-h^2*sin(omega*t)
^2)^(1/2))^2+(y__r(t)-h*sin(omega*t))^2)^(1/2))*(x__r(t)-(L^2-h^2*sin(omega*t)^
2)^(1/2))/((x__r(t)-(L^2-h^2*sin(omega*t)^2)^(1/2))^2+(y__r(t)-h*sin(omega*t))^
2)^(1/2)+2*lambda__2(t)*(x__l(t)-x__r(t))+1/2*varepsilon^2*M*diff(u__r(t),t) =
0, -(L__0-((x__r(t)-(L^2-h^2*sin(omega*t)^2)^(1/2))^2+(y__r(t)-h*sin(omega*t))^
2)^(1/2))*(y__r(t)-h*sin(omega*t))/((x__r(t)-(L^2-h^2*sin(omega*t)^2)^(1/2))^2+
(y__r(t)-h*sin(omega*t))^2)^(1/2)+2*lambda__2(t)*(y__l(t)-y__r(t))+1/2*
varepsilon^2*M+1/2*varepsilon^2*M*diff(v__r(t),t) = 0, x__l(t)*(L^2-h^2*sin(
omega*t)^2)^(1/2)+y__l(t)*h*sin(omega*t) = 0, -L^2+y__r(t)^2-2*y__l(t)*y__r(t)+
x__r(t)^2-2*x__l(t)*x__r(t)+y__l(t)^2+x__l(t)^2 = 0];
ODES := [-u__l(t)+diff(x__l(t),t), -v__l(t)+diff(y__l(t),t), -u__r(t)+diff(x__r
(t),t), -v__r(t)+diff(y__r(t),t), -((-1/2*varepsilon^2*M*diff(u__l(t),t)+(2*
x__l(t)-2*x__r(t))*lambda__2(t)+(cos(omega*t)^2*h^2+L^2-h^2)^(1/2)*lambda__1(t)
-x__l(t))*(x__l(t)^2+y__l(t)^2)^(1/2)+x__l(t)*L__0)/(x__l(t)^2+y__l(t)^2)^(1/2)
, 1/2/(x__l(t)^2+y__l(t)^2)^(1/2)*((-2*lambda__1(t)*h*sin(omega*t)+varepsilon^2
*M*diff(v__l(t),t)+(-4*lambda__2(t)+2)*y__l(t)+varepsilon^2*M+4*y__r(t)*
lambda__2(t))*(x__l(t)^2+y__l(t)^2)^(1/2)-2*y__l(t)*L__0), -2*((1/2*(cos(omega*
t)^2*h^2+L^2-h^2)^(1/2)-1/4*varepsilon^2*M*diff(u__r(t),t)+(lambda__2(t)-1/2)*
x__r(t)-lambda__2(t)*x__l(t))*(-2*y__r(t)*sin(omega*t)*h+y__r(t)^2+L^2-2*x__r(t
)*(cos(omega*t)^2*h^2+L^2-h^2)^(1/2)+x__r(t)^2)^(1/2)+1/2*L__0*(x__r(t)-(cos(
omega*t)^2*h^2+L^2-h^2)^(1/2)))/(-2*y__r(t)*sin(omega*t)*h+y__r(t)^2+L^2-2*x__r
(t)*(cos(omega*t)^2*h^2+L^2-h^2)^(1/2)+x__r(t)^2)^(1/2), 2*((-1/2*h*sin(omega*t
)+1/4*varepsilon^2*M*diff(v__r(t),t)+(-lambda__2(t)+1/2)*y__r(t)+1/4*varepsilon
^2*M+lambda__2(t)*y__l(t))*(-2*y__r(t)*sin(omega*t)*h+y__r(t)^2+L^2-2*x__r(t)*(
cos(omega*t)^2*h^2+L^2-h^2)^(1/2)+x__r(t)^2)^(1/2)-1/2*L__0*(y__r(t)-h*sin(
omega*t)))/(-2*y__r(t)*sin(omega*t)*h+y__r(t)^2+L^2-2*x__r(t)*(cos(omega*t)^2*h
^2+L^2-h^2)^(1/2)+x__r(t)^2)^(1/2)];
INVS := [-x__l(t)*(cos(omega*t)^2*h^2+L^2-h^2)^(1/2)-y__l(t)*h*sin(omega*t), -
x__l(t)^2+2*x__l(t)*x__r(t)-x__r(t)^2+(L+y__l(t)-y__r(t))*(L-y__l(t)+y__r(t)),
(h*(y__l(t)*omega*cos(omega*t)+sin(omega*t)*v__l(t))*(cos(omega*t)^2*h^2+L^2-h^
2)^(1/2)+u__l(t)*cos(omega*t)^2*h^2-x__l(t)*cos(omega*t)*h^2*omega*sin(omega*t)
+u__l(t)*(L^2-h^2))/(cos(omega*t)^2*h^2+L^2-h^2)^(1/2), (2*x__l(t)-2*x__r(t))*
u__l(t)+(-2*x__l(t)+2*x__r(t))*u__r(t)+2*(y__l(t)-y__r(t))*(v__l(t)-v__r(t)), -\
4/(cos(omega*t)^2*h^2+L^2-h^2)^(3/2)/(x__l(t)^2+y__l(t)^2)^(1/2)*(1/2*(cos(
omega*t)^2*h^2+L^2-h^2)^(3/2)*((cos(omega*t)*M*h*omega*varepsilon^2*v__l(t)+2*(
lambda__2(t)*(y__l(t)-y__r(t))+(-1/4*M*omega^2*varepsilon^2-1/2)*y__l(t)-1/4*
varepsilon^2*M)*h*sin(omega*t)+L^2*lambda__1(t))*(x__l(t)^2+y__l(t)^2)^(1/2)+
L__0*y__l(t)*sin(omega*t)*h)+(((-1/4*M*omega^2*varepsilon^2+lambda__2(t)-1/2)*
x__l(t)-lambda__2(t)*x__r(t))*h^4*cos(omega*t)^4-1/2*M*cos(omega*t)^3*sin(omega
*t)*u__l(t)*h^4*omega*varepsilon^2+2*(L+h)*(L-h)*((-1/4*M*omega^2*varepsilon^2+
lambda__2(t)-1/2)*x__l(t)-lambda__2(t)*x__r(t))*h^2*cos(omega*t)^2-1/2*M*sin(
omega*t)*u__l(t)*h^2*omega*varepsilon^2*(L-h)*(L+h)*cos(omega*t)+(((L^2-h^2)*
lambda__2(t)+(1/4*M*omega^2*varepsilon^2+1/2)*h^2-1/2*L^2)*x__l(t)-lambda__2(t)
*x__r(t)*(L-h)*(L+h))*(L+h)*(L-h))*(x__l(t)^2+y__l(t)^2)^(1/2)+1/2*L__0*x__l(t)
*(cos(omega*t)^2*h^2+L^2-h^2)^2)/varepsilon^2/M, -2*((2*(x__l(t)^2+y__l(t)^2)^(
1/2)*(lambda__1(t)-1)*(x__l(t)-x__r(t))*(cos(omega*t)^2*h^2+L^2-h^2)^(1/2)+(2*h
*(lambda__1(t)-1)*(y__l(t)-y__r(t))*sin(omega*t)+(8*lambda__2(t)-2)*x__l(t)^2+(
-16*lambda__2(t)+4)*x__r(t)*x__l(t)+(8*lambda__2(t)-2)*x__r(t)^2+(8*lambda__2(t
)-2)*y__l(t)^2+(-16*lambda__2(t)+4)*y__r(t)*y__l(t)+(8*lambda__2(t)-2)*y__r(t)^
2+(u__l(t)^2-2*u__r(t)*u__l(t)+u__r(t)^2+(v__l(t)-v__r(t))^2)*M*varepsilon^2)*(
x__l(t)^2+y__l(t)^2)^(1/2)+2*(x__l(t)^2-x__l(t)*x__r(t)+y__l(t)*(y__l(t)-y__r(t
)))*L__0)*(-2*y__r(t)*sin(omega*t)*h+y__r(t)^2+L^2-2*x__r(t)*(cos(omega*t)^2*h^
2+L^2-h^2)^(1/2)+x__r(t)^2)^(1/2)-2*(x__l(t)^2+y__l(t)^2)^(1/2)*((-x__l(t)+x__r
(t))*(cos(omega*t)^2*h^2+L^2-h^2)^(1/2)-h*(y__l(t)-y__r(t))*sin(omega*t)+x__l(t
)*x__r(t)-x__r(t)^2+y__r(t)*(y__l(t)-y__r(t)))*L__0)/(-2*y__r(t)*sin(omega*t)*h
+y__r(t)^2+L^2-2*x__r(t)*(cos(omega*t)^2*h^2+L^2-h^2)^(1/2)+x__r(t)^2)^(1/2)/(
x__l(t)^2+y__l(t)^2)^(1/2)/varepsilon^2/M];
ICS := [x__l(0) = 0, y__l(0) = 1/2, x__r(0) = 1, y__r(0) = 1/2, u__l(0) = -1/2,
v__l(0) = 0, u__r(0) = -1/2, v__r(0) = 0, lambda__1(0) = 0, lambda__2(0) = 0];
DATA := [L = 1.0, L__0 = .5, varepsilon = .1e-1, M = 10.0, h = .1, tau = .62831\
85308, omega = 10.0];
