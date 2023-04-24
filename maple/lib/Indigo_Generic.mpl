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

  local n, m, l, tbl, G_tmp, rng_b, rng_a, veil_subs;

  # Apply veil to input vector G
  rng_b := _self:-m_LEM:-VeilTableSize(_self:-m_LEM);
  G_tmp := _self:-m_LEM:-Veil~(_self:-m_LEM, G);
  rng_a := _self:-m_LEM:-VeilTableSize(_self:-m_LEM);

  # Substitute the veil arguments with the dependent variables
  # V[num] -> V[num](params)
  if (rng_a > rng_b) then
    veil_subs := _self:-GetVeilArgsSubs(_self, max(1, rng_b)..rng_a);
    if (nops(veil_subs) > 0) then
      G_tmp := subs(op(veil_subs), G_tmp);
    end if;
  end if;

  # Check input dimensions E
  n, m := LinearAlgebra:-Dimension(E);
  if (n <> m) then
    error(
      "input matrix E must be square (got E = %d x %d).",
      n, m
    );
  end if;

  # Check input dimensions G
  l := LinearAlgebra:-Dimension(G_tmp);
  if (n <> l) then
    error(
      "input matrix E size (got E = %d x %d) is not consistent with vector G "
       "size (got G = 1 x %d).", n, m, l
    );
  end if;

  # Build the kernel of E
  tbl := _self:-KernelBuild(_self, E);
  return table([
    "Et"   = tbl["N"].E,
    "Gt"   = tbl["N"].G_tmp,
    "A"    = tbl["K"].G_tmp,
    "rank" = tbl["rank"]
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

  # store vars
  _self:-m_SystemVars := vars;

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

  # Check input dimensions
  if (nops(eqns) <> nops(vars)) then
    error(
      "the number of equations (%d) must be the same of the number of variables "
      "(%d).", nops(eqns), nops(vars)
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
    "index-0 DAE (ODE), false otherwise.";

  local vars, E, G, E_tmp, G_tmp, A, nE, mE, nA, dA, H, F, nH, mH, tbl;

  if not evalb(_self:-m_SystemType = 'Generic') then
    error(
      "system must be of type 'Generic' but got '%s'.",
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
      "number of row of E (%d x %d) plus the number of algebraic equations "
      "(%d) must be equal to the column of E.",
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
      "A' = H vars' + F, size H = %d x %d, size E = %d x %d.",
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
  $)::boolean;

  description "Reduce the index of the 'Generic' type DAE system of equations. "
    "Return true if the system of equations has been reduced to index-0 DAE "
    "(ODE), false otherwise.";

  local out;

  # Reduce index by one till index-0 DAE (ODE) condition is reached
  out := true;
  while (out) do
    out := _self:-ReduceIndexByOne_Generic(_self);
  end do;
  return out;
end proc: # ReduceIndex_Generic

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# That's all folks!
