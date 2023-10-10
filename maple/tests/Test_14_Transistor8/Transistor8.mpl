VARS := [y__1(t), y__2(t), y__3(t), y__4(t), y__5(t), y__6(t), y__7(t), y__8(t)
];
DAES := [-.1*sin(200*Pi*t)/R__0-y__1(t)/R__0-C__1*diff(y__1(t),t)+C__1*diff(
y__2(t),t) = 0, U__b/R__2-y__2(t)*(1/R__1+1/R__2)+(alpha-1)*beta*(exp((y__2(t)-
y__3(t))/U__f)-1)+C__1*diff(y__1(t),t)-C__1*diff(y__2(t),t) = 0, beta*(exp((
y__2(t)-y__3(t))/U__f)-1)-y__3(t)/R__3-C__2*diff(y__3(t),t) = 0, U__b/R__4-y__4
(t)/R__4-alpha*beta*(exp((y__2(t)-y__3(t))/U__f)-1)-C__3*diff(y__4(t),t)+C__3*
diff(y__5(t),t) = 0, U__b/R__6-y__5(t)*(1/R__5+1/R__6)+(alpha-1)*beta*(exp((
y__5(t)-y__6(t))/U__f)-1)+C__3*diff(y__4(t),t)-C__3*diff(y__5(t),t) = 0, beta*(
exp((y__5(t)-y__6(t))/U__f)-1)-y__6(t)/R__7-C__4*diff(y__6(t),t) = 0, U__b/R__8
-y__7(t)/R__8-alpha*beta*(exp((y__5(t)-y__6(t))/U__f)-1)-C__5*diff(y__7(t),t)+
C__5*diff(y__8(t),t) = 0, -y__8(t)/R__9+C__5*diff(y__7(t),t)-C__5*diff(y__8(t),
t) = 0];
