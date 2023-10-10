VARS := [y__1(t), y__2(t), y__3(t), y__4(t), y__5(t)];
DAES := [-.4*sin(200*Pi*t)/R__0-y__1(t)/R__0-C__1*diff(y__1(t),t)+C__1*diff(
y__2(t),t) = 0, U__b/R__2-y__2(t)*(1/R__1+1/R__2)+(alpha-1)*beta*(exp((y__2(t)-
y__3(t))/U__f)-1)+C__1*diff(y__1(t),t)-C__1*diff(y__2(t),t) = 0, beta*(exp((
y__2(t)-y__3(t))/U__f)-1)-y__3(t)/R__3-C__2*diff(y__3(t),t) = 0, U__b/R__4-y__4
(t)/R__4-alpha*beta*(exp((y__2(t)-y__3(t))/U__f)-1)-C__3*diff(y__4(t),t)+C__3*
diff(y__5(t),t) = 0, -y__5(t)/R__5+C__3*diff(y__4(t),t)-C__3*diff(y__5(t),t) =
0];
