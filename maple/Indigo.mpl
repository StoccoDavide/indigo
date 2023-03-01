# # # # # # # # # # # # # # # # # #
#  ___           _ _              #
# |_ _|_ __   __| (_) __ _  ___   #
#  | || '_ \ / _` | |/ _` |/ _ \  #
#  | || | | | (_| | | (_| | (_) | #
# |___|_| |_|\__,_|_|\__, |\___/  #
#                    |___/        #
# # # # # # # # # # # # # # # # # #

# Authors: Davide Stocco and Enrico Bertolazzi
# Date:    22/02/2023

Indigo := module()

  export Reset,
         SetWarningLevel,
         ChangeStrategies,
         KernelBuild,
         LoadMatrices,
         LoadEquations,
         ReduceIndexByOne,
         ReduceIndexMbdDae3,
         # TODO: ReduceIndexMbdDae2
         # TODO: ReduceIndexMbdDae1
         ReduceIndex,
         ReductionSteps;

  local  ModuleLoad,
         ModuleUnload,
         lib_base_path,
         VeilingStrategy,
         PivotingStrategy,
         ZeroStrategy,
         DAEtype, # "Linear", "MBD3", "MBD2", "MBD1", "Generic"
         UpdateReductionSteps,
         SeparateMatrices;

  global WarningLevel;

  uses IndigoUtils, LULEM;

  option  package,
          load   = ModuleLoad,
          unload = ModuleUnload;

  description "'Indigo' module";

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: ModuleUnload
  #  Routines to load the module.
  #}
  ModuleLoad := proc()

    local i;

    # Display module init message
    printf(cat(
      "'Indigo' module version 0.0, ",
      "BSD 3-Clause License - Copyright (C) 2023, D. Stocco and E. Bertolazzi.\n"
      ));

    # Library path
    lib_base_path := null;
    for i in [libname] do
      if (StringTools[Search]("Indigo", i) <> 0) then
        lib_base_path := i;
      end if;
    end do;
    if (lib_base_path = null) then
      error("Cannot find 'Indigo' module");
    end if;

    with(IndigoUtils);
    with(LULEM);

    # Library internal variables
    WarningLevel  := 1;

    # Reset the library
    Reset();

    return NULL;
  end proc: # ModuleLoad

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: ModuleUnload
  #  Routines to unload the module.
  #}
  ModuleUnload := proc()
    printf("Unloading 'Indigo'\n");
    return NULL;
  end proc: # ModuleUnload

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: SetWarningLevel
  #   Set the warning level.
  #
  # Parameters:
  #   lvl - warning level
  #}
  SetWarningLevel := proc( lvl::integer, $ )
    WarningLevel := lvl;
    return NULL;
  end proc: # SetWarningLevel

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: Reset
  #   Reset the library.
  #}
  Reset := proc( $ )
    # Internal variables
    unprotect('ReductionSteps');
    ReductionSteps := [];
    protect('ReductionSteps');

    # Reset the LU decomposition strategies
    ChangeStrategies();

    # Reset the veiling variables
    ForgetVeil(Q);

    return NULL;
  end proc: # Reset

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  UpdateReductionSteps := proc( X::list, E::Matrix, G::Vector, A::Vector, r::integer, $ )
    local tbl;
    unprotect('ReductionSteps');
    tbl := table([
      "X" = X,
      "E" = E,
      "G" = G,
      "A" = A,
      "r" = r
      ]);
    ReductionSteps := [op(ReductionSteps), tbl];

    protect('ReductionSteps');

    return NULL;
  end proc: # UpdateReductionSteps

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: ChangeStrategies
  #   Change the strategies for the LU decomposition.
  #
  # Parameters:
  #   Veiling  - veiling strategy
  #   Pivoting - pivoting strategy
  #   Zero     - zero detection strategy
  #}
  ChangeStrategies := proc({
    veiling::procedure  := VeilingStrategy_n,
    pivoting::procedure := PivotingStrategy_Sindets,
    zero::procedure     := ZeroStrategy_length
    }, $ )

    VeilingStrategy  := veiling;
    PivotingStrategy := pivoting;
    ZeroStrategy     := zero;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: KernelBuild
  #   Build the kernel of a matrix.
  #
  # Parameters:
  #   E - matrix
  #
  # Returns:
  #   the kernel of E, the matrix N such that E*N = 0 and the rank of E
  #}
  KernelBuild := proc( E, $ )
    local n, m, r, L, U, rr, cc, rnk, P, Q, k, j, tmp, M, K, N;

    # Get row and column dimensions
    n, m := LinearAlgebra[Dimension](E);

    # Decompose the matrix as E = P * L * U
    L, U, rr, cc, rnk := LULEM[LU](E, 'K', VeilingStrategy, PivotingStrategy, ZeroStrategy);
    P, Q := LULEM[PermutationMatrices](rr, cc);
    #print(P, L, U);
    #P, L, U := LinearAlgebra[LUDecomposition](E);
    #print(P, L, U);

    # The rank can be deduced from LU decomposition, by counting the row of U
    # that are non-zeros
    r := 0;
    for k from 1 to n do
      tmp := true;
      for j from 1 to m do
        if (U[k,j] <> 0) then
          tmp := false;
          break;
        end if;
      end;
      if tmp then
        break;
      end if;
      # Rank is at least k
      r := k;
    end do;

    # Compute M = L^(-1).P^T
    M := LinearAlgebra[LinearSolve](L, LinearAlgebra[Transpose](P));

    # Return matrices
    if (r > 0) then
      N := M[1..r, 1..-1];
    else
      N := Matrix(0, m);
    end if;
    if (r < n) then
      K := M[r+1..-1, 1..-1];
    else
      K := Matrix(0, m);
    end if;

    # Return the results
    if (_nresults = 3) then
      return K, N, r;
    elif (_nresults = 2) then
      return K, N;
    else
      return K;
    end if;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: LoadMatrices
  #   Separate algebraic and differential equations.
  #
  # Parameters:
  #   E - matrix of equations
  #   G - matrix of differential variables
  #
  # Returns (optional):
  #   Et - matrix of algebraic equations
  #   Gt - matrix of algebraic variables
  #   A  - matrix of differential equations
  #   r  - rank of E
  #}
  SeparateMatrices := proc( E::Matrix, G::Vector, $ )
    local n, m, l, K, L, r;

    # Check input dimensions
    n, m := LinearAlgebra[Dimension](E);
    l := LinearAlgebra[Dimension](G);
    assert(
      n = m,
      "Indigo::SeparateMatrices(...): input matrix E must be square (%d x %d).",
      n, m
    );
    assert(
      n = l, cat(
      "Indigo::SeparateMatrices(...): input matrix E size (%d x %d) not consistent ",
      "with vector G size (1 x %d)."),
      n, m, l
    );

    K, L, r := KernelBuild(E);
    return L.E, # Et
           L.G, # Gt
           K.G, # A
           r;   # r
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: LoadMatrices
  #   Separate algebraic and differential equations.
  #
  # Parameters:
  #   E - matrix of equations
  #   G - matrix of differential variables
  #
  # Returns (optional):
  #   Et - matrix of algebraic equations
  #   Gt - matrix of algebraic variables
  #   A  - matrix of differential equations
  #   r  - rank of E
  #}
  LoadMatrices := proc( E::Matrix, vars::list, G::Vector, $ )
    local E_tmp, G_tmp, A_tmp, r_tmp;
    E_tmp, G_tmp, A_tmp, r_tmp := SeparateMatrices(E, G);
    UpdateReductionSteps(vars, E_tmp, G_tmp, A_tmp, r_tmp);
    return NULL;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  #
  LoadEquations := proc( eqns::list, vars::list, $ )
    local E, G;

    # Check input dimensions
    assert(
      nops(eqns) = nops(vars), cat(
      "Indigo::LoadEquations(...): the number of equations (%d) must be the ",
      "same of the number of variables (%d)."),
      nops(eqns), nops(vars)
    );

    E, G := LinearAlgebra[GenerateMatrix](eqns, diff(vars, t)):
    LoadMatrices(E, vars, G);
    return NULL;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Assume that DAE has algebraic part already separated:
  #
  # E(x,t) x' = G(x,t)
  #         0 = A(x,t)
  #
  # after index reduction return
  #
  # Er(x,t) x' = Gr(x,t)
  #          0 = Ar(x,t)
  #
  # with the new algebraic part separated
  ReduceIndexByOne := proc( $ )
    local X_tmp, E_tmp, G_tmp, A_tmp, nE, mE, nA, dA, H, F, nH, mH, Er, Gr, Ar, rr;

    X_tmp := ReductionSteps[-1]["X"];
    E_tmp := ReductionSteps[-1]["E"];
    G_tmp := ReductionSteps[-1]["G"];
    A_tmp := ReductionSteps[-1]["A"];

    # Check dimensions
    nE, mE := LinearAlgebra[Dimension](E_tmp);
    nA := LinearAlgebra[Dimension](A_tmp);
    assert(
      nA + nE = mE, cat(
      "Indigo::ReduceIndexByOne(...): number of row of E (%d x %d) plus the ",
      "number of algebraic equations (%d) must be equal to the column of E."),
      nE, mE, nA
    );

    # Separate algebraic and differential part
    dA := diff(A_tmp, t);

    # E * diff_vars - G = dA
    H, F := LinearAlgebra[GenerateMatrix](convert(dA, list), diff(X_tmp, t));

    # Check dimensions
    nH, mH := LinearAlgebra[Dimension](H);
    assert(
      (nH + nE = mE) and (mH = mE), cat(
      "Indigo::ReduceIndexByOne(...): bad dimension of linear part of constraint ",
      "derivative A' = H vars' + F, size H = %d x %d, size E = %d x %d."),
      nH, mH, nE, mE
    );

    # Split matrices to be stored
    Er, Gr, Ar, rr := SeparateMatrices(<E_tmp, H>, convert(<G_tmp, F>, Vector));

    if (LinearAlgebra[Dimension](Ar) = 0) then
      print_message("DAE0 system has been reached.");
      return false;
    else
      UpdateReductionSteps(ReductionSteps[-1]["X"], Er, Gr, Ar, rr);
      return true;
    end if;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ReduceIndexMbdDae3 := proc( Mass::Matrix, Phi_in, f_in, qvars, vvars, lvars )
    local tbl, n, m, f, dq, dv, v_dot,
          ODE_POS, ODE_VEL, tmp,
          Phi, Phi_P, Phi_t, A, A_rhs, g, bigM, bigRHS, bigVAR;

    # Recast type of inputs
    if type(f_in, Vector) then
      f := f_in;
    else
      f := convert(f_in, Vector);
    end;

    if type(Phi_in, Vector) then
      Phi := Phi_in;
    else
      Phi := convert(Phi_in, Vector);
    end;

    # Check dimensions of inputs
    n, m := LinearAlgebra[Dimension](Mass);
    assert(
      (n = m) and (n = nops(vvars)), cat(
      "indigo::ReduceIndexMbdDae3(...): mass matrix must be square and of the ",
      "same size of the length of velocity variables."), Mass, vvars
    );

    n := nops(qvars);
    assert(
      (n = nops(vvars)), cat(
      "indigo::ReduceIndexMbdDae3(...): velocity variables and position ",
      "variables must have the same size.")
    );

    m := LinearAlgebra[Dimension](Phi);
    assert(
      (m = nops(lvars)), cat(
      "indigo::ReduceIndexMbdDae3(...): lambda variables must have the same ",
      "length the number of constraints.")
    );

    # Differential variables
    dq := diff(qvars, t);
    dv := diff(vvars, t);

    # Definition of variable "derivative of velocities"
    v_dot := map(map( cat, map2( op, 0, vvars ), __d ), (t));

    # ODDE position part q' = v
    ODE_POS := zip((x, y)-> x = y, dq, vvars);

    # ODE velocity part v' = v__d
    ODE_VEL := zip((x, y)-> x = y, dv, v_dot);

    # Hidden contraint/invariant A(q,v,t)
    A := subs(ODE_POS, diff(Phi, t));

    Phi_P, A_rhs := LinearAlgebra[GenerateMatrix](convert(A, list), vvars);
    # Hidden invariant Phi_P v__d - g(q,v,t)
    tmp, g := LinearAlgebra[GenerateMatrix](diff(convert(A, list), t), dv);

    # Big linear system
    bigM   := <<Mass, Phi_P>|<Transpose(Phi_P), Matrix(m, m)>>;
    bigRHS := convert(<f, subs(ODE_POS, g)>, Vector);
    bigVAR := [op(v_dot), op(lvars)];

    # Return the computed blocks
    return table([
      "m"       = m,
      "n"       = n,
      "PVARS"   = qvars,
      "VVARS"   = vvars,
      "LVARS"   = lvars,
      "VDOT"    = v_dot,
      "ODE_POS" = ODE_POS,
      "ODE_VEL" = ODE_VEL,
      "ODE_RHS" = [op(map(rhs, ODE_POS)), op(map(rhs, ODE_VEL))],
      "Phi"     = Phi,
      "Phi_P"   = Phi_P,
      "A_rhs"   = A_rhs,
      "A"       = A,
      "f"       = f,
      "g"       = subs(ODE_POS, g),
      "bigVAR"  = bigVAR,
      "bigM"    = bigM,
      "bigRHS"  = bigRHS
    ]);
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(*
  reduce_index_MBD_DAE3_full := proc( Mass, Phi, f, qvars, vvars, lvars )
    local tbl, n, m, bigETA;

    tbl := ReduceIndexMbdDae3( Mass, Phi, f, qvars, vvars, lvars );

    n := tbl["n"];
    m := tbl["m"];

    bigETA := convert(tbl["bigM"].<seq(mu||i,i=1..n+m)>,Vector);

    tbl["bigETA"]  := bigETA;
    tbl["JbigETA"] := JACOBIAN(bigETA, [op(qvars), op(vvars)] );
    tbl["JbigRHS"] := JACOBIAN(tbl["bigRHS"],[op(qvars),op(vvars)]);

    # Return the computed blocks
    return tbl;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  reduce_index_MBD_DAE3_baumgarte := proc( Mass, Phi, f_in, qvars, vvars, lvars )
    local tbl;

    tbl                 := reduce_index_MBD_DAE3_full( Mass, Phi, f_in, qvars, vvars, lvars );
    tbl["h"]            := tbl["g"]-2*eta*omega*tbl["A"]-omega^2*tbl["Phi"];
    tbl["bigRHS_stab"]  := convert(<tbl["f"] ,tbl["h"] >,Vector);
    tbl["JbigRHS_stab"] := JACOBIAN(tbl["bigRHS_stab"],[op(qvars),op(vvars)]);

    # Return the computed blocks
    return tbl;
  end:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
