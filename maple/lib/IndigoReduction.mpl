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
  tbl::table,
  $)

  local E, g, a, A, b;

  # Try to simplify the output matrices
  if (_self:-m_TimeLimit > 0) then

    # Simplify the matrix E
    try
      tbl["E"] := timelimit(_self:-m_TimeLimit, simplify(tbl["E"]));
    catch "time expired":
      tbl["E"] := tbl["E"];
      WARNING("time expired, simplify(E) interrupted.");
    end try;

    # Simplify the vector g
    try
      tbl["g"] := timelimit(_self:-m_TimeLimit, simplify(tbl["g"]));
    catch "time expired":
      tbl["g"] := tbl["g"];
      WARNING("time expired, simplify(g) interrupted.");
    end try;

    # Simplify the matrix a
    try
      tbl["a"] := timelimit(_self:-m_TimeLimit, simplify(tbl["a"]));
    catch "time expired":
      tbl["a"] := tbl["a"];
      WARNING("time expired, simplify(a) interrupted.");
    end try;

    # Simplify the matrix A
    try
      tbl["A"] := timelimit(_self:-m_TimeLimit, simplify(tbl["A"]));
    catch "time expired":
      tbl["A"] := tbl["A"];
      WARNING("time expired, simplify(A) interrupted.");
    end try;

    # Simplify the vector b
    try
      tbl["b"] := timelimit(_self:-m_TimeLimit, simplify(tbl["b"]));
    catch "time expired":
      tbl["b"] := tbl["b"];
      WARNING("time expired, simplify(b) interrupted.");
    end try;

  end if;

  return NULL;
