VARS := [x__1(t), y__1(t), u__1(t), v__1(t), lambda__1(t), x__2(t), y__2(t), 
u__2(t), v__2(t), lambda__2(t)];
ODES := [diff(x__1(t),t)-u__1(t), diff(y__1(t),t)-v__1(t), diff(u__1(t),t)+2*
x__1(t)*lambda__1(t), diff(v__1(t),t)+2*y__1(t)*lambda__1(t)+g, diff(x__2(t),t)
-u__2(t), diff(y__2(t),t)-v__2(t), diff(u__2(t),t)+2*x__2(t)*lambda__2(t), diff
(v__2(t),t)+2*y__2(t)*lambda__2(t)+g, 2*c*(ell+c*lambda__1(t))*diff(lambda__1(t
),t)-2*x__2(t)*u__2(t)-2*y__2(t)*v__2(t), (-64*c*(c^4*(x__1(t)^2+y__1(t)^2)*
lambda__1(t)^5+7/16*c^3*(64/7*y__1(t)^2*ell+c*y__1(t)*g+64/7*ell*x__1(t)^2-4/7*
c*(u__1(t)^2+v__1(t)^2))*lambda__1(t)^4+7/4*c^2*(24/7*y__1(t)^2*ell+c*y__1(t)*g
+24/7*ell*x__1(t)^2-4/7*c*(u__1(t)^2+v__1(t)^2))*ell*lambda__1(t)^3-1/8*c*((c*
x__2(t)^2*lambda__2(t)+c*y__2(t)^2*lambda__2(t)+1/2*c*y__2(t)*g-1/2*c*u__2(t)^2
-1/2*c*v__2(t)^2-32*ell^3)*y__1(t)^2-3*c*(x__2(t)*u__2(t)*v__1(t)+y__2(t)*v__1(
t)*v__2(t)+7*g*ell^2)*y__1(t)+(c*x__2(t)^2*lambda__2(t)+c*y__2(t)^2*lambda__2(t
)+1/2*c*y__2(t)*g-1/2*c*u__2(t)^2-1/2*c*v__2(t)^2-32*ell^3)*x__1(t)^2-3*c*u__1(
t)*(x__2(t)*u__2(t)+y__2(t)*v__2(t))*x__1(t)+12*c*ell^2*(u__1(t)^2+v__1(t)^2))*
lambda__1(t)^2-1/4*((c*x__2(t)^2*lambda__2(t)+c*y__2(t)^2*lambda__2(t)+1/2*c*
y__2(t)*g-1/2*c*u__2(t)^2-1/2*c*v__2(t)^2-4*ell^3)*y__1(t)^2-3*c*(x__2(t)*u__2(
t)*v__1(t)+y__2(t)*v__1(t)*v__2(t)+7/3*g*ell^2)*y__1(t)+(c*x__2(t)^2*lambda__2(
t)+c*y__2(t)^2*lambda__2(t)+1/2*c*y__2(t)*g-1/2*c*u__2(t)^2-1/2*c*v__2(t)^2-4*
ell^3)*x__1(t)^2-3*c*u__1(t)*(x__2(t)*u__2(t)+y__2(t)*v__2(t))*x__1(t)+4*c*ell^
2*(u__1(t)^2+v__1(t)^2))*ell*lambda__1(t)+((-3/16*v__2(t)^2-1/8*lambda__2(t)*
ell^2)*y__2(t)^2+(-3/8*x__2(t)*u__2(t)*v__2(t)-1/16*g*ell^2)*y__2(t)+(-3/16*
u__2(t)^2-1/8*lambda__2(t)*ell^2)*x__2(t)^2+1/16*ell^2*(u__2(t)^2+v__2(t)^2))*
y__1(t)^2+3/8*(x__2(t)*u__2(t)*v__1(t)+y__2(t)*v__1(t)*v__2(t)+7/6*g*ell^2)*ell
^2*y__1(t)+((-3/16*v__2(t)^2-1/8*lambda__2(t)*ell^2)*y__2(t)^2+(-3/8*x__2(t)*
u__2(t)*v__2(t)-1/16*g*ell^2)*y__2(t)+(-3/16*u__2(t)^2-1/8*lambda__2(t)*ell^2)*
x__2(t)^2+1/16*ell^2*(u__2(t)^2+v__2(t)^2))*x__1(t)^2+3/8*ell^2*u__1(t)*(x__2(t
)*u__2(t)+y__2(t)*v__2(t))*x__1(t)-1/4*ell^4*(u__1(t)^2+v__1(t)^2))*diff(
lambda__1(t),t)-64*(ell+c*lambda__1(t))*((c^4*y__1(t)*lambda__1(t)^5+(7/16*c^4*
g+3*c^3*ell*y__1(t))*lambda__1(t)^4+(21/16*c^3*g*ell+3*c^2*y__1(t)*ell^2)*
lambda__1(t)^3+1/4*c*((c*x__2(t)^2*lambda__2(t)+c*y__2(t)^2*lambda__2(t)+1/2*c*
y__2(t)*g-1/2*c*u__2(t)^2-1/2*c*v__2(t)^2+4*ell^3)*y__1(t)-3/2*c*(x__2(t)*u__2(
t)*v__1(t)+y__2(t)*v__1(t)*v__2(t)-7/2*g*ell^2))*lambda__1(t)^2+1/2*c*((x__2(t)
^2*lambda__2(t)+y__2(t)^2*lambda__2(t)+1/2*y__2(t)*g-1/2*u__2(t)^2-1/2*v__2(t)^
2)*y__1(t)-3/2*x__2(t)*u__2(t)*v__1(t)-3/2*y__2(t)*v__1(t)*v__2(t)+7/8*g*ell^2)
*ell*lambda__1(t)+((1/8*v__2(t)^2+1/4*lambda__2(t)*ell^2)*y__2(t)^2+(1/8*g*ell^
2+1/4*x__2(t)*u__2(t)*v__2(t))*y__2(t)+(1/8*u__2(t)^2+1/4*lambda__2(t)*ell^2)*
x__2(t)^2-1/8*ell^2*(u__2(t)^2+v__2(t)^2))*y__1(t)-3/8*ell^2*v__1(t)*(x__2(t)*
u__2(t)+y__2(t)*v__2(t)))*diff(y__1(t),t)+(c^4*x__1(t)*lambda__1(t)^5+3*c^3*ell
*x__1(t)*lambda__1(t)^4+3*c^2*ell^2*x__1(t)*lambda__1(t)^3+1/4*c*((c*x__2(t)^2*
lambda__2(t)+c*y__2(t)^2*lambda__2(t)+1/2*c*y__2(t)*g-1/2*c*u__2(t)^2-1/2*c*
v__2(t)^2+4*ell^3)*x__1(t)-3/2*c*u__1(t)*(x__2(t)*u__2(t)+y__2(t)*v__2(t)))*
lambda__1(t)^2+1/2*c*ell*((x__2(t)^2*lambda__2(t)+y__2(t)^2*lambda__2(t)+1/2*
y__2(t)*g-1/2*u__2(t)^2-1/2*v__2(t)^2)*x__1(t)-3/2*u__1(t)*(x__2(t)*u__2(t)+
y__2(t)*v__2(t)))*lambda__1(t)+((1/8*v__2(t)^2+1/4*lambda__2(t)*ell^2)*y__2(t)^
2+(1/8*g*ell^2+1/4*x__2(t)*u__2(t)*v__2(t))*y__2(t)+(1/8*u__2(t)^2+1/4*
lambda__2(t)*ell^2)*x__2(t)^2-1/8*ell^2*(u__2(t)^2+v__2(t)^2))*x__1(t)-3/8*ell^
2*u__1(t)*(x__2(t)*u__2(t)+y__2(t)*v__2(t)))*diff(x__1(t),t)+(1/4*c^2*((y__2(t)
*lambda__2(t)+1/4*g)*y__1(t)^2-3/2*v__1(t)*v__2(t)*y__1(t)+x__1(t)*((y__2(t)*
lambda__2(t)+1/4*g)*x__1(t)-3/2*u__1(t)*v__2(t)))*lambda__1(t)^2+1/2*c*((y__2(t
)*lambda__2(t)+1/4*g)*y__1(t)^2-3/2*v__1(t)*v__2(t)*y__1(t)+x__1(t)*((y__2(t)*
lambda__2(t)+1/4*g)*x__1(t)-3/2*u__1(t)*v__2(t)))*ell*lambda__1(t)+((1/8*v__2(t
)^2+1/4*lambda__2(t)*ell^2)*y__2(t)+1/16*g*ell^2+1/8*x__2(t)*u__2(t)*v__2(t))*
y__1(t)^2-3/8*ell^2*v__1(t)*v__2(t)*y__1(t)+1/8*(((2*lambda__2(t)*ell^2+v__2(t)
^2)*y__2(t)+1/2*g*ell^2+x__2(t)*u__2(t)*v__2(t))*x__1(t)-3*ell^2*u__1(t)*v__2(t
))*x__1(t))*diff(y__2(t),t)+(-3/8*(1/3*u__2(t)*y__1(t)^2+v__1(t)*x__2(t)*y__1(t
)+x__1(t)*(x__2(t)*u__1(t)+1/3*u__2(t)*x__1(t)))*c^2*lambda__1(t)^2-3/4*(1/3*
u__2(t)*y__1(t)^2+v__1(t)*x__2(t)*y__1(t)+x__1(t)*(x__2(t)*u__1(t)+1/3*u__2(t)*
x__1(t)))*c*ell*lambda__1(t)+(1/8*x__2(t)^2*u__2(t)-1/8*ell^2*u__2(t)+1/8*x__2(
t)*v__2(t)*y__2(t))*y__1(t)^2-3/8*ell^2*v__1(t)*x__2(t)*y__1(t)+1/8*((x__2(t)^2
*u__2(t)+x__2(t)*v__2(t)*y__2(t)-ell^2*u__2(t))*x__1(t)-3*x__2(t)*ell^2*u__1(t)
)*x__1(t))*diff(u__2(t),t)+(-1/8*c^2*(v__2(t)*y__1(t)^2+3*y__2(t)*v__1(t)*y__1(
t)+3*u__1(t)*y__2(t)*x__1(t)+v__2(t)*x__1(t)^2)*lambda__1(t)^2-1/4*c*ell*(v__2(
t)*y__1(t)^2+3*y__2(t)*v__1(t)*y__1(t)+3*u__1(t)*y__2(t)*x__1(t)+v__2(t)*x__1(t
)^2)*lambda__1(t)+(1/8*v__2(t)*y__2(t)^2-1/8*ell^2*v__2(t)+1/8*x__2(t)*u__2(t)*
y__2(t))*y__1(t)^2-3/8*ell^2*v__1(t)*y__2(t)*y__1(t)+1/8*x__1(t)*((x__2(t)*u__2
(t)*y__2(t)+v__2(t)*y__2(t)^2-ell^2*v__2(t))*x__1(t)-3*y__2(t)*ell^2*u__1(t)))*
diff(v__2(t),t)+(1/4*(x__2(t)*lambda__2(t)*y__1(t)^2-3/2*v__1(t)*u__2(t)*y__1(t
)+x__1(t)*(x__2(t)*lambda__2(t)*x__1(t)-3/2*u__1(t)*u__2(t)))*c^2*lambda__1(t)^
2+1/2*(x__2(t)*lambda__2(t)*y__1(t)^2-3/2*v__1(t)*u__2(t)*y__1(t)+x__1(t)*(x__2
(t)*lambda__2(t)*x__1(t)-3/2*u__1(t)*u__2(t)))*c*ell*lambda__1(t)+(1/8*u__2(t)*
v__2(t)*y__2(t)+1/4*(1/2*u__2(t)^2+lambda__2(t)*ell^2)*x__2(t))*y__1(t)^2-3/8*
ell^2*v__1(t)*u__2(t)*y__1(t)+1/4*((1/2*u__2(t)*v__2(t)*y__2(t)+(1/2*u__2(t)^2+
lambda__2(t)*ell^2)*x__2(t))*x__1(t)-3/2*ell^2*u__1(t)*u__2(t))*x__1(t))*diff(
x__2(t),t)-1/2*(-1/4*(x__1(t)^2+y__1(t)^2)*(x__2(t)^2+y__2(t)^2)*diff(lambda__2
(t),t)+(c^2*u__1(t)*lambda__1(t)^2+c*ell*u__1(t)*lambda__1(t)+3/4*x__1(t)*(x__2
(t)*u__2(t)+y__2(t)*v__2(t)))*diff(u__1(t),t)+diff(v__1(t),t)*(c^2*v__1(t)*
lambda__1(t)^2+c*ell*v__1(t)*lambda__1(t)+3/4*y__1(t)*(x__2(t)*u__2(t)+y__2(t)*
v__2(t))))*(ell+c*lambda__1(t))^2))/(ell+c*lambda__1(t))^4/c];
INVS := [-x__1(t)^2-y__1(t)^2+ell^2, lambda__1(t)^2*c^2+2*lambda__1(t)*c*ell-
y__2(t)^2-x__2(t)^2+ell^2, 2*x__1(t)*u__1(t)+2*y__1(t)*v__1(t), 4*x__1(t)^2*
lambda__1(t)+4*lambda__1(t)*y__1(t)^2-2*u__1(t)^2-2*v__1(t)^2+2*y__1(t)*g, (-16
*c^2*(y__1(t)*v__1(t)+x__1(t)*u__1(t))*lambda__1(t)^2+((-6*c^2*g-16*c*ell*y__1(
t))*v__1(t)-16*c*ell*u__1(t)*x__1(t))*lambda__1(t)-6*v__1(t)*c*ell*g-4*(x__1(t)
^2+y__1(t)^2)*(x__2(t)*u__2(t)+y__2(t)*v__2(t)))/c/(ell+c*lambda__1(t)), (-32*c
^4*(x__1(t)^2+y__1(t)^2)*lambda__1(t)^5+(-96*c^3*ell*y__1(t)^2-28*c^4*y__1(t)*g
-96*c^3*ell*x__1(t)^2+16*c^4*(u__1(t)^2+v__1(t)^2))*lambda__1(t)^4-6*c^2*(16*
y__1(t)^2*ell^2+14*c*y__1(t)*g*ell+16*ell^2*x__1(t)^2+c*(c*g^2-8*ell*u__1(t)^2-\
8*ell*v__1(t)^2))*lambda__1(t)^3-18*c*((4/9*c*x__2(t)^2*lambda__2(t)+4/9*c*y__2
(t)^2*lambda__2(t)+2/9*c*y__2(t)*g-2/9*c*u__2(t)^2-2/9*c*v__2(t)^2+16/9*ell^3)*
y__1(t)^2-4/3*c*(x__2(t)*u__2(t)*v__1(t)+y__2(t)*v__1(t)*v__2(t)-7/2*g*ell^2)*
y__1(t)+(4/9*c*x__2(t)^2*lambda__2(t)+4/9*c*y__2(t)^2*lambda__2(t)+2/9*c*y__2(t
)*g-2/9*c*u__2(t)^2-2/9*c*v__2(t)^2+16/9*ell^3)*x__1(t)^2-4/3*c*u__1(t)*(x__2(t
)*u__2(t)+y__2(t)*v__2(t))*x__1(t)+c*ell*(c*g^2-8/3*ell*u__1(t)^2-8/3*ell*v__1(
t)^2))*lambda__1(t)^2-18*c*ell*((8/9*x__2(t)^2*lambda__2(t)+8/9*y__2(t)^2*
lambda__2(t)+4/9*y__2(t)*g-4/9*u__2(t)^2-4/9*v__2(t)^2)*y__1(t)^2+(-8/3*x__2(t)
*u__2(t)*v__1(t)-8/3*y__2(t)*v__1(t)*v__2(t)+14/9*g*ell^2)*y__1(t)+(8/9*x__2(t)
^2*lambda__2(t)+8/9*y__2(t)^2*lambda__2(t)+4/9*y__2(t)*g-4/9*u__2(t)^2-4/9*v__2
(t)^2)*x__1(t)^2-8/3*u__1(t)*(x__2(t)*u__2(t)+y__2(t)*v__2(t))*x__1(t)+ell*(c*g
^2-8/9*ell*u__1(t)^2-8/9*ell*v__1(t)^2))*lambda__1(t)+((-8*lambda__2(t)*ell^2-4
*v__2(t)^2)*y__2(t)^2+(-8*x__2(t)*u__2(t)*v__2(t)-4*g*ell^2)*y__2(t)+(-4*x__2(t
)^2+4*ell^2)*u__2(t)^2-8*x__2(t)^2*lambda__2(t)*ell^2+4*ell^2*v__2(t)^2)*y__1(t
)^2+24*ell^2*v__1(t)*(x__2(t)*u__2(t)+y__2(t)*v__2(t))*y__1(t)+((-8*lambda__2(t
)*ell^2-4*v__2(t)^2)*y__2(t)^2+(-8*x__2(t)*u__2(t)*v__2(t)-4*g*ell^2)*y__2(t)+(
-4*x__2(t)^2+4*ell^2)*u__2(t)^2-8*x__2(t)^2*lambda__2(t)*ell^2+4*ell^2*v__2(t)^
2)*x__1(t)^2+24*ell^2*u__1(t)*(x__2(t)*u__2(t)+y__2(t)*v__2(t))*x__1(t)-6*c*ell
^3*g^2)/(ell+c*lambda__1(t))^3/c];
ICS := [x__1(0) = 1, y__1(0) = 0, u__1(0) = 0, v__1(0) = 1, lambda__1(0) = 0, 
x__2(0) = 1, y__2(0) = 0, u__2(0) = 0, v__2(0) = 1, lambda__2(0) = 0, x__3(0) =
1, y__3(0) = 0, u__3(0) = 0, v__3(0) = 1, lambda__3(0) = 0];
DATA := [g = 1, ell = 1, c = .1];