# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                        ___           _ _                                    #
#                       |_ _|_ __   __| (_) __ _  ___                         #
#                        | || '_ \ / _` | |/ _` |/ _ \                        #
#                        | || | | | (_| | | (_| | (_) |                       #
#                       |___|_| |_|\__,_|_|\__, |\___/                        #
#                                          |___/                              #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Authors: Davide Stocco (University of Trento)
#          Enrico Bertolazzi (University of Trento)
#
# License: BSD 3-Clause License
#
# This is a module for the 'Indigo' package. It contains the auxiliary
# functions to be used in the 'Indigo' package.

Indigo := module()

  export Reset,
         EnableWarningMode,
         DisableWarningMode,
         EnableVerboseMode,
         DisableVerboseMode,
         SetVeilingSymbol,
         KernelBuild,
         # Wrapper
         LoadMatrices,
         LoadEquations,
         ReduceIndex,
         # Linear
         LoadMatrices_Linear,
         LoadEquations_Linear,
         ReduceIndexByOne_Linear,
         ReduceIndex_Linear,
         # Generic
         LoadMatrices_Generic,
         LoadEquations_Generic,
         ReduceIndexByOne_Generic,
         ReduceIndex_Generic,
         # Mbd index-3
         LoadMatrices_Mbd3,
         LoadEquations_Mbd3,
         ReduceIndex_Mbd3,
         # Index reduction steps
         GetReductionSteps,
         GetDifferentialEquations,
         GetHiddenConstraints,
         GetIndexOneConstraints,
         GetSystemType,
         GetVeilArgsSubs,
         RemoveTimeStates;

  local  ModuleLoad,
         ModuleUnload,
         lib_base_path,
         ReductionSteps,
         SystemType,
         WarningMode,
         VerboseMode,
         VeilingSymbol,
         SeparateMatrices,
         DAEvars;

  option package,
         load   = ModuleLoad,
         unload = ModuleUnload;

  description "'Indigo' module";

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ModuleLoad := proc()

    description "'Indigo' module load procedure.";

    local i;

    # Display module init message
    printf(
      "'Indigo' module version 0.0, BSD 3-Clause License - Copyright (C) 2023, "
      "D. Stocco and E. Bertolazzi.\n"
    );

    # Library path
    lib_base_path := null;
    for i in [libname] do
      if (StringTools:-Search("Indigo", i) <> 0) then
        lib_base_path := i;
      end if;
    end do;
    if (lib_base_path = null) then
      error("Cannot find 'Indigo' module");
    end if;

    # Library internal variables
    Indigo:-WarningMode   := true;
    Indigo:-VerboseMode   := false;
    Indigo:-VeilingSymbol := "V";

    # Protected variables
    protect('Empty', 'Linear', 'Generic', 'Mbd3');

    # Reset the library
    Indigo:-Reset();

    return NULL;
  end proc: # ModuleLoad

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ModuleUnload := proc()

    description "'Indigo' module unload procedure.";

    # Protected variables
    unprotect('Empty', 'Linear', 'Generic', 'Mbd3');
    return NULL;
  end proc: # ModuleUnload

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  EnableWarningMode := proc( $ )

    description "Enable the warning mode.";

    Indigo:-WarningMode := true;
    return NULL;
  end proc: # EnableWarningMode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  DisableWarningMode := proc( $ )

    description "Disable the warning mode.";

    Indigo:-WarningMode := false;
    return NULL;
  end proc: # DisableWarningMode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  EnableVerboseMode := proc( $ )

    description "Enable the verbose mode.";

    Indigo:-VerboseMode := true;
    return NULL;
  end proc: # EnableVerboseMode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  DisableVerboseMode := proc( $ )

    description "Disable the verbose mode.";

    Indigo:-VerboseMode := false;
    return NULL;
  end proc: # DisableVerboseMode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  SetVeilingSymbol := proc(
    sym::{string},
    $)

    description "Set the veiling symbol as a string <sym>.";

    Indigo:-VeilingSymbol := sym;
    return NULL;
  end proc: # SetVeilingSymbol

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Reset := proc( $ )

    description "Reset the library.";

    # Internal variables
    Indigo:-SystemType     := 'Empty';
    Indigo:-ReductionSteps := [];
    Indigo:-DAEvars        := [];

    # Reset the veiling variables
    LEM:-VeilForget(parse(Indigo:-VeilingSymbol));

    return NULL;
  end proc: # Reset

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetReductionSteps := proc(
    i::{nonnegint} := 0,
    $)::{list(table)};

    description "Get the list of reduction steps.";

    if (i = 0) then
      return Indigo:-ReductionSteps;
    else
      return Indigo:-ReductionSteps[i];
    end if;
  end proc: # GetReductionSteps

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetDifferentialEquations := proc( $ )::{list};

    description "Get the list of differential equations of the reduced system.";

    return convert(Indigo:-ReductionSteps[-1]["E"].<diff(Indigo:-DAEvars, t)> -
      Indigo:-ReductionSteps[-1]["G"], list);
  end proc: # GetDifferentialEquations

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetHiddenConstraints := proc( $ )::{list};

    description "Get the list of hidden constraints of the reduced system.";

    #return subs(
    #  op(Indigo:-GetVeilArgsSubs()),
    #  map(x -> op(convert(x["A"], list)), Indigo:-ReductionSteps)
    #);
    return map(x -> op(convert(x["A"], list)), Indigo:-ReductionSteps);
  end proc: # GetHiddenConstraints

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetIndexOneConstraints := proc( $ )::{list};

    description "Get the list of index-1 constraints of the reduced system.";

    #return subs(
    #  op(Indigo:-GetVeilArgsSubs()),
    #  LEM:-VeilList(parse(Indigo:-VeilingSymbol))
    #);
    return LEM:-VeilList(parse(Indigo:-VeilingSymbol));
  end proc: # GetIndexOneConstraints

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetVeilArgsSubs := proc(
    rng::{range} := 1..-1,
    $)::{list(algebraic = algebraic)};

    description "Get the list of veil arguments substitutions.";

    local V_list, var_name, arg_list, L, R;

    print("GetVeilArgsSubs", rng, LEM:-VeilTableSize(parse(Indigo:-VeilingSymbol)));#, LEM:-VeilList(parse(Indigo:-VeilingSymbol)));
    V_list   := LEM:-VeilList(parse(Indigo:-VeilingSymbol))[rng];
    arg_list := map(selectfun, V_list, map2(op, 0, Indigo:-DAEvars));
    return zip((L, R) -> L = L(op(R)), lhs~(V_list), arg_list);
  end proc: # GetVeilArgsSubs

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  RemoveTimeStates := proc(
    arg::{algebraic,
          algebraic = algebraic,
          list(algebraic),
          list(algebraic = algebraic)},
    $)::{algebraic,
         algebraic = algebraic,
         list(algebraic),
         list(algebraic = algebraic)};

    description "Remove the time states from the system.";

    local x;

    return subs(op(map(x -> diff(x, t) = cat(op(0, x), __dot), Indigo:-DAEvars)),
                op(map(x -> x = op(0, x), Indigo:-DAEvars)),
                arg);
  end proc: # RemoveTimeStates

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetSystemType := proc( $ )::{symbol};

    description "Return the type of the system.";

    return Indigo:-SystemType;
  end proc: # GetSystemType

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  KernelBuild := proc(
    E::{Matrix},
    $)::{table};

    description "Build the kernel of a matrix <E>, and return the matrix N such "
      "that E*N = 0 and the rank of E.";

    local n, m, tbl, r, P, Q, M, K, N, rng_b, rng_a, veil_subs;

    # Get row and column dimensions
    n, m := LinearAlgebra:-Dimension(E);

    # Decompose the matrix as P.E.Q = L.U
    rng_b := LEM:-VeilTableSize(parse(Indigo:-VeilingSymbol));
    tbl   := LULEM:-LU(E, parse(Indigo:-VeilingSymbol));
    rng_a := LEM:-VeilTableSize(parse(Indigo:-VeilingSymbol));
    P, Q  := LULEM:-PermutationMatrices(tbl["r"], tbl["c"]);

    print("KernelBuild1, rng_b", rng_b);
    print("KernelBuild1, rng_a", rng_a);

    # Substitute the veil arguments with the dependent variables
    # V[num] -> V[num](params)
    if (rng_a > rng_b) then
      veil_subs := Indigo:-GetVeilArgsSubs(max(1, rng_b)..rng_a);
      print("KernelBuild1, veil_subs", veil_subs);
      tbl["L"] := subs(op(veil_subs), tbl["L"]);
      tbl["U"] := subs(op(veil_subs), tbl["U"]);
    end if;

    # Compute M = L^(-1).P^T
    M := LinearAlgebra:-LinearSolve(tbl["L"], LinearAlgebra:-Transpose(P));

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
    rng_b := LEM:-VeilTableSize(parse(Indigo:-VeilingSymbol));
    K := LEM:-Veil[parse(Indigo:-VeilingSymbol)]~(K);
    N := LEM:-Veil[parse(Indigo:-VeilingSymbol)]~(N);
    rng_a := LEM:-VeilTableSize(parse(Indigo:-VeilingSymbol));

    print("KernelBuild2, rng_b", rng_b);
    print("KernelBuild2, rng_a", rng_a);

    # Substitute the veil arguments with the dependent variables
    # V[num] -> V[num](params)
    if (rng_a > rng_b) then
      veil_subs := Indigo:-GetVeilArgsSubs(max(1, rng_b)..rng_a);
      print("KernelBuild2, veil_subs", veil_subs);
      K := subs(op(veil_subs), K);
      N := subs(op(veil_subs), N);
    end if;

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

  LoadMatrices := proc(
    typ::{symbol}
    # _passed
    )

    description "Load the matrices from the input DAE system of type <typ>.";

    if (_npassed < 2) then
      IndigoUtils:-ErrorMessage(
        "Indigo::LoadMatrices(...): no DAE system to load."
      );
    elif (typ = 'Linear') and (_npassed = 5) then
      Indigo:-LoadMatrices_Linear(_passed[2..-1]);
    elif (typ = 'Generic') and (_npassed = 4) then
      Indigo:-LoadMatrices_Generic(_passed[2..-1]);
    elif (typ = 'Mbd3') and (_npassed = 7) then
      Indigo:-LoadMatrices_Mbd3(_passed[2..-1]);
    else
      IndigoUtils:-ErrorMessage(
        "Indigo::LoadMatrices(...): invalid input arguments."
      );
    end if;
    return NULL;
  end proc: # LoadMatrices

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LoadEquations := proc(
    typ::{symbol}
    # _passed
    )

    description "Load the matrices from the input DAE system of type <typ>.";

    if (_npassed < 3) then
      IndigoUtils:-PrintMessage(
        "BAD USAGE: call the function as Indigo:-LoadEquations('type', ...),\n"
        "where type must be choosen between: 'Linear', 'Generic' or 'Mbd3'.\n"
      );
      IndigoUtils:-ErrorMessage(
        "Indigo[LoadEquations]('type', ... ): no DAE system to load."
      );
    elif (typ = 'Linear') and (_npassed = 3) then
      Indigo:-LoadEquations_Linear(_passed[2..-1]);
    elif (typ = 'Generic') and (_npassed = 3) then
      Indigo:-LoadEquations_Generic(_passed[2..-1]);
    elif (typ = 'Mbd3') and (_npassed = 5) then
      Indigo:-LoadEquations_Mbd3(_passed[2..-1]);
    else
      IndigoUtils:-ErrorMessage(
        "Indigo::LoadEquations(...): invalid input arguments."
      );
    end if;
    return NULL;
  end proc: # LoadEquations

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ReduceIndex := proc( $ )::{boolean};

    description "Reduce the index of the loaded DAE system.";

    if evalb(Indigo:-SystemType = 'Empty') then
      if Indigo:-WarningMode then
        IndigoUtils:-WarningMessage(
          "Indigo::ReduceIndex(...): no DAE system loaded yet."
        );
      end if;
      return false;
    elif evalb(Indigo:-SystemType = 'Linear') then
      return Indigo:-ReduceIndex_Linear();
    elif evalb(Indigo:-SystemType = 'Generic') then
      return Indigo:-ReduceIndex_Generic();
    elif evalb(Indigo:-SystemType = 'Mbd3') then
      return Indigo:-ReduceIndex_Mbd3();
    else
      IndigoUtils:-ErrorMessage(
        "Indigo::ReduceIndex(...): invalid system type '%s'.",
        Indigo:-SystemType
      );
      return false;
    end if;
  end proc: # ReduceIndex

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

$include "./lib/Indigo_Linear.mpl"
$include "./lib/Indigo_Generic.mpl"
$include "./lib/Indigo_Mbd3.mpl"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

end module: # Indigo

# That's all folks!
