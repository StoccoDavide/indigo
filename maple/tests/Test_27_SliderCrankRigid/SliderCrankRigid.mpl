POSITION_VARS := [phi__1(t), phi__2(t), x__3(t)];
VELOCITY_VARS := [phi__1__dot(t), phi__2__dot(t), x__3__dot(t)];
LAMBDA_VARS := [lambda__1(t), lambda__2(t), lambda__3(t)];
VARS := [phi__1(t), phi__2(t), x__3(t), phi__1__dot(t), phi__2__dot(t), 
x__3__dot(t), lambda__1(t), lambda__2(t), lambda__3(t)];
DAES := [diff(phi__1(t),t) = phi__1__dot(t), diff(phi__2(t),t) = phi__2__dot(t)
, diff(x__3(t),t) = x__3__dot(t), (l__1^2*m__2+J__1)*diff(phi__1__dot(t),t)+1/2
*l__1*l__2*m__2*cos(phi__1(t)-phi__2(t))*diff(phi__2__dot(t),t) = -1/2*sin(
phi__1(t)-phi__2(t))*diff(phi__2(t),t)^2*l__1*l__2*m__2-1/2*(2*lambda__1(t)+
theta*(m__1+2*m__2))*l__1*cos(phi__1(t))-l__1*sin(phi__1(t))*lambda__2(t)-
lambda__3(t), 1/2*l__1*l__2*m__2*cos(phi__1(t)-phi__2(t))*diff(phi__1__dot(t),t
)+J__2*diff(phi__2__dot(t),t) = -1/2*(-l__1*m__2*diff(phi__1(t),t)^2*sin(phi__1
(t)-phi__2(t))+(theta*m__2+2*lambda__1(t))*cos(phi__2(t))+2*sin(phi__2(t))*
lambda__2(t))*l__2, m__3*diff(x__3__dot(t),t) = -lambda__2(t), l__1*sin(phi__1(
t))+l__2*sin(phi__2(t)) = 0, x__3(t)-l__1*cos(phi__1(t))-l__2*cos(phi__2(t)) =
0, phi__1(t)-Omega*t = 0];
FIRST_ORDER := [diff(phi__1(t),t) = phi__1__dot(t), diff(phi__2(t),t) = 
phi__2__dot(t), diff(x__3(t),t) = x__3__dot(t)];
DATA := [l__1 = .15, l__2 = .3, m__1 = .36, m__2 = .151104, m__3 = .75552e-1, 
J__1 = .2727e-2, J__2 = .45339259e-2, h = .8e-2, d = .8e-2, rho = 7870, E = .20\
e12, Omega = 150, theta = 0, C__1 = 0, C__2 = 0, C__3 = 0, C__4 = 0];
ICS := [phi__1(0) = 0., phi__2(0) = 0., x__3(0) = .4500000000000000, 
phi__1__dot(0) = 150.0000000000000, phi__2__dot(0) = -74.99576703969453, 
x__3__dot(0) = -.2689386719979040e-5, lambda__1(0) = .6552727150584648e-7, 
lambda__2(0) = -382.4589509350831, lambda__3(0) = .4635908708561371e-8];
