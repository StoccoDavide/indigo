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
end proc: # SimplifyReductionStep

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export SeparateMatrices::static := proc(
  _self::Indigo,
  M::Matrix,
  f::Vector,
  {
  repivot::boolean := false
  }, $)

  description "Separate algebraic and differential equations from DAE system "
    "equations matrix <M> and differential variables vector <f>. Return the "
    "algebraic equations matrix <E>, the algebraic variables matrix <f>, the "
    "differential equations matrix <a>, and the rank of <M>.";

  local m, n, r, pvt, M_tmp, f_tmp, tbl, i, j, E, ga;

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
  pvt := _self:-m_LAST:-LU(
    _self:-m_LAST, M,
    parse("indigo_restart") = evalb(nops(_self:-m_ReductionSteps) > 0),  #FIXME:false,
    parse("indigo_repivot") = repivot
  );

  # Check if complicated symbolic pivot detected
  if repivot and type(pvt, table) then
      if _self:-m_VerboseMode then
        printf("Indigo:-SeparateMatrices(...): symbolic pivot detected, "
          "additional dummy variables should be introduced to '%a.'", [op(_self:-m_SystemVars), op(_self:-m_SystemDummyVars)][pvt["j"]]);
      end if;

      # Add a dummy variable - TODO: V1(t) = diff(x_n(t), t), where n is the column of the pivot
      _self:-m_SystemDummyVars := [
        op(_self:-m_SystemDummyVars),
        parse(cat("V", nops(_self:-m_SystemDummyVars)+1, "(t)")) # TODO: change dummy variable name
      ];

      # Add the equation to the system
      M_tmp := Matrix(m+1, m+1, 0);
      M_tmp[1..pvt["i"]-1, 1..pvt["j"]-1]   := copy(M[1..pvt["i"]-1, 1..pvt["j"]-1]);
      M_tmp[1..pvt["i"]-1, pvt["j"]+1..-2]  := copy(M[1..pvt["i"]-1, pvt["j"]+1..-1]);
      M_tmp[pvt["i"], pvt["j"]]             := 1;
      M_tmp[pvt["i"]+1..-2, 1..pvt["j"]-1]  := copy(M[pvt["i"]+1..-1, 1..pvt["j"]-1]);
      M_tmp[pvt["i"]+1..-2, pvt["j"]+1..-2] := copy(M[pvt["i"]+1..-1, pvt["j"]+1..-1]);
      M_tmp[-1, 1..pvt["j"]-1]              := copy(M[pvt["i"], 1..pvt["j"]-1]);
      M_tmp[-1, pvt["j"]+1..-2]             := copy(M[pvt["i"], pvt["j"]+1..-1]);

      f_tmp := Vector(m+1, 0);
      f_tmp[1..pvt["i"]-1]  := copy(f[1..pvt["i"]-1]);
      f_tmp[pvt["i"]]       := _self:-m_SystemDummyVars[-1];
      f_tmp[pvt["i"]+1..-2] := copy(f[pvt["i"]+1..-1]);
      f_tmp[-1]             := copy(f[pvt["i"]]) - _self:-m_SystemDummyVars[-1]*pvt["value"];

      print("M", M, "x_tmp", [pvt["i"], pvt["j"], pvt["value"]], "M_tmp", M_tmp);
      print("f", f, "x_tmp", "f_tmp", f_tmp);

      # Call again the function
      return _self:-SeparateMatrices(_self, M_tmp, f_tmp, parse("repivot") = repivot);
    else

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
  end if;
