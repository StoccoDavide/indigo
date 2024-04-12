VARS := [theta(t), A(t), H(t), lambda(t), xi(t), V__R(t), beta(t)];
DAES := [diff(H(t),t) = V__R(t)*sin(theta(t)), (H(t)+a__e)*cos(lambda(t))*diff(
xi(t),t) = V__R(t)*cos(theta(t))*sin(A(t)), (H(t)+a__e)*diff(lambda(t),t) = 
V__R(t)*cos(theta(t))*cos(A(t)), m*(H(t)+a__e)^2*diff(V__R(t),t) = (-.\
9804676923e-3*V__R(t)^2*H(t)^2*S-.1960935385e-2*V__R(t)^2*H(t)*S*a__e-.\
9804676923e-3*V__R(t)^2*S*a__e^2)*exp(-1/23800*H(t))+(H(t)^3*m*Omega__E^2+3.*H(
t)^2*a__e*m*Omega__E^2+3.*H(t)*a__e^2*m*Omega__E^2+a__e^3*m*Omega__E^2)*sin(
theta(t))*cos(lambda(t))^2+(-1.*H(t)^3*m*Omega__E^2-3.*H(t)^2*a__e*m*Omega__E^2
-3.*H(t)*a__e^2*m*Omega__E^2-1.*a__e^3*m*Omega__E^2)*cos(A(t))*cos(theta(t))*
sin(lambda(t))*cos(lambda(t))-1.*mu*sin(theta(t))*m, m*V__R(t)*(H(t)+a__e)^2*
diff(theta(t),t) = (.1042661538e-2*V__R(t)^2*H(t)^2*S+.2085323076e-2*V__R(t)^2*
H(t)*S*a__e+.1042661538e-2*V__R(t)^2*S*a__e^2)*cos(beta(t))*exp(-1/23800*H(t))+
(H(t)^3*m*Omega__E^2+3.*H(t)^2*a__e*m*Omega__E^2+3.*H(t)*a__e^2*m*Omega__E^2+
a__e^3*m*Omega__E^2)*cos(theta(t))*cos(lambda(t))^2+((H(t)^3*m*Omega__E^2+3.*H(
t)^2*a__e*m*Omega__E^2+3.*H(t)*a__e^2*m*Omega__E^2+a__e^3*m*Omega__E^2)*cos(A(t
))*sin(theta(t))*sin(lambda(t))+(2.*V__R(t)*H(t)^2*m*Omega__E+4.*V__R(t)*H(t)*
a__e*m*Omega__E+2.*V__R(t)*a__e^2*m*Omega__E)*sin(A(t)))*cos(lambda(t))+(V__R(t
)^2*H(t)*m+V__R(t)^2*a__e*m-1.*m*mu)*cos(theta(t)), cos(theta(t))*m*(H(t)+a__e)
*V__R(t)*diff(A(t),t) = (.1042661538e-2*S*H(t)+.1042661538e-2*S*a__e)*V__R(t)^2
*sin(beta(t))*exp(-1/23800*H(t))+((H(t)^2*m*Omega__E^2+2.*H(t)*a__e*m*Omega__E^
2+a__e^2*m*Omega__E^2)*sin(A(t))*sin(lambda(t))+(-2.*H(t)*m*Omega__E-2.*a__e*m*
Omega__E)*V__R(t)*cos(A(t))*tan(theta(t))*cos(theta(t)))*cos(lambda(t))+(2.*H(t
)*m*Omega__E+2.*a__e*m*Omega__E)*V__R(t)*cos(theta(t))*sin(lambda(t))+V__R(t)^2
*cos(theta(t))^2*sin(A(t))*tan(lambda(t))*m, .9804676923e-3*exp(-1/23800*H(t))*
S*V__R(t)^2/m-C__0+C__1*(-V__R(t)+V__0)-C__2*(V__R(t)-V__0)^2+C__3*(-V__R(t)+
V__0)^3 = 0];
ICS := [theta(332.868734542) = -.1308973356e-1, A(332.868734542) = 1.095863207,
H(332.868734542) = 264039.3280, xi(332.868734542) = 3.101765061, lambda(332.868\
734542) = .5592347076, V__R(332.868734542) = 24317.07980, beta(332.868734542) =
.7173428600];
DATA := [V__0 = 24317.0798, mu = .1407653916e17, Omega__E = .7272205218e-3, 
C__0 = 3.974960446019, C__1 = -.1448947694635e-1, C__2 = -.2156171551995e-4, 
C__3 = -.1089609507291e-7, a__e = 20902900.0, m = 5964.496499824, S = 2690.0, 
alpha = 2/9*Pi];
