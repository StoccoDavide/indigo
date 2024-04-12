VARS := [phi__1(t), phi__2(t), x__3(t), q__1(t), q__2(t), q__3(t), q__4(t), 
phi__1__dot(t), phi__2__dot(t), x__3__dot(t), q__1__dot(t), q__2__dot(t), 
q__3__dot(t), q__4__dot(t), lambda__1(t), lambda__2(t), lambda__3(t)];
DAES := [-phi__1__dot(t)+diff(phi__1(t),t), -phi__2__dot(t)+diff(phi__2(t),t),
-x__3__dot(t)+diff(x__3(t),t), -q__1__dot(t)+diff(q__1(t),t), -q__2__dot(t)+
diff(q__2(t),t), -q__3__dot(t)+diff(q__3(t),t), -q__4__dot(t)+diff(q__4(t),t),
1/6*(-12*l__2*l__1*(d*q__1(t)*h*diff(phi__2(t),t)^2*rho-2/3*d*(diff(q__3(t),t)+
1/4*diff(q__4(t),t))*h*rho*Pi*diff(phi__2(t),t)-1/3*Pi*(d*q__3(t)*h*rho+1/4*d*
q__4(t)*h*rho+3/4*m__2)*diff(phi__2__dot(t),t)-d*h*diff(q__1__dot(t),t)*rho)*
cos(phi__1(t)-phi__2(t))+12*l__2*l__1*(1/3*(d*q__3(t)*h*rho+1/4*d*q__4(t)*h*rho
+3/4*m__2)*Pi*diff(phi__2(t),t)^2+2*d*h*diff(q__1(t),t)*diff(phi__2(t),t)*rho+d
*(q__1(t)*diff(phi__2__dot(t),t)-1/3*(diff(q__3__dot(t),t)+1/4*diff(q__4__dot(t
),t))*Pi)*h*rho)*sin(phi__1(t)-phi__2(t))+6*((l__1^2*m__2+J__1)*diff(
phi__1__dot(t),t)+(lambda__1(t)+theta*(m__2+1/2*m__1))*l__1*cos(phi__1(t))+l__1
*sin(phi__1(t))*lambda__2(t)+lambda__3(t))*Pi)/Pi, 1/6*(12*l__2*(1/3*(d*q__3(t)
*h*rho+1/4*d*q__4(t)*h*rho+3/4*m__2)*Pi*diff(phi__1__dot(t),t)+d*q__1(t)*h*diff
(phi__1(t),t)^2*rho)*Pi^2*l__1*cos(phi__1(t)-phi__2(t))+12*(d*q__1(t)*h*diff(
phi__1__dot(t),t)*rho-1/3*(d*q__3(t)*h*rho+1/4*d*q__4(t)*h*rho+3/4*m__2)*diff(
phi__1(t),t)^2*Pi)*l__2*Pi^2*l__1*sin(phi__1(t)-phi__2(t))+4*(3*q__4(t)^2+(1/2*
rho*d*h*l__2^2+3*q__3(t))*q__4(t)+rho*d*h*l__2^2*q__3(t)+3/4*q__1(t)^2+3/4*q__2
(t)^2+12*q__3(t)^2+3/2*J__2)*Pi^3*diff(phi__2__dot(t),t)+4*Pi^3*((rho*d*h*l__2^
2+24*q__3(t)+3*q__4(t))*diff(q__3(t),t)+(1/2*rho*d*h*l__2^2+3*q__3(t)+6*q__4(t)
)*diff(q__4(t),t)+3/2*q__1(t)*diff(q__1(t),t)+3/2*q__2(t)*diff(q__2(t),t))*diff
(phi__2(t),t)+96*d*((1/16*Pi^2-1/2)*q__4(t)+1/16*Pi^2*l__2+q__3(t))*l__2*h*rho*
diff(q__1__dot(t),t)-6*d*((Pi^2-8)*q__1(t)-1/2*q__2(t)*Pi^2)*l__2*h*rho*diff(
q__4__dot(t),t)-96*d*(1/32*Pi^2*l__2+q__1(t))*l__2*h*rho*diff(q__3__dot(t),t)-\
12*(1/4*d*q__4(t)*h*diff(q__2__dot(t),t)*rho*l__2-1/3*((1/4*d*h*rho*l__2*theta+
3/2*lambda__1(t))*q__4(t)+l__2*(d*q__3(t)*h*rho*theta+3/4*theta*m__2+3/2*
lambda__1(t)))*Pi*cos(phi__2(t))+sin(phi__2(t))*(-1/2*q__4(t)*lambda__2(t)*Pi+
l__2*(d*q__1(t)*h*rho*theta-1/2*lambda__2(t)*Pi)))*Pi^2)/Pi^3, lambda__2(t)+
m__3*diff(x__3__dot(t),t), 1/72*(144*Pi^2*cos(phi__1(t)-phi__2(t))*diff(
phi__1__dot(t),t)*d*h*l__1*l__2^4*rho-144*diff(phi__1(t),t)^2*sin(phi__1(t)-
phi__2(t))*Pi^2*d*h*l__1*l__2^4*rho+1152*h*rho*((1/16*Pi^2-1/2)*q__4(t)+1/16*Pi
^2*l__2+q__3(t))*l__2^4*d*diff(phi__2__dot(t),t)-36*diff(phi__2(t),t)^2*q__1(t)
*Pi^3*l__2^3+2304*h*l__2^4*((1/16*Pi^2-1/2)*diff(q__4(t),t)+diff(q__3(t),t))*d*
rho*diff(phi__2(t),t)+36*Pi^2*(diff(q__1__dot(t),t)*Pi*l__2^3+2*diff(q__1(t),t)
*Pi*C__1*l__2^3+h*(4*theta*cos(phi__2(t))*rho*l__2^4+E*(l__2*(q__1(t)*Pi^2-160/
9*q__2(t))*q__4(t)+1/12*q__1(t)*h^2*Pi^4+320/9*q__2(t)*q__3(t)*l__2)*Pi)*d))/Pi
^3/l__2^3, 1/18*(-9*diff(phi__2(t),t)^2*q__2(t)*Pi*l__2^3-18*h*l__2^4*d*rho*
diff(phi__2(t),t)*diff(q__4(t),t)-9*q__4(t)*diff(phi__2__dot(t),t)*d*h*l__2^4*
rho+36*Pi*(1/4*diff(q__2__dot(t),t)*l__2^3+1/2*diff(q__2(t),t)*C__2*l__2^3+E*h*
(Pi^2*(1/3*h^2*Pi^2+q__4(t)*l__2)*q__2(t)+80/9*(q__3(t)-1/2*q__4(t))*l__2*q__1(
t))*d))/Pi/l__2^3, 1/18*(-12*diff(phi__1(t),t)^2*cos(phi__1(t)-phi__2(t))*Pi^3*
d*h*l__1*l__2^3*rho-12*Pi^3*sin(phi__1(t)-phi__2(t))*diff(phi__1__dot(t),t)*d*h
*l__1*l__2^3*rho-144*(1/24*rho*d*h*l__2^2+q__3(t)+1/8*q__4(t))*l__2^2*Pi^3*diff
(phi__2(t),t)^2-576*diff(q__1(t),t)*diff(phi__2(t),t)*d*h*l__2^3*rho-288*h*rho*
l__2^3*(1/32*Pi^2*l__2+q__1(t))*d*diff(phi__2__dot(t),t)+320*(9/20*diff(
q__3__dot(t),t)*l__2^2+9/160*diff(q__4__dot(t),t)*l__2^2+9/160*diff(q__3(t),t)*
C__3*l__2^2+h*(3/80*theta*sin(phi__2(t))*rho*l__2^3+E*(q__1(t)*q__2(t)+3/10*(
q__3(t)-1/2*q__4(t))*l__2))*d)*Pi^3)/Pi^3/l__2^2, 1/36*(-6*diff(phi__1(t),t)^2*
cos(phi__1(t)-phi__2(t))*Pi^3*d*h*l__1*l__2^3*rho-6*Pi^3*sin(phi__1(t)-phi__2(t
))*diff(phi__1__dot(t),t)*d*h*l__1*l__2^3*rho-36*l__2^2*Pi^3*(1/6*rho*d*h*l__2^
2+q__3(t)+2*q__4(t))*diff(phi__2(t),t)^2-72*h*((Pi^2-8)*diff(q__1(t),t)-1/2*
diff(q__2(t),t)*Pi^2)*l__2^3*d*rho*diff(phi__2(t),t)-36*h*rho*l__2^3*d*((Pi^2-8
)*q__1(t)-1/2*q__2(t)*Pi^2)*diff(phi__2__dot(t),t)+9*(4*diff(q__3__dot(t),t)*
l__2^2+8*diff(q__4__dot(t),t)*l__2^2+4*diff(q__4(t),t)*C__4*l__2^2+2/3*l__2^2*(
d*h*rho*l__2*theta+6*lambda__1(t))*sin(phi__2(t))-4*lambda__2(t)*cos(phi__2(t))
*l__2^2+h*E*d*(q__1(t)^2*Pi^2-320/9*q__1(t)*q__2(t)+4*q__2(t)^2*Pi^2-32/3*l__2*
(q__3(t)-7/8*q__4(t))))*Pi^3)/Pi^3/l__2^2, (l__2+q__4(t))*sin(phi__2(t))+l__1*
sin(phi__1(t)), (-l__2-q__4(t))*cos(phi__2(t))-l__1*cos(phi__1(t))+x__3(t), 
phi__1(t)-Omega*t];
ODES := [-x__3__dot(t)+diff(x__3(t),t), -q__1__dot(t)+diff(q__1(t),t), -
q__2__dot(t)+diff(q__2(t),t), -q__3__dot(t)+diff(q__3(t),t), 1/18*(-9*diff(
phi__2(t),t)^2*q__2(t)*Pi*l__2^3-18*h*l__2^4*d*rho*diff(phi__2(t),t)*diff(q__4(
t),t)-9*q__4(t)*diff(phi__2__dot(t),t)*d*h*l__2^4*rho+36*(1/4*diff(q__2__dot(t)
,t)*l__2^3+E*d*h*Pi^2*(1/3*h^2*Pi^2+q__4(t)*l__2)*q__2(t)+80/9*(E*q__3(t)*d*h*
q__1(t)-1/2*E*q__4(t)*d*h*q__1(t)+9/160*q__2__dot(t)*C__2*l__2^2)*l__2)*Pi)/Pi/
l__2^3, lambda__2(t)+m__3*diff(x__3__dot(t),t), -q__4__dot(t)+diff(q__4(t),t),
-phi__2__dot(t)+diff(phi__2(t),t), -phi__1__dot(t)+diff(phi__1(t),t), 1/72*(144
*Pi^2*cos(phi__1(t)-phi__2(t))*diff(phi__1__dot(t),t)*d*h*l__1*l__2^4*rho-144*
diff(phi__1(t),t)^2*sin(phi__1(t)-phi__2(t))*Pi^2*d*h*l__1*l__2^4*rho+1152*h*
rho*((1/16*Pi^2-1/2)*q__4(t)+1/16*Pi^2*l__2+q__3(t))*l__2^4*d*diff(phi__2__dot(
t),t)-36*diff(phi__2(t),t)^2*q__1(t)*Pi^3*l__2^3+2304*h*l__2^4*((1/16*Pi^2-1/2)
*diff(q__4(t),t)+diff(q__3(t),t))*d*rho*diff(phi__2(t),t)+36*Pi^2*(diff(
q__1__dot(t),t)*Pi*l__2^3+4*h*d*theta*cos(phi__2(t))*rho*l__2^4+(E*d*h*l__2*(
q__1(t)*Pi^2-160/9*q__2(t))*q__4(t)+1/12*E*q__1(t)*d*h^3*Pi^4+320/9*E*q__2(t)*
q__3(t)*d*h*l__2+2*q__1__dot(t)*C__1*l__2^3)*Pi))/Pi^3/l__2^3, 1/18*(-12*diff(
phi__1(t),t)^2*cos(phi__1(t)-phi__2(t))*Pi^3*d*h*l__1*l__2^3*rho-12*Pi^3*sin(
phi__1(t)-phi__2(t))*diff(phi__1__dot(t),t)*d*h*l__1*l__2^3*rho-144*(1/24*rho*d
*h*l__2^2+q__3(t)+1/8*q__4(t))*l__2^2*Pi^3*diff(phi__2(t),t)^2-576*diff(q__1(t)
,t)*diff(phi__2(t),t)*d*h*l__2^3*rho-288*h*rho*l__2^3*(1/32*Pi^2*l__2+q__1(t))*
d*diff(phi__2__dot(t),t)+320*(9/20*diff(q__3__dot(t),t)*l__2^2+9/160*diff(
q__4__dot(t),t)*l__2^2+3/80*h*d*theta*sin(phi__2(t))*rho*l__2^3+h*d*E*q__1(t)*
q__2(t)+3/10*l__2*(E*q__3(t)*d*h-1/2*E*q__4(t)*d*h+3/16*l__2*q__3__dot(t)*C__3)
)*Pi^3)/Pi^3/l__2^2, 1/48*V_y58KN[1]*diff(phi__2__dot(t),t)-1/1080*V_y58KN[3],
diff(phi__1__dot(t),t), 1/360*(l__2^3*h*rho*((-16*Pi^2+160)*q__1(t)+Pi^2*(l__2+
8*q__2(t)))*d*V_y58KN[3]-1200*V_y58KN[1]*(1/40*diff(phi__1(t),t)^2*cos(phi__1(t
)-phi__2(t))*Pi^3*d*h*l__1*l__2^3*rho+3/80*Pi^3*l__2^2*(rho*d*h*l__2^2+15*q__4(
t))*diff(phi__2(t),t)^2+3/5*l__2^3*h*rho*d*((Pi^2-10)*diff(q__1(t),t)-1/2*diff(
q__2(t),t)*Pi^2)*diff(phi__2(t),t)+(-9/16*diff(q__4__dot(t),t)*l__2^2-1/40*l__2
^2*(d*h*rho*l__2*theta+12*lambda__1(t))*sin(phi__2(t))+3/10*lambda__2(t)*cos(
phi__2(t))*l__2^2-3/40*E*q__1(t)^2*d*h*Pi^2+10/3*h*d*E*q__1(t)*q__2(t)-3/10*E*
q__2(t)^2*d*h*Pi^2+l__2*(E*q__3(t)*d*h-4/5*E*q__4(t)*d*h+3/80*l__2*q__3__dot(t)
*C__3-3/10*l__2*q__4__dot(t)*C__4))*Pi^3))/Pi^3/l__2^2/V_y58KN[1]];
INVS := [(-l__2-q__4(t))*sin(phi__2(t))-l__1*sin(phi__1(t)), (l__2+q__4(t))*cos
(phi__2(t))+l__1*cos(phi__1(t))-x__3(t), -phi__1(t)+Omega*t, sin(phi__2(t))*
q__4__dot(t)+(l__2+q__4(t))*cos(phi__2(t))*phi__2__dot(t)+l__1*cos(phi__1(t))*
phi__1__dot(t), x__3__dot(t)-cos(phi__2(t))*q__4__dot(t)+(l__2+q__4(t))*sin(
phi__2(t))*phi__2__dot(t)+l__1*sin(phi__1(t))*phi__1__dot(t), -Omega+
phi__1__dot(t), -1/675*V_y58KN[4], 1/675*V_y58KN[5], 1/4050*(-4*l__1*l__2*((-\
180*d*(d*h*l__2*(Pi^2-8)*rho-1/24*Pi^4)*h*rho*q__4(t)+(30*Pi^4*d*h*rho-2880*d^2
*h^2*l__2*rho^2)*q__3(t)-180*d^2*h^2*Pi^2*rho^2*l__2^2+45/2*Pi^4*m__2)*cos(
phi__1(t)-phi__2(t))+d*((-2*d*h*l__2*(Pi^2+20)*rho+90*Pi^2)*q__1(t)+Pi^2*d*h*
l__2*rho*(q__2(t)-7/4*l__2))*h*rho*Pi*sin(phi__1(t)-phi__2(t)))*V_y58KN[3]+5*
V_y58KN[2]*Pi^4*V_y58KN[1])/Pi^4/V_y58KN[1]];
ICS := [phi__1(0) = 0., phi__2(0) = 0., x__3(0) = .4500169330000000, q__1(0) =
0., q__2(0) = 0., q__3(0) = .1033398630000000e-4, q__4(0) = .1693279690000000e-\
4, phi__1__dot(0) = 150.0000000000000, phi__2__dot(0) = -74.99576703969453, 
x__3__dot(0) = -.2689386719979040e-5, q__1__dot(0) = .4448961125815990, 
q__2__dot(0) = .4634339319238670e-2, q__3__dot(0) = -.1785910760000550e-5, 
q__4__dot(0) = -.2689386719979040e-5, lambda__1(0) = .6552727150584648e-7, 
lambda__2(0) = -382.4589509350831, lambda__3(0) = .4635908708561371e-8];
