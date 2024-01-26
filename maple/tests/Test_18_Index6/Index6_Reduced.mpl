VARS := [x__1(t), x__2(t), x__3(t), x__4(t), x__5(t), x__6(t)];
DAES := [diff(x__6(t),t)+x__5(t) = sin(t), diff(x__5(t),t)+x__4(t) = sin(t), 
diff(x__4(t),t)+x__3(t) = sin(t), diff(x__3(t),t)+x__2(t) = sin(t), diff(x__2(t
),t)+x__1(t) = sin(t), x__6(t) = cos(t)];
ODES := [diff(x__3(t),t)+x__2(t)-sin(t), diff(x__4(t),t)+x__3(t)-sin(t), diff(
x__5(t),t)+x__4(t)-sin(t), diff(x__6(t),t)+x__5(t)-sin(t), diff(x__2(t),t)+x__1
(t)-sin(t), 2*cos(t)-diff(x__1(t),t)];
INVS := [-x__6(t)+cos(t), 2*sin(t)-x__5(t), -2*cos(t)-x__4(t)+sin(t), -sin(t)-
cos(t)-x__3(t), cos(t)-x__2(t), 2*sin(t)-x__1(t)];
ICS := [x__1(0) = 0., x__2(0) = 1.0, x__3(0) = -1.0, x__4(0) = -2.0, x__5(0) =
0., x__6(0) = 1.0];