end proc: # SeparateMatrices

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export LoadMatrices::static := proc(
  _self::Indigo,
  M::Matrix,
  f::Vector,
  vars::list,
  {
  check_rank::boolean := true,
  repivot::boolean    := false
  }, $)

  description "Load a DAE system of equations <M>x'=<f>. The list of variables "
    "<vars> must be the same of the variables used in the system of equations. "
    "The optional parameter <check_rank> can be set to true to check if the "
    "system of equations is already reduced to index-0 DAE (ODE) system.";

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
  _self:-m_LEM:-SetVeilingDependency(_self:-m_LEM, vars);

  # Compute the rank of M
  if check_rank then
    rnk := _self:-m_LAST:-Rank(_self:-m_LAST, M); #rnk := LinearAlgebra:-Rank(M);
    if (rnk = nops(_self:-m_SystemVars) + nops(_self:-m_SystemDummyVars)) then #rnk = nops(_self:-m_SystemVars)

      # Update reduction steps
      _self:-m_ReductionSteps := [table([
          "index-0" = true,
          "index-1" = false,
          "E"       = M,
          "g"       = f,
          "a"       = Vector([]),
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
  tbl := _self:-SeparateMatrices(_self, M, f, parse("repivot") = repivot);

  # Try to simplify the reduction step
  tbl["E"], tbl["g"], tbl["a"] := SimplifyReductionStep(_self, tbl["E"], tbl["g"], tbl["a"]);

  # Update reduction steps
  _self:-m_ReductionSteps := [table([
    "index-0" = false,
    "index-1" = false,
    "E"       = tbl["E"],
    "g"       = tbl["g"],
    "a"       = tbl["a"],
    "rank"    = tbl["rank"],
    "pivots"  = tbl["pivots"]
  ])];
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

  # Build the matrices and load them (Mx' = f)
  M, f := LinearAlgebra:-GenerateMatrix(eqns, diff(vars, t)): # TODO: can be directly used in LoadMatrices?

  _self:-LoadMatrices(_self, M, f, vars);
  return NULL;
end proc: # LoadEquations

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export ReduceIndexByOne::static := proc(
  _self::Indigo,
  {
  check_index::boolean := true,
  check_rank::boolean  := false,
  repivot::boolean     := false
  }, $)::boolean;

  description "Reduce the index of the DAE system of equations by one. Return "
    "true if the system of equations has been reduced to index-0 DAE (ODE) or "
    "index-1 DAE, false otherwise. The optional parameter <check_rank> can be "
    "set to true to check if the system of equations is already reduced to "
    "index-0 DAE (ODE) system.";

  local vars, vars_a, E, g, E_tmp, a, nE, mE, na, Jv, da, Ea, ga, M, f, rnk,
    nEa, mEa, tbl, veil_list;

  if not _self:-m_SystemLoaded then
    error("system must be loaded before calling Indigo:-ReduceIndexByOne(...).");
  end if;

  # Check if the system is already reduced to index-0 or index-1 DAE
  if _self:-m_ReductionSteps[-1]["index-0"] then
    if _self:-m_VerboseMode then
      printf("Indigo:-ReduceIndexByOne(...): index-0 DAE (ODE) system has been "
        "already reached, with an initial index-%d DAE system.", nops(_self:-m_ReductionSteps)-1);
    end if;
    return false;
  elif _self:-m_ReductionSteps[-1]["index-1"] then
    if _self:-m_VerboseMode then
      printf("Indigo:-ReduceIndexByOne(...): index-1 DAE system has been already"
        "reached, with an initial index-%d DAE system.", nops(_self:-m_ReductionSteps));
    end if;
    return false;
  end if;

  vars := [op(_self:-m_SystemVars), op(_self:-m_SystemDummyVars)]; # FIXME: _self:-m_SystemVars;
  E    := _self:-m_ReductionSteps[-1]["E"];
  g    := _self:-m_ReductionSteps[-1]["g"];
  a    := _self:-m_ReductionSteps[-1]["a"];

  # Check dimensions
  nE, mE := LinearAlgebra:-Dimension(E);
  na     := LinearAlgebra:-Dimension(a);
  if (na + nE <> mE) then
    error("number of E rows plus the number of algebraic equations a must be "
      "equal to the E columns (found %1 + %2 ≠ %3).", nE, na, mE);
  end if;

  # Check if the system is an index-1 DAE
  if check_index then
    vars_a := map(j -> `if`(
      rtable_scanblock(E, [rtable_dims(E)[1], j], ArrayTools:-HasNonZero),
      NULL, vars[j]), [seq(i, i=1..nops(vars))]);
    if not has(type~(a, linear(vars_a)), false) then

      # Update reduction steps
      _self:-m_ReductionSteps[-1]["index-1"] := true;
      _self:-m_ReductionSteps[-1]["vars_d"] := remove(member, vars, vars_a);
      _self:-m_ReductionSteps[-1]["E_d"] :=
        E[1..-1, remove(j-> ArrayTools:-IsZero(E[1..-1,j]), [seq(i, i=1..op([1,2], E))])];
      _self:-m_ReductionSteps[-1]["g_d"] := g;
      _self:-m_ReductionSteps[-1]["vars_a"] := vars_a;
      _self:-m_ReductionSteps[-1]["E_a"], _self:-m_ReductionSteps[-1]["g_a"] :=
        LinearAlgebra:-GenerateMatrix(convert(a, list), vars_a);

      if _self:-m_VerboseMode then
        printf("Indigo:-ReduceIndexByOne(...): index-1 DAE system has been "
          "reached, with an initial index-%d DAE system.", nops(_self:-m_ReductionSteps));
      end if;

      # Return false, we have reached index-1 DAE
      return false;
    end if;
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
    error("bad dimension of linear part of constraint derivative a' = Ea vars' "
    "+ ga, size Ea = %1 x %2, size E = %3 x %4.", nEa, mEa, nE, mE);
  end if;

  M := <E, Ea>;
  f := convert(<g, ga>, Vector);

  # Compute the rank of M
  if check_rank then
    rnk := _self:-m_LAST:-Rank(_self:-m_LAST, M); #rnk := LinearAlgebra:-Rank(M);
    if (rnk = nops(vars)) then #rnk = nops(_self:-m_SystemVars)

      # Update reduction steps
      _self:-m_ReductionSteps := [op(_self:-m_ReductionSteps),
        table([
          "index-0" = true,
          "index-1" = false,
          "E"       = M,
          "g"       = f,
          "a"       = Vector([]),
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
  tbl := _self:-SeparateMatrices(_self, M, f, parse("repivot") = repivot);

  # Try to simplify the reduction step
  tbl["E"], tbl["g"], tbl["a"] := SimplifyReductionStep(_self, tbl["E"], tbl["g"], tbl["a"]);

  # Update reduction steps
  _self:-m_ReductionSteps := [op(_self:-m_ReductionSteps),
    table([
      "index-0" = evalb(LinearAlgebra:-Dimension(tbl["a"]) = 0),
      "index-1" = false,
      "E"       = tbl["E"],
      "g"       = tbl["g"],
      "a"       = tbl["a"],
      "rank"    = tbl["rank"],
      "pivots"  = tbl["pivots"]
    ])
  ];

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
