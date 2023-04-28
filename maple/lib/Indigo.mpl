# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                        ___           _ _                                    #
#                       |_ _|_ __   __| (_) __ _  ___                         #
#                        | || '_ \ / _` | |/ _` |/ _ \                        #
#                        | || | | | (_| | | (_| | (_) |                       #
#                       |___|_| |_|\__,_|_|\__, |\___/                        #
#                                          |___/                              #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Current version authors:
#   Davide Stocco     (University of Trento)
#   Enrico Bertolazzi (University of Trento)
#
# License: BSD 3-Clause License
#
# This is a module for the 'Indigo' module.

unprotect('Indigo');
module Indigo()

  description "'Indigo' module.";

  option object;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local m_LAST           := NULL;
  local m_LEM            := NULL;
  local m_VerboseMode    := false;
  local m_WarningMode    := true;
  local m_SystemType     := 'Empty';
  local m_ReductionSteps := [];
  local m_SystemVars     := [];
  local m_SystemInvs     := [];

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export Info::static := proc()

    description "Print 'LAST' module information.";

    printf(
      "+--------------------------------------------------------------------------+\n"
      "| 'Indigo' module version 1.0 - BSD 3-Clause License - Copyright (c) 2023  |\n"
      "| Current version authors:                                                 |\n"
      "|   Davide Stocco and Enrico Bertolazzi.                                   |\n"
      "+--------------------------------------------------------------------------+\n"
    );
    return NULL;
  end proc: # Info

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ModuleLoad::static := proc()

    description "'Indigo' module load procedure.";

    local i, lib_base_path;

    lib_base_path := NULL;
    for i in [libname] do
      if (StringTools:-Search("Indigo", i) <> 0) then
        lib_base_path := i;
      end if;
    end do;
    if (lib_base_path = NULL) then
      error "cannot find 'Indigo' module.";
    end if;
    protect('Empty', 'Linear', 'Generic', 'MultiBody');
    return NULL;
  end proc: # ModuleLoad

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ModuleUnload::static := proc()

    description "'Indigo' module unload procedure.";

    unprotect('Empty', 'Linear', 'Generic', 'MultiBody');
    return NULL;
  end proc: # ModuleUnload

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ModuleCopy::static := proc(
    _self::Indigo,
    proto::Indigo,
    $)

    description "Copy the objects <proto> into <self>.";

    _self:-m_LAST           := proto:-m_LAST;
    _self:-m_LEM            := proto:-m_LEM;
    _self:-m_VerboseMode    := proto:-m_VerboseMode;
    _self:-m_WarningMode    := proto:-m_WarningMode;
    _self:-m_SystemType     := proto:-m_SystemType;
    _self:-m_ReductionSteps := proto:-m_ReductionSteps;
    _self:-m_SystemVars     := proto:-m_SystemVars;
    _self:-m_SystemInvs     := proto:-m_SystemInvs;
  end proc: # ModuleCopy

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export CheckInit::static := proc(
    _self::Indigo,
    $)

    description "Check if the 'LAST' object is initialized.";

    if (_self:-m_LAST = NULL) then
      error(
        "the 'LAST' object is not initialized, use 'Indigo:-InitLAST(...)'' or "
        "other appropriate initialization methods first."
      );
    end if;
    if (_self:-m_LEM = NULL) then
      error(
        "the 'LEM' object is not initialized, use 'Indigo:-InitLAST(...)'' or "
        "other appropriate initialization methods first."
      );
    end if;
    return NULL;
  end proc: # CheckInit

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export InitLAST::static := proc(
    _self::Indigo,
    label::{symbol, string} := NULL,
    $)

    description "Initialize the 'LAST' object with veiling label <label>.";

    _self:-m_LAST := Object(LAST);
    _self:-m_LAST:-InitLEM(_self:-m_LAST, label);
    _self:-m_LEM  := _self:-m_LAST:-GetLEM(_self:-m_LAST);
    return NULL;
  end proc: # InitLAST

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ClearLAST::static := proc(
    _self::Indigo,
    $)

    description "Clear the 'LAST' (and 'LEM') object.";

    _self:-m_LAST := NULL;
    _self:-m_LEM  := NULL;
  end proc: # ClearLAST

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export SetLAST::static := proc(
    _self::Indigo,
    obj::LAST,
    $)

    description "Set the 'LAST' (and 'LEM') object <obj>.";

    _self:-m_LAST := obj;
    _self:-m_LEM  := _self:-m_LAST:-GetLEM(_self:-m_LAST);
    return NULL;
  end proc: # SetLAST

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetLAST::static := proc(
    _self::Indigo,
    $)::LAST;

    description "Get the 'LAST' object.";

    return _self:-m_LAST;
  end proc: # GetLAST

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export SetLEM::static := proc(
    _self::LAST,
    obj::LEM,
    $)

    description "Set the 'LEM' object <obj>.";

    _self:-m_LAST:-SetLEM(_self:-m_LAST, obj);
    _self:-m_LEM := obj;
    return NULL;
  end proc: # SetLEM

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetLEM::static := proc(
    _self::Indigo,
    $)::LEM;

    description "Get the 'LEM' object.";

    return _self:-m_LEM;
  end proc: # GetLEM

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export EnableVerboseMode::static := proc(
    _self::Indigo,
    $)

    description "Enable the verbose mode.";

    _self:-m_VerboseMode := true;
    _self:-m_LAST:-EnableVerboseMode(_self:-m_LAST);
    _self:-m_LEM:-EnableVerboseMode(_self:-m_LEM);
    return NULL;
  end proc: # EnableVerboseMode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export DisableVerboseMode::static := proc(
    _self::Indigo,
    $)

    description "Disable the verbose mode.";

    _self:-m_VerboseMode := false;
    _self:-m_LAST:-DisableVerboseMode(_self:-m_LAST);
    _self:-m_LEM:-DisableVerboseMode(_self:-m_LEM);
    return NULL;
  end proc: # DisableVerboseMode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export SetVerboseMode::static := proc(
    _self::Indigo,
    mode::boolean,
    $)

    description "Set the verbosity of the module to <mode>.";

    _self:-m_VerboseMode := mode;
    _self:-m_LAST:-SetVerboseMode(_self:-m_LAST, mode);
    _self:-m_LEM:-SetVerboseMode(_self:-m_LEM, mode);
    return NULL;
  end proc: # SetVerboseMode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export EnableWarningMode::static := proc(
    _self::Indigo,
    $)

    description "Enable the warning mode of the module.";

    _self:-m_WarningMode := true;
    _self:-m_LAST:-EnableWarningMode(_self:-m_LAST);
    _self:-m_LEM:-EnableWarningMode(_self:-m_LEM);
    return NULL;
  end proc: # EnableWarningMode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export DisableWarningMode::static := proc(
    _self::Indigo,
    $)

    description "Disable the warning mode of the module.";

    _self:-m_WarningMode := false;
    _self:-m_LAST:-DisableWarningMode(_self:-m_LAST);
    _self:-m_LEM:-DisableWarningMode(_self:-m_LEM);
    return NULL;
  end proc: # DisableWarningMode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export SetWarningMode::static := proc(
    _self::Indigo,
    mode::boolean,
    $)

    description "Set the warning mode of the module to <mode>.";

    _self:-m_WarningMode := mode;
    _self:-m_LAST:-SetWarningMode(_self:-m_LAST, mode);
    _self:-m_LEM:-SetWarningMode(_self:-m_LEM, mode);
    return NULL;
  end proc: # SetWarningMode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export SetVeilingSymbol::static := proc(
    _self::Indigo,
    sym::string,
    $)

    description "Set the veiling symbol as a string <sym>.";

    _self:-VeilingSymbol := sym;
    return NULL;
  end proc: # SetVeilingSymbol

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export Reset::static := proc(
    _self::Indigo,
    label::{symbol, string} := NULL,
    $)

    description "Reset the library.";

    if _self:-m_LAST = NULL then
      _self:-InitLAST(_self, label);
    end if;

    _self:-m_SystemType     := 'Empty';
    _self:-m_ReductionSteps := [];
    _self:-m_SystemVars     := [];
    _self:-m_SystemInvs     := [];
    _self:-m_LEM:-ForgetVeil(_self:-m_LEM);
    return NULL;
  end proc: # Reset

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetReductionSteps::static := proc(
    _self::Indigo,
    i::integer := NULL,
    $)::{list(table), table};

    description "Get the list of reduction steps.";

    # Check if the reduction steps are available
    if (_self:-m_ReductionSteps = []) then
      error(
        "reduction steps are not yet available, please load the system "
        "matrices/equations and perform the system index reduction first."
      );
      return NULL;
    end if;

    # Retrieve the list of reduction steps
    if (i = NULL) then
      return _self:-m_ReductionSteps;
    else
      return _self:-m_ReductionSteps[i];
    end if;
  end proc: # GetReductionSteps

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetUserInvariants::static := proc(
    _self::Indigo,
    $)::list(algebraic);

    description "Get the user-defined system invariants.";

    return _self:-m_SystemInvs;
  end proc: # GetUserInvariants

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export SetUserInvariants::static := proc(
    _self::Indigo,
    invs::list(algebraic),
    $)

    description "Set the user-defined system invariants to <invs>.";

    _self:-m_SystemInvs := invs;
    return NULL;
  end proc: # SetUserInvariants

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ClearUserInvariants::static := proc(
    _self::Indigo,
    $)

    description "Clear the user-defined system invariants.";

    _self:-m_SystemInvs := [];
    return NULL;
  end proc: # ClearUserInvariants

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetDifferentialEquations::static := proc(
    _self::Indigo,
    $)::list;

    description "Get the list of differential equations of the reduced implicit "
      "system of the type F(x,x',t) = 0.";

    return convert(_self:-m_ReductionSteps[-1]["E"].<diff(_self:-m_SystemVars, t)> -
      _self:-m_ReductionSteps[-1]["G"], list);
  end proc: # GetDifferentialEquations

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetInvariants::static := proc(
    _self::Indigo,
    $)::list;

    description "Get the invariants of the reduced system.";

    return map(x -> op(convert(x["A"], list)), _self:-m_ReductionSteps);
  end proc: # GetInvariants

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetIndexOneConstraints::static := proc(
    _self::Indigo,
    $)::list;

    description "Get the index-1 constraints of the reduced system.";

    return _self:-m_LEM:-VeilList(_self:-m_LEM, parse("dependency") = true);
  end proc: # GetIndexOneConstraints

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetVeilArgsSubs::static := proc(
    _self::Indigo,
    rng::range := 1..-1,
    $)::list(algebraic = algebraic);

    description "Get the list of veil arguments substitutions.";

    local V_list, V_deps, idx_list, idx_deps, arg_list;

    V_list   := _self:-m_LEM:-VeilList(_self:-m_LEM);
    idx_list := select~(type, indets~(V_list), indexed);
    arg_list := map(selectfun, V_list, map2(op, 0, _self:-m_SystemVars));
    idx_deps := zip(
      (L, R) -> `if`(nops(R) > 0, L = op(R), L = NULL), lhs~(V_list), arg_list
    );
    V_deps := convert~(subs(op(idx_deps), idx_list), list);
    return zip(
      (L, R) -> L = `if`(nops(R) > 0 and (R[1] <> NULL), L(op(R)), L),
      lhs~(V_list[rng]), V_deps[rng]
    );
  end proc: # GetVeilArgsSubs

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export RemoveTimeStates::static := proc(
    _self::Indigo,
    expr::{algebraic, list(algebraic),
           algebraic = algebraic, list(algebraic = algebraic)},
    $)::{algebraic, list(algebraic),
         algebraic = algebraic, list(algebraic = algebraic)};

    description "Remove the time states from the system.";

    return subs(
      op(map(x -> diff(x, t) = cat(op(0, x), __dot), _self:-m_SystemVars)),
      op(map(x -> x = op(0, x), _self:-m_SystemVars)),
      expr
    );
  end proc: # RemoveTimeStates

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetSystemType::static := proc(
    _self::Indigo,
    $)::symbol;

    description "Return the type of the system.";

    return _self:-m_SystemType;
  end proc: # GetSystemType

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export KernelBuild::static := proc(
    _self::Indigo,
    E::Matrix,
    $)::table;

    description "Build the kernel of a matrix <E>, and return the matrix N such "
      "that E*N = 0 and the rank of E.";

    local n, m, tbl, r, P, Q, M, K, N;

    # Check if LAST and LEM are initialized
    _self:-CheckInit(_self);

    # Get row and column dimensions
    n, m := LinearAlgebra:-Dimension(E);

    # Decompose the matrix as P.E.Q = L.U
    _self:-m_LAST:-LU(_self:-m_LAST, E, parse("veil_sanity_check") = false);

    # Retrieve the results of the LU decomposition
    tbl  := _self:-m_LAST:-GetResults(_self:-m_LAST);
    P, Q := _self:-m_LAST:-PermutationMatrices(_self:-m_LAST, tbl["r"], tbl["c"]);

    # Compute M = L^(-1).P
    M := LinearAlgebra:-LinearSolve(tbl["L"], P);

    # Build the N matrix
    r := tbl["rank"];
    if (r > 0) then
      N := M[1..r, 1..-1];
    else
      N := Matrix(0, m);
    end if;

    # Build the K matrix
    if (r < n) then
      K := M[r+1..-1, 1..-1];
    else
      K := Matrix(0, m);
    end if;

    # Apply the veil to input matrices
    K := _self:-m_LEM:-Veil~(_self:-m_LEM, K);
    N := _self:-m_LEM:-Veil~(_self:-m_LEM, N);

    # Return the results
    return table([
      "L"    = tbl["L"],
      "U"    = tbl["U"],
      "r"    = tbl["r"],
      "c"    = tbl["c"],
      "P"    = P,
      "Q"    = Q,
      "K"    = K,
      "N"    = N,
      "rank" = r
      ]);
  end proc: # KernelBuild

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export LoadMatrices::static := proc(
    _self::Indigo,
    type::symbol
    # _passed
    )

    description "Load the matrices from the input system of type <type>.";

    if (_npassed < 3) then
      error("no system to load.");
    elif (type = 'Linear') and (_npassed = 6) then
      _self:-LoadMatrices_Linear(_self, _passed[3..-1]);
    elif (type = 'Generic') and (_npassed = 5) then
      _self:-LoadMatrices_Generic(_self, _passed[3..-1]);
    elif (type = 'MultiBody') and (_npassed = 8) then
      _self:-LoadMatrices_MultiBody(_self, _passed[3..-1]);
    else
      error("invalid input arguments.");
    end if;
    return NULL;
  end proc: # LoadMatrices

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export LoadEquations::static := proc(
    _self::Indigo,
    type::symbol
    # _passed
    )

    description "Load the matrices from the input system of type <type>.";

    if (_npassed < 3) then
      WARNING(
        "BAD USAGE: call the function as Indigo:-LoadEquations('type', ...), "
        "where type must be choosen between: 'Linear', 'Generic' or 'MultiBody'."
      );
      error("no system to load.");
    elif (type = 'Linear') and (_npassed = 4) then
      _self:-LoadEquations_Linear(_self, _passed[3..-1]);
    elif (type = 'Generic') and (_npassed = 4) then
      _self:-LoadEquations_Generic(_self, _passed[3..-1]);
    elif (type = 'MultiBody') and (_npassed = 6) then
      _self:-LoadEquations_MultiBody(_self, _passed[3..-1]);
    else
      error("invalid input arguments.");
    end if;
    return NULL;
  end proc: # LoadEquations

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ReduceIndex::static := proc(
    _self::Indigo,
    {max_iter::integer := 10},
    $)::boolean;

    description "Reduce the index of the loaded system.";

    if evalb(_self:-m_SystemType = 'Empty') then
      if _self:-m_WarningMode then
        WARNING("Indigo::ReduceIndex(...): no system loaded yet.");
      end if;
      return false;
    elif evalb(_self:-m_SystemType = 'Linear') then
      return _self:-ReduceIndex_Linear(_self);
    elif evalb(_self:-m_SystemType = 'Generic') then
      return _self:-ReduceIndex_Generic(_self);
    elif evalb(_self:-m_SystemType = 'MultiBody') then
      return _self:-ReduceIndex_MultiBody(_self);
    else
      error("invalid system type '%s'.", _self:-m_SystemType);
      return false;
    end if;
  end proc: # ReduceIndex

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export TranslateToMatlab::static := proc(
    _self::Indigo,
    name::string,
    type::string,
    {
    data::list(symbol = algebraic) := [],
    info::string                   := "No class description provided."
    }, $)::string;

    description "Generate Matlab code for the loaded system with name <name>, "
      "indigo class <type>, output file './<fname>.m', optional internal class "
      "data <data>, and class information string <info>.";

    local vars, eqns, invs, algs;

    # Get system data
    if evalb(_self:-m_SystemType = 'Empty') then
      if _self:-m_WarningMode then
        WARNING("Indigo::ReduceIndex(...): no system loaded yet.");
      end if;
    elif evalb(_self:-m_SystemType = 'Linear') then
      # TODO: implement
    elif evalb(_self:-m_SystemType = 'Generic') then
      vars := _self:-m_SystemVars;
      eqns := _self:-GetDifferentialEquations(_self);
      invs := [
        op(_self:-GetUserInvariants(_self)), op(_self:-GetInvariants(_self))
      ];
      algs := _self:-GetIndexOneConstraints(_self);
    elif evalb(_self:-m_SystemType = 'MultiBody') then
      # TODO: implement
    else
      error("invalid system type '%s'.", _self:-m_SystemType);
    end if;

    # Generate class body string
    if (type = "Implicit") then
      return IndigoCodegen:-ImplicitSystemToMatlab(
        name, vars, eqns, invs,
        parse("algs") = algs,
        parse("data") = data,
        parse("info") = info
      );
    elif (type = "Explicit") then
      return IndigoCodegen:-ExplicitSystemToMatlab(
        name, vars, eqns, invs,
        parse("algs") = algs,
        parse("data") = data,
        parse("info") = info
      );
    elif (type = "SemiExplicit") then
      return IndigoCodegen:-SemiExplicitSystemToMatlab(
        name, vars, eqns, invs,
        parse("algs") = algs,
        parse("data") = data,
        parse("info") = info
      );
    else
      error("unknown indigo class type '%s'.", type);
    end if;
    return "";
  end proc: # TranslateToMatlab

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GenerateMatlabCode::static := proc(
    _self::Indigo,
    name::string,
    type::string,
    {
    data::list(symbol = algebraic) := [],
    info::string                   := "No class description provided."
    }, $)

    description "Generate Matlab code for the loaded system with name <name>, "
      "indigo class <type>, output file './<name>.m', optional internal class "
      "data <data>, and class information string <info>.";

    IndigoCodegen:-GenerateFile(
      cat("./", name, ".m"),
      _self:-TranslateToMatlab(
        _self, name, type, parse("data") = data, parse("info") = info
      )
    );
    return NULL;
  end proc: # GenerateMatlabCode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

$include "./lib/Indigo_Linear.mpl"
$include "./lib/Indigo_Generic.mpl"
$include "./lib/Indigo_MultiBody.mpl"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

end module: # Indigo

# That's all folks!
