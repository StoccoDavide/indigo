# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   ____          _            _   _
#  |  _ \ ___  __| |_   _  ___| |_(_) ___  _ __
#  | |_) / _ \/ _` | | | |/ __| __| |/ _ \| '_ \
#  |  _ <  __/ (_| | |_| | (__| |_| | (_) | | | |
#  |_| \_\___|\__,_|\__,_|\___|\__|_|\___/|_| |_|
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

local SimplifyReductionStep := proc(
  _self::Indigo,
  E::Matrix,
  g::Vector,
  a::Vector,
  $)::Matrix, Vector, Vector;

  local E_tmp, g_tmp, a_tmp;

  # Try to simplify the output matrices
  if (_self:-m_TimeLimit > 0) then

    # Simplify the matrix E
    try
      E_tmp := timelimit(_self:-m_TimeLimit, simplify(E));
    catch "time expired":
      E_tmp := E;
      WARNING("time expired, simplify(E) interrupted.");
    end try;

    # Simplify the matrix g
    try
      g_tmp := timelimit(_self:-m_TimeLimit, simplify(g));
    catch "time expired":
      g_tmp := g;
      WARNING("time expired, simplify(g) interrupted.");
    end try;

    # Simplify the matrix a
    try
      a_tmp := timelimit(_self:-m_TimeLimit, simplify(a));
    catch "time expired":
      a_tmp := a;
      WARNING("time expired, simplify(a) interrupted.");
    end try;

  end if;

  return E_tmp, g_tmp, a_tmp;
end proc: # SimplifyMatrices

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export SeparateMatrices::static := proc(
  _self::Indigo,
  M::Matrix,
  f::Vector,
  $)

  description "Separate algebraic and differential equations from DAE system "
    "equations matrix <M> and differential variables vector <f>. Return the "
    "algebraic equations matrix <E>, the algebraic variables matrix <f>, the "
    "differential equations matrix <a>, and the rank of <M>.";

  local n, m, r, P, Q, tbl, E, ga;

  # Check if LAST and LEM are initialized
  _self:-CheckInit(_self);

  # Check input dimensions M
  n, m := LinearAlgebra:-Dimension(M);
  if (n <> m) then
    error("input matrix M must be square (got M = %1 x %2).", n, m);
  end if;

  # Check input dimensions f
  r := LinearAlgebra:-Dimension(f);
  if (n <> r) then
    error("input vector f is 1 x %1, expeced 1 x %2.", r, n);
  end if;

  # Decompose the matrix as P.M.Q = L.U
  _self:-m_LAST:-LU(_self:-m_LAST, M, parse("veil_sanity_check") = false);

  # Retrieve the results of the LU decomposition
  tbl := _self:-m_LAST:-GetResults(_self:-m_LAST);
  r   := tbl["rank"];

  # Compute E = L^(-1).P.M (first 'r' rows) = U.Q^T
  E := _self:-m_LAST:-GetUQT(_self:-m_LAST);

  # Compute <g, a> = L^(-1).P.f
  ga :=_self:-m_LAST:-ApplyLP(_self:-m_LAST, f);

  return table([
    "E"      = E[1..r, 1..-1],
    "g"      = ga[1..r],
    "a"      = ga[r+1..-1],
    "rank"   = r,
    "pivots" = tbl["pivots"]
  ]);
end proc: # SeparateMatrices

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export LoadMatrices::static := proc(
  _self::Indigo,
  M::Matrix,
  f::Vector,
  vars::list,
  $)

  description "Load a DAE system of equations <M>x'=<f>. The list of variables "
    "<vars> must be the same of the variables used in the system of equations.";

  local tbl;

  # Check if the system is already loaded
  if _self:-m_SystemLoaded then
    if _self:-m_VerboseMode then
      WARNING(
        "Indigo:-LoadMatrices(...): a system of equations is already loaded, "
        "reduction steps and veiling variables will be overwritten."
      );
    end if;
    _self:-Reset(_self);
  end if;

  # Set system type
  _self:-m_SystemLoaded := true;

  # Store system variables
  _self:-m_SystemVars := vars;
  _self:-m_LEM:-SetVeilingDependency(_self:-m_LEM, vars);

  # Separate algebraic and differential equations
  tbl := _self:-SeparateMatrices(_self, M, f);

  # Try to simplify the reduction step
  tbl["E"], tbl["g"], tbl["a"] := SimplifyReductionStep(_self,
    tbl["E"], tbl["g"], tbl["a"]
  );

  # Update reduction steps
  _self:-m_ReductionSteps := [table([
    "E"      = tbl["E"],
    "g"      = tbl["g"],
    "a"      = tbl["a"],
    "rank"   = tbl["rank"],
    "pivots" = tbl["pivots"]
  ])];
  return NULL;
end proc: # LoadMatrices

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export LoadEquations::static := proc(
  _self::Indigo,
  eqns::list,
  vars::list,
  $)

  description "Load a DAE system of equations <eqns>. The list of variables "
    "<vars> must be the same of the variables used in the system of equations.";

  local M, f;

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

  # Build the matrices and load them (Mx' = f)
  M, f := LinearAlgebra:-GenerateMatrix(eqns, diff(vars, t)): # TODO: can be directly used in LoadMatrices?

  _self:-LoadMatrices(_self, M, f, vars);
  return NULL;
