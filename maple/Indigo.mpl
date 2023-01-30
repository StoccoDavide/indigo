# -*- mode: ruby -*-

$include "./Indigo_maple/IndigoDefines.mpl"

$define XO_variable             coerce( symbol, (s::function(symbol))->op(0,s) )
$define XO_name                 coerce( string, (s::symbol)->convert(s,string) )

$define XO_variables_list(A)    A::coerce( (s)->Indigo:-_toVariableList("A",s) )
$define XO_functions_list(A)    A::coerce( (s)->Indigo:-_toFunctionList("A",s) )
$define XO_equations_list(A)    A::coerce( (s)->Indigo:-_toEquationList("A",s) )
$define XO_parameters_list(A)   A::coerce( (s)->Indigo:-_toParameterList("A",s) )

$define XO_guess_list(A)        A::coerce( (s)->Indigo:-_toGuessList("A",s) )
$define XO_controls_list(A)     XO_guess_list(A)
$define XO_assign_list(A)       A::coerce( (s)->Indigo:-_toAssignList("A",s) )
$define XO_scaling_list         list({function(symbol),symbol}={algebraic,algebraic..algebraic})

$define XO_APPEND_ARRAY(A,V)    A := ArrayTools[Concatenate]( 2, A, V )

Indigo := module()

  description "BLA BLA\n";

  # Module defined as a package (i.e.) collection of procedures
  option package, load = ModuleLoad, unload = ModuleUnLoad;

  export init,
         reset,
         copyright,
         version,
         info,

         set_warning_level,

         # coercion
         _toEquationList,
         _toFunctionList,
         _toVariableList,
         _toParameterList,
         _toGuessList,
         _toAssignList
         ;

  local  ModuleLoad,
         ModuleUnLoad,
         Indigo_base_path,
         IndigoVersion_string;

  global warning_level;

  # eventuali pacchetti da includere
  uses StringTools, LinearAlgebra;

  #{
  # Function: ModuleUnLoad
  #   Function called when the module is destroyed
  #}
  ModuleUnLoad := proc()
    # print a message
    # printf("Going away module 'Indigo'\n");
    NULL;
  end proc:

  #{
  # Function: ModuleLoad
  #   Procedure for problem set up
  #}
  ModuleLoad := proc()
    local p;
    # memorizzo posizione della libreria
    Indigo_base_path := null;
    for p in [libname] do
      if Search("Indigo",p) <> 0 then
        #print(p);
        Indigo_base_path := p;
      end;
    end;
    if Indigo_base_path = null then
      error "cannot find Indigo toolBox installed!";
    end:
    #---------------------------------------
    IndigoVersion_string := "0.0.0"
    warning_level        := 1;
    reset();
    #---------------------------------------
    copyright("Indigo");
    #with(IndigoUtils):
    #with(IndigoIO):
    #with(IndigoPlots):
    #with(LinearAlgebra):
    NULL;
  end proc:

  version := proc()
    description "Returns out a version description of the Indigo installed package";
    return IndigoVersion_string;
  end proc:

  copyright := proc( name::string )
    :-printf("Module '%12s %s', Copyright (C) XXX -- University of Trento 2023\n",name,IndigoVersion_string);
  end:

  info := proc()
    description "Print out a short summary of the main library commands and the calling sequence.";
    printf("This is Indigo %s\n",version());
    printf("\nDefinition of an RK library:\n");
  end proc:

  set_warning_level := proc( wl::integer, $)
    warning_level := wl;
  end proc:

  reset := proc($)
    NULL;
  end proc:

  _toEquationList := proc( arg::string, eqns, $ )
    local elem, out;
    if not ( type(eqns,'Vector({algebraic,algebraic=algebraic})') or
             type(eqns,'list({algebraic,algebraic=algebraic})') or eqns = [] ) then
      :IndigoUtils:-errorMessage(
        "List of equation argument `%s` expected to be a "
        "list or a Vector of agebraic expression or equalities", arg
      );
    end:
    out := [];
    for elem in convert(eqns,list) do
      if type(elem,`=`) then
        out := [op(out), lhs(elem)-rhs(elem)];
      else
        out := [op(out), elem];
      end:
    end:
    out;
  end proc:

  _toFunctionList := proc( arg::string, fcns, $ )
    if type(fcns,'Vector(function)') then
      return convert(fcns,list);
    elif type(fcns,'list(function)') or fcns = [] then
      return fcns;
    else
      :IndigoUtils:-errorMessage(
        "List of function argument `%s` expected to be "
        "a list or a Vector of function\n", arg
      );
    end:
  end proc:

  _toVariableList := proc( arg::string, fcns, $ )
    if type(fcns,'Vector(function(symbol))') then
      return convert(fcns,list);
    elif type(fcns,'list(function(symbol))') or fcns = [] then
      return fcns;
    else
      :IndigoUtils:-errorMessage(
        "List of variable argument `%s` expected to be a "
        "list or a Vector of `function(symbol)`\n", arg
      );
    end:
  end proc:

  _toParameterList := proc( arg::string, fcns, $ )
    if type(fcns,'Vector(symbol)') then
      return convert(fcns,list);
    elif type(fcns,'list(symbol)') or fncs = [] then
      return fcns;
    else
      :IndigoUtils:-errorMessage(
        "Lost of parameter argument `%s` expected to be "
        "a list or a Vector of `symbol`\n", arg
      );
    end:
  end proc:

  _toGuessList := proc( arg::string, fcns, $ )
    local tmp, elem;
    if type(fcns,'list({symbol,function(symbol)}=algebraic)') or
       type(fcns,'Vector({symbol,function(symbol)}=algebraic)') then
      tmp := [];
      for elem in convert(fcns,list) do
        if type(lhs(elem),'function') then
          tmp := [op(tmp), op(0,lhs(elem)) = rhs(elem) ];
        else
          tmp := [op(tmp), elem ];
        end:
      end:
      return tmp;
    elif type(fcns,'symbol=algebraic') then
      return [fcns];
    elif type(fcns,'function(symbol)=algebraic') then
      return [op(0,lhs(fcns)) = rhs(fcns) ];
    elif fcns = [] then
      return [];
    else
      :IndigoUtils:-errorMessage(
        "Guess list argument `%s` expected to be a list "
        "or a Vector of assignment to a symbol or a function\n", arg
      );
    end:
  end proc:

  _toAssignList := proc( arg::string, fcns, $ )
    if type(fcns,'symbol={algebraic,string}') then
      return [fcns];
    elif type(fcns,'list(symbol={algebraic,string})') or fncs = [] then
      return fcns;
    elif type(fcns,'set(symbol={algebraic,string})') then
      return convert(fcns,list);
    elif type(fcns,'Vector(symbol={algebraic,string})') then
      return convert(fcns,list);
    else
      :IndigoUtils:-errorMessage(
        "Assign list argument `%s` expected to be a list "
        "or a Vector of assignment to a symbol\n", arg
      );
    end:
  end proc:

