VARS := [x__1(t), x__2(t), x__3(t), x__4(t), x__5(t)];
ODES := [-cos(t)+diff(x__2(t),t)+diff(x__3(t),t)+x__1(t), -cos(t)+diff(x__4(t),
t)+diff(x__5(t),t)+x__3(t), -diff(x__2(t),t)+diff(x__1(t),t), -diff(x__4(t),t)+
diff(x__3(t),t), -sin(t)-diff(x__5(t),t)];
INVS := [-x__2(t)+x__1(t), -x__4(t)+x__3(t), cos(t)-x__5(t)];
ICS := [x__1(0) = 0, x__2(0) = 0, x__3(0) = 0, x__4(0) = 0, x__5(0) = 1];
