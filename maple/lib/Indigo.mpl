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
         SystemType,
         ReductionSteps;

  local  ModuleLoad,
         ModuleUnload,
         lib_base_path,
         WarningMode,
         VerboseMode,
         VeilingSymbol,
         SeparateMatrices;

  option  package,
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
    unprotect('Generic', 'Mbd3', 'Empty');
    return NULL;
  end proc: # ModuleUnload

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  EnableWarningMode := proc( $ )::{nothing};

    description "Enable the warning mode.";

    Indigo:-WarningMode := true;
    return NULL;
  end proc: # EnableWarningMode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  DisableWarningMode := proc( $ )::{nothing};

    description "Disable the warning mode.";

    Indigo:-WarningMode := false;
    return NULL;
  end proc: # DisableWarningMode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  EnableVerboseMode := proc( $ )::{nothing};

    description "Enable the verbose mode.";

    Indigo:-VerboseMode := true;
    return NULL;
  end proc: # EnableVerboseMode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  DisableVerboseMode := proc( $ )::{nothing};

    description "Disable the verbose mode.";

    Indigo:-VerboseMode := false;
    return NULL;
  end proc: # DisableVerboseMode

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  SetVeilingSymbol := proc(
    sym::{string},
    $)::{nothing};

    description "Set the veiling symbol as a string <sym>.";

    Indigo:-VeilingSymbol := sym;
    return NULL;
  end proc: # SetVeilingSymbol

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Reset := proc( $ )::{nothing};

    description "Reset the library.";

    # Internal variables
    unprotect(Indigo:-SystemType, Indigo:-ReductionSteps);
    Indigo:-SystemType     := 'Empty';
    Indigo:-ReductionSteps := [];
    protect(Indigo:-SystemType, Indigo:-ReductionSteps);

    # Reset the veiling variables
    LEM:-VeilForget(parse(Indigo:-VeilingSymbol));

    return NULL;
  end proc: # Reset

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  KernelBuild := proc(
    E::{Matrix},
    $)

    description "Build the kernel of a matrix <E>, and return the matrix N such "
    "that E*N = 0 and the rank of E.";

    local n, m, tbl, r, P, Q, M, K, N;

    # Get row and column dimensions
    n, m := LinearAlgebra:-Dimension(E);

    # Decompose the matrix as P.E.Q = L.U
    tbl  := LULEM:-LU(E, parse(Indigo:-VeilingSymbol));
    P, Q := LULEM:-PermutationMatrices(tbl["r"], tbl["c"]);

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
    )::{nothing};

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
    )::{nothing};

    description "Load the matrices from the input DAE system of type <typ>.";

    if (_npassed < 2) then
      IndigoUtils:-ErrorMessage(
        "Indigo::LoadEquations(...): no DAE system to load."
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
  #   _     _
  #  | |   (_)_ __   ___  __ _ _ __
  #  | |   | | '_ \ / _ \/ _` | '__|
  #  | |___| | | | |  __/ (_| | |
  #  |_____|_|_| |_|\___|\__,_|_|
  #
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LoadMatrices_Linear := proc(
    E::{Matrix},
    G::{Matrix},
    f::{Vector},
    vars::{Vector},
    $)::{nothing};

    description "Load a 'Generic' type system of equations as matrices <E> and "
      "<G>. The list of variables <vars> must be the same of the variables "
      "used in the system of equations.";

    local tbl;

    # Check if the system is already loaded
    if evalb(Indigo:-SystemType <> 'Empty') then
      if Indigo:-WarningMode then
        IndigoUtils:-WarningMessage(
          "Indigo::LoadMatrices_Linear(...): a system of equations is already "
          "loaded, reduction steps and veiling variables will be overwritten."
        );
      end if;
      Indigo:-Reset();
    end if;

    # Set system type
    unprotect(Indigo:-SystemType);
    Indigo:-SystemType := 'Linear';
    protect(Indigo:-SystemType);

    # Update reduction steps
    unprotect(Indigo:-ReductionSteps);
    Indigo:-ReductionSteps := [table([
      "vars" = vars,
      "E"    = E,
      "G"    = G,
      "f"    = f
      # "rank" = tbl["rank"] do we need this?
    ])];
    protect(Indigo:-ReductionSteps);
    return NULL;
  end proc: # LoadMatrices_Linear

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LoadEquations_Linear := proc(
    eqns::{list},
    vars::{list},
    $)::{nothing};

    description "Load a 'Linear' type system of equations <eqns>. The list of "
      "variables <vars> must be the same of the variables used in the system "
      "of equations.";

    local eqns_tmp, E, G, f;

    # Check input dimensions
    assert(
      nops(eqns) = nops(vars),
      "Indigo::LoadEquations_Linear(...): the number of equations (%d) must be "
      "the same of the number of variables (%d).",
      nops(eqns), nops(vars)
    );

    E, eqns_tmp := LinearAlgebra:-GenerateMatrix(eqns, diff(vars, t)):
    G, f := LinearAlgebra:-GenerateMatrix(eqns_tmp, vars):
    Indigo:-LoadEquations_Linear(E, G, f, vars);
    return NULL;
  end proc: # LoadEquations_Linear

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ReduceIndexByOne_Linear := proc( $ )::{boolean};

    description "Reduce the index of the 'Linear' type DAE system of equations "
      "by one. Return true if the system of equations has been reduced to "
      "index-0 DAE, false otherwise.";

    local vars, E, G, A, nE, mE, nA, dA, H, F, nH, mH, tbl;

    assert(
      evalb(Indigo:-SystemType = 'Linear'),
      "Indigo::ReduceIndexByOne_Linear(...): system must be of type 'Linear' "
      "but got '%s'.",
      Indigo:-SystemType
    );

    vars := Indigo:-ReductionSteps[-1]["vars"];
    E := Indigo:-ReductionSteps[-1]["E"];
    G := Indigo:-ReductionSteps[-1]["G"];
    f := Indigo:-ReductionSteps[-1]["f"];

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
    tbl := Indigo:-SeparateMatrices(<E, H>, convert(<G, F>, Vector));

    # Update reduction steps
    unprotect(Indigo:-ReductionSteps);
    Indigo:-ReductionSteps := [op(ReductionSteps),
      table([
        "vars" = vars,
        "E"    = tbl["Et"],
        "G"    = tbl["Gt"],
        "A"    = tbl["A"],
        "rank" = tbl["rank"]
      ])
    ];
    protect(Indigo:-ReductionSteps);
    *)

    # Check if we have reached index-0 DAE
    if (LinearAlgebra:-Dimension(tbl["A"]) = 0) then
      if Indigo:-VerbosityMode then
        IndigoUtils:-PrintMessage(
          "Indigo::ReduceIndexByOne_Linear(...): index-0 DAE system has been "
          "reached."
        );
      end if;
      return false;
    else
      return true;
    end if;
  end proc: # LoadEquationsByOne_Linear

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ReduceIndex_Linear := proc( $ )::{boolean};

    description "Reduce the index of the 'Linear' type DAE system of equations. "
      "Return true if the system of equations has been reduced to index-0 DAE, "
      "false otherwise.";

    local out;

    # Reduce index by one till index-0 DAE condition is reached
    out := true;
    while (out) do
      out := Indigo:-ReduceIndexByOne_Linear();
    end do;
    return out;
  end proc: # ReduceIndex_Linear

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #    ____                      _
  #   / ___| ___ _ __   ___ _ __(_) ___
  #  | |  _ / _ \ '_ \ / _ \ '__| |/ __|
  #  | |_| |  __/ | | |  __/ |  | | (__
  #   \____|\___|_| |_|\___|_|  |_|\___|
  #
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  SeparateMatrices := proc(
    E::{Matrix},
    G::{Vector},
    $)

    description "Separate algebraic and differential equations from DAE system "
      "equations matrix <E> and differential variables vector <G>. Return the "
      "algebraic equations matrix <Et>, the algebraic variables matrix <Gt>, "
      "the differential equations matrix <A>, and the rank of <E>.";

    local n, m, l, tbl;

    # Check input dimensions E
    n, m := LinearAlgebra:-Dimension(E);
    assert(
      n = m,
      "Indigo::SeparateMatrices(...): input matrix E must be square (%d x %d).",
      n, m
    );

    # Check input dimensions G
    l := LinearAlgebra:-Dimension(G);
    assert(
      n = l,
      "Indigo::SeparateMatrices(...): input matrix E size (%d x %d) not "
      "consistent with vector G size (1 x %d).",
      n, m, l
    );

    # Build the kernel of E
    tbl := Indigo:-KernelBuild(E);
    return table([
      "Et"   = tbl["N"].E,
      "Gt"   = tbl["N"].G,
      "A"    = tbl["K"].G,
      "rank" = tbl["rank"]
    ]);
  end proc: # SeparateMatrices

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LoadMatrices_Generic := proc(
    E::{Matrix},
    G::{Vector},
    vars::{list},
    $)::{nothing};

    description "Load a 'Generic' type system of equations as matrices <E> and "
      "<G>. The list of variables <vars> must be the same of the variables "
      "used in the system of equations.";

    local tbl;

    # Check if the system is already loaded
    if evalb(Indigo:-SystemType <> 'Empty') then
      if Indigo:-WarningMode then
        IndigoUtils:-WarningMessage(
          "Indigo::LoadMatrices_Generic(...): a system of equations is already "
          "loaded, reduction steps and veiling variables will be overwritten."
        );
      end if;
      Indigo:-Reset();
    end if;

    # Set system type
    unprotect(Indigo:-SystemType);
    Indigo:-SystemType := 'Generic';
    protect(Indigo:-SystemType);

    # Separate algebraic and differential equations
    tbl := Indigo:-SeparateMatrices(E, G);

    # Update reduction steps
    unprotect(Indigo:-ReductionSteps);
    Indigo:-ReductionSteps := [table([
      "vars" = vars,
      "E"    = tbl["Et"],
      "G"    = tbl["Gt"],
      "A"    = tbl["A"],
      "rank" = tbl["rank"]
    ])];
    protect(Indigo:-ReductionSteps);
    return NULL;
  end proc: # LoadMatrices_Generic

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LoadEquations_Generic := proc(
    eqns::{list},
    vars::{list},
    $)::{nothing};

    description "Load a 'Generic' type system of equations <eqns>. The list of "
      "variables <vars> must be the same of the variables used in the system "
      "of equations.";

    local E, G;

    # Check input dimensions
    assert(
      nops(eqns) = nops(vars),
      "Indigo::LoadEquations_Generic(...): the number of equations (%d) must be "
      "the same of the number of variables (%d).",
      nops(eqns), nops(vars)
    );

    # Build the matrices and load them
    E, G := LinearAlgebra:-GenerateMatrix(eqns, diff(vars, t)):
    Indigo:-LoadMatrices_Generic(E, G, vars);
    return NULL;
  end proc: # LoadEquations_Generic

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ReduceIndexByOne_Generic := proc( $ )::{boolean};

    description "Reduce the index of the 'Generic' type DAE system of equations "
      "by one. Return true if the system of equations has been reduced to "
      "index-0 DAE, false otherwise.";

    local vars, E, G, A, nE, mE, nA, dA, H, F, nH, mH, tbl;

    assert(
      evalb(Indigo:-SystemType = 'Generic'),
      "Indigo::ReduceIndexByOne_Generic(...): system must be of type 'Generic' "
      "but got '%s'.",
      Indigo:-SystemType
    );

    vars := Indigo:-ReductionSteps[-1]["vars"];
    E := Indigo:-ReductionSteps[-1]["E"];
    G := Indigo:-ReductionSteps[-1]["G"];
    A := Indigo:-ReductionSteps[-1]["A"];

    # Check dimensions
    nE, mE := LinearAlgebra:-Dimension(E);
    nA := LinearAlgebra:-Dimension(A);
    assert(
      nA + nE = mE,
      "Indigo::ReduceIndexByOne_Generic(...): number of row of E (%d x %d) plus "
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
    tbl := Indigo:-SeparateMatrices(<E, H>, convert(<G, F>, Vector));

    # Update reduction steps
    unprotect(Indigo:-ReductionSteps);
    Indigo:-ReductionSteps := [op(ReductionSteps),
      table([
        "vars" = vars,
        "E"    = tbl["Et"],
        "G"    = tbl["Gt"],
        "A"    = tbl["A"],
        "rank" = tbl["rank"]
      ])
    ];
    protect(Indigo:-ReductionSteps);

    # Check if we have reached index-0 DAE
    if (LinearAlgebra:-Dimension(tbl["A"]) = 0) then
      if Indigo:-VerbosityMode then
        IndigoUtils:-PrintMessage(
          "Indigo::ReduceIndexByOne_Generic(...): index-0 DAE system has been "
          "reached."
        );
      end if;
      return false;
    else
      return true;
    end if;
  end proc: # ReduceIndexByOne_Generic

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ReduceIndex_Generic := proc( $ )::{boolean};

    description "Reduce the index of the 'Generic' type DAE system of equations. "
      "Return true if the system of equations has been reduced to index-0 DAE, "
      "false otherwise.";

    local out;

    # Reduce index by one till index-0 DAE condition is reached
    out := true;
    while (out) do
      out := Indigo:-ReduceIndexByOne_Generic();
    end do;
    return out;
  end proc: # ReduceIndex_Generic

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #   __  __ _         _ _____
  #  |  \/  | |__   __| |___ /
  #  | |\/| | '_ \ / _` | |_ \
  #  | |  | | |_) | (_| |___) |
  #  |_|  |_|_.__/ \__,_|____/
  #
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LoadMatrices_Mbd3 := proc(
    Mass::{Matrix},
    Phi::{Vector},
    f::{Vector},
    q_vars::{list},
    v_vars::{list},
    l_vars::{list},
    $)::{nothing};

    description "Load a 'Mbd3' type system of equations with mass matrix "
      "<Mass>, constraint vector <Phi>, external force vector <f>, the position "
      "variables <q_vars>, the velocity variables <v_vars> and the Lagrange "
      "multipliers <l_vars>.";

    local tbl;

    # Check if the system is already loaded
    if not evalb(Indigo:-SystemType = 'Empty') then
      if Indigo:-WarningMode then
        IndigoUtils:-WarningMessage(
          "Indigo::LoadMatrices_Mbd3(...): a system of equations is already "
          "loaded, reduction steps and veiling variables will be overwritten."
        );
      end if;
      Indigo:-Reset();
    end if;

    # Set system type
    unprotect(Indigo:-SystemType);
    Indigo:-SystemType := 'Mbd3';
    protect(Indigo:-SystemType);

    # Separate algebraic and differential equations
    unprotect(Indigo:-ReductionSteps);
    Indigo:-ReductionSteps := [table([
      "Mass"   = Mass,
      "Phi"    = Phi,
      "f"      = f,
      "q_vars" = q_vars,
      "v_vars" = v_vars,
      "l_vars" = l_vars
    ])];
    return NULL;
  end proc: # LoadMatrices_Mbd3

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LoadEquations_Mbd3 := proc(
    eqns::{list},
    q_vars::{list},
    v_vars::{list},
    l_vars::{list},
    $)::{nothing};

    description "Load a 'Mdb' type system of equations <eqns> with the position "
      "variables <q_vars>, the velocity variables <v_vars> and the Lagrange "
      "multipliers <l_vars>.";

    local tmp, Mass, Phi, f;

    # Build the matrices
    tmp, f := LinearAlgebra:-GenerateMatrix(eqns, [op(v_vars), op(l_vars)]);
    Mass, Phi := LinearAlgebra:-GenerateMatrix(tmp, v_vars);

    # Load matrices
    Indigo:-LoadMbdMatrices(Mass, Phi, f, q_vars, v_vars, l_vars);
    return NULL;
  end proc: # LoadEquations_Mbd3

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ReduceIndex_Mbd3 := proc({
    jacobians::{boolean} := false,
    baumgarte::{boolean} := false
    }, $)::{boolean};

    description "Reduce the index of the multibody DAE system of equations. "
      "Return true if  the system of equations has been reduced to index-0 "
      "DAE, false otherwise.";

    local n, m, q_vars_t, v_vars_t, v_vars_dot, ODE_pos, ODE_vel, tmp, A, Phi_P,
      Phi_t, A_rhs, g, Mass_tot, f_tot, vars_tot, eta_tot, Jeta_tot, Jf_tot, h,
      f_stab, Jf_stab;

    assert(
      evalb(Indigo:-SystemType = "Mbd"),
      "Indigo::ReduceIndex_Mbd3(...): system must be of type 'Mbd3' but got '%s'.",
      Indigo:-SystemType
    );

    # Check dimensions of inputs
    n, m := LinearAlgebra:-Dimension(Mass);
    assert(
      (n = m) and (n = nops(v_vars)),
      "Indigo::ReduceIndex_Mbd3(...): mass matrix must be square and of the same "
      "size of the length of velocity variables.",
      Mass, v_vars
    );

    n := nops(q_vars);
    assert(
      n = nops(v_vars),
      "Indigo::ReduceIndex_Mbd3(...): velocity variables and position variables "
      "must have the same size."
    );

    m := LinearAlgebra:-Dimension(Phi);
    assert(
      (m = nops(l_vars)),
      "Indigo::ReduceIndex_Mbd3(...): lambda variables must have the same length "
      "the number of constraints."
    );

    # Differential variables
    q_vars_t := diff(q_vars, t);
    v_vars_t := diff(v_vars, t);

    # Definition of variable "derivative of velocities"
    v_vars_dot := map(map(cat, map2(op, 0, v_vars), __d), (t));

    # ODDE position part q' = v
    ODE_pos := zip((x, y) -> x = y, q_vars_t, v_vars);

    # ODE velocity part v' = v__d
    ODE_vel := zip((x, y) -> x = y, v_vars_t, v_vars_dot);

    # Hidden contraint/invariant A(q,v,t)
    A := subs(ODE_pos, diff(Phi, t));
    Phi_P, A_rhs := LinearAlgebra:-GenerateMatrix(convert(A, list), v_vars);

    # Hidden invariant Phi_P v__d - g(q,v,t)
    tmp, g := LinearAlgebra:-GenerateMatrix(diff(convert(A, list), t), v_vars_t);

    # Big linear system
    Mass_tot := <<Mass, Phi_P>|<LinearAlgebra:-Transpose(Phi_P), Matrix(m, m)>>;
    f_tot    := convert(<f, subs(ODE_pos, g)>, Vector);
    vars_tot := [op(v_vars_dot), op(l_vars)];

    # Jacobians of the big linear system
    if jacobians then
      eta_tot  := convert(Mass_tot.<seq(mu||i, i = 1..n+m)>, Vector);;
      Jeta_tot := IndigoUtils:-DoJacobian(eta_tot, [op(q_vars), op(v_vars)]);
      Jf_tot   := IndigoUtils:-DoJacobian(f_tot, [op(q_vars), op(v_vars)]);
    else
      eta_tot  := NULL;
      Jeta_tot := NULL;
      Jf_tot   := NULL;
    end if;

    # Baumgarte stabilization
    if baumgarte then
      h       := g - 2*eta*omega*A - omega^2*Phi;
      f_stab  := convert(<f, h>, Vector);
      Jf_stab := IndigoUtils:-DoJacobian(f_stab, [op(q_vars), op(v_vars)]);
    else
      h       := NULL;
      f_stab  := NULL;
      Jf_stab := NULL;
    end if;

    # Return the computed blocks
    unprotect(Indigo:-ReductionSteps);
    Indigo:-ReductionSteps := [
      table([
        # Inputs
        op(op(eval(Indigo:-ReductionSteps))),
        # Variables
        "v_vars_dot" = v_vars_dot,
        # Dimensions
        "m"          = m,
        "n"          = n,
        # Differential part
        "ODE_pos"    = ODE_pos,
        "ODE_vel"    = ODE_vel,
        "ODE_f"      = [op(rhs~(ODE_pos)), op(rhs~(ODE_vel))],
        # Invariants
        "A"          = A,
        "Phi_P"      = Phi_P,
        "Phi_t"      = diff(Phi, t),
        "A_rhs"      = A_rhs,
        "g"          = subs(ODE_pos, g),
        # Overall system
        "Mass_tot"   = Mass_tot,
        "f_tot"      = f_tot,
        "vars_tot"   = vars_tot,
        # Jacobians
        "eta_tot"    = eta_tot,
        "Jeta_tot"   = Jeta_tot,
        "Jf_tot"     = Jf_tot,
        # Baumgarte stabilization
        "h"          = h,
        "f_stab"     = f_stab,
        "Jf_stab"    = Jf_stab
      ])
    ];
    protect(Indigo:-ReductionSteps);
  end proc: # ReduceIndex_Mbd3;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(*
  F_TO_MATLAB := proc( F_in, vars, name )
    local i, F, str, LST, vals, vv, ind;
    if type(F_in,list) then
      F := F_in;
    else
      F := convert(F_in,list);
    end;
    ind := "    ";
    LST  := []:
    vals := "":
    for i from 1 to nops(F) do
      vv := simplify(F[i]);
      if evalb(vv <> 0) then
        LST  := [op(LST), convert("res__"||i,symbol) = vv ];
        vals := cat(vals,sprintf("%s  res__%s(%d) = res__%d;\n",ind,name,i,i));
      end;
    end;
    str := CodeGeneration[Matlab](LST,optimize=true,coercetypes=false,deducetypes=false,output=string);
    printf("%sfunction res__%s = %s( self, t, vars__ )\n",ind,name,name);
    printf("\n%s  %% extract states\n",ind);
    for i from 1 to nops(vars) do
      printf("%s  %s = vars__(%d);\n",ind,convert(vars[i],string),i);
    end;
    printf("\n%s  %% evaluate function\n",ind);
    printf("%s  %s\n",ind,StringTools[SubstituteAll](  str, "\n", cat("\n  ",ind) ));
    printf("\n%s  %% store on output\n",ind);
    printf("%s  res__%s = zeros(%d,1);\n",ind,name,nops(F));
    printf("%s\n%send\n",vals,ind);
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  JF_TO_MATLAB := proc( JF, vars, name )
    local val, pat, NR, NC, i, j, str, ind, LST;
    NR  := LinearAlgebra[RowDimension](JF);
    NC  := LinearAlgebra[ColumnDimension](JF);
    LST := []:
    pat := "";
    ind := "    ";
    for i from 1 to NR do
      for j from 1 to NC do
        val := simplify(JF[i,j]);
        if evalb(val <> 0) then
          LST := [op(LST), convert("res__"||i||_||j,symbol) = val];
          pat := cat(pat,sprintf("%s  res__%s(%d,%d) = res__%d_%d;\n",ind,name,i,j,i,j));
        end;
      end;
    end;
    str := CodeGeneration[Matlab](LST,optimize=true,coercetypes=false,deducetypes=false,output=string);
    printf("%sfunction res__%s = %s( self, t, vars__ )\n",ind,name,name);
    printf("\n%s  %% extract states\n",ind);
    for i from 1 to nops(vars) do
      printf("%s  %s = vars__(%d);\n",ind,convert(vars[i],string),i);
    end;
    printf("\n%s  %% evaluate function\n",ind);
    printf("%s  %s\n",ind,StringTools[SubstituteAll]( str, "\n", cat("\n  ",ind) ));
    printf("%s  %% store on output\n",ind);
    printf("%s  res__%s = zeros(%d,%d);\n",ind,name,NR,NC);
    printf("%s",pat);
    printf("%send\n",ind);
  end proc:
*)
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

end module: # Indigo

# That's all folks!
