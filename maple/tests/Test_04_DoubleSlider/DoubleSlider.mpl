POSITION_VARS := [x(t), y(t), theta(t)];
VELOCITY_VARS := [u(t), v(t), omega(t)];
LAMBDA_VARS := [lambda__1(t), lambda__2(t)];
VARS := [x(t), y(t), theta(t), u(t), v(t), omega(t), lambda__1(t), lambda__2(t)
];
FIRST_ORDER := [diff(x(t),t) = u(t), diff(y(t),t) = v(t), diff(theta(t),t) = 
omega(t)];
DAES := [-u(t)+diff(x(t),t) = 0, -v(t)+diff(y(t),t) = 0, -omega(t)+diff(theta(t
),t) = 0, diff(u(t),t)*m+lambda__1(t) = 0, diff(v(t),t)*m+g*m+lambda__2(t) = 0,
cos(theta(t))*ell*lambda__2(t)-sin(theta(t))*ell*lambda__1(t)+2*diff(omega(t),t
)*J = 0, cos(theta(t))*ell+2*x(t) = 0, sin(theta(t))*ell+2*y(t) = 0];