end proc: # LoadEquations

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export ReduceIndexByOne::static := proc(
  _self::Indigo,
  $)::boolean;

  description "Reduce the index of the DAE system of equations by one. Return "
    "true if the system of equations has been reduced to index-0 DAE (ODE) or "
    "index-1 DAE, false otherwise.";

  local vars, E, g, E_tmp, a, nE, mE, na, Jv, da, Ea, ga, M, f, dtr, nEa, mEa,
    tbl, veil_list;

  if not _self:-m_SystemLoaded then
    error("system must be loaded before calling Indigo:-ReduceIndexByOne(...).");
  end if;

  vars := _self:-m_SystemVars;
  E    := _self:-m_ReductionSteps[-1]["E"];
  g    := _self:-m_ReductionSteps[-1]["g"];
  a    := _self:-m_ReductionSteps[-1]["a"];

  # Check dimensions
  nE, mE := LinearAlgebra:-Dimension(E);
  na     := LinearAlgebra:-Dimension(a);
  if (na + nE <> mE) then
    error(
      "number of E rows plus the number of algebraic equations a must be equal "
      "to the E columns (found %1 + %2 ≠ %3).", nE, na, mE
    );
  end if;

  if _self:-m_VerboseMode then
    printf("Indigo:-ReduceIndexByOne(...): differentiation of algebraic "
    "equations... ");
  end if;

  # Separate algebraic and differential part
  veil_list := _self:-m_LEM:-VeilList(
    _self:-m_LEM, parse("reverse") = true, parse("dependency") = true
  );
  if (nops(veil_list) <> 0) then
    Jv := IndigoUtils:-DoJacobian(convert(veil_list, Vector), vars);
    Jv := select[flatten](j -> (lhs(j) <> 0), convert(Jv, list));
    da := subs(op(Jv), diff(a, t));
  else
    da := diff(a, t);
  end if;

  if has(da, D) then
    da := convert(da, diff);
    if has(da, D) then
      print(indets(da));
      error("partial derivatives in the differential part of the system.");
    end if;
  end if;

  if _self:-m_VerboseMode then
    printf("DONE\n");
    printf("Indigo:-ReduceIndexByOne(...): generating linear system... ");
  end if;

  # da/dt = E_ax' - ga
  Ea, ga := LinearAlgebra:-GenerateMatrix(convert(da, list), diff(vars, t));

  if _self:-m_VerboseMode then
    printf("DONE\n");
  end if;

  # Check dimensions
  nEa, mEa := LinearAlgebra:-Dimension(Ea);
  if  (nEa + nE <> mE) or (mEa <> mE) then
    error(
      "bad dimension of linear part of constraint derivative "
      "a' = Ea vars' + ga, size Ea = %1 x %2, size E = %3 x %4.",
      nEa, mEa, nE, mE
    );
  end if;

  M := <E, Ea>;
  f := convert(<g, ga>, Vector);

  # Compute the determinant of <E, Ea>
  dtr := _self:-m_LAST:-Rank(_self:-m_LAST, M); #dtr := LinearAlgebra:-Determinant(M);
  try
    dtr := timelimit(_self:-m_TimeLimit, simplify(dtr));
  catch "time expired":
    WARNING("time expired, simplify(det(E, Ea)) interrupted.");
  end try;

  if (dtr = nops(_self:-m_SystemVars)) then

    # Update reduction steps
    _self:-m_ReductionSteps := [op(_self:-m_ReductionSteps),
      table([
        "E"      = M,
        "g"      = f,
        "a"      = Vector([]),
        "rank"   = mE,
        "pivots" = _self:-m_LAST:-GetResults(_self:-m_LAST, "pivots")
      ])
    ];

    # Return false, we have reached maximum reduction
    if _self:-m_VerboseMode then
      printf("Indigo:-ReduceIndexByOne(...): index-0 DAEs (ODEs) system has "
        "been reached.");
    end if;
    return false;
  end if;

  # Split matrices to be stored
  tbl := _self:-SeparateMatrices(_self, M, f);

  # Try to simplify the reduction step
  tbl["E"], tbl["g"], tbl["a"] := SimplifyReductionStep(_self,
    tbl["E"], tbl["g"], tbl["a"]
  );

  # Update reduction steps
  _self:-m_ReductionSteps := [op(_self:-m_ReductionSteps),
    table([
      "E"      = tbl["E"],
      "g"      = tbl["g"],
      "a"      = tbl["a"],
      "rank"   = tbl["rank"],
      "pivots" = tbl["pivots"]
    ])
  ];

  # Check if we have reached maximum reduction
  if (LinearAlgebra:-Dimension(tbl["a"]) = 0) then
    if _self:-m_VerboseMode then
      printf("Indigo:-ReduceIndexByOne(...): index-0 DAEs (ODEs) system has "
      "been reached.");
    end if;
    return false;
  else
    return true;
  end if;
end proc: # ReduceIndexByOne

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export ReduceIndex::static := proc(
  _self::Indigo,
  {max_iter::integer := 10},
  $)::boolean;

  description "Reduce the index of the DAE system of equations. A maximum of "
    "<max_iter> reduction steps is performed. Return true if the system of "
    "equations has been reduced to index-0 DAEs (ODEs) system, false otherwise.";

  local out, i;

  out := true;
  for i from 1 to max_iter while out do
    out := _self:-ReduceIndexByOne(_self);
  end do;
  return out;
end proc: # ReduceIndex

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export GetPivots::static := proc(
  _self::Indigo,
  $)::Matrix(algebraic);

  description "Get the pivots of the system.";

  local out, i;

  # Store the pivots in a matrix
  out := Matrix(i -> -1, nops(_self:-m_SystemVars), nops(_self:-m_ReductionSteps));
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
