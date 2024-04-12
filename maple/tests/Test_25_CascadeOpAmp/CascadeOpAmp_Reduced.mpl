VARS := [x__1(t), x__2(t), x__3(t), x__4(t), x__5(t), x__6(t), x__7(t), x__8(t)
, x__9(t), x__10(t)];
DAES := [x__1(t)+C__1*R__1*diff(U(t),t), x__2(t)+C__2*R__2*diff(x__1(t),t), 
x__3(t)+C__3*R__3*diff(x__2(t),t), x__4(t)+C__4*R__4*diff(x__3(t),t), x__5(t)+
C__5*R__5*diff(x__4(t),t), x__6(t)+C__6*R__6*diff(x__5(t),t), x__7(t)+C__7*R__7
*diff(x__6(t),t), x__8(t)+C__8*R__8*diff(x__7(t),t), x__9(t)+C__9*R__9*diff(
x__8(t),t), x__10(t)+C__10*R__10*diff(x__9(t),t)];
ODES := [-diff(x__1(t),t)-C__1*R__1*diff(diff(U(t),t),t), -diff(x__2(t),t)+C__2
*R__2*C__1*R__1*diff(diff(diff(U(t),t),t),t), -diff(x__3(t),t)-C__3*R__3*C__2*
R__2*C__1*R__1*diff(diff(diff(diff(U(t),t),t),t),t), -diff(x__4(t),t)+C__4*R__4
*C__3*R__3*C__2*R__2*C__1*R__1*diff(diff(diff(diff(diff(U(t),t),t),t),t),t), -
diff(x__5(t),t)-C__5*R__5*C__4*R__4*C__3*R__3*C__2*R__2*C__1*R__1*diff(diff(
diff(diff(diff(diff(U(t),t),t),t),t),t),t), -diff(x__6(t),t)+C__6*R__6*C__5*
R__5*C__4*R__4*C__3*R__3*C__2*R__2*C__1*R__1*diff(diff(diff(diff(diff(diff(diff
(U(t),t),t),t),t),t),t),t), -diff(x__7(t),t)-C__7*R__7*C__6*R__6*C__5*R__5*C__4
*R__4*C__3*R__3*C__2*R__2*C__1*R__1*diff(diff(diff(diff(diff(diff(diff(diff(U(t
),t),t),t),t),t),t),t),t), -diff(x__8(t),t)+C__8*R__8*C__7*R__7*C__6*R__6*C__5*
R__5*C__4*R__4*C__3*R__3*C__2*R__2*C__1*R__1*diff(diff(diff(diff(diff(diff(diff
(diff(diff(U(t),t),t),t),t),t),t),t),t),t), -diff(x__9(t),t)-C__9*R__9*C__8*
R__8*C__7*R__7*C__6*R__6*C__5*R__5*C__4*R__4*C__3*R__3*C__2*R__2*C__1*R__1*diff
(diff(diff(diff(diff(diff(diff(diff(diff(diff(U(t),t),t),t),t),t),t),t),t),t),t
), -diff(x__10(t),t)+C__10*R__10*C__9*R__9*C__8*R__8*C__7*R__7*C__6*R__6*C__5*
R__5*C__4*R__4*C__3*R__3*C__2*R__2*C__1*R__1*diff(diff(diff(diff(diff(diff(diff
(diff(diff(diff(diff(U(t),t),t),t),t),t),t),t),t),t),t),t)];
INVS := [-x__1(t)-C__1*R__1*diff(U(t),t), -x__2(t)+C__2*R__2*C__1*R__1*diff(
diff(U(t),t),t), -x__3(t)-C__3*R__3*C__2*R__2*C__1*R__1*diff(diff(diff(U(t),t),
t),t), -x__4(t)+C__4*R__4*C__3*R__3*C__2*R__2*C__1*R__1*diff(diff(diff(diff(U(t
),t),t),t),t), -x__5(t)-C__5*R__5*C__4*R__4*C__3*R__3*C__2*R__2*C__1*R__1*diff(
diff(diff(diff(diff(U(t),t),t),t),t),t), -x__6(t)+C__6*R__6*C__5*R__5*C__4*R__4
*C__3*R__3*C__2*R__2*C__1*R__1*diff(diff(diff(diff(diff(diff(U(t),t),t),t),t),t
),t), -x__7(t)-C__7*R__7*C__6*R__6*C__5*R__5*C__4*R__4*C__3*R__3*C__2*R__2*C__1
*R__1*diff(diff(diff(diff(diff(diff(diff(U(t),t),t),t),t),t),t),t), -x__8(t)+
C__8*R__8*C__7*R__7*C__6*R__6*C__5*R__5*C__4*R__4*C__3*R__3*C__2*R__2*C__1*R__1
*diff(diff(diff(diff(diff(diff(diff(diff(U(t),t),t),t),t),t),t),t),t), -x__9(t)
-C__9*R__9*C__8*R__8*C__7*R__7*C__6*R__6*C__5*R__5*C__4*R__4*C__3*R__3*C__2*
R__2*C__1*R__1*diff(diff(diff(diff(diff(diff(diff(diff(diff(U(t),t),t),t),t),t)
,t),t),t),t), -x__10(t)+C__10*R__10*C__9*R__9*C__8*R__8*C__7*R__7*C__6*R__6*
C__5*R__5*C__4*R__4*C__3*R__3*C__2*R__2*C__1*R__1*diff(diff(diff(diff(diff(diff
(diff(diff(diff(diff(U(t),t),t),t),t),t),t),t),t),t),t)];
DATA := [U_i = 12, f = 300, R__1 = .1e7, R__2 = .1e7, R__3 = .1e7, R__4 = .1e7,
R__5 = .1e7, R__6 = .1e7, R__7 = .1e7, R__8 = .1e7, R__9 = .1e7, R__10 = .1e7,
C__1 = .1e-5, C__2 = .1e-5, C__3 = .1e-5, C__4 = .1e-5, C__5 = .1e-5, C__6 = .1\
e-5, C__7 = .1e-5, C__8 = .1e-5, C__9 = .1e-5, C__10 = .1e-5];
ICS := [x__1(0) = 0, x__2(0) = 0, x__3(0) = 0, x__4(0) = 0, x__5(0) = 0, x__6(0
) = 0, x__7(0) = 0, x__8(0) = 0, x__9(0) = 0, x__10(0) = 0];
