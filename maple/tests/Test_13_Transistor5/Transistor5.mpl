VARS := [y__1(t), y__2(t), y__3(t), y__4(t), y__5(t)];
DAES := [-.4*sin(200*Pi*t)/R__0-y__1(t)/R__0-C__1*diff(y__1(t),t)+C__1*diff(
y__2(t),t) = 0, U__b/R__2-y__2(t)*(1/R__1+1/R__2)+(alpha-1)*beta*(exp((y__2(t)-
y__3(t))/U__f)-1)+C__1*diff(y__1(t),t)-C__1*diff(y__2(t),t) = 0, beta*(exp((
y__2(t)-y__3(t))/U__f)-1)-y__3(t)/R__3-C__2*diff(y__3(t),t) = 0, U__b/R__4-y__4
(t)/R__4-alpha*beta*(exp((y__2(t)-y__3(t))/U__f)-1)-C__3*diff(y__4(t),t)+C__3*
diff(y__5(t),t) = 0, -y__5(t)/R__5+C__3*diff(y__4(t),t)-C__3*diff(y__5(t),t) =
0];
ICS := [y__1(0) = 0., y__2(0) = 1/2*U__b, y__3(0) = 1/2*U__b, y__4(0) = U__b, 
y__5(0) = 0.];
DATA := [U__b = 6.0, U__f = .26e-1, alpha = .99, beta = .1e-5, R__0 = .1e4, 
R__1 = .9e4, R__2 = .9e4, R__3 = .9e4, R__4 = .9e4, R__5 = .9e4, R__6 = .9e4, 
C__1 = .1e-5, C__2 = .2e-5, C__3 = .3e-5];
