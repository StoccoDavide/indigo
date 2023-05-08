# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   _     _
#  | |   (_)_ __   ___  __ _ _ __
#  | |   | | '_ \ / _ \/ _` | '__|
#  | |___| | | | |  __/ (_| | |
#  |_____|_|_| |_|\___|\__,_|_|
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export LoadMatrices_Linear::static := proc(
  _self::Indigo,
  E::Matrix,
  G::Matrix,
  f::Vector,
  vars::Vector,
  $)

  description "Load a 'Generic' type system of equations as matrices <E> and "
    "<G>. The list of variables <vars> must be the same of the variables "
    "used in the system of equations.";

  local tbl;

  # Check if the system is already loaded
  if evalb(_self:-m_SystemType <> 'Empty') then
    if _self:-m_VerboseMode then
      WARNING(
        "Indigo::LoadMatrices_Linear(...): a system of equations is already "
        "loaded, reduction steps and veiling variables will be overwritten."
      );
    end if;
    _self:-Reset(_self);
  end if;

  # store vars
  _self:-m_SystemVars := vars;

  # Set system type
  _self:-m_SystemType := 'Linear';

  # Update reduction steps
  _self:-m_ReductionSteps := [table([
    "E" = E,
    "G" = G,
    "f" = f
    # "rank" = tbl["rank"] do we need this?
  ])];
  return NULL;
end proc: # LoadMatrices_Linear

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export LoadEquations_Linear::static := proc(
  _self::Indigo,
  eqns::list,
  vars::list,
  $)

  description "Load a 'Linear' type system of equations <eqns>. The list of "
    "variables <vars> must be the same of the variables used in the system "
    "of equations.";

  local eqns_tmp, E, G, f;

  # Check input dimensions
  if (nops(eqns) <> nops(vars)) then
    error(
      "the number of equations (%1) must be the same of the number of variables "
      "(%2).",
      nops(eqns), nops(vars)
    );
  end if;

  E, eqns_tmp := LinearAlgebra:-GenerateMatrix(eqns, diff(vars, t)):
  G, f := LinearAlgebra:-GenerateMatrix(eqns_tmp, vars):
  _self:-LoadEquations_Linear(_self, E, G, f, vars);
  return NULL;
end proc: # LoadEquations_Linear

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export ReduceIndexByOne_Linear::static := proc(
  _self::Indigo,
  $)::boolean;

  description "Reduce the index of the 'Linear' type DAE system of equations "
    "by one. Return true if the system of equations has been reduced to "
    "index-0 DAE (ODE), false otherwise.";

  local vars, E, G, A, nE, mE, nA, dA, H, F, f, nH, mH, tbl;

  if not evalb(_self:-m_SystemType = 'Linear') then
    error(
      "system must be of type 'Linear' but got '%1'.",
      _self:-m_SystemType
    );
  end if;

  vars := _self:-m_SystemVars;
  E    := _self:-m_ReductionSteps[-1]["E"];
  G    := _self:-m_ReductionSteps[-1]["G"];
  f    := _self:-m_ReductionSteps[-1]["f"];

  (*
  # Check dimensions
  nE, mE := LinearAlgebra:-Dimension(E);
  nA := LinearAlgebra:-Dimension(A);
  assert(
    nA + nE = mE,
    "Indigo::ReduceIndexByOne_Linear(...): number of row of E (%d x %d) plus "
    "the number of algebraic equations (%d) must be equal to the column of E.",
    nE, mE, nA
  );

  # Separate algebraic and differential part
  dA := diff(A, t);

  # E * diff_vars - G = dA
  H, F := LinearAlgebra:-GenerateMatrix(convert(dA, list), diff(vars, t));

  # Check dimensions
  nH, mH := LinearAlgebra:-Dimension(H);
  assert(
    (nH + nE = mE) and (mH = mE),
    "Indigo::ReduceIndexByOne_Generic(...): bad dimension of linear part of "
    "constraint derivative A' = H vars' + F, size H = %d x %d, size E = %d x %d.",
    nH, mH, nE, mE
  );

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
  *)

  # Check if we have reached index-0 DAE
  if (LinearAlgebra:-Dimension(tbl["A"]) = 0) then
    if _self:-m_VerboseMode then
      printf(
        "Indigo::ReduceIndexByOne_Linear(...): index-0 DAE (ODE) system has "
        "been reached."
      );
    end if;
    return false;
  else
    return true;
  end if;
end proc: # LoadEquationsByOne_Linear

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export ReduceIndex_Linear::static := proc(
  _self::Indigo,
  $)::boolean;

  description "Reduce the index of the 'Linear' type DAE system of equations. "
    "Return true if the system of equations has been reduced to index-0 DAE "
    "(ODE), false otherwise.";

  local out;

  # Reduce index by one till index-0 DAE (ODE) condition is reached
  out := true;
  while (out) do
    out := _self:-ReduceIndexByOne_Linear(_self);
  end do;
  return out;
end proc: # ReduceIndex_Linear

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
