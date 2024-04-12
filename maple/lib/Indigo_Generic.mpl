# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#    ____                      _
#   / ___| ___ _ __   ___ _ __(_) ___
#  | |  _ / _ \ '_ \ / _ \ '__| |/ __|
#  | |_| |  __/ | | |  __/ |  | | (__
#   \____|\___|_| |_|\___|_|  |_|\___|
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

local SimplifyReductionStep_Generic := proc(
  _self::Indigo,
  E::Matrix,
  G::Vector,
  A::Vector,
  $)::Matrix, Vector, Vector;

  local E_tmp, G_tmp, A_tmp;

  E_tmp := copy(E);
  G_tmp := copy(G);
  A_tmp := copy(A);

  # Try to simplify the output matrices
  if (_self:-m_TimeLimit > 0) then

    # Simplify the matrix E
    try
      E_tmp := timelimit(_self:-m_TimeLimit, simplify(E_tmp));
    catch "time expired":
      WARNING("time expired, simplify(E) interrupted.");
    end try;

    # Simplify the matrix G
    try
      G_tmp := timelimit(_self:-m_TimeLimit, simplify(G_tmp));
    catch "time expired":
      WARNING("time expired, simplify(G) interrupted.");
    end try;

    # Simplify the matrix A
    try
      A_tmp := timelimit(_self:-m_TimeLimit, simplify(A_tmp));
    catch "time expired":
      WARNING("time expired, simplify(A) interrupted.");
    end try;

  end if;

  return E_tmp, G_tmp, A_tmp;
end proc: # SimplifyMatrices

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export SeparateMatrices::static := proc(
  _self::Indigo,
  E::Matrix,
  G::Vector,
  $)

  description "Separate algebraic and differential equations from DAE system "
    "equations matrix <E> and differential variables vector <G>. Return the "
    "algebraic equations matrix <Et>, the algebraic variables matrix <Gt>, the "
    "differential equations matrix <A>, and the rank of <E>.";

  local n, m, r, P, Q, tbl, Et, GtA;

  # Check if LAST and LEM are initialized
  _self:-CheckInit(_self);

  # Check input dimensions E
  n, m := LinearAlgebra:-Dimension(E);
  if (n <> m) then
    error("input matrix E must be square (got E = %1 x %2).", n, m);
  end if;

  # Check input dimensions G
  r := LinearAlgebra:-Dimension(G);
  if (n <> r) then
    error("input vector G is 1 x %1, expeced 1 x %2.", r, n);
  end if;

  # Decompose the matrix as P.E.Q = L.U
  if (_self:-m_Factorization = "LU") then
    _self:-m_LAST:-LU(_self:-m_LAST, E, parse("veil_sanity_check") = false);
  elif (_self:-m_Factorization = "FFLU") then
    _self:-m_LAST:-FFLU(_self:-m_LAST, E, parse("veil_sanity_check") = false);
  else
    error("factorization method '%1' not supported.", _self:-m_Factorization);
  end if;

  # Retrieve the results of the LU decomposition
  tbl := _self:-m_LAST:-GetResults(_self:-m_LAST);
  r   := tbl["rank"];

  # Compute Et = L^(-1).P.E (first 'r' rows) = U.Q^T
  Et := _self:-m_LAST:-GetUQT(_self:-m_LAST);
  Et := Et[1..r, 1..-1];

  # Compute <Gt, A> = L^(-1).P.G
  GtA :=_self:-m_LAST:-ApplyLP(_self:-m_LAST, G);

  return table([
    "Et"     = Et,
    "Gt"     = copy(GtA[1..r]),
    "A"      = copy(GtA[r+1..-1]),
    "rank"   = r,
    "pivots" = tbl["pivots"]
  ]);
