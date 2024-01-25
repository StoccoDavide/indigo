%
% Check routine taken from reference:
%
% A family of embedded Runge-Kutta formulae, J. R. Dormand and P. J. Prince,
% Journal of Computational and Applied Mathematics, volume 6(1), 1980.
%
function [order, msg] = tableau_order( this, A, b, c )

  arguments
    this    Indigo.RungeKutta
    A (:,:) double
    b (1,:) double
    c (:,1) double
  end

  CMD = 'Indigo.RungeKutta.tableau_order(...): ';

  % Temporary variables initialization
  tol   = eps^(2/3);
  one   = ones(length(c), 1);
  Ac    = A*c;
  bA    = (b*A).';
  err   = A*one - c;
  order = -1;
  msg   = '';

  % Check consistency
  if (max(abs(err)) > tol)
    msg = [CMD, 'consistency A*1-c == 0 failed.\n'];
    return;
  end
  order = 0;

  % Check order 1
  if (abs(sum(b) - 1) > tol)
    msg = sprintf([CMD, 'order 1 sum(b) == 1 failed, found sum(b) == %g'], sum(b));
    return;
  end
  order = 1;

  % Check order 2
  bc = b(:).*c;
  if (abs(sum(bc) - 1/2) > tol)
    msg = sprintf([CMD, 'order 2 failed sum(b*c)=%g != 1/2.\n'], sum(bc));
    return;
  end

  order = 2;

  % Check order 3
  bc2 = b(:).*c.^2;
  if (abs(sum(bc2) - 1/3) > tol)
    msg = sprintf([CMD, 'order 3 failed sum(b*c^2)=%g != 1/3.\n'], sum(bc2));
    return;
  end

  bAc = b(:).*Ac;
  if (abs(sum(bAc) - 1/6) > tol)
    msg = sprintf([CMD, 'order 3 failed sum(b*d)=%g != 1/6.\n'], sum(bAc));
    return;
  end

  order = 3;

  % Check order 4
  bc3 = b(:).*c.^3;
  if (abs(sum(bc3) - 1/4) > tol)
    msg = sprintf([CMD, 'order 4 failed sum(b*c^3)=%g != 1/4.\n'], sum(bc3));
    return;
  end

  cAc  = c.*Ac;
  bcAc = b(:).*cAc;
  if (abs(sum(bcAc) - 1/8) > tol)
    msg = sprintf([CMD, 'order 4 failed sum(b*c*A*c)=%g != 1/8.\n'], sum(bcAc));
    return;
  end

  bAc2 = bA.*c.^2;
  if (abs(sum(bAc2) - 1/12) > tol)
    msg = sprintf([CMD, 'order 4 failed sum(b*A*c^2)=%g != 1/12.\n'], sum(bAc2));
    return;
  end

  bAAc = bA.*Ac;
  if (abs(sum(bAAc) - 1/24) > tol)
    msg = sprintf([CMD, 'order 4 failed sum(b*A*A*c)=%g != 1/24.\n'], sum(bAAc));
    return;
  end

  order = 4;

  % Check order 5
  bc4 = b(:).*c.^4;
  if (abs(sum(bc4) - 1/5) > tol)
    msg = sprintf([CMD, 'order 5 failed sum(b*c^4)=%g != 1/5.\n'], sum(bc4));
    return;
  end

  bc2Ac = bc2.*Ac;
  if (abs(sum(bc2Ac) - 1/10) > tol)
    msg = sprintf([CMD, 'order 5 failed sum(b*c^2*A*c)=%g != 1/10.\n'], sum(bc2Ac));
    return;
  end

  bAcAc = (b(:).*Ac).*Ac;
  if (abs(sum(bAcAc) - 1/20) > tol)
    msg = sprintf([CMD, 'order 5 failed sum(b*A*c*A*c)=%g != 1/20.\n'], sum(bAcAc));
    return;
  end

  Ac2   = A*(c.^2);
  bcAc2 = bc.*Ac2;
  if (abs(sum(bcAc2) - 1/15) > tol)
    msg = sprintf([CMD, 'order 5 failed sum(b*c*A*c^2)=%g != 1/15.\n'], sum(bcAc2));
    return;
  end

  Ac3  = A*(c.^3);
  bAc3 = b(:).*Ac3;
  if (abs(sum(bAc3) - 1/20) > tol)
    msg = sprintf([CMD, 'order 5 failed sum(b*A*c^3)=%g != 1/20.\n'], sum(bAc3));
    return;
  end

  bAcAc = bA.*(c.*Ac);
  if (abs(sum(bAcAc) - 1/40) > tol)
    msg = sprintf([CMD, 'order 5 failed sum(b*A*c*A*c)=%g != 1/40.\n'], sum(bAcAc));
    return;
  end

  bAAc2 = bA.*Ac2;
  if (abs(sum(bAAc2) - 1/60) > tol)
    msg = sprintf([CMD, 'order 5 failed sum(b*A*c*A*c)=%g != 1/60.\n'], sum(bAAc2));
    return;
  end

  AAc   = A*Ac;
  bAAAc = bA.*AAc;
  if (abs(sum(bAAAc) - 1/120) > tol)
    msg = sprintf([CMD, 'order 5 failed sum(b*A*c*A*c)=%g != 1/120.\n'], sum(bAAAc));
    return;
  end

  order = 5;

  % Check order 6
  bc5 = b(:).*c.^5;
  if (abs(sum(bc5) - 1/6) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(b*c^5)=%g != 1/6.\n'], sum(bc5));
    return;
  end

  bc3Ac = bc3.*Ac;
  if (abs(sum(bc3Ac) - 1/12) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bc3Ac)=%g != 1/12.\n'], sum(bc3Ac));
    return;
  end

  bcAcAc = bc.*Ac.^2;
  if (abs(sum(bcAcAc) - 1/24) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bcAcAc)=%g != 1/24.\n'], sum(bc3Ac));
    return;
  end

  bc2Ac2 = bc2.*Ac2;
  if (abs(sum(bc2Ac2) - 1/18) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bc2Ac2)=%g != 1/18.\n'], sum(bc2Ac2));
    return;
  end

  bAc2Ac = b(:).*Ac2.*Ac;
  if (abs(sum(bAc2Ac) - 1/36) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bAc2Ac)=%g != 1/36.\n'], sum(bAc2Ac));
    return;
  end

  bcAc3 = bc.*Ac3;
  if (abs(sum(bcAc3) - 1/24) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bcAc3)=%g != 1/24.\n'], sum(bcAc3));
    return;
  end

  Ac4  = A*c.^4;
  bAc4 = b(:).*Ac4;
  if (abs(sum(bAc4) - 1/30) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bAc4)=%g != 1/30.\n'], sum(bAc4));
    return;
  end

  bc2A   = A.'*bc2;
  bc2AAc = bc2A.*Ac;
  if (abs(sum(bc2AAc) - 1/36) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bc2AAc)=%g != 1/36.\n'], sum(bc2AAc));
    return;
  end

  bAcAAc = bAc.*A*Ac;
  if (abs(sum(bAcAAc) - 1/72) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bAcAAc)=%g != 1/72.\n'], sum(bAcAAc));
    return;
  end

  bcA    = A'*bc;
  bcAcAc = bcA.*cAc;
  if (abs(sum(bcAcAc) - 1/48) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bcAcAc)=%g != 1/48.\n'], sum(bcAcAc));
    return;
  end

  bAc2Ac = bA.*c.^2.*Ac;
  if (abs(sum(bAc2Ac) - 1/60) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bAc2Ac)=%g != 1/60.\n'], sum(bAc2Ac));
    return;
  end

  bAAcAc = bA.*Ac.^2;
  if (abs(sum(bAAcAc) - 1/120) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bAAcAc)=%g != 1/120.\n'], sum(bAAcAc));
    return;
  end

  bcAAc2 = bcA.*Ac2;
  if (abs(sum(bcAAc2) - 1/72) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bcAAc2)=%g != 1/72.\n'], sum(bcAAc2));
    return;
  end

  bAcAc2 = bA.*c.*Ac2;
  if (abs(sum(bAcAc2) - 1/90) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bAcAc2)=%g != 1/90.\n'], sum(bAcAc2));
    return;
  end

  bAAc3 = bA.*Ac3;
  if (abs(sum(bAAc3) - 1/120) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bAAc3)=%g != 1/120.\n'], sum(bAAc3));
    return;
  end

  bcAAAc = bcA.*A*Ac;
  if (abs(sum(bcAAAc) - 1/144) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bcAAAc)=%g != 1/144.\n'], sum(bcAAAc));
    return;
  end

  bAcAAc = (bA.*c).*A*Ac;
  if (abs(sum(bAcAAc) - 1/180) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bAcAAc)=%g != 1/180.\n'], sum(bAcAAc));
    return;
  end

  bAAcAc = bA.*A*(cAc);
  if (abs(sum(bAAcAc) - 1/240) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bAAcAc)=%g != 1/240.\n'], sum(bAAcAc));
    return;
  end

  bAAAc2 = bA.*A*Ac2;
  if (abs(sum(bAAAc2) - 1/360) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bAAcAc)=%g != 1/360.\n'], sum(bAAAc2));
    return;
  end

  bAAAAc = bA.*A*(A*Ac);
  if (abs(sum(bAAAAc) - 1/720) > tol)
    msg = sprintf([CMD, 'order 6 failed sum(bAAcAc)=%g != 1/720.\n'], sum(bAAAAc));
    return;
  end

  order = 6;
end
