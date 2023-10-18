VARS := [x__1(t), x__2(t), x__3(t), x__4(t), x__5(t), x__6(t)];
DAES := [diff(x__1(t),t) = cos(t)-x__2(t)+x__3(t), diff(x__2(t),t) = cos(t)-
x__3(t)+x__4(t), diff(x__3(t),t) = cos(t)-x__4(t)+x__5(t), diff(x__4(t),t) = 
cos(t)-x__5(t)+x__6(t), diff(x__5(t),t) = cos(t)+sin(t)-x__6(t), x__1(t)+x__2(t
)+x__3(t)+x__4(t)+x__5(t)-5*sin(t) = 0];
ICS := [x__1(0) = 0, x__2(0) = 0, x__3(0) = 0, x__4(0) = 0, x__5(0) = 0, x__6(0
) = 0];
