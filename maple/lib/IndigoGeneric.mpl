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
    Gin::{Vector},
    $)

    description "Separate algebraic and differential equations from DAE system "
                "equations matrix <E> and differential variables vector <G>. Return the "
                "algebraic equations matrix <Et>, the algebraic variables matrix <Gt>, "
                "the differential equations matrix <A>, and the rank of <E>.";

    local n, m, l, tbl, SS, z, apply_veil, G, do_veil;

    # Check if to veil or not
    do_veil    := LEM:-Veil[parse(Indigo:-VeilingSymbol)];
    apply_veil := (z) -> `if`(LULEM:-VeilingStrategy(z), do_veil(z), z);

    #
    # V E I L I N G
    #
    G := apply_veil~( Gin );

    #
    # V[num] --> V[num]( params )
    #
    SS := Indigo:-GetVeilArgsSubs();
    G  := subs(SS,G);

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

    # store vars
    Indigo:-DAEvars := vars;

    # Set system type
    Indigo:-SystemType := 'Generic';

    # Separate algebraic and differential equations
    tbl := Indigo:-SeparateMatrices(E, G);

    # Update reduction steps
    Indigo:-ReductionSteps := [table([
      "E"    = tbl["Et"],
      "G"    = tbl["Gt"],
      "A"    = tbl["A"],
      "rank" = tbl["rank"]
    ])];
    return NULL;
  end proc: # LoadMatrices_Generic

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LoadEquations_Generic := proc(
    eqns::{list},
    vars::{list},
    $)::{nothing};

    description "Load a 'Generic' type system of equations <eqns>. The list of "
                "variables <vars> must be the same of the variables used in the "
                "system of equations.";

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
                "by one. Return true if the system of equations has been reduced "
                "to index-0 DAE (ODE), false otherwise.";

    local vars, E, G, A, nE, mE, nA, dA, H, F, nH, mH, tbl;

    assert(
      evalb(Indigo:-SystemType = 'Generic'),
      "Indigo::ReduceIndexByOne_Generic(...): system must be of type 'Generic' "
      "but got '%s'.",
      Indigo:-SystemType
    );

    vars := Indigo:-DAEvars;
    E    := Indigo:-ReductionSteps[-1]["E"];
    G    := Indigo:-ReductionSteps[-1]["G"];
    A    := Indigo:-ReductionSteps[-1]["A"];

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
    Indigo:-ReductionSteps := [op(ReductionSteps),
      table([
        "E"    = tbl["Et"],
        "G"    = tbl["Gt"],
        "A"    = tbl["A"],
        "rank" = tbl["rank"]
      ])
    ];

    # Check if we have reached index-0 DAE
    if (LinearAlgebra:-Dimension(tbl["A"]) = 0) then
      if Indigo:-VerboseMode then
        IndigoUtils:-PrintMessage(
          "Indigo::ReduceIndexByOne_Generic(...): index-0 DAE (ODE) system has been "
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
      "Return true if the system of equations has been reduced to index-0 DAE (ODE), "
      "false otherwise.";

    local out;

    # Reduce index by one till index-0 DAE (ODE) condition is reached
    out := true;
    while (out) do
      out := Indigo:-ReduceIndexByOne_Generic();
    end do;
    return out;
  end proc: # ReduceIndex_Generic

# That's all folks!