end proc: # SeparateMatrices

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export LoadMatrices_Generic::static := proc(
  _self::Indigo,
  E::Matrix,
  G::Vector,
  vars::list,
  first_order::list := [],
  $)

  description "Load a 'Generic' type system of equations as matrices <E> and "
    "<G>. The list of variables <vars> must be the same of the variables "
    "used in the system of equations.";

  local tbl;

  # Check if the system is already loaded
  if evalb(_self:-m_SystemType <> 'Empty') then
    if _self:-m_VerboseMode then
      WARNING(
        "Indigo::LoadMatrices_Generic(...): a system of equations is already "
        "loaded, reduction steps and veiling variables will be overwritten."
      );
    end if;
    _self:-Reset(_self);
  end if;

  # Store system variables
  _self:-m_SystemVars := vars;
  _self:-m_LEM:-SetVeilingDependency(_self:-m_LEM, vars);

  # Set system type
  _self:-m_SystemType := 'Generic';

  # Separate algebraic and differential equations
  tbl := _self:-SeparateMatrices(_self, E, G);

  # Try to simplify the reduction step
  tbl["Et"], tbl["Gt"], tbl["A"] := SimplifyReductionStep_Generic(_self,
    tbl["Et"], tbl["Gt"], tbl["A"]
  );

  # Update reduction steps
  _self:-m_ReductionSteps := [table([
    "E"      = tbl["Et"],
    "G"      = tbl["Gt"],
    "A"      = tbl["A"],
    "rank"   = tbl["rank"],
    "pivots" = tbl["pivots"]
  ])];
  return NULL;
end proc: # LoadMatrices_Generic

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export LoadEquations_Generic::static := proc(
  _self::Indigo,
  eqns::list,
  vars::list,
  first_order::list := [],
  $)

  description "Load a 'Generic' type system of equations <eqns>. The list of "
    "variables <vars> must be the same of the variables used in the system "
    "of equations.";

  local E, G;

  # Check if the system differential order is 1
  if not (_self:-DiffOrder(_self, eqns, vars) = 1) then
    error(
      "system differential order must be 1 but got %1.",
      _self:-DiffOrder(_self, eqns, vars)
    );
  end if;

  # Check input dimensions
  if (nops(eqns) <> nops(vars)) then
    error(
      "the number of equations (%1) must be the same of the number of variables "
      "(%2).", nops(eqns), nops(vars)
    );
  end if;

  # Build the matrices and load them
  E, G := LinearAlgebra:-GenerateMatrix(eqns, diff(vars, t)):

  _self:-LoadMatrices_Generic(_self, E, G, vars, first_order);
  return NULL;