end proc: # SimplifyReductionStep

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export SeparateMatrices::static := proc(
  _self::Indigo,
  M::Matrix,
  f::Vector,
  warmstart::boolean,
  $)

  description "Separate algebraic and differential equations from DAE system "
    "equations matrix <M> and differential variables vector <f>. Return the "
    "algebraic equations matrix <E>, the algebraic variables matrix <f>, the "
    "differential equations matrix <a>, and the rank of <M>. The <warmstart> "
    "parameter can be set to true to use the previous LU decomposition results.";

  local n, m, r, Q, tbl, E, ga, pvt;

  # Check if LAST and LEM are initialized
  _self:-CheckInit(_self);

  # Check input dimensions M
  m, n := LinearAlgebra:-Dimension(M);
  if (m <> n) then
    error("input matrix M must be square (got M = %1 x %2).", m, n);
  end if;

  # Check input dimensions f
  r := LinearAlgebra:-Dimension(f);
  if (m <> r) then
    error("input vector f is 1 x %1, expeced 1 x %2.", r, m);
  end if;

  # Decompose the matrix as P.M.Q = L.U
  pvt := _self:-m_LAST:-LU(_self:-m_LAST, M,  parse("warmstart") = warmstart);

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
  {
  check_rank::boolean := true
  }, $)

  description "Load a DAE system of equations <M>.<vars>'=<f>. The optional "
    "parameter <check_rank> can be set to true to check if the system of "
    "equations is already reduced to index-0 DAE (ODE) system.";

  local rnk, tbl;

  # Check if the system is already loaded
  if _self:-m_SystemLoaded then
    if _self:-m_VerboseMode then
      WARNING("Indigo:-LoadMatrices(...): a system of equations is already "
        "loaded, reduction steps and veiling variables will be overwritten.");
    end if;
    _self:-Reset(_self);
  end if;

  # Set system type
  _self:-m_SystemLoaded := true;

  # Store system variables
  _self:-m_SystemVars := vars;
  _self:-m_LEM:-SetVeilingDeps(_self:-m_LEM, vars);

  # Compute the rank of M: if rank is full, the system is index-0 DAE system
  if check_rank then
    rnk := _self:-m_LAST:-Rank(_self:-m_LAST, M);
    if (rnk = nops(_self:-m_SystemVars)) then

      # Update reduction steps
      _self:-m_ReductionSteps := [table([
          "index-0" = true,
          "index-1" = false,
          "vars_x"  = vars,
          "vars_y"  = [],
          "E"       = M,
          "g"       = f,
          "a"       = Vector([]),
          "A"       = Matrix([]),
          "b"       = Vector([]),
          "rank"    = rnk,
          "pivots"  = _self:-m_LAST:-GetResults(_self:-m_LAST, "pivots")
        ])
      ];

      # Return false, we have reached maximum reduction
      if _self:-m_VerboseMode then
        printf("Indigo:-ReduceIndexByOne(...): index-0 DAE (ODE) system has been "
          "reached, with an initial index-%d DAE system.", nops(_self:-m_ReductionSteps)-1);
      end if;
      return false;
    end if;
  end if;

  # Separate algebraic and differential equations
  tbl := _self:-SeparateMatrices(_self, M, f, false);

  # Update reduction steps
  _self:-m_ReductionSteps := [table([
    "index-0" = false,
    "index-1" = false,
    "vars_x"  = vars,
    "vars_y"  = [],
    "E"       = tbl["E"],
    "g"       = tbl["g"],
    "a"       = tbl["a"],
    "A"       = Matrix([]),
    "b"       = Vector([]),
    "rank"    = tbl["rank"],
    "pivots"  = tbl["pivots"]
  ])];

  # Try to simplify the reduction step
  _self:-SimplifyReductionStep(_self, _self:-m_ReductionSteps[-1]);
  return true;
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
    error("system differential order must be 1 but got %1.",
    _self:-DiffOrder(_self, eqns, vars));
  end if;

  # Check input dimensions
  if (nops(eqns) <> nops(vars)) then
    error("the number of equations (%1) must be the same of the number of "
    "variables (%2).", nops(eqns), nops(vars));
  end if;

  # Build the DAE system matrices and load them (M.x' = f)
  M, f := LinearAlgebra:-GenerateMatrix(eqns, diff(vars, t)): # CONSIDER: can be directly used in LoadMatrices?
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

  local vars_x, vars_y, E, g, a, A, b, nE, mE, na, ny, Jv_x, da_t, da_i, E_a,
    g_a, M, f, rnk, nE_a, mE_a, tbl, veil_list;

  if not _self:-m_SystemLoaded then
    error("system must be loaded before calling Indigo:-ReduceIndexByOne(...).");
  end if;

  # Check if the system is already reduced to index-0 or index-1 DAE
  if _self:-m_ReductionSteps[-1]["index-0"] then
    if _self:-m_VerboseMode then
      printf("Indigo:-ReduceIndexByOne(...): index-0 DAE (ODE) system has been already"
        "reached, with an initial index-%d DAE system.", nops(_self:-m_ReductionSteps)-1);
    end if;
    return false;
  elif _self:-m_ReductionSteps[-1]["index-1"] then
    if _self:-m_VerboseMode then
      printf("Indigo:-ReduceIndexByOne(...): index-1 DAE system has already been "
        "reached, with an initial index-%d DAE system.", nops(_self:-m_ReductionSteps));
    end if;
    return false;
  end if;

  vars_x := _self:-m_ReductionSteps[-1]["vars_x"];
  E := _self:-m_ReductionSteps[-1]["E"];
  g := _self:-m_ReductionSteps[-1]["g"];
  a := _self:-m_ReductionSteps[-1]["a"];

  # Check dimensions
  nE, mE := LinearAlgebra:-Dimension(E);
  na     := LinearAlgebra:-Dimension(a);
  if (na + nE <> mE) then
    error("number of E rows plus the number of algebraic equations a must be "
      "equal to the E columns (found %1 + %2 ≠ %3).", nE, na, mE);
  end if;

  # Extract the variables that are still algebraic
  vars_y := map(j -> `if`(
    rtable_scanblock(E, [rtable_dims(E)[1], j], ArrayTools:-HasNonZero),
    NULL, vars_x[j]), [seq(i, i=1..nops(vars_x))]);

  if (nops(vars_y) > 0) then
    A, b := LinearAlgebra:-GenerateMatrix(convert(a, list), vars_y);
    ny := _self:-m_LAST:-Rank(_self:-m_LAST, A);
  else
    ny := 0;
  end if;

  # Update reduction steps based on the index of the DAE system
  if (ny > 0) and (ny = na) then # DAEs index equal to 1 with linear algebraic equations

    if _self:-m_VerboseMode then
      printf("Indigo:-ReduceIndexByOne(...): found %d linear algebraic equations "
        "in the system. Index-1 variables: %a\n", ny, vars_y);
    end if;

    # Update reduction steps
    _self:-m_ReductionSteps := [op(_self:-m_ReductionSteps),
      table([
        "index-0" = false,
        "index-1" = true,
        "vars_x"  = remove(member, vars_x, vars_y),
        "vars_y"  = vars_y,
        "E"       = E[1..-1, remove(j -> ArrayTools:-IsZero(E[1..-1, j]), [seq(i, i=rtable_dims(E)[2])])],
        "g"       = g,
        "a"       = a,
        "rank"    = _self:-m_ReductionSteps[-1]["rank"],
        "pivots"  = _self:-m_ReductionSteps[-1]["pivots"]
      ])
    ];

    if _self:-m_VerboseMode then
      printf("Indigo:-ReduceIndexByOne(...): index-1 DAE system has been reached, "
        "with an initial index-%d DAE system.\n",
        nops(_self:-m_ReductionSteps)-1, ny, vars_y);
    end if;
    return false;

  else # No linear algebraic equations found: continue with the reduction

    vars_y := [];
    if _self:-m_VerboseMode then
      printf("Indigo:-ReduceIndexByOne(...): no linear algebraic equations found, "
        "continuing with the reduction.\n");
    end if;
  end if;

  if _self:-m_VerboseMode then
    printf("Indigo:-ReduceIndexByOne(...): differentiation of algebraic "
    "equations... ");
  end if;

  # Differentiate the algebraic equations
  da_t := diff(a, t);

  # Eliminate the partial derivatives of the veiling variables
  veil_list := _self:-m_LEM:-VeilList(
    _self:-m_LEM, parse("reverse") = true, parse("dependency") = true
  );
  if (nops(veil_list) > 0) then
    Jv_x := IndigoUtils:-DoJacobian(convert(veil_list, Vector), _self:-m_SystemVars);
    Jv_x := select[flatten](j -> (lhs(j) <> 0), convert(Jv_x, list));
    da_t := subs(op(Jv_x), da_t);
  end if;

  if has(da_t, D) then
    da_t := convert(da_t, diff);
    if has(da_t, D) then
      print(indets(da_t));
      error("partial derivatives in the differential part of the system.");
    end if;
  end if;

  if _self:-m_VerboseMode then
    printf("DONE\n");
    printf("Indigo:-ReduceIndexByOne(...): generating linear system... ");
  end if;

  # da/dt = E_a.x' - g_a
  E_a, g_a := LinearAlgebra:-GenerateMatrix(convert(da_t, list), diff(vars_x, t));

  if _self:-m_VerboseMode then
    printf("DONE\n");
  end if;

  # Check dimensions
  nE_a, mE_a := LinearAlgebra:-Dimension(E_a);
  if  (nE_a + nE <> mE) or (mE_a <> mE) then
    error("bad dimension of linear part of constraint derivative a' = E_a.vars' "
    "+ g_a, size E_a = %1 x %2, size E = %3 x %4.", nE_a, mE_a, nE, mE);
  end if;

  M := <E, E_a>;
  f := convert(<g, g_a>, Vector);

  # Separate algebraic and differential equations
  tbl := _self:-SeparateMatrices(_self, M, f, evalb(nops(vars_y) = 0));

  # Update reduction steps
  _self:-m_ReductionSteps := [op(_self:-m_ReductionSteps),
    table([
      "index-0" = evalb(LinearAlgebra:-Dimension(tbl["a"]) = 0),
      "index-1" = false,
      "vars_x"  = vars_x,
      "vars_y"  = vars_y,
      "E"       = tbl["E"],
      "g"       = tbl["g"],
      "a"       = tbl["a"],
      "rank"    = tbl["rank"],
      "pivots"  = tbl["pivots"]
    ])
  ];

  # Try to simplify the reduction step
  _self:-SimplifyReductionStep(_self, _self:-m_ReductionSteps[-1]);

  # Check if we have reached maximum reduction
  if _self:-m_ReductionSteps[-1]["index-0"] then
    if _self:-m_VerboseMode then
      printf("Indigo:-ReduceIndexByOne(...): index-0 DAE (ODE) system has been "
        "reached, with an initial index-%d DAE system.", nops(_self:-m_ReductionSteps)-1);
    end if;
    return false;
  else
    return true;
  end if;
end proc: # ReduceIndexByOne

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export ReduceIndex::static := proc(
  _self::Indigo,
  {
  max_iter::integer := 10
  }, $)::boolean;

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
