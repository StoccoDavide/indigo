POSITION_VARS := [x__l(t), y__l(t), x__r(t), y__r(t)];
VELOCITY_VARS := [u__l(t), v__l(t), u__r(t), v__r(t)];
LAMBDA_VARS := [lambda__1(t), lambda__2(t)];
VARS := [x__l(t), y__l(t), x__r(t), y__r(t), u__l(t), v__l(t), u__r(t), v__r(t)
, lambda__1(t), lambda__2(t)];
FIRST_ORDER := [diff(x__l(t),t) = u__l(t), diff(y__l(t),t) = v__l(t), diff(x__r
(t),t) = u__r(t), diff(y__r(t),t) = v__r(t)];
DAES := [-u__l(t)+diff(x__l(t),t) = 0, -v__l(t)+diff(y__l(t),t) = 0, -u__r(t)+
diff(x__r(t),t) = 0, -v__r(t)+diff(y__r(t),t) = 0, -(L__0-(x__l(t)^2+y__l(t)^2)
^(1/2))*x__l(t)/(x__l(t)^2+y__l(t)^2)^(1/2)-lambda__1(t)*(L^2-h^2*sin(omega*t)^
2)^(1/2)-2*lambda__2(t)*(x__l(t)-x__r(t))+1/2*varepsilon^2*M*diff(u__l(t),t) =
0, -(L__0-(x__l(t)^2+y__l(t)^2)^(1/2))*y__l(t)/(x__l(t)^2+y__l(t)^2)^(1/2)-
lambda__1(t)*h*sin(omega*t)-2*lambda__2(t)*(y__l(t)-y__r(t))+1/2*varepsilon^2*M
+1/2*varepsilon^2*M*diff(v__l(t),t) = 0, -(L__0-((x__r(t)-(L^2-h^2*sin(omega*t)
^2)^(1/2))^2+(y__r(t)-(L^2-h^2*sin(omega*t)^2)^(1/2))^2)^(1/2))*(x__r(t)-(L^2-h
^2*sin(omega*t)^2)^(1/2))/((x__r(t)-(L^2-h^2*sin(omega*t)^2)^(1/2))^2+(y__r(t)-
(L^2-h^2*sin(omega*t)^2)^(1/2))^2)^(1/2)+2*lambda__2(t)*(x__l(t)-x__r(t))+1/2*
varepsilon^2*M*diff(u__r(t),t) = 0, -(L__0-((x__r(t)-(L^2-h^2*sin(omega*t)^2)^(
1/2))^2+(y__r(t)-(L^2-h^2*sin(omega*t)^2)^(1/2))^2)^(1/2))*(y__r(t)-h*sin(omega
*t))/((x__r(t)-(L^2-h^2*sin(omega*t)^2)^(1/2))^2+(y__r(t)-(L^2-h^2*sin(omega*t)
^2)^(1/2))^2)^(1/2)+2*lambda__2(t)*(y__l(t)-y__r(t))+1/2*varepsilon^2*M+1/2*
varepsilon^2*M*diff(v__r(t),t) = 0, x__l(t)*(L^2-h^2*sin(omega*t)^2)^(1/2)+y__l
(t)*h*sin(omega*t) = 0, -L^2+y__r(t)^2-2*y__l(t)*y__r(t)+x__r(t)^2-2*x__l(t)*
x__r(t)+y__l(t)^2+x__l(t)^2 = 0];