end proc: # LoadEquations_Generic

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export ReduceIndexByOne_Generic::static := proc(
  _self::Indigo,
  $)::boolean;

  description "Reduce the index of the 'Generic' type DAE system of equations "
    "by one. Return true if the system of equations has been reduced to "
    "index-0 DAE (ODE) or index-1 DAE, false otherwise.";

  local vars, E, G, pvts, E_tmp, G_tmp, A, nE, mE, nA, Jv, dA, H, F, EH, GF,
    dtr, nH, mH, tbl, veil_list;

  if not evalb(_self:-m_SystemType = 'Generic') then
    error(
      "system must be of type 'Generic' but got '%1'.",
      _self:-m_SystemType
    );
  end if;

  vars := _self:-m_SystemVars;
  E    := _self:-m_ReductionSteps[-1]["E"];
  G    := _self:-m_ReductionSteps[-1]["G"];
  A    := _self:-m_ReductionSteps[-1]["A"];
  pvts := _self:-m_ReductionSteps[-1]["pivots"];

  # Check dimensions
  nE, mE := LinearAlgebra:-Dimension(E);
  nA := LinearAlgebra:-Dimension(A);
  if (nA + nE <> mE) then
    error(
      "number of row of E (%1 x %2) plus the number of algebraic equations "
      "(%3) must be equal to the column of E.",
      nE, mE, nA
    );
  end if;

  if _self:-m_VerboseMode then
    printf("Indigo::ReduceIndexByOne_Generic(...): differentiation of "
      "algebraic equations... ");
  end if;

  # Separate algebraic and differential part
  veil_list := _self:-m_LEM:-VeilList(
    _self:-m_LEM, parse("reverse") = true, parse("dependency") = true
  );
  if (nops(veil_list) <> 0) then
    Jv := IndigoUtils:-DoJacobian(convert(veil_list, Vector), vars);
    Jv := select[flatten](j -> evalb(lhs(j) <> 0), convert(Jv, list));
    dA := subs(op(Jv), diff(A, t));
  else
    dA := diff(A, t);
  end if;

  if has(dA, D) then
    dA := convert(dA, diff);
    if has(dA, D) then
      print(indets(dA));
      error("partial derivatives in the differential part of the system.");
    end if;
  end if;

  if _self:-m_VerboseMode then
    printf("DONE\n");
    printf("Indigo::ReduceIndexByOne_Generic(...): generating linear system... ");
  end if;

  # E * diff_vars - G = dA
  H, F := LinearAlgebra:-GenerateMatrix(convert(dA, list), diff(vars, t));

  if _self:-m_VerboseMode then
    printf("DONE\n");
  end if;

  # Check dimensions
  nH, mH := LinearAlgebra:-Dimension(H);
  if  (nH + nE <> mE) or (mH <> mE) then
    error(
      "bad dimension of linear part of constraint derivative "
      "A' = H vars' + F, size H = %1 x %2, size E = %3 x %4.",
      nH, mH, nE, mE
    );
  end if;

  EH := <E, H>;
  GF := convert(<G, F>, Vector);

  # Check if determinant of <E, H> is NOT zero
  dtr := _self:-m_LAST:-Rank(_self:-m_LAST, EH); #dtr := LinearAlgebra:-Determinant(EH);
  try
    dtr := timelimit(_self:-m_TimeLimit, simplify(dtr));
  catch "time expired":
    WARNING("time expired, simplify(det(E, H)) interrupted.");
  end try;

  #if (dtr <> 0) then
  if (dtr = nops(_self:-m_SystemVars)) then

    # Update reduction steps
    _self:-m_ReductionSteps := [op(_self:-m_ReductionSteps),
      table([
        "E"      = EH,
        "G"      = GF,
        "A"      = Vector([]),
        "rank"   = mE,
        "pivots" = _self:-m_LAST:-GetResults(_self:-m_LAST, "pivots")
      ])
    ];

    # Return false, we have reached maximum reduction
    if _self:-m_VerboseMode then
      printf("Indigo::ReduceIndexByOne_Generic(...): index-0 DAEs (ODEs) system "
        "has been reached.");
    end if;
    return false;
  end if;

  # Split matrices to be stored
  tbl := _self:-SeparateMatrices(_self, EH, GF);

  # Try to simplify the reduction step
  tbl["Et"], tbl["Gt"], tbl["A"] := SimplifyReductionStep_Generic(_self,
    tbl["Et"], tbl["Gt"], tbl["A"]
  );

  # Update reduction steps
  _self:-m_ReductionSteps := [op(_self:-m_ReductionSteps),
    table([
      "E"      = tbl["Et"],
      "G"      = tbl["Gt"],
      "A"      = tbl["A"],
      "rank"   = tbl["rank"],
      "pivots" = tbl["pivots"]
    ])
  ];

  # Check if we have reached maximum reduction
  if (LinearAlgebra:-Dimension(tbl["A"]) = 0) then
    if _self:-m_VerboseMode then
      printf("Indigo::ReduceIndexByOne_Generic(...): index-0 DAEs (ODEs) system "
        "has been reached.");
    end if;
    return false;
  else
    return true;
  end if;
end proc: # ReduceIndexByOne_Generic

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export ReduceIndex_Generic::static := proc(
  _self::Indigo,
  {max_iter::integer := 10},
  $)::boolean;

  description "Reduce the index of the 'Generic' type DAE system of equations. "
    "A maximum of <max_iter> reduction steps is performed. Return true if the "
    "system of equations has been reduced to index-0 DAEs (ODEs) system, "
    "false otherwise.";

  local out, i;

  out := true;
  for i from 1 to max_iter while (out) do
    out := _self:-ReduceIndexByOne_Generic(_self);
  end do;
  return out;
end proc: # ReduceIndex_Generic

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export GetPivots::static := proc(
  _self::Indigo,
  $)::Matrix(algebraic);

  description "Get the pivots of the system.";

  local out, i;

  # Store the pivots in a matrix
  out := Matrix(nops(_self:-m_SystemVars), nops(_self:-m_ReductionSteps));
  for i to nops(_self:-m_ReductionSteps) do
    out[1..nops(_self:-m_ReductionSteps[i]["pivots"]), i] :=
      convert(_self:-m_ReductionSteps[i]["pivots"], Vector);
  end do;

  # Try to simplify
  try
    out := timelimit(_self:-m_TimeLimit, simplify(out));
  catch "time expired":
    WARNING("time expired, simplify interrupted.");
  end try;

  # Return the results
  return out;
end proc: # GetPivots

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# That's all folks!
