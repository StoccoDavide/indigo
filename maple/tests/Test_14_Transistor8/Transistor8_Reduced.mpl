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
ODES := [(-C__2*diff(y__3(t),t)*R__3+beta*R__3*exp((y__2(t)-y__3(t))/U__f)-beta
*R__3-y__3(t))/R__3, (diff(y__6(t),t)*R__7*C__4-beta*R__7*exp((y__5(t)-y__6(t))
/U__f)+beta*R__7+y__6(t))/R__7/C__4, (diff(y__1(t),t)*R__0*C__1-diff(y__2(t),t)
*R__0*C__1+.1*sin(200*Pi*t)+y__1(t))/R__0/C__1, (alpha*beta*R__4*exp((y__2(t)-
y__3(t))/U__f)+diff(y__4(t),t)*R__4*C__3-diff(y__5(t),t)*R__4*C__3-alpha*beta*
R__4+y__4(t)-U__b)/R__4/C__3, (alpha*beta*R__8*exp((y__5(t)-y__6(t))/U__f)+diff
(y__7(t),t)*R__8*C__5-diff(y__8(t),t)*R__8*C__5-alpha*beta*R__8+y__7(t)-U__b)/
R__8/C__5, (((alpha-1.)*beta*R__0*R__2*R__1*diff(y__2(t),t)+(-1.*alpha+1.)*beta
*R__0*R__2*R__1*diff(y__3(t),t))*exp((y__2(t)-y__3(t))/U__f)-62.83185308*cos(
200*Pi*t)*U__f*R__1*R__2+(-1.*R__0*R__1*U__f-1.*R__0*R__2*U__f)*diff(y__2(t),t)
-1.*diff(y__1(t),t)*U__f*R__1*R__2)/U__f/R__0/C__1/R__1/R__2, (R__4*R__5*R__6*
beta*(alpha-1)*(diff(y__5(t),t)-diff(y__6(t),t))*exp((y__5(t)-y__6(t))/U__f)-
R__4*R__5*R__6*beta*alpha*(diff(y__2(t),t)-diff(y__3(t),t))*exp((y__2(t)-y__3(t
))/U__f)-U__f*(R__4*(R__6+R__5)*diff(y__5(t),t)+R__5*diff(y__4(t),t)*R__6))/
U__f/R__4/C__3/R__5/R__6, (-R__8*R__9*beta*alpha*(diff(y__5(t),t)-diff(y__6(t),
t))*exp((y__5(t)-y__6(t))/U__f)-U__f*(diff(y__7(t),t)*R__9+diff(y__8(t),t)*R__8
))/U__f/C__5/R__8/R__9];
INVS := [((alpha-1.)*beta*R__2*R__0*R__1*exp((y__2(t)-y__3(t))/U__f)-.1*R__1*
R__2*sin(200*Pi*t)+(-1.*R__0*R__1-1.*R__0*R__2)*y__2(t)-1.*R__1*R__2*y__1(t)+((
-1.*alpha+1.)*beta*R__2+U__b)*R__0*R__1)/R__0/C__1/R__1/R__2, (R__4*R__5*R__6*
beta*(alpha-1)*exp((y__5(t)-y__6(t))/U__f)-exp((y__2(t)-y__3(t))/U__f)*R__4*
R__5*R__6*alpha*beta-R__4*(R__6+R__5)*y__5(t)-R__5*(y__4(t)*R__6+(-R__6*beta-
U__b)*R__4-R__6*U__b))/R__4/C__3/R__5/R__6, (-exp((y__5(t)-y__6(t))/U__f)*R__8*
R__9*alpha*beta-y__7(t)*R__9-y__8(t)*R__8+R__9*(R__8*alpha*beta+U__b))/R__8/
C__5/R__9];
ICS := [y__1(0) = 0., y__2(0) = U__b/(R__2/R__1+1), y__3(0) = U__b/(R__2/R__1+1
), y__4(0) = U__b, y__5(0) = U__b/(R__6/R__5+1), y__6(0) = U__b/(R__6/R__5+1),
y__7(0) = U__b, y__8(0) = 0.];
DATA := [U__b = 6.0, U__f = .26e-1, alpha = .99, beta = .1e-5, R__0 = .1e4, 
R__1 = .9e4, R__2 = .9e4, R__3 = .9e4, R__4 = .9e4, R__5 = .9e4, R__6 = .9e4, 
R__7 = .9e4, R__8 = .9e4, R__9 = .9e4, C__1 = .1e-5, C__2 = .2e-5, C__3 = .3e-5
, C__4 = .4e-5, C__5 = .5e-5];
