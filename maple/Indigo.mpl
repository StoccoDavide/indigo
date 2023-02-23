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

  export reset,
         set_warning_level,
         change_strategies,
         kernel_build,
         load_matrices,
         load_equations,
         reduce_index_by_one,
         X_sys,
         E_sys,
         G_sys,
         A_sys,
         r_sys,
         history;

  local  module_load,
         module_unload,
         lib_base_path,
         veiling_strategy,
         pivoting_strategy,
         zero_strategy,
         update_history,
         separate_matrices;

  global warning_level;

  uses IndigoUtils, LULEM;

  # Package options
  option  package,
          load   = module_load,
          unload = module_unload;

  description "'Indigo' module";

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: module_unload
  #  Routines to load the module.
  #}
  module_load := proc()

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
    warning_level  := 1;

    # Reset the library
    reset();

    return NULL;
  end proc: # module_load

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: module_unload
  #  Routines to unload the module.
  #}
  module_unload := proc()
    printf("Unloading 'Indigo'\n");
    return NULL;
  end proc: # module_unload

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: set_warning_level
  #   Set the warning level.
  #
  # Parameters:
  #   lvl - warning level
  #}
  set_warning_level := proc( lvl::integer, $ )
    warning_level := lvl;
    return NULL;
  end proc: # set_warning_level

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: reset
  #   Reset the library.
  #}
  reset := proc( $ )
    # Internal variables
    unprotect('X_sys', 'E_sys', 'G_sys', 'A_sys', 'r_sys');
    X_sys := NULL;
    E_sys := NULL;
    G_sys := NULL;
    A_sys := NULL;
    r_sys := NULL;
    protect('X_sys', 'E_sys', 'G_sys', 'A_sys', 'r_sys');
    unprotect('history');
    history := table([]);
    history[parse("E")] := table([]);
    history[parse("G")] := table([]);
    history[parse("A")] := table([]);
    history[parse("r")] := table([]);
    history[parse("iter")] := 0;
    protect('history');

    # Reset the LU decomposition strategies
    change_strategies();

    # Reset the veiling variables
    ForgetVeil(Q);

    return NULL;
  end proc: # reset

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  update_history := proc( i::integer, E::Matrix, G::Vector, A::Vector, r::integer, $ )

    unprotect('history');
    history[parse("iter")] := i;
    history[parse("E")][i] := E;
    history[parse("G")][i] := G;
    history[parse("A")][i] := A;
    history[parse("r")][i] := r;
    protect('history');

    return NULL;
  end proc: # update_history

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: change_strategies
  #   Change the strategies for the LU decomposition.
  #
  # Parameters:
  #   Veiling  - veiling strategy
  #   Pivoting - pivoting strategy
  #   Zero     - zero detection strategy
  #}
  change_strategies := proc({
    veiling::procedure  := VeilingStrategy_L,
    pivoting::procedure := PivotStrategy_Slength,
    zero::procedure     := ZeroStrategy_normalizer
    }, $ )

    veiling_strategy  := veiling;
    pivoting_strategy := pivoting;
    zero_strategy     := zero;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: kernel_build
  #   Build the kernel of a matrix.
  #
  # Parameters:
  #   E - matrix
  #
  # Returns:
  #   the kernel of E, the matrix N such that E*N = 0 and the rank of E
  #}
  kernel_build := proc( E, $ )
    local n, m, r, P, L, U, k, j, tmp, M, K, N;

    # Get row and column dimensions
    n, m := LinearAlgebra[Dimension](E);

    # Decompose the matrix as E = P * L * U
    P, L, U := LUD(E, Q, veiling_strategy, pivoting_strategy, zero_strategy);
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
  # Function: load_matrices
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
  separate_matrices := proc( E::Matrix, G::Vector, $ )
    local n, m, l, K, L, r;

    # Check input dimensions
    n, m := LinearAlgebra[Dimension](E);
    l := LinearAlgebra[Dimension](G);
    assert(
      n = m,
      "Indigo::separate_matrices(...): input matrix E must be square (%d x %d).",
      n, m
    );
    assert(
      n = l, cat(
      "Indigo::separate_matrices(...): input matrix E size (%d x %d) not consistent ",
      "with vector G size (1 x %d)."),
      n, m, l
    );

    K, L, r := kernel_build(E);
    return L.E, # Et
           L.G, # Gt
           K.G, # A
           r;   # r
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: load_matrices
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
  load_matrices := proc( E::Matrix, vars::list, G::Vector, $ )
    unprotect('X_sys', 'E_sys', 'G_sys', 'A_sys', 'r_sys');
    X_sys := vars;
    E_sys, G_sys, A_sys, r_sys := separate_matrices(E, G);
    protect('X_sys', 'E_sys', 'G_sys', 'A_sys', 'r_sys');
    update_history(0, E_sys, G_sys, A_sys, r_sys);
    return NULL;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  #
  load_equations := proc( eqns::list, vars::list, $ )
    local E, G;

    # Check input dimensions
    assert(
      nops(eqns) = nops(vars), cat(
      "Indigo::load_equations(...): the number of equations (%d) must be the ",
      "same of the number of variables (%d)."),
      nops(eqns), nops(vars)
    );

    E, G := LinearAlgebra[GenerateMatrix](eqns, diff(vars, t)):
    load_matrices(E, vars, G);
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
  reduce_index_by_one := proc( $ )
    local iter, E_tmp, G_tmp, A_tmp, nE, mE, nA, dA, H, F, nH, mH, Er, Gr, Ar, rr;

    iter  := history[parse("iter")];
    E_tmp := history[parse("E")][iter];
    G_tmp := history[parse("G")][iter];
    A_tmp := history[parse("A")][iter];

    # Check dimensions
    nE, mE := LinearAlgebra[Dimension](E_tmp);
    nA := LinearAlgebra[Dimension](A_tmp);
    assert(
      nA+nE = mE, cat(
      "Indigo::reduce_index_by_one(...): number of row of E (%d x %d) plus the ",
      "number of algebraic equations (%d) must be equal to the column of E."),
      nE, mE, nA
    );

    # Separate algebraic and differential part
    dA := diff(A_tmp, t);

    # E*dvars-G = dA
    H, F := LinearAlgebra[GenerateMatrix](convert(dA, list), diff(X_sys, t));

    # Check dimensions
    nH, mH := LinearAlgebra[Dimension](H);
    assert(
      (nH+nE = mE) and (mH = mE), cat(
      "Indigo::reduce_index_by_one(...): bad dimension of linear part of constraint ",
      "derivative A' = H vars' + F, size H = %d x %d, size E = %d x %d."),
      nH, mH, nE, mE
    );

    # Split matrices to be stored
    Er, Gr, Ar, rr := separate_matrices(<E_tmp, H>, convert(<G_tmp, F>, Vector));

    if (LinearAlgebra[Dimension](Ar) = 0) then
      print_message("Index-0 DAEs system has been reached.");
      return false;
    else
      update_history(history[parse("iter")]+1, Er, Gr, Ar, rr);
      return true;
    end if;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(*
  DAE3_get_ODE_and_invariants := proc( Mass, Phi_in, f_in, qvars, vvars, lvars )
    local tbl, n, m, f, q_D, v_D, v_dot,
          ODE_POS, ODE_VEL, tmp,
          Phi, Phi_P, Phi_t, A, A_rhs, g, bigM, bigRHS, bigVAR;

    if type(f_in,'Vector') then
      f := f_in;
    else
      f := convert(f_in,Vector);
    end;


    if type(Phi_in,'Vector') then
      Phi := Phi_in;
    else
      Phi := convert(Phi_in,Vector);
    end;

    n, m:= Dimension( Mass );
    if n <> m or n <> nops(vvars) then
      print(
        "DAE3_get_ODE_and_invariants: mass marrix must be square\n"
        "and of the same size of the length of vvars", Mass, vvars
      );
    end;

    n := nops( qvars );
    m := Dimension( Phi );

    if n <> nops(vvars) then
      print(
        "DAE3_get_ODE_and_invariants: qvars and vvars\n"
        "must have the same length", qvars, vvars
      );
    end;

    if m <> nops(lvars) then
      print(
        "DAE3_get_ODE_and_invariants: lvars must have\n"
        "the same length the number of constraints", lvars, Phi
      );
    end;

    # differential variables
    q_D := map( diff, qvars, t );
    v_D := map( diff, vvars, t );

    # definition of variable "derivative of velocities"
    v_dot := map( map( cat, map2( op, 0, vvars ), __d ), (t) );

    # ode position part q' = v
    ODE_POS := zip( (x,y)-> x = y, q_D, vvars );

    # ode velocity part v' = v__d
    ODE_VEL := zip( (x,y)-> x = y, v_D, v_dot );

    # hidden contraint/invariant A(q,v,t)
    A := subs( ODE_POS, diff(Phi,t) );

    Phi_P, A_rhs := GenerateMatrix(convert(A,list),vvars);
    # hidden invariant Phi_P v__d - g(q,v,t)
    tmp, g := GenerateMatrix(diff(convert(A,list),t),v_D);

    if tb_dae_debug then
      print("DAE3_get_ODE_and_invariants: Phi_P, tmp",Phi_P, tmp);
    end;

    # big linear system
    bigM   := <<Mass,Phi_P>|<Transpose(Phi_P),Matrix(m,m)>>;
    bigRHS := convert(<f,subs(ODE_POS,g)>,Vector);
    bigVAR := [op(v_dot),op(lvars)];
    # return the computed block
    return table([
      "m"       = m,
      "n"       = n,
      "PVARS"   = qvars,
      "VVARS"   = vvars,
      "LVARS"   = lvars,
      "VDOT"    = v_dot,
      "ODE_RHS" = [op(map(rhs,ODE_POS)),op(map(rhs,ODE_VEL))],
      "ODE_POS" = ODE_POS,
      "ODE_VEL" = ODE_VEL,
      "Phi"     = Phi,
      "Phi_P"   = Phi_P,
      "A_rhs"   = A_rhs,
      "A"       = A,
      "f"       = f,
      "g"       = subs(ODE_POS,g),
      "bigVAR"  = bigVAR,
      "bigM"    = bigM,
      "bigRHS"  = bigRHS
    ]);
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  DAE3_get_ODE_and_invariants_full := proc( Mass, Phi, f, qvars, vvars, lvars )
    local tbl, n, m, bigETA;

    tbl := DAE3_get_ODE_and_invariants( Mass, Phi, f, qvars, vvars, lvars );

    n := tbl["n"];
    m := tbl["m"];

    bigETA := convert(tbl["bigM"].<seq(mu||i,i=1..n+m)>,Vector);

    tbl["bigETA"]  := bigETA;
    tbl["JbigETA"] := JACOBIAN(bigETA,[op(qvars),op(vvars)]);
    tbl["JbigRHS"] := JACOBIAN(tbl["bigRHS"],[op(qvars),op(vvars)]);

    # return the computed block
    return tbl;
  end proc:


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  DAE3_get_ODE_and_invariants_baumgarte := proc( Mass, Phi, f_in, qvars, vvars, lvars )
    local tbl;
    tbl                 := DAE3_get_ODE_and_invariants_full( Mass, Phi, f_in, qvars, vvars, lvars );
    tbl["h"]            := tbl["g"]-2*eta*omega*tbl["A"]-omega^2*tbl["Phi"];
    tbl["bigRHS_stab"]  := convert(<tbl["f"] ,tbl["h"] >,Vector);
    tbl["JbigRHS_stab"] := JACOBIAN(tbl["bigRHS_stab"],[op(qvars),op(vvars)]);
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
