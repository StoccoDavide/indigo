VARS := [y__1(t), y__2(t), y__3(t), y__4(t), y__5(t), y__6(t)];
DAES := [2*k__1*y__1(t)^4*y__2(t)^(1/2)-k__2*y__3(t)*y__4(t)+k__2/K*y__1(t)*
y__5(t)+k__3*y__1(t)*y__4(t)^2+diff(y__1(t),t) = 0, 1/2*k__1*y__1(t)^4*y__2(t)^
(1/2)+k__3*y__1(t)*y__4(t)^2+1/2*k__4*y__6(t)^2*y__2(t)^(1/2)-klA*(p__CO2/H-
y__2(t))+diff(y__2(t),t) = 0, -k__1*y__1(t)^4*y__2(t)^(1/2)+k__2*y__3(t)*y__4(t
)-k__2/K*y__1(t)*y__5(t)+diff(y__3(t),t) = 0, k__2*y__3(t)*y__4(t)-k__2/K*y__1(
t)*y__5(t)+2*k__3*y__1(t)*y__4(t)^2+diff(y__4(t),t) = 0, -k__2*y__3(t)*y__4(t)+
k__2/K*y__1(t)*y__5(t)-k__4*y__6(t)^2*y__2(t)^(1/2)+diff(y__5(t),t) = 0, -K__s*
y__1(t)*y__4(t)+y__6(t) = 0];
ICS := [y__1(0) = .444, y__2(0) = .123e-2, y__3(0) = 0., y__4(0) = .7e-2, y__5(
0) = 0., y__6(0) = .35999964];
DATA := [k__1 = 18.7, k__2 = .58, k__3 = .9e-1, k__4 = .42, K = 34.4, klA = 3.3
, K__s = 115.83, p__CO2 = .9, H = 737.0];
