POSITION_VARS := [x(t), y(t)];
VELOCITY_VARS := [u(t), v(t)];
LAMBDA_VARS := [lambda(t)];
VARS := [x(t), y(t), u(t), v(t), lambda(t)];
FIRST_ORDER := [diff(x(t),t) = u(t), diff(y(t),t) = v(t)];
DAES := [-u(t)+diff(x(t),t) = 0, -v(t)+diff(y(t),t) = 0, diff(u(t),t)*m-2*x(t)*
lambda(t) = 0, diff(v(t),t)*m+g*m+lambda(t) = 0, y(t)-x(t)^2 = 0];
