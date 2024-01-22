
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   __  __       _ _   _ ____            _
#  |  \/  |_   _| | |_(_) __ )  ___   __| |_   _
#  | |\/| | | | | | __| |  _ \ / _ \ / _` | | | |
#  | |  | | |_| | | |_| | |_) | (_) | (_| | |_| |
#  |_|  |_|\__,_|_|\__|_|____/ \___/ \__,_|\__, |
#                                          |___/
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export LoadMatrices_MultiBody::static := proc(
  _self::Indigo,
  Mass::Matrix,
  Phi::Vector,
  f::Vector,
  q_vars::list,
  v_vars::list,
  l_vars::list,
  $)

  description "Load a 'MultiBody' type system of equations with mass matrix "
    "<Mass>, constraint vector <Phi>, external force vector <f>, the position "
    "variables <q_vars>, the velocity variables <v_vars> and the Lagrange "
    "multipliers <l_vars>.";

  local tbl;

  # Check if the system is already loaded
  if not evalb(_self:-m_SystemType = 'Empty') then
    if _self:-m_VerboseMode then
      WARNING(
        "Indigo::LoadMatrices_MultiBody(...): a system of equations is already "
        "loaded, reduction steps and veiling variables will be overwritten."
      );
    end if;
    _self:-Reset(_self);
  end if;

  # Set system type
  _self:-m_SystemType := 'MultiBody';

  # Separate algebraic and differential equations
  _self:-m_ReductionSteps := [table([
    "Mass"   = Mass,
    "Phi"    = Phi,
    "f"      = f,
    "q_vars" = q_vars,
    "v_vars" = v_vars,
    "l_vars" = l_vars
  ])];
  return NULL;
end proc: # LoadMatrices_MultiBody

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export LoadEquations_MultiBody::static := proc(
  _self::Indigo,
  eqns::list,
  q_vars::list,
  v_vars::list,
  l_vars::list,
  $)

  description "Load a 'Mdb' type system of equations <eqns> with the position "
    "variables <q_vars>, the velocity variables <v_vars> and the Lagrange "
    "multipliers <l_vars>.";

  local tmp, i, perm, Dif, Phi, Mass, r, f;

  # Calculate permutation
  tmp := [seq(0, i = 1..nops(eqns))];
  for i from 1 to nops(eqns) do
    if has(eqns[i], diff(q_vars, t)) then
      tmp[i] := 2;
    elif has(eqns[i], diff(v_vars, t)) then
      tmp[i] := 1;
    elif not has(eqns[i], diff) then
      tmp[i] := 0;
    else
      error("%1-th equation is neither algebraic nor differential.", i);
    end if;
  end do;
  perm := sort(tmp, `>`, output='permutation');

  # Separate algebraic and differential equations
  Dif := eqns[perm][nops(q_vars)+1..nops(q_vars)+nops(v_vars)];
  Phi := convert(eqns[perm][nops(q_vars)+nops(v_vars)+1..-1], Vector);
  Phi := lhs~(Phi) - rhs~(Phi);

  # Separate mass matrix and external forces
  Mass, r := LinearAlgebra:-GenerateMatrix(Dif, diff(v_vars, t));
  tmp,  f := LinearAlgebra:-GenerateMatrix(convert(r, list), l_vars);

  # Load matrices
  _self:-LoadMatrices_MultiBody(_self, Mass, Phi, f, q_vars, v_vars, l_vars);
  return NULL;
end proc: # LoadEquations_MultiBody

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

