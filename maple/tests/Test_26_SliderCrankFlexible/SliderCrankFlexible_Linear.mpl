POSITION_VARS := [phi__1(t), phi__2(t), x__3(t), q__1(t), q__2(t), q__3(t), 
q__4(t)];
VELOCITY_VARS := [phi__1__dot(t), phi__2__dot(t), x__3__dot(t), q__1__dot(t), 
q__2__dot(t), q__3__dot(t), q__4__dot(t)];
LAMBDA_VARS := [lambda__1(t), lambda__2(t), lambda__3(t)];
VARS := [phi__1(t), phi__2(t), x__3(t), q__1(t), q__2(t), q__3(t), q__4(t), 
phi__1__dot(t), phi__2__dot(t), x__3__dot(t), q__1__dot(t), q__2__dot(t), 
q__3__dot(t), q__4__dot(t), lambda__1(t), lambda__2(t), lambda__3(t)];
DAES := [diff(phi__1(t),t) = phi__1__dot(t), diff(phi__2(t),t) = phi__2__dot(t)
, diff(x__3(t),t) = x__3__dot(t), diff(q__1(t),t) = q__1__dot(t), diff(q__2(t),
t) = q__2__dot(t), diff(q__3(t),t) = q__3__dot(t), diff(q__4(t),t) = q__4__dot(
t), 1/6*(4*(Pi*(d*q__3(t)*h*rho+1/4*d*q__4(t)*h*rho+3/4*m__2)*diff(phi__2__dot(
t),t)+3*d*h*diff(q__1__dot(t),t)*rho)*l__1*l__2*cos(phi__1(t)-phi__2(t))+12*d*
l__1*rho*h*(q__1(t)*diff(phi__2__dot(t),t)-1/3*Pi*(diff(q__3__dot(t),t)+1/4*
diff(q__4__dot(t),t)))*l__2*sin(phi__1(t)-phi__2(t))+6*diff(phi__1__dot(t),t)*
Pi*(l__1^2*m__2+J__1))/Pi = 1/6*(-4*l__2*(6*d*h*diff(q__1(t),t)*diff(phi__2(t),
t)*rho+phi__2__dot(t)^2*Pi*(d*q__3(t)*h*rho+1/4*d*q__4(t)*h*rho+3/4*m__2))*l__1
*sin(phi__1(t)-phi__2(t))+12*d*l__2*rho*h*l__1*(-2/3*Pi*(diff(q__3(t),t)+1/4*
diff(q__4(t),t))*diff(phi__2(t),t)+phi__2__dot(t)^2*q__1(t))*cos(phi__1(t)-
phi__2(t))-3*Pi*((2*lambda__1(t)+theta*(m__1+2*m__2))*l__1*cos(phi__1(t))+2*
l__1*sin(phi__1(t))*lambda__2(t)+2*lambda__3(t)))/Pi, 1/6*(4*Pi^3*(d*q__3(t)*h*
rho+1/4*d*q__4(t)*h*rho+3/4*m__2)*l__1*diff(phi__1__dot(t),t)*l__2*cos(phi__1(t
)-phi__2(t))+12*diff(phi__1__dot(t),t)*sin(phi__1(t)-phi__2(t))*Pi^2*q__1(t)*d*
h*l__1*l__2*rho+4*Pi^3*(3*q__4(t)^2+(1/2*rho*d*h*l__2^2+3*q__3(t))*q__4(t)+rho*
d*h*l__2^2*q__3(t)+3/4*q__1(t)^2+3/4*q__2(t)^2+12*q__3(t)^2+3/2*J__2)*diff(
phi__2__dot(t),t)-96*(((-1/16*Pi^2+1/2)*q__4(t)-1/16*Pi^2*l__2-q__3(t))*diff(
q__1__dot(t),t)+((1/16*Pi^2-1/2)*q__1(t)-1/32*q__2(t)*Pi^2)*diff(q__4__dot(t),t
)+(1/32*Pi^2*l__2+q__1(t))*diff(q__3__dot(t),t)+1/32*q__4(t)*diff(q__2__dot(t),
t)*Pi^2)*d*rho*h*l__2)/Pi^3 = 1/6*(4*Pi*(d*q__3(t)*h*rho+1/4*d*q__4(t)*h*rho+3/
4*m__2)*phi__1__dot(t)^2*l__2*l__1*sin(phi__1(t)-phi__2(t))-12*rho*l__1*
phi__1__dot(t)^2*cos(phi__1(t)-phi__2(t))*d*h*l__2*q__1(t)-4*Pi*((rho*d*h*l__2^
2+24*q__3(t)+3*q__4(t))*diff(q__3(t),t)+(1/2*rho*d*h*l__2^2+3*q__3(t)+6*q__4(t)
)*diff(q__4(t),t)+3/2*q__1(t)*diff(q__1(t),t)+3/2*q__2(t)*diff(q__2(t),t))*diff
(phi__2(t),t)-4*Pi*((1/4*d*h*rho*l__2*theta+3/2*lambda__1(t))*q__4(t)+l__2*(d*
q__3(t)*h*rho*theta+3/4*theta*m__2+3/2*lambda__1(t)))*cos(phi__2(t))+12*sin(
phi__2(t))*(-1/2*q__4(t)*lambda__2(t)*Pi+l__2*(d*q__1(t)*h*rho*theta-1/2*
lambda__2(t)*Pi)))/Pi, m__3*diff(x__3__dot(t),t) = -lambda__2(t), 1/2*(4*rho*
l__1*cos(phi__1(t)-phi__2(t))*d*h*l__2*diff(phi__1__dot(t),t)*Pi^2+2*((Pi^2-8)*
q__4(t)+Pi^2*l__2+16*q__3(t))*d*l__2*rho*h*diff(phi__2__dot(t),t)+diff(
q__1__dot(t),t)*Pi^3)/Pi^3 = 1/24*(48*phi__1__dot(t)^2*sin(phi__1(t)-phi__2(t))
*Pi^2*d*h*l__1*l__2^4*rho-768*h*l__2^4*((1/16*Pi^2-1/2)*diff(q__4(t),t)+diff(
q__3(t),t))*d*rho*diff(phi__2(t),t)-Pi^2*(24*Pi*C__1*l__2^3*diff(q__1(t),t)+48*
theta*d*h*rho*l__2^4*cos(phi__2(t))+q__1(t)*Pi*(E*d*h^3*Pi^4-12*l__2^3*
phi__2__dot(t)^2)))/Pi^3/l__2^3, -1/2*rho*q__4(t)*d*h*l__2/Pi*diff(phi__2__dot(
t),t)+1/2*diff(q__2__dot(t),t) = 1/2*phi__2__dot(t)^2*q__2(t)+rho*diff(phi__2(t
),t)*d*h*l__2/Pi*diff(q__4(t),t)-2/3*E*d*h^3/l__2^3*Pi^4*q__2(t)-C__2*diff(q__2
(t),t), 1/6*(-4*rho*l__1*sin(phi__1(t)-phi__2(t))*d*h*l__2*diff(phi__1__dot(t),
t)*Pi^3-3*d*h*rho*l__2*(Pi^2*l__2+32*q__1(t))*diff(phi__2__dot(t),t)+48*Pi^3*(
diff(q__3__dot(t),t)+1/8*diff(q__4__dot(t),t)))/Pi^3 = 1/3*(2*phi__1__dot(t)^2*
cos(phi__1(t)-phi__2(t))*Pi^3*d*h*l__1*l__2^2*rho+96*diff(q__1(t),t)*diff(
phi__2(t),t)*d*h*l__2^2*rho-16*Pi^3*(3/16*diff(q__3(t),t)*C__3*l__2+1/8*theta*
sin(phi__2(t))*d*h*rho*l__2^2-3/2*l__2*(1/24*rho*d*h*l__2^2+q__3(t)+1/8*q__4(t)
)*phi__2__dot(t)^2+E*d*h*(q__3(t)-1/2*q__4(t))))/Pi^3/l__2, 1/6*(-rho*l__1*sin(
phi__1(t)-phi__2(t))*d*h*l__2*diff(phi__1__dot(t),t)*Pi^3-6*((Pi^2-8)*q__1(t)-1
/2*q__2(t)*Pi^2)*d*l__2*rho*h*diff(phi__2__dot(t),t)+6*Pi^3*(diff(q__3__dot(t),
t)+2*diff(q__4__dot(t),t)))/Pi^3 = 1/6*(phi__1__dot(t)^2*cos(phi__1(t)-phi__2(t
))*Pi^3*d*h*l__1*l__2^2*rho+12*h*l__2^2*d*rho*((Pi^2-8)*diff(q__1(t),t)-1/2*
diff(q__2(t),t)*Pi^2)*diff(phi__2(t),t)+16*(-3/8*diff(q__4(t),t)*C__4*l__2-1/16
*l__2*(d*h*rho*l__2*theta+6*lambda__1(t))*sin(phi__2(t))+3/8*lambda__2(t)*cos(
phi__2(t))*l__2+3/8*l__2*(1/6*rho*d*h*l__2^2+q__3(t)+2*q__4(t))*phi__2__dot(t)^
2+E*d*h*(q__3(t)-7/8*q__4(t)))*Pi^3)/Pi^3/l__2, (l__2+q__4(t))*sin(phi__2(t))+
l__1*sin(phi__1(t)) = 0, (-l__2-q__4(t))*cos(phi__2(t))-l__1*cos(phi__1(t))+
x__3(t) = 0, phi__1(t)-Omega*t = 0];
FIRST_ORDER := [diff(phi__1(t),t) = phi__1__dot(t), diff(phi__2(t),t) = 
phi__2__dot(t), diff(x__3(t),t) = x__3__dot(t), diff(q__1(t),t) = q__1__dot(t),
diff(q__2(t),t) = q__2__dot(t), diff(q__3(t),t) = q__3__dot(t), diff(q__4(t),t)
= q__4__dot(t)];
DATA := [l__1 = .15, l__2 = .3, m__1 = .36, m__2 = .151104, m__3 = .75552e-1, 
J__1 = .2727e-2, J__2 = .45339259e-2, h = .8e-2, d = .8e-2, rho = 7870, E = .20\
e12, Omega = 150, theta = 0, C__1 = 0, C__2 = 0, C__3 = 0, C__4 = 0];
ICS := [phi__1(0) = 0., phi__2(0) = 0., x__3(0) = .4500169330000000, q__1(0) =
0., q__2(0) = 0., q__3(0) = .1033398630000000e-4, q__4(0) = .1693279690000000e-\
4, phi__1__dot(0) = 150.0000000000000, phi__2__dot(0) = -74.99576703969453, 
x__3__dot(0) = -.2689386719979040e-5, q__1__dot(0) = .4448961125815990, 
q__2__dot(0) = .4634339319238670e-2, q__3__dot(0) = -.1785910760000550e-5, 
q__4__dot(0) = -.2689386719979040e-5, lambda__1(0) = .6552727150584648e-7, 
lambda__2(0) = -382.4589509350831, lambda__3(0) = .4635908708561371e-8];
