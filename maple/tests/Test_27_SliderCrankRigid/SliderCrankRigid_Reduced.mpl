VARS := [phi__1(t), phi__2(t), x__3(t), phi__1__dot(t), phi__2__dot(t), 
x__3__dot(t), lambda__1(t), lambda__2(t), lambda__3(t)];
DAES := [-phi__1__dot(t)+diff(phi__1(t),t), -phi__2__dot(t)+diff(phi__2(t),t),
-x__3__dot(t)+diff(x__3(t),t), 1/2*l__1*l__2*m__2*cos(phi__1(t)-phi__2(t))*diff
(phi__2__dot(t),t)+1/2*sin(phi__1(t)-phi__2(t))*diff(phi__2(t),t)^2*l__1*l__2*
m__2+1/2*(2*l__1^2*m__2+2*J__1)*diff(phi__1__dot(t),t)+l__1*(lambda__1(t)+1/2*
theta*(m__1+2*m__2))*cos(phi__1(t))+l__1*sin(phi__1(t))*lambda__2(t)+lambda__3(
t), 1/2*l__1*l__2*m__2*cos(phi__1(t)-phi__2(t))*diff(phi__1__dot(t),t)-1/2*sin(
phi__1(t)-phi__2(t))*diff(phi__1(t),t)^2*l__1*l__2*m__2+J__2*diff(phi__2__dot(t
),t)+((1/2*theta*m__2+lambda__1(t))*cos(phi__2(t))+sin(phi__2(t))*lambda__2(t))
*l__2, lambda__2(t)+m__3*diff(x__3__dot(t),t), l__1*sin(phi__1(t))+l__2*sin(
phi__2(t)), x__3(t)-l__1*cos(phi__1(t))-l__2*cos(phi__2(t)), phi__1(t)-Omega*t]
;
ODES := [-x__3__dot(t)+diff(x__3(t),t), lambda__2(t)+m__3*diff(x__3__dot(t),t),
-phi__1__dot(t)+diff(phi__1(t),t), -phi__2__dot(t)+diff(phi__2(t),t), diff(
phi__1__dot(t),t), -1/2*sin(phi__1(t)-phi__2(t))*diff(phi__1(t),t)^2*l__1*l__2*
m__2+J__2*diff(phi__2__dot(t),t)+((1/2*theta*m__2+lambda__1(t))*cos(phi__2(t))+
sin(phi__2(t))*lambda__2(t))*l__2, 1/2*(2*cos(phi__2(t))*l__1*l__2^2*m__2*(-sin
(phi__1(t))*cos(phi__2(t))+cos(phi__1(t))*sin(phi__2(t)))*diff(phi__1(t),t)*
diff(diff(phi__1(t),t),t)-cos(phi__2(t))*l__1*l__2^2*m__2*(cos(phi__1(t))*cos(
phi__2(t))+sin(phi__1(t))*sin(phi__2(t)))*diff(phi__1(t),t)^3+2*l__1*(cos(
phi__2(t))^2*cos(phi__1(t))+cos(phi__2(t))*sin(phi__2(t))*sin(phi__1(t))-1/2*
cos(phi__1(t)))*m__2*l__2^2*diff(phi__2(t),t)*diff(phi__1(t),t)^2+2*J__2*cos(
phi__1(t))*diff(phi__1(t),t)*phi__1__dot(t)^2*l__1+4*(cos(phi__2(t))^2*
lambda__2(t)*l__2+(-1/2*l__2*(theta*m__2+2*lambda__1(t))*sin(phi__2(t))+1/2*
phi__2__dot(t)^2*J__2)*cos(phi__2(t))-1/2*lambda__2(t)*l__2)*l__2*diff(phi__2(t
),t)+4*l__1*sin(phi__1(t))*phi__1__dot(t)*diff(phi__1__dot(t),t)*J__2+4*J__2*
l__2*sin(phi__2(t))*phi__2__dot(t)*diff(phi__2__dot(t),t)+2*cos(phi__2(t))*l__2
^2*(cos(phi__2(t))*diff(lambda__1(t),t)+sin(phi__2(t))*diff(lambda__2(t),t)))/
J__2, 1/4*(diff(phi__1(t),t)^2*l__1*l__2^2*m__2*m__3*(diff(phi__1(t),t)-2*diff(
phi__2(t),t))*sin(phi__1(t)-2*phi__2(t))-2*diff(phi__1(t),t)*l__1*l__2^2*m__2*
m__3*cos(phi__1(t)-2*phi__2(t))*diff(diff(phi__1(t),t),t)+4*((1/2*theta*m__2+
lambda__1(t))*diff(phi__2(t),t)-1/2*diff(lambda__2(t),t))*l__2^2*m__3*cos(2*
phi__2(t))+2*diff(phi__1(t),t)*l__1*l__2^2*m__2*m__3*cos(phi__1(t))*diff(diff(
phi__1(t),t),t)+4*(lambda__2(t)*diff(phi__2(t),t)+1/2*diff(lambda__1(t),t))*
l__2^2*m__3*sin(2*phi__2(t))-diff(phi__1(t),t)^3*l__1*l__2^2*m__2*m__3*sin(
phi__1(t))+4*l__1*diff(phi__1(t),t)*sin(phi__1(t))*phi__1__dot(t)^2*m__3*J__2+4
*l__2*diff(phi__2(t),t)*sin(phi__2(t))*phi__2__dot(t)^2*m__3*J__2+(2*l__2^2*
m__3+4*J__2)*diff(lambda__2(t),t)-8*J__2*m__3*(l__1*cos(phi__1(t))*phi__1__dot(
t)*diff(phi__1__dot(t),t)+l__2*cos(phi__2(t))*phi__2__dot(t)*diff(phi__2__dot(t
),t)))/J__2/m__3, 1/8*(-2*diff(phi__1(t),t)^2*l__1^2*l__2^2*m__2^2*(diff(phi__1
(t),t)-diff(phi__2(t),t))*cos(2*phi__1(t)-2*phi__2(t))-2*diff(phi__1(t),t)*l__1
^2*l__2^2*m__2^2*sin(2*phi__1(t)-2*phi__2(t))*diff(diff(phi__1(t),t),t)-2*l__1*
((1/2*theta*m__2+lambda__1(t))*diff(phi__1(t),t)+(-theta*m__2-2*lambda__1(t))*
diff(phi__2(t),t)+diff(lambda__2(t),t))*l__2^2*m__2*sin(phi__1(t)-2*phi__2(t))-\
2*l__1*l__2^2*m__2*(lambda__2(t)*diff(phi__1(t),t)-2*lambda__2(t)*diff(phi__2(t
),t)-diff(lambda__1(t),t))*cos(phi__1(t)-2*phi__2(t))-4*(diff(phi__1(t),t)-diff
(phi__2(t),t))*cos(phi__1(t)-phi__2(t))*diff(phi__2(t),t)^2*l__1*l__2*m__2*J__2
-8*sin(phi__1(t)-phi__2(t))*diff(phi__2(t),t)*l__1*l__2*m__2*J__2*diff(diff(
phi__2(t),t),t)+8*l__1*(((-1/4*l__2^2*m__2+J__2)*lambda__1(t)+1/2*theta*(-1/4*
l__2^2*m__2^2+J__2*m__1+2*J__2*m__2))*sin(phi__1(t))-(-1/4*l__2^2*m__2+J__2)*
lambda__2(t)*cos(phi__1(t)))*diff(phi__1(t),t)-8*l__1*(-1/4*l__2^2*m__2+J__2)*
diff(lambda__1(t),t)*cos(phi__1(t))-8*l__1*(-1/4*l__2^2*m__2+J__2)*diff(
lambda__2(t),t)*sin(phi__1(t))-8*diff(lambda__3(t),t)*J__2)/J__2];
INVS := [-l__1*sin(phi__1(t))-l__2*sin(phi__2(t)), -x__3(t)+l__1*cos(phi__1(t))
+l__2*cos(phi__2(t)), -phi__1(t)+Omega*t, l__2*cos(phi__2(t))*phi__2__dot(t)+
l__1*cos(phi__1(t))*phi__1__dot(t), x__3__dot(t)+l__2*sin(phi__2(t))*
phi__2__dot(t)+l__1*sin(phi__1(t))*phi__1__dot(t), -Omega+phi__1__dot(t), 1/2*(
cos(phi__2(t))*l__1*l__2^2*m__2*(-sin(phi__1(t))*cos(phi__2(t))+cos(phi__1(t))*
sin(phi__2(t)))*diff(phi__1(t),t)^2+l__2^2*(theta*m__2+2*lambda__1(t))*cos(
phi__2(t))^2+2*cos(phi__2(t))*sin(phi__2(t))*lambda__2(t)*l__2^2+2*J__2*(l__1*
sin(phi__1(t))*phi__1__dot(t)^2+l__2*sin(phi__2(t))*phi__2__dot(t)^2))/J__2, 1/
4*(-diff(phi__1(t),t)^2*l__1*l__2^2*m__2*m__3*cos(phi__1(t)-2*phi__2(t))+2*(1/2
*theta*m__2+lambda__1(t))*l__2^2*m__3*sin(2*phi__2(t))-2*lambda__2(t)*l__2^2*
m__3*cos(2*phi__2(t))+diff(phi__1(t),t)^2*l__1*l__2^2*m__2*m__3*cos(phi__1(t))-\
4*l__1*cos(phi__1(t))*phi__1__dot(t)^2*m__3*J__2-4*l__2*cos(phi__2(t))*
phi__2__dot(t)^2*m__3*J__2+4*(1/2*l__2^2*m__3+J__2)*lambda__2(t))/J__2/m__3, 1/
8*(-diff(phi__1(t),t)^2*l__1^2*l__2^2*m__2^2*sin(2*phi__1(t)-2*phi__2(t))+2*
l__1*((1/2*theta*m__2+lambda__1(t))*cos(phi__1(t))-lambda__2(t)*sin(phi__1(t)))
*l__2^2*m__2*cos(2*phi__2(t))+2*l__1*(lambda__2(t)*cos(phi__1(t))+(1/2*theta*
m__2+lambda__1(t))*sin(phi__1(t)))*l__2^2*m__2*sin(2*phi__2(t))+4*J__2*l__1*
l__2*m__2*(-sin(phi__1(t))*cos(phi__2(t))+cos(phi__1(t))*sin(phi__2(t)))*diff(
phi__2(t),t)^2-8*l__1*((-1/4*l__2^2*m__2+J__2)*lambda__1(t)+1/2*theta*(-1/4*
l__2^2*m__2^2+J__2*m__1+2*J__2*m__2))*cos(phi__1(t))-8*l__1*(-1/4*l__2^2*m__2+
J__2)*lambda__2(t)*sin(phi__1(t))-8*lambda__3(t)*J__2)/J__2];
ICS := [phi__1(0) = 0., phi__2(0) = 0., x__3(0) = .4500000000000000, 
phi__1__dot(0) = 150.0000000000000, phi__2__dot(0) = -74.99576703969453, 
x__3__dot(0) = -.2689386719979040e-5, lambda__1(0) = .6552727150584648e-7, 
lambda__2(0) = -382.4589509350831, lambda__3(0) = .4635908708561371e-8];
