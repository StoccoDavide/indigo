VARS := [x__1(t), x__2(t), x__3(t)];
DAES := [diff(x__2(t),t)+x__1(t) = sin(t), diff(x__3(t),t)+x__2(t) = sin(t), 
x__3(t) = cos(t)];
ODES := [-sin(t)+diff(x__3(t),t)+x__2(t), -sin(t)+diff(x__2(t),t)+x__1(t), 2*
sin(t)+cos(t)-diff(x__1(t),t)];
INVS := [cos(t)-x__3(t), 2*sin(t)-x__2(t), -2*cos(t)+sin(t)-x__1(t)];
ICS := [x__1(0) = -2, x__2(0) = 0, x__3(0) = 1];