$include "./Indigo_maple/Indigo_Common.mpl"

# controllo analisi sistema dinamico
$include "./Indigo_maple/Indigo_DS_DynamicSystem.mpl"

# controllo ottimo
$include "./Indigo_maple/Indigo_OCP_generate.mpl"
$include "./Indigo_maple/Indigo_OCP_scaling.mpl"
$include "./Indigo_maple/Indigo_OCP_DynamicSystem.mpl"
$include "./Indigo_maple/Indigo_OCP_Jacobians.mpl"

$include "./Indigo_maple/Indigo_OCP_BoundaryConditions.mpl"
$include "./Indigo_maple/Indigo_OCP_Target.mpl"
$include "./Indigo_maple/Indigo_OCP_Guess.mpl"
$include "./Indigo_maple/Indigo_OCP_InterfaceConditions.mpl"
$include "./Indigo_maple/Indigo_OCP_PostProcessing.mpl"
$include "./Indigo_maple/Indigo_OCP_Controls.mpl"
$include "./Indigo_maple/Indigo_OCP_Constraints.mpl"

# indipendenti da OCP e _DynamicSystem
$include "./Indigo_maple/Indigo_UserFunction.mpl"
$include "./Indigo_maple/Indigo_UserObjects.mpl"
$include "./Indigo_maple/Indigo_UserObjects_Mesh.mpl"
$include "./Indigo_maple/Indigo_UserObjects_Astro.mpl"
$include "./Indigo_maple/Indigo_UserObjects_Clothoids.mpl"
$include "./Indigo_maple/Indigo_UserObjects_Splines.mpl"
$include "./Indigo_maple/Indigo_UserObjects_Engine.mpl"
$include "./Indigo_maple/Indigo_UserObjects_Road.mpl"
$include "./Indigo_maple/Indigo_UserObjects_PenaltyBarrierU.mpl"
$include "./Indigo_maple/Indigo_UserObjects_PenaltyBarrier1D.mpl"
$include "./Indigo_maple/Indigo_UserObjects_PenaltyBarrier2D.mpl"
$include "./Indigo_maple/Indigo_UserObjects_ToolPath1D.mpl"
$include "./Indigo_maple/Indigo_UserObjects_ToolPath2D.mpl"
$include "./Indigo_maple/Indigo_UserObjects_Tyre.mpl"
$include "./Indigo_maple/Indigo_UserObjects_Path2D.mpl"

##ModuleLoad();

end module:
