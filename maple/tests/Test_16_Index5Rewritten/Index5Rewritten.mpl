VARS := [x__1(t), x__2(t), x__3(t), x__4(t), x__5(t), x__6(t), u__1(t), u__2(t)
, v(t), w(t), X(t), Y(t)];
DAES := [-x__4(t)+diff(x__1(t),t) = 0, -x__5(t)+diff(x__2(t),t) = 0, -x__6(t)+
diff(x__3(t),t) = 0, -v(t)-X(t)*(2/(2-cos(x__3(t))^2)+2*cos(x__3(t))/(2-cos(
x__3(t))^2)+2/(2-cos(x__3(t))^2)*w)+diff(x__4(t),t) = 0, v(t)-X(t)*(1-6/(2-cos(
x__3(t))^2)+2*cos(x__3(t))/(2-cos(x__3(t))^2))+2/(2-cos(x__3(t))^2)*w-u__2(t)+
diff(x__5(t),t) = 0, v(t)-X(t)*(2/(2-cos(x__3(t))^2)-9*cos(x__3(t))/(2-cos(x__3
(t))^2))+2*x__4(t)^2*sin(x__3(t))/(2-cos(x__3(t))^2)+diff(Y(t),t)^2*cos(x__3(t)
)*sin(x__3(t))/(2-cos(x__3(t))^2)+(2/(2-cos(x__3(t))^2)+cos(x__3(t))/(2-cos(
x__3(t))^2))*w(t)+diff(x__6(t),t) = 0, cos(x__1(t))+cos(Y(t))-cos(exp(t)-1)-cos
(t-1) = 0, cos(x__1(t))+sin(Y(t))+sin(exp(t)-1)+sin(t-1) = 0, w(t)-u__1(t)+u__2
(t) = 0, X(t)-2*x__3(t)+x__2(t) = 0, Y(t)-x__1(t)-x__3(t) = 0, v(t)-2*diff(Y(t)
,t)^2*sin(x__3(t))/(2-cos(x__3(t))^2)-x__4(t)^2*cos(x__3(t))*sin(x__3(t))/(2-
cos(x__3(t))^2) = 0];
DAES := [-x__4(t)+diff(x__1(t),t) = 0, -x__5(t)+diff(x__2(t),t) = 0, -x__6(t)+
diff(x__3(t),t) = 0, -v(t)-X(t)*(2/(2-cos(x__3(t))^2)+2*cos(x__3(t))/(2-cos(
x__3(t))^2)+2/(2-cos(x__3(t))^2)*w)+diff(x__4(t),t) = 0, v(t)-X(t)*(1-6/(2-cos(
x__3(t))^2)+2*cos(x__3(t))/(2-cos(x__3(t))^2))+2/(2-cos(x__3(t))^2)*w-u__2(t)+
diff(x__5(t),t) = 0, v(t)-X(t)*(2/(2-cos(x__3(t))^2)-9*cos(x__3(t))/(2-cos(x__3
(t))^2))+2*x__4(t)^2*sin(x__3(t))/(2-cos(x__3(t))^2)+diff(Y(t),t)^2*cos(x__3(t)
)*sin(x__3(t))/(2-cos(x__3(t))^2)+(2/(2-cos(x__3(t))^2)+cos(x__3(t))/(2-cos(
x__3(t))^2))*w(t)+diff(x__6(t),t) = 0, cos(x__1(t))+cos(Y(t))-cos(exp(t)-1)-cos
(t-1) = 0, cos(x__1(t))+sin(Y(t))+sin(exp(t)-1)+sin(t-1) = 0, w(t)-u__1(t)+u__2
(t) = 0, X(t)-2*x__3(t)+x__2(t) = 0, Y(t)-x__1(t)-x__3(t) = 0, v(t)-2*diff(Y(t)
,t)^2*sin(x__3(t))/(2-cos(x__3(t))^2)-x__4(t)^2*cos(x__3(t))*sin(x__3(t))/(2-
cos(x__3(t))^2) = 0];
