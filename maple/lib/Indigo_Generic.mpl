# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#    ____                      _
#   / ___| ___ _ __   ___ _ __(_) ___
#  | |  _ / _ \ '_ \ / _ \ '__| |/ __|
#  | |_| |  __/ | | |  __/ |  | | (__
#   \____|\___|_| |_|\___|_|  |_|\___|
#
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
  _self:-m_LAST:-LU(_self:-m_LAST, E, parse("veil_sanity_check") = false);


  # Retrieve the results of the LU decomposition
  tbl  := _self:-m_LAST:-GetResults(_self:-m_LAST);
  P, Q := _self:-m_LAST:-PermutationMatrices(_self:-m_LAST, tbl["r"], tbl["c"]);
  r    := tbl["rank"];

  # Compute Et = L^(-1).P.E (first 'r' rows) = U.Q^T
  Et := tbl["U"].LinearAlgebra:-Transpose(Q);
  Et := Et[1..r, 1..-1];

  # Compute <Gt, A> = L^(-1).P.G
  GtA := LinearAlgebra:-LinearSolve(tbl["L"], P.G);

  return table([
    "Et"   = Et,
    "Gt"   = copy(GtA[1..r]),
    "A"    = copy(GtA[r+1..-1]),
    "rank" = r
  ]);
end proc: # SeparateMatrices

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export LoadMatrices_Generic::static := proc(
  _self::Indigo,
  E::Matrix,
  G::Vector,
  vars::list,
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
  _self:-m_LEM:-SetVeilingDependency(_self:-m_LEM, convert(vars, set));

  # Set system type
  _self:-m_SystemType := 'Generic';

  # Separate algebraic and differential equations
  tbl := _self:-SeparateMatrices(_self, E, G);

  # Update reduction steps
  _self:-m_ReductionSteps := [table([
    "E"    = tbl["Et"],
    "G"    = tbl["Gt"],
    "A"    = tbl["A"],
    "rank" = tbl["rank"]
  ])];
  return NULL;
end proc: # LoadMatrices_Generic

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export LoadEquations_Generic::static := proc(
  _self::Indigo,
  eqns::list,
  vars::list,
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

  _self:-LoadMatrices_Generic(_self, E, G, vars);
  return NULL;
end proc: # LoadEquations_Generic

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export ReduceIndexByOne_Generic::static := proc(
  _self::Indigo,
  $)::boolean;

  description "Reduce the index of the 'Generic' type DAE system of equations "
    "by one. Return true if the system of equations has been reduced to "
    "index-0 DAE (ODE) or index-1 DAE, false otherwise.";

  local vars, E, G, E_tmp, G_tmp, A, nE, mE, nA, dA, H, F, nH, mH, tbl;

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

  # Separate algebraic and differential part
  dA := diff(A, t);

  # E * diff_vars - G = dA
  H, F := LinearAlgebra:-GenerateMatrix(convert(dA, list), diff(vars, t));

  # Check dimensions
  nH, mH := LinearAlgebra:-Dimension(H);
  if  (nH + nE <> mE) or (mH <> mE) then
    error(
      "bad dimension of linear part of constraint derivative "
      "A' = H vars' + F, size H = %1 x %2, size E = %3 x %4.",
      nH, mH, nE, mE
    );
  end if;

  # Split matrices to be stored
  tbl := _self:-SeparateMatrices(_self, <E, H>, convert(<G, F>, Vector));

  # Update reduction steps
  _self:-m_ReductionSteps := [op(_self:-m_ReductionSteps),
    table([
      "E"    = tbl["Et"],
      "G"    = tbl["Gt"],
      "A"    = tbl["A"],
      "rank" = tbl["rank"]
    ])
  ];

  # Check if we have reached index-0 DAE
  if (LinearAlgebra:-Dimension(tbl["A"]) = 0) then
    if _self:-m_VerboseMode then
      printf(
        "Indigo::ReduceIndexByOne_Generic(...): index-0 DAE (ODE) system has "
        "been reached."
      );
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
    "system of equations has been reduced to index-0 DAE (ODE) or index-1 DAE "
    "(if veiling variables are used), false otherwise.";

  local out, i;

  out := true;
  for i from 1 to max_iter while (out) do
    out := _self:-ReduceIndexByOne_Generic(_self);
  end do;
  return out;
end proc: # ReduceIndex_Generic

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# That's all folks!
