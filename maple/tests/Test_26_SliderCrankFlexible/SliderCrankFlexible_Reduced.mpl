VARS := [phi__1(t), phi__2(t), x__3(t), q__1(t), q__2(t), q__3(t), q__4(t), 
phi__1__dot(t), phi__2__dot(t), x__3__dot(t), q__1__dot(t), q__2__dot(t), 
q__3__dot(t), q__4__dot(t), lambda__1(t), lambda__2(t), lambda__3(t)];
DAES := [-phi__1__dot(t)+diff(phi__1(t),t), -phi__2__dot(t)+diff(phi__2(t),t),
-x__3__dot(t)+diff(x__3(t),t), -q__1__dot(t)+diff(q__1(t),t), -q__2__dot(t)+
diff(q__2(t),t), -q__3__dot(t)+diff(q__3(t),t), -q__4__dot(t)+diff(q__4(t),t),
1/6*(-12*l__2*(-1/3*Pi*(d*q__3(t)*h*rho+1/4*d*q__4(t)*h*rho+3/4*m__2)*diff(
phi__2__dot(t),t)+h*rho*d*(-diff(q__1__dot(t),t)+phi__2__dot(t)*(q__1(t)*
phi__2__dot(t)-2/3*(q__3__dot(t)+1/4*q__4__dot(t))*Pi)))*l__1*cos(phi__1(t)-
phi__2(t))+12*l__2*(d*q__1(t)*h*diff(phi__2__dot(t),t)*rho-1/3*d*h*diff(
q__3__dot(t),t)*Pi*rho-1/12*d*h*diff(q__4__dot(t),t)*Pi*rho+1/3*phi__2__dot(t)*
(Pi*(d*q__3(t)*h*rho+1/4*d*q__4(t)*h*rho+3/4*m__2)*phi__2__dot(t)+6*d*q__1__dot
(t)*h*rho))*l__1*sin(phi__1(t)-phi__2(t))+6*((l__1^2*m__2+J__1)*diff(
phi__1__dot(t),t)+(lambda__1(t)+theta*(m__2+1/2*m__1))*l__1*cos(phi__1(t))+l__1
*sin(phi__1(t))*lambda__2(t)+lambda__3(t))*Pi)/Pi, 1/6*(12*l__2*(1/3*(d*q__3(t)
*h*rho+1/4*d*q__4(t)*h*rho+3/4*m__2)*Pi*diff(phi__1__dot(t),t)+d*q__1(t)*h*
phi__1__dot(t)^2*rho)*l__1*Pi^2*cos(phi__1(t)-phi__2(t))+12*l__2*l__1*Pi^2*(d*
q__1(t)*h*diff(phi__1__dot(t),t)*rho-1/3*(d*q__3(t)*h*rho+1/4*d*q__4(t)*h*rho+3
/4*m__2)*Pi*phi__1__dot(t)^2)*sin(phi__1(t)-phi__2(t))+4*(3*q__4(t)^2+(1/2*rho*
d*h*l__2^2+3*q__3(t))*q__4(t)+rho*d*h*l__2^2*q__3(t)+3/4*q__1(t)^2+3/4*q__2(t)^
2+12*q__3(t)^2+3/2*J__2)*Pi^3*diff(phi__2__dot(t),t)+96*h*rho*((1/16*Pi^2-1/2)*
q__4(t)+1/16*Pi^2*l__2+q__3(t))*l__2*d*diff(q__1__dot(t),t)-6*((Pi^2-8)*q__1(t)
-1/2*q__2(t)*Pi^2)*h*rho*l__2*d*diff(q__4__dot(t),t)-96*h*rho*l__2*d*(1/32*Pi^2
*l__2+q__1(t))*diff(q__3__dot(t),t)-12*(1/4*d*q__4(t)*h*diff(q__2__dot(t),t)*
rho*l__2-1/3*((1/4*d*h*rho*l__2*theta+3/2*lambda__1(t))*q__4(t)+l__2*(d*q__3(t)
*h*rho*theta+3/4*theta*m__2+3/2*lambda__1(t)))*Pi*cos(phi__2(t))+(-1/2*q__4(t)*
lambda__2(t)*Pi+l__2*(d*q__1(t)*h*rho*theta-1/2*lambda__2(t)*Pi))*sin(phi__2(t)
)-1/3*phi__2__dot(t)*((3*q__3__dot(t)+6*q__4__dot(t))*q__4(t)+(24*q__3__dot(t)+
3*q__4__dot(t))*q__3(t)+d*h*q__3__dot(t)*rho*l__2^2+1/2*d*h*q__4__dot(t)*rho*
l__2^2+3/2*q__1(t)*q__1__dot(t)+3/2*q__2(t)*q__2__dot(t))*Pi)*Pi^2)/Pi^3, 
lambda__2(t)+m__3*diff(x__3__dot(t),t), 1/72*(144*Pi^2*cos(phi__1(t)-phi__2(t))
*diff(phi__1__dot(t),t)*d*h*l__1*l__2^4*rho-144*phi__1__dot(t)^2*sin(phi__1(t)-
phi__2(t))*Pi^2*d*h*l__1*l__2^4*rho+1152*d*((1/16*Pi^2-1/2)*q__4(t)+1/16*Pi^2*
l__2+q__3(t))*rho*h*l__2^4*diff(phi__2__dot(t),t)+36*Pi^3*diff(q__1__dot(t),t)*
l__2^3+144*rho*theta*cos(phi__2(t))*d*h*l__2^4*Pi^2-36*phi__2__dot(t)^2*q__1(t)
*Pi^3*l__2^3+2304*((1/16*Pi^2-1/2)*q__4__dot(t)+q__3__dot(t))*l__2^4*h*rho*d*
phi__2__dot(t)+36*Pi^3*(E*d*h*l__2*(q__1(t)*Pi^2-160/9*q__2(t))*q__4(t)+1/12*E*
q__1(t)*d*h^3*Pi^4+320/9*E*q__2(t)*q__3(t)*d*h*l__2+2*q__1__dot(t)*C__1*l__2^3)
)/Pi^3/l__2^3, -1/2*phi__2__dot(t)^2*q__2(t)-rho*phi__2__dot(t)*d*h*l__2/Pi*
q__4__dot(t)+2/3*E*d*h^3/l__2^3*Pi^4*q__2(t)+2*d*((80/9*q__3(t)-40/9*q__4(t))*
q__1(t)+q__2(t)*q__4(t)*Pi^2)*h*E/l__2^2+C__2*q__2__dot(t)-1/2*rho*q__4(t)*d*h*
l__2/Pi*diff(phi__2__dot(t),t)+1/2*diff(q__2__dot(t),t), 1/18*(-12*phi__1__dot(
t)^2*cos(phi__1(t)-phi__2(t))*Pi^3*d*h*l__1*l__2^3*rho-12*Pi^3*sin(phi__1(t)-
phi__2(t))*diff(phi__1__dot(t),t)*d*h*l__1*l__2^3*rho-288*d*rho*h*(1/32*Pi^2*
l__2+q__1(t))*l__2^3*diff(phi__2__dot(t),t)+144*Pi^3*diff(q__3__dot(t),t)*l__2^
2+18*Pi^3*diff(q__4__dot(t),t)*l__2^2+12*rho*theta*sin(phi__2(t))*d*h*l__2^3*Pi
^3-144*(1/24*rho*d*h*l__2^2+q__3(t)+1/8*q__4(t))*Pi^3*l__2^2*phi__2__dot(t)^2-\
576*phi__2__dot(t)*q__1__dot(t)*d*h*l__2^3*rho+320*Pi^3*(E*q__1(t)*q__2(t)*d*h+
3/10*(E*q__3(t)*d*h-1/2*E*q__4(t)*d*h+3/16*q__3__dot(t)*C__3*l__2)*l__2))/Pi^3/
l__2^2, 1/36*(-6*phi__1__dot(t)^2*cos(phi__1(t)-phi__2(t))*Pi^3*d*h*l__1*l__2^3
*rho-6*Pi^3*sin(phi__1(t)-phi__2(t))*diff(phi__1__dot(t),t)*d*h*l__1*l__2^3*rho
-36*d*((Pi^2-8)*q__1(t)-1/2*q__2(t)*Pi^2)*rho*h*l__2^3*diff(phi__2__dot(t),t)+
36*Pi^3*diff(q__3__dot(t),t)*l__2^2+72*Pi^3*diff(q__4__dot(t),t)*l__2^2+6*Pi^3*
l__2^2*(d*h*rho*l__2*theta+6*lambda__1(t))*sin(phi__2(t))-36*cos(phi__2(t))*
lambda__2(t)*Pi^3*l__2^2-36*(1/6*rho*d*h*l__2^2+q__3(t)+2*q__4(t))*Pi^3*l__2^2*
phi__2__dot(t)^2-72*((Pi^2-8)*q__1__dot(t)-1/2*q__2__dot(t)*Pi^2)*l__2^3*h*rho*
d*phi__2__dot(t)+9*Pi^3*(E*q__1(t)^2*d*h*Pi^2-320/9*E*q__1(t)*q__2(t)*d*h+4*E*
q__2(t)^2*d*h*Pi^2-32/3*(E*q__3(t)*d*h-7/8*E*q__4(t)*d*h-3/8*q__4__dot(t)*C__4*
l__2)*l__2))/Pi^3/l__2^2, (l__2+q__4(t))*sin(phi__2(t))+l__1*sin(phi__1(t)), (-
l__2-q__4(t))*cos(phi__2(t))-l__1*cos(phi__1(t))+x__3(t), phi__1(t)-Omega*t];
ODES := [-x__3__dot(t)+diff(x__3(t),t), -q__1__dot(t)+diff(q__1(t),t), -
q__2__dot(t)+diff(q__2(t),t), -q__3__dot(t)+diff(q__3(t),t), -1/2*rho*q__4(t)*d
*h*l__2/Pi*diff(phi__2__dot(t),t)+1/2*diff(q__2__dot(t),t)+1/18*(36*(q__2(t)*Pi
^2-40/9*q__1(t))*E*Pi*h*d*l__2*q__4(t)-9*phi__2__dot(t)^2*q__2(t)*Pi*l__2^3-18*
l__2^4*h*rho*d*phi__2__dot(t)*q__4__dot(t)+12*(E*d*h^3*Pi^4*q__2(t)+80/3*E*q__1
(t)*q__3(t)*d*h*l__2+3/2*C__2*q__2__dot(t)*l__2^3)*Pi)/Pi/l__2^3, lambda__2(t)+
m__3*diff(x__3__dot(t),t), -q__4__dot(t)+diff(q__4(t),t), -phi__2__dot(t)+diff(
phi__2(t),t), -phi__1__dot(t)+diff(phi__1(t),t), 1/72*(144*Pi^2*cos(phi__1(t)-
phi__2(t))*diff(phi__1__dot(t),t)*d*h*l__1*l__2^4*rho-144*phi__1__dot(t)^2*sin(
phi__1(t)-phi__2(t))*Pi^2*d*h*l__1*l__2^4*rho+1152*d*((1/16*Pi^2-1/2)*q__4(t)+1
/16*Pi^2*l__2+q__3(t))*rho*h*l__2^4*diff(phi__2__dot(t),t)+36*Pi^3*diff(
q__1__dot(t),t)*l__2^3+144*rho*theta*cos(phi__2(t))*d*h*l__2^4*Pi^2-36*
phi__2__dot(t)^2*q__1(t)*Pi^3*l__2^3+2304*((1/16*Pi^2-1/2)*q__4__dot(t)+
q__3__dot(t))*l__2^4*h*rho*d*phi__2__dot(t)+36*Pi^3*(E*d*h*l__2*(q__1(t)*Pi^2-\
160/9*q__2(t))*q__4(t)+1/12*E*q__1(t)*d*h^3*Pi^4+320/9*E*q__2(t)*q__3(t)*d*h*
l__2+2*q__1__dot(t)*C__1*l__2^3))/Pi^3/l__2^3, 1/18*(-12*phi__1__dot(t)^2*cos(
phi__1(t)-phi__2(t))*Pi^3*d*h*l__1*l__2^3*rho-12*Pi^3*sin(phi__1(t)-phi__2(t))*
diff(phi__1__dot(t),t)*d*h*l__1*l__2^3*rho-288*d*rho*h*(1/32*Pi^2*l__2+q__1(t))
*l__2^3*diff(phi__2__dot(t),t)+144*Pi^3*diff(q__3__dot(t),t)*l__2^2+18*Pi^3*
diff(q__4__dot(t),t)*l__2^2+12*rho*theta*sin(phi__2(t))*d*h*l__2^3*Pi^3-144*(1/
24*rho*d*h*l__2^2+q__3(t)+1/8*q__4(t))*Pi^3*l__2^2*phi__2__dot(t)^2-576*
phi__2__dot(t)*q__1__dot(t)*d*h*l__2^3*rho+320*Pi^3*(E*q__1(t)*q__2(t)*d*h+3/10
*(E*q__3(t)*d*h-1/2*E*q__4(t)*d*h+3/16*q__3__dot(t)*C__3*l__2)*l__2))/Pi^3/l__2
^2, 1/96*V_y58KN[2]*diff(phi__2__dot(t),t)-1/1080*V_y58KN[4], diff(phi__1__dot(
t),t), 15/8*diff(q__4__dot(t),t)-1/360*V_y58KN[6]];
INVS := [(-l__2-q__4(t))*sin(phi__2(t))-l__1*sin(phi__1(t)), (l__2+q__4(t))*cos
(phi__2(t))+l__1*cos(phi__1(t))-x__3(t), -phi__1(t)+Omega*t, sin(phi__2(t))*
q__4__dot(t)+(l__2+q__4(t))*cos(phi__2(t))*phi__2__dot(t)+l__1*cos(phi__1(t))*
phi__1__dot(t), x__3__dot(t)-cos(phi__2(t))*q__4__dot(t)+(l__2+q__4(t))*sin(
phi__2(t))*phi__2__dot(t)+l__1*sin(phi__1(t))*phi__1__dot(t), -Omega+
phi__1__dot(t), 1/675*(-60*cos(phi__2(t))*(l__2+q__4(t))*V_y58KN[4]-1350*(1/
1350*sin(phi__2(t))*V_y58KN[6]+cos(phi__2(t))*phi__2__dot(t)*q__4__dot(t)-1/2*
phi__2__dot(t)^2*(l__2+q__4(t))*sin(phi__2(t))-1/2*l__1*sin(phi__1(t))*
phi__1__dot(t)^2)*V_y58KN[2])/V_y58KN[2], 1/675*(-60*sin(phi__2(t))*m__3*(l__2+
q__4(t))*V_y58KN[4]+675*(1/675*cos(phi__2(t))*V_y58KN[6]*m__3-phi__2__dot(t)^2*
m__3*(l__2+q__4(t))*cos(phi__2(t))-phi__1__dot(t)^2*l__1*cos(phi__1(t))*m__3-2*
q__4__dot(t)*phi__2__dot(t)*sin(phi__2(t))*m__3+lambda__2(t))*V_y58KN[2])/m__3/
V_y58KN[2], 1/4050*V_y58KN[5]];
ICS := [phi__1(0) = 0., phi__2(0) = 0., x__3(0) = .4500169330000000, q__1(0) =
0., q__2(0) = 0., q__3(0) = .1033398630000000e-4, q__4(0) = .1693279690000000e-\
4, phi__1__dot(0) = 150.0000000000000, phi__2__dot(0) = -74.99576703969453, 
x__3__dot(0) = -.2689386719979040e-5, q__1__dot(0) = .4448961125815990, 
q__2__dot(0) = .4634339319238670e-2, q__3__dot(0) = -.1785910760000550e-5, 
q__4__dot(0) = -.2689386719979040e-5, lambda__1(0) = .6552727150584648e-7, 
lambda__2(0) = -382.4589509350831, lambda__3(0) = .4635908708561371e-8];
