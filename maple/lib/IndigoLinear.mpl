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
  #   _     _
  #  | |   (_)_ __   ___  __ _ _ __
  #  | |   | | '_ \ / _ \/ _` | '__|
  #  | |___| | | | |  __/ (_| | |
  #  |_____|_|_| |_|\___|\__,_|_|
  #
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LoadMatrices_Linear := proc( E::Matrix, G::Matrix, f::Vector, vars::Vector, $ )

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

    # store vars
    Indigo:-DAEvars := vars;

    # Set system type
    Indigo:-SystemType := 'Linear';

    # Update reduction steps
    Indigo:-ReductionSteps := [table([
      "E" = E,
      "G" = G,
      "f" = f
      # "rank" = tbl["rank"] do we need this?
    ])];
    return NULL;
  end proc: # LoadMatrices_Linear

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LoadEquations_Linear := proc( eqns::list, vars::list, $ )

    description "Load a 'Linear' type system of equations <eqns>. The list of "
      "variables <vars> must be the same of the variables used in the system "
      "of equations.";

    local eqns_tmp, E, G, f;

    # Check input dimensions
    if nops(eqns) <> nops(vars) then
      error "Indigo::LoadEquations_Linear(...): the number of equations (%d) must be "
            "the same of the number of variables (%d).",
            nops(eqns), nops(vars)
    end if;

    E, eqns_tmp := LinearAlgebra:-GenerateMatrix(eqns, diff(vars, t)):
    G, f := LinearAlgebra:-GenerateMatrix(eqns_tmp, vars):
    Indigo:-LoadEquations_Linear(E, G, f, vars);
    return NULL;
  end proc: # LoadEquations_Linear

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ReduceIndexByOne_Linear := proc( $ )::boolean;

    description "Reduce the index of the 'Linear' type DAE system of equations "
      "by one. Return true if the system of equations has been reduced to "
      "index-0 DAE (ODE), false otherwise.";

    local vars, E, G, A, nE, mE, nA, dA, H, F, f, nH, mH, tbl;

    if not evalb(Indigo:-SystemType = 'Linear') then
      error "Indigo::ReduceIndexByOne_Linear(...): system must be of type 'Linear' "
            "but got '%s'.",
            Indigo:-SystemType
    end if;

    vars := Indigo:-DAEvars;
    E    := Indigo:-ReductionSteps[-1]["E"];
    G    := Indigo:-ReductionSteps[-1]["G"];
    f    := Indigo:-ReductionSteps[-1]["f"];

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
    Indigo:-ReductionSteps := [op(ReductionSteps),
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
      if Indigo:-VerboseMode then
        IndigoUtils:-PrintMessage(
          "Indigo::ReduceIndexByOne_Linear(...): index-0 DAE (ODE) system has been "
          "reached."
        );
      end if;
      return false;
    else
      return true;
    end if;
  end proc: # LoadEquationsByOne_Linear

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ReduceIndex_Linear := proc( $ )::boolean;

    description "Reduce the index of the 'Linear' type DAE system of equations. "
                "Return true if the system of equations has been reduced to index-0 DAE (ODE), "
                "false otherwise.";

    local out;

    # Reduce index by one till index-0 DAE (ODE) condition is reached
    out := true;
    while (out) do
      out := Indigo:-ReduceIndexByOne_Linear();
    end do;
    return out;
  end proc: # ReduceIndex_Linear

# That's all folks!