export ReduceIndex_MultiBody::static := proc(
  _self::Indigo,
  {
  baumgarte::boolean := false
  }, $)::boolean;

  description "Reduce the index of the multibody DAE system of equations. "
    "Return true if  the system of equations has been reduced to index-0 "
    "DAE, false otherwise.";

  local Mass, Phi, f, q_vars, v_vars, l_vars, i, n, m, q_vars_t, v_vars_t,
    v_vars_dot, ODE_pos, ODE_vel, tmp, A, Phi_P, Phi_t, A_rhs, g, A_tot, f_tot,
    x_tot, h_tot, h_stab, f_stab;

  if not evalb(_self:-m_SystemType = 'MultiBody') then
    error(
      "system must be of type 'MultiBody' but got '%1'.",
      _self:-m_SystemType
    );
  end if;

  # Retrieve matrices
  Mass   := _self:-m_ReductionSteps[-1]["Mass"];
  Phi    := _self:-m_ReductionSteps[-1]["Phi"];
  f      := _self:-m_ReductionSteps[-1]["f"];
  q_vars := _self:-m_ReductionSteps[-1]["q_vars"];
  v_vars := _self:-m_ReductionSteps[-1]["v_vars"];
  l_vars := _self:-m_ReductionSteps[-1]["l_vars"];

  # Check dimensions of inputs
  n, m := LinearAlgebra:-Dimension(Mass);
  if (n <> m) or (n <> nops(v_vars)) then
    error("mass matrix must be square and of the same size of the length of "
      "velocity variables.");
  end if;

  if (nops(q_vars) <> nops(v_vars)) then
    error("velocity variables and position variables must have the same size.");
  end if;

  m := LinearAlgebra:-Dimension(Phi);
  if (m <> nops(l_vars)) then
    error("lambda variables and constraints must have the same size.");
  end if;

  # Differential variables
  q_vars_t := diff(q_vars, t);
  v_vars_t := diff(v_vars, t);

  # Definition of variable "derivative of velocities"
  v_vars_dot := map(map(cat, map2(op, 0, v_vars), "__d"), (t));

  # ODE position part q' = v
  ODE_pos := zip((x, y) -> x = y, q_vars_t, v_vars);

  # ODE velocity part v' = v_d
  ODE_vel := zip((x, y) -> x = y, v_vars_t, v_vars_dot);

  # Second hidden contraint/invariant A(q,v,t)
  A := subs(ODE_pos, diff(Phi, t));
  Phi_P, A_rhs := LinearAlgebra:-GenerateMatrix(convert(A, list), v_vars);

  # Third hidden invariant Phi_P*v_d - g(q,v,t)
  tmp, g := LinearAlgebra:-GenerateMatrix(diff(convert(A, list), t), v_vars_t);

  # Big ODE system
  A_tot := <<Mass, Phi_P>|<LinearAlgebra:-Transpose(Phi_P), Matrix(m, m)>>;
  f_tot := convert(<f, subs(ODE_pos, g)>, Vector);
  x_tot := [op(v_vars_dot), op(l_vars)];
  h_tot := subs(ODE_pos, ODE_vel, <Phi, A, Phi_P.<op(v_vars_dot)> - g>);

  # Baumgarte stabilization
  if baumgarte then
    h_stab := g - 2*eta*omega*A - omega^2*Phi;
    f_stab := convert(<f, h_stab>, Vector);
  else
    h_stab := NULL;
    f_stab := NULL;
  end if;

  # Return the computed blocks
  _self:-m_ReductionSteps := [op(_self:-m_ReductionSteps),
    table([
      # Variables
      "v_vars_dot" = v_vars_dot,
      # Differential part
      "ODE_pos" = ODE_pos,
      "ODE_vel" = ODE_vel,
      "ODE_f"   = [op(rhs~(ODE_pos)), op(rhs~(ODE_vel))],
      # Invariants
      "A"       = A,
      "Phi_P"   = Phi_P,
      "Phi_t"   = diff(Phi, t),
      "A_rhs"   = A_rhs,
      "g"       = subs(ODE_pos, g),
      # Overall system
      "A_tot"   = A_tot,
      "f_tot"   = f_tot,
      "x_tot"   = x_tot,
      "h_tot"   = h_tot,
      # Baumgarte stabilization
      "h_stab"  = h_stab,
      "f_stab"  = f_stab
    ])
  ];
  return true;
end proc: # ReduceIndex_MultiBody;

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
