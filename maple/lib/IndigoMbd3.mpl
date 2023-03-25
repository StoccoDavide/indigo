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
    Indigo:-SystemType := 'Mbd3';

    # Separate algebraic and differential equations
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

    local i, n, m, q_vars_t, v_vars_t, v_vars_dot, ODE_pos, ODE_vel, tmp, A, Phi_P,
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
  end proc: # ReduceIndex_Mbd3;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# That's all folks!
