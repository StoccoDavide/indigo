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

  local m_LAST            := NULL;
  local m_LEM             := NULL;
  local m_VerboseMode     := false;
  local m_WarningMode     := true;
  local m_SystemLoaded    := false;
  local m_TimeLimit       := 0.1;
  local m_ReductionSteps  := [];
  local m_SystemVars      := [];
  local m_SystemDummyVars := [];
  local m_SystemInvs      := [];

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
    return NULL;
  end proc: # ModuleLoad

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ModuleUnload::static := proc()

    description "'Indigo' module unload procedure.";

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
    _self:-m_TimeLimit      := proto:-m_TimeLimit;
    _self:-m_SystemLoaded   := proto:-m_SystemLoaded;
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
      error("the 'LAST' object is not initialized, use 'Indigo:-InitLAST(...)'' "
        "or other appropriate initialization methods first."
      );
    end if;
    if (_self:-m_LEM = NULL) then
      error("the 'LEM' object is not initialized, use 'Indigo:-InitLAST(...)'' "
        "or other appropriate initialization methods first.");
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

  export SetTimeLimit::static := proc(
    _self::Indigo,
    x::numeric,
    $)

    description "Set the time limit of the module to <x>.";

    if (x < 0) then
      error("time limit must be a non-negative number.");
    end if;

    _self:-m_TimeLimit := x;
    return NULL;
  end proc: # SetTimeLimit

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetTimeLimit::static := proc(
    _self::Indigo,
    $)::numeric;

    description "Get the time limit of the module.";

    return _self:-m_TimeLimit;
  end proc: # GetTimeLimit

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

    _self:-m_SystemLoaded   := false;
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
      error("reduction steps are not yet available, please load the system "
        "matrices/equations and perform the system index reduction first.");
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

  export AddUserInvariant::static := proc(
    _self::Indigo,
    invs::algebraic,
    $)

    description "Add a user-defined system invariant.";

    _self:-m_SystemInvs := [op(_self:-m_SystemInvs), invs];
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

    description "Get the latest differential equations of the system as "
      "F(x,x',t) = 0.";

    local out;

    # Store the differential equations
    out := convert(_self:-m_ReductionSteps[-1]["E"].<diff(_self:-m_SystemVars, t)> -
      _self:-m_ReductionSteps[-1]["g"], list);

    # Try to simplify
    try
      out := timelimit(_self:-m_TimeLimit, simplify(out));
    catch "time expired":
      WARNING("time expired, simplify interrupted.");
    end try;

    # Return the results
    return out;
  end proc: # GetDifferentialEquations

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetAlgebraicEquations::static := proc(
    _self::Indigo,
    $)::list;

    description "Get the latest algebraic equations of the system as "
      "F(x,x',t) = 0.";

    local out;

    # Store the algebraic equations
    out := convert(_self:-m_ReductionSteps[-1]["a"], list);

    # Try to simplify
    try
      out := timelimit(_self:-m_TimeLimit, simplify(out));
    catch "time expired":
      WARNING("time expired, simplify interrupted.");
    end try;

    # Return the results
    return out;
  end proc: # GetAlgebraicEquations

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetDAEquations::static := proc(
    _self::Indigo,
    $)::list;

    description "Get the latest differential-algebraic equations of the "
      "current system as F(x,x',t) = 0.";

    return [
      op(_self:-GetDifferentialEquations(_self)),
      op(_self:-GetAlgebraicEquations(_self))
    ];
  end proc: # GetAlgebraicEquations

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetInvariants::static := proc(
    _self::Indigo,
    $)::list;

    description "Get the invariants of the system.";

    local out;

    # Store the invariants
    out := map(x -> op(convert(x["a"], list)), _self:-m_ReductionSteps);

    # Try to simplify
    try
      out := timelimit(_self:-m_TimeLimit, simplify(out));
    catch "time expired":
      WARNING("time expired, simplify interrupted.");
    end try;

    # Return the results
    return out;
  end proc: # GetInvariants

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetVeils::static := proc(
    _self::Indigo,
    $)::list;

    description "Get the veils of the system.";

    local out;

    # Store the veils
    out := _self:-m_LEM:-VeilList(_self:-m_LEM, parse("dependency") = true);

    # Try to simplify
    try
      out := timelimit(_self:-m_TimeLimit, simplify(out));
    catch "time expired":
      WARNING("time expired, simplify interrupted.");
    end try;

    # Return the results
    return out;
  end proc: # GetVeils

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetVeilsSubs::static := proc(
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
  end proc: # GetVeilsSubs

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

  export GetSystemLoaded::static := proc(
    _self::Indigo,
    $)::symbol;

    description "Return the type of the system.";

    return _self:-m_SystemLoaded;
  end proc: # GetSystemLoaded

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export DiffOrder := proc(
    _self::Indigo,
    eqns::list,
    vars::list,
    $)::nonnegint;

    description "Return the differential order of the system.";

    return max(map(y -> op(map(x -> PDEtools:-difforder(x), eqns)), vars))
  end proc: # SystemDegree

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export TranslateToMatlab::static := proc(
    _self::Indigo,
    name::string,
    {
    type::string                   := "Implicit",
    data::list(symbol = algebraic) := [],
    info::string                   := "No class description provided."
    }, $)::string;

    description "Generate Matlab code for the loaded system with name <name>, "
      "indigo class <type>, output file './<fname>.m', optional internal class "
      "data <data>, and class information string <info>.";

    local vars, eqns, veil, invs, pvts, label;

    # Get system data
    if _self:-m_SystemLoaded then
      vars := _self:-m_SystemVars;
      eqns := _self:-GetDAEquations(_self);
      veil := _self:-GetVeils(_self);
      pvts := _self:-GetPivots(_self);
      invs := [
        op(_self:-GetUserInvariants(_self)), op(_self:-GetInvariants(_self))
      ];
    else
      if _self:-m_WarningMode then
        WARNING("Indigo:-ReduceIndex(...): no system loaded yet.");
      end if;
    end if;

    # Generate class body string
    label := convert(_self:-m_LEM:-GetVeilingLabel(_self:-m_LEM), string);
    if (type = "Implicit") then
      return IndigoCodegen:-ImplicitSystemToMatlab(
        name, vars, eqns,
        parse("veil")  = veil, parse("invs")  = invs,  parse("pvts") = pvts,
        parse("data")  = data, parse("label") = label, parse("info") = info
      );
    elif (type = "Explicit") then
      return IndigoCodegen:-ExplicitSystemToMatlab(
        name, vars, eqns,
        parse("veil")  = veil, parse("invs")  = invs,  parse("pvts") = pvts,
        parse("data")  = data, parse("label") = label, parse("info") = info
      );
    elif (type = "SemiExplicit") then
      return IndigoCodegen:-SemiExplicitSystemToMatlab(
        name, vars, eqns,
        parse("veil")  = veil, parse("invs")  = invs,  parse("pvts") = pvts,
        parse("data")  = data, parse("label") = label, parse("info") = info
      );
    else
      error("unknown indigo class type '%1'.", type);
    end if;
    return "";
  end proc: # TranslateToMatlab

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GenerateMatlabCode::static := proc(
    _self::Indigo,
    name::string,
    {
    type::string                   := "Implicit",
    path::string                   := "./",
    data::list(symbol = algebraic) := [],
    info::string                   := "No class description provided."
    }, $)

    description "Generate Matlab code for the loaded system with name <name>, "
      "indigo class <type>, output file './<name>.m', optional internal class "
      "data <data>, and class information string <info>.";

    IndigoCodegen:-GenerateFile(
      cat(path, "/", name, ".m"),
      _self:-TranslateToMatlab(
        _self, name,
        parse("type") = type,
        parse("data") = data,
        parse("info") = info
      )
    );
    return NULL;
  end proc: # GenerateMatlabCode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

$include "./lib/IndigoReduction.mpl"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

end module: # Indigo

# That's all folks!
