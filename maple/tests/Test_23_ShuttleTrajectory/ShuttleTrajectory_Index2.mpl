VARS := [H(t), xi(t), lambda(t), V__R(t), theta(t), A(t), beta(t), alpha(t)];
DAES := [diff(H(t),t) = V__R(t)*sin(theta(t)), (H(t)+a__e)*cos(lambda(t))*diff(
xi(t),t) = V__R(t)*cos(theta(t))*sin(A(t)), (H(t)+a__e)*diff(lambda(t),t) = 
V__R(t)*cos(theta(t))*cos(A(t)), m*(H(t)+a__e)^2*diff(V__R(t),t) = ((-.47560e-4
*S-.3903256749e-4*S*alpha(t)^2)*V__R(t)^2*H(t)^2+(-.95120e-4*S*a__e-.7806513498\
e-4*S*alpha(t)^2*a__e)*V__R(t)^2*H(t)+(-.47560e-4*S*a__e^2-.3903256749e-4*S*
alpha(t)^2*a__e^2)*V__R(t)^2)*exp(-1/23800*H(t))+(H(t)^3*m*Omega__E^2+3.*H(t)^2
*a__e*m*Omega__E^2+3.*H(t)*a__e^2*m*Omega__E^2+a__e^3*m*Omega__E^2)*sin(theta(t
))*cos(lambda(t))^2+(-1.*H(t)^3*m*Omega__E^2-3.*H(t)^2*a__e*m*Omega__E^2-3.*H(t
)*a__e^2*m*Omega__E^2-1.*a__e^3*m*Omega__E^2)*cos(A(t))*cos(theta(t))*sin(
lambda(t))*cos(lambda(t))-1.*mu*sin(theta(t))*m, m*V__R(t)*(H(t)+a__e)^2*diff(
theta(t),t) = (.6812468184e-3*V__R(t)^2*H(t)^2*alpha(t)*S+.1362493637e-2*V__R(t
)^2*H(t)*alpha(t)*S*a__e+.6812468184e-3*V__R(t)^2*alpha(t)*S*a__e^2)*cos(beta(t
))*exp(-1/23800*H(t))+(H(t)^3*m*Omega__E^2+3.*H(t)^2*a__e*m*Omega__E^2+3.*H(t)*
a__e^2*m*Omega__E^2+a__e^3*m*Omega__E^2)*cos(theta(t))*cos(lambda(t))^2+((H(t)^
3*m*Omega__E^2+3.*H(t)^2*a__e*m*Omega__E^2+3.*H(t)*a__e^2*m*Omega__E^2+a__e^3*m
*Omega__E^2)*cos(A(t))*sin(theta(t))*sin(lambda(t))+(2.*V__R(t)*H(t)^2*m*
Omega__E+4.*V__R(t)*H(t)*a__e*m*Omega__E+2.*V__R(t)*a__e^2*m*Omega__E)*sin(A(t)
))*cos(lambda(t))+(V__R(t)^2*H(t)*m+V__R(t)^2*a__e*m-1.*mu*m)*cos(theta(t)), 
cos(theta(t))*m*(H(t)+a__e)*V__R(t)*diff(A(t),t) = ((.6812468184e-3*alpha(t)*S*
H(t)+.6812468184e-3*alpha(t)*S*a__e)*V__R(t)^2*sin(beta(t))*cos(lambda(t))*exp(
-1/23800*H(t))+((H(t)^2*m*Omega__E^2+2.*H(t)*a__e*m*Omega__E^2+a__e^2*m*
Omega__E^2)*sin(A(t))*sin(lambda(t))+(-2.*H(t)*m*Omega__E-2.*a__e*m*Omega__E)*
V__R(t)*cos(A(t))*sin(theta(t)))*cos(lambda(t))^2+(2.*H(t)*m*Omega__E+2.*a__e*m
*Omega__E)*V__R(t)*cos(theta(t))*sin(lambda(t))*cos(lambda(t))+V__R(t)^2*cos(
theta(t))^2*sin(A(t))*sin(lambda(t))*m)/cos(lambda(t)), theta(t)+1/180*Pi+1/
1800000*Pi*t^2 = 0, A(t)-1/4*Pi-1/180000*Pi*t^2 = 0];
ICS := [H(0) = 100000.0, xi(0) = 0., lambda(0) = 0., V__R(0) = 12000.0, theta(0
) = -.1745329252e-1, A(0) = .7853981635, beta(0) = -.9112291796e-3, alpha(0) =
-.4665038328e-1];
DATA := [mu = .1407653916e17, Omega__E = .7272205218e-4, a__e = 20902900.0, m =
2.890532728, S = 1.0];
