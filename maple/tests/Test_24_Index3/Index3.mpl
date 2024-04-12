VARS := [x__1(t), x__2(t), x__3(t)];
DAES := [diff(x__2(t),t)+x__1(t) = sin(t), diff(x__3(t),t)+x__2(t) = sin(t), 
x__3(t) = cos(t)];
ICS := [x__1(0) = -2, x__2(0) = 0, x__3(0) = 1];
