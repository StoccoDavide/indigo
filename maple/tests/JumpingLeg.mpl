# File containing the equations of motion for the Jumping Leg system

# Variables
vars_JumpingLeg := [
  y1(t),
  theta1(t),
  theta2(t),
  y1__dot(t),
  theta1__dot(t),
  theta2__dot(t),
  Rp__x(t),
  Tp__z(t),
  R__x1(t),
  R__y1(t),
  R__x2(t),
  R__y2(t)
];

# Equations
eqns_JumpingLeg := [
  -Rp__x(t) + R__x1(t),
  m*diff(y1__dot(t), t) + m*g + R__y1(t),
  -(theta1(t) - theta1__ref)*K__M1 - theta1__dot(t)*C__M1 - Tp__z(t),
  -m1*theta1__dot(t)^2*sin(theta1(t))*y__G1 + m1*diff(theta1__dot(t), t)*cos(theta1(t))*y__G1 - R__x1(t) + R__x2(t),
  m1*(diff(theta1__dot(t), t)*sin(theta1(t))*y__G1 + theta1__dot(t)^2*cos(theta1(t))*y__G1 + diff(y1__dot(t), t)) + m1*g - R__y1(t) + R__y2(t),
  Iz1*diff(theta1__dot(t), t) + ((-y__G1 + L1)*R__x2(t) + y__G1*R__x1(t))*cos(theta1(t)) + sin(theta1(t))*((-y__G1 + L1)*R__y2(t) + R__y1(t)*y__G1) - (theta2(t) - theta2__ref)*K__M2 - theta2__dot(t)*C__M2 + (theta1(t) - theta1__ref)*K__M1 + theta1__dot(t)*C__M1,
  m2*(diff(theta2__dot(t), t)*cos(theta2(t))*y__G2 - theta2__dot(t)^2*sin(theta2(t))*y__G2 + diff(theta1__dot(t), t)*cos(theta1(t))*L1 - theta1__dot(t)^2*sin(theta1(t))*L1) + (1/2 + ((cos(theta2(t))*L2 + cos(theta1(t))*L1 - y1(t))*Kc - (theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)*Cc)/(2*x0*sqrt(1 + ((cos(theta2(t))*L2 + cos(theta1(t))*L1 - y1(t))*Kc - (theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)*Cc)^2/x0^2)))*((cos(theta2(t))*L2 + cos(theta1(t))*L1 - y1(t))*Kc - (theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)*Cc)*(theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)*mu__x/(x0*sqrt(1 + (theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)^2/x0^2)) - R__x2(t),
  m2*(diff(theta2__dot(t), t)*sin(theta2(t))*y__G2 + theta2__dot(t)^2*cos(theta2(t))*y__G2 + diff(theta1__dot(t), t)*sin(theta1(t))*L1 + theta1__dot(t)^2*cos(theta1(t))*L1 + diff(y1__dot(t), t)) + m2*g - (1/2 + ((cos(theta2(t))*L2 + cos(theta1(t))*L1 - y1(t))*Kc - (theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)*Cc)/(2*x0*sqrt(1 + ((cos(theta2(t))*L2 + cos(theta1(t))*L1 - y1(t))*Kc - (theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)*Cc)^2/x0^2)))*((cos(theta2(t))*L2 + cos(theta1(t))*L1 - y1(t))*Kc - (theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)*Cc) - R__y2(t),
  Iz2*diff(theta2__dot(t), t) + (-(y__G2 - L2)*(1/2 + ((cos(theta2(t))*L2 + cos(theta1(t))*L1 - y1(t))*Kc - (theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)*Cc)/(2*x0*sqrt(1 + ((cos(theta2(t))*L2 + cos(theta1(t))*L1 - y1(t))*Kc - (theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)*Cc)^2/x0^2)))*((cos(theta2(t))*L2 + cos(theta1(t))*L1 - y1(t))*Kc - (theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)*Cc)*(theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)*mu__x/(x0*sqrt(1 + (theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)^2/x0^2)) + R__x2(t)*y__G2)*cos(theta2(t)) + ((y__G2 - L2)*(1/2 + ((cos(theta2(t))*L2 + cos(theta1(t))*L1 - y1(t))*Kc - (theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)*Cc)/(2*x0*sqrt(1 + ((cos(theta2(t))*L2 + cos(theta1(t))*L1 - y1(t))*Kc - (theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)*Cc)^2/x0^2)))*((cos(theta2(t))*L2 + cos(theta1(t))*L1 - y1(t))*Kc - (theta2__dot(t)*cos(theta2(t))*L2 + theta1__dot(t)*cos(theta1(t))*L1)*Cc) + R__y2(t)*y__G2)*sin(theta2(t)) + (theta2(t) - theta2__ref)*K__M2 + theta2__dot(t)*C__M2,
  -y1__dot(t) + diff(y1(t), t),
  -theta1__dot(t) + diff(theta1(t), t),
  -theta2__dot(t) + diff(theta2(t), t)
];
