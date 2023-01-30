#! .. _Indigo-io-package:
#!
#! ==========================
#! Indigo Parameters package
#! ==========================
#!
#!

$define XO_assign_list(A) A::coerce( (s)->IndigoPars:-_toAssignList("A",s) )

IndigoPars := module()

  description "Module for Parameters Storing and Ordering. Used by Indigo Library\n";

  # Module defined as a package (i.e.) collection of procedures
  option package, load = ModuleLoad, unload = ModuleUnLoad;

  export reset,
         add,
         adds,
         get_parameters,
         get_assigned_parameters,
         get_parameter_assignments,
         assignment_reorder,
         connected_components,
         plot_dependence,
         print;

  local  ModuleLoad,
         ModuleUnLoad,
         Parameters,
         OrderedList,
         Singleton,
         _toAssignList,
         DependenceGraph, StrongCC, CC, CC_one_element;

  uses LinearAlgebra, IndigoUtils;

  # PROCEDURE () ------------------------------------------------------------#
  # Function called at module instatiation or loaded from a repository.
  ModuleLoad := proc( )
    # display a message
    IndigoCopyright("IndigoPars");
    NULL;
  end proc:

  # PROCEDURE () ------------------------------------------------------------#
  # Function called when the module is destroyed
  ModuleUnLoad := proc( )
    # print a message
    # printf("Going away module 'Parameters'\n");
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  reset := proc ( $ )
    description "Reset the list of parameters";
    Parameters := table([]);
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
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
      print( fcns );
      :IndigoUtils:-errorMessage(
        "Assign list argument `%s` expected to be a "
        "list or a Vector of assignment to a symbol\n", arg
      );
    end:
  end proc:

  #==========================================================================#
  #==========================================================================#
  add := proc ( par::{symbol={algebraic,string}}, $ )
    description "Add one parameters to the list of parameters";
    local idx, value;
    # controllo se esiste
    idx   := lhs(par);
    value := rhs(par);
    ###if is( idx in {indices(Parameters,'nolist')} ) then
    if assigned( Parameters[idx] ) then
      # se esiste controllo se gia assegnato
      if not evalb(value = null) then
        # se value <> null controllo se assegnazione cambia contenuto 'non null'
        if not ( evalb(Parameters[idx] = null) or evalb(Parameters[idx] = value) ) then
          :IndigoUtils:-warningMessage( "Parameter `%s` already set to `%s` is now assigned to `%s`.",
                                         convert(idx,string), convert(Parameters[idx],string), convert(value,string) );
        end:
        Parameters[idx] := value;
      end:
    else
      # parametro non ancora inserito
      Parameters[idx] := value;
    end:
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  adds := proc ( XO_assign_list(pars), $ )
    description "Add parameters to the list of parameters";
    local tmp;
    for tmp in pars do
      IndigoPars:-add(tmp);
    end;
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  get_parameters := proc($)
    return {indices(Parameters,'nolist')};
  end proc:

  #==========================================================================#
  #==========================================================================#
  get_assigned_parameters := proc($)
    local tmp, tmp1;
    tmp := {};
    for tmp1 in {indices(Parameters,'nolist')} do
      if not (Parameters[tmp1] = null) then
        tmp := tmp union {tmp1};
      end:
    od:
    return tmp;
  end proc:

  #==========================================================================#
  #==========================================================================#
  get_parameter_assignments := proc($)
    return {entries(Parameters, 'pairs')};
  end proc:

  #==========================================================================#
  #                 _
  #    ___  _ __ __| | ___ _ __
  #   / _ \| '__/ _` |/ _ \ '__|
  #  | (_) | | | (_| |  __/ |
  #   \___/|_|  \__,_|\___|_|
  #
  #==========================================================================#
  #
  # model_pars  = parametri del modello da assegnare
  # object_pars = parametri che sono usati nella inizializzazione degli oggetti
  #
  #
  assignment_reorder := proc( model_pars::set(symbol), object_pars::set(symbol), $ )
    description "Order `Parameters` in order to satisfy dependence";
    local i, j, edges, vars, item, tmp, tmp1, tmp2, tmp3, tmp4, SINGLETON, CC, SUBS, model_pars_table, aux_pars_table, aux_pars;

    # elenco parametri, ordino sia i parametri del modello che i parametri ausiliari
    vars := [indices(Parameters,'nolist')];

    # nessun parametro da ordinare
    if nops(vars) = 0 then
      OrderedList := [];
      return Array([]), Array([]);
    end:

    # cerco eventuali parametri non assegnati
    tmp := {};
    for tmp1 in vars do
      if Parameters[tmp1] = null then
        tmp := tmp union {tmp1};
      end:
    od:
    # messaggio ridondante, controllato anche dopo
    #if nops(tmp) > 0 then
    #  WARNING( "Parameters `%1` are not assigned!.", tmp );
    #end:

    # costruisco grafico delle dipendenze
    edges := {}:
    for i from 1 to numelems(Parameters) do
      tmp := Parameters[vars[i]];
      for tmp1 in vars do
        if has(tmp,tmp1) then
          edges := {op(edges),[tmp1,vars[i]]};
          if tmp1=vars[i] then
            :IndigoUtils:-errorMessage(
              "Recursive parameter definition, Parameter %s initialized with %s\n",
              convert(tmp1,string), convert(tmp,string)
            );
          end:
        end:
      end:
    end:

    # plot grafico delle dipendenze
    DependenceGraph := GraphTheory[Digraph](vars,edges);

    # Se aciclico posso ordinare!
    if not GraphTheory[IsAcyclic](DependenceGraph) then
      :IndigoUtils:-errorMessage( "Circular dependence in parameters!\n" );
    end;

    # Calcolo componenti fortemente connesse, fortunatamente sono in ordine di dipendenza
    StrongCC := GraphTheory[StronglyConnectedComponents](DependenceGraph,sorted=true);
    # necessario rovesciare ordine con Maple 2019
    StringTools:-RegMatch("Maple ([0-9]+\.[0-9]+)",kernelopts(version), 'mtch1', 'MapleVersion');
    if parse(MapleVersion) >= 2019 then
      StrongCC := ListTools:-Reverse(StrongCC):
    end:

    # Estraggo ordine (map(op,SSC)) e riordino equazioni
    OrderedList := map(op,StrongCC);

    :-printf("Reordered parameters\n");
    :-print( OrderedList );

    SUBS := {entries(Parameters, 'pairs')}; # IndigoPars:-get_parameter_assignments();

    # analisi dipendenze
    SINGLETON, CC := IndigoPars:-connected_components(object_pars);

    # i parametri con le assegnazioni nell'ordine corretto sono salvati in OCP_data["auxiliary_parameters"]
    aux_pars_table := Array([]);
    aux_pars       := {};
    item           := [];
    vars           := {}; # conterra' la lista delle variabili inizializzate
    for i from 1 to nops(OrderedList) do
      # da verificare in futuro se
      # GraphTheory[Degree](DependenceGraph,OrderedList[i]) == 0
      # allora il valore può essere tolto dalla tabella e assegnato direttamente
      if not ( {OrderedList[i]} subset SINGLETON ) then
        # non è un singleton, salvo assegnazione
        tmp := subs(SUBS,OrderedList[i]);
        if tmp = OrderedList[i] then # controllo se simbolo non assegnato
          tmp  := null;
        end;
        if tmp = null then
          item := [op(item),OrderedList[i]];
        end;
        aux_pars := aux_pars union {OrderedList[i]};
        tmp1 := [
          "name"    = OrderedList[i],
          "value"   = IndigoIO:-expressionToRuby(tmp),
          "C_value" = IndigoIO:-expressionToC(tmp)[4..-3]
        ];
        vars := vars union {OrderedList[i]};
        aux_pars_table := ArrayTools[Concatenate]( 2, aux_pars_table, Array([table(tmp1)]) );
      end:
    end:

    if nops(item) > 0 then
      :IndigoUtils:-warningMessage("The following auxiliary parameters are not initialized: %s",convert(item,string));
    end:

    model_pars_table := Array([]);
    item := [];
    for i from 1 to nops(model_pars) do
      tmp1 := model_pars[i]; # symbolo da assegnare
      # controllo se parametro è stato assegnato nei parametri ausiliary
      if {tmp1} subset aux_pars then
        tmp2 := tmp1; # assegno a nome variabile ausiliaria
      else
        tmp2 := subs(SUBS,tmp1); # valore assegnato
        if tmp2 = tmp1 then # controllo se simbolo non assegnato
          tmp2 := null; # valore non assegnato, lo marco
        end;
        if tmp2 = null then
          item := [op(item),tmp1];
        else
          vars := vars union {tmp1};
        end;
      end:
      tmp1 := [
        "name"    = tmp1,
        "value"   = IndigoIO:-expressionToRuby(tmp2),
        "C_value" = IndigoIO:-expressionToC(tmp2)[4..-3]
      ];
      model_pars_table := ArrayTools[Concatenate]( 2, model_pars_table, Array([table(tmp1)]) );
    end:

    #:-print("OrderedList",OrderedList);
    #:-print("model_pars_table",model_pars);
    #for i from 1 to numelems(model_pars_table) do
    #  :-printf("%s = %s\n",model_pars_table[i]["name"],toString(model_pars_table[i]["value"]));
    #end;
    #:-print("aux_pars_table");
    #for i from 1 to numelems(aux_pars_table) do
    #  :-printf("%s = %s\n",aux_pars_table[i]["name"],toString(aux_pars_table[i]["value"]));
    #end;

    for tmp1 in object_pars do
      if not {tmp1} subset vars then
        item  := [op(item),tmp1];
      end;
    end;

    if nops(item) > 0 then
      :IndigoUtils:-warningMessage("The following parameters are not initialized: %s",convert(item,string));
    end:

    # controllo variabili assegnate ma non usate che non sono usate nella inizializazione delle classi
    for tmp1 in CC do
      if nops(tmp1 intersect model_pars) = 0 and nops(tmp1 intersect object_pars) = 0 then
        :IndigoUtils:-warningMessage("variable(s) `%s` is initialized but not used in the model!",convert(tmp1,string));
      end;
    end;

    return model_pars_table, aux_pars_table;

  end proc:

  #==========================================================================#
  #==========================================================================#
  plot_dependence := proc( $ )
    local cc, ccomp, sg;    # elenco parametri
    # Calcolo componenti connesse
    ccomp := GraphTheory[ConnectedComponents](DependenceGraph);
    for cc in ccomp do
      if nops(cc) > 1 then
        sg := GraphTheory[InducedSubgraph](DependenceGraph,cc);
        :-print( GraphTheory[DrawGraph](sg) );
      else
        :-printf("singleton: %a\n",op(cc));
      end;
    end;
    :-printf("\n");
  end proc:

  #==========================================================================#
  #==========================================================================#
  connected_components := proc( pars::set(symbol), $ )
    local vars, cc, ccomp;    # elenco parametri
    vars := [indices(Parameters,'nolist')];

    # nessun parametro da ordinare
    if nops(vars) = 0 then
      Singleton := {};
      CC        := [];
    else
      # Calcolo componenti connesse
      ccomp := GraphTheory[ConnectedComponents](DependenceGraph);
      Singleton := {};
      CC        := [];
      for cc in ccomp do
        if nops(cc) = 1 and not({op(cc)} subset pars) then
          Singleton := Singleton union {op(cc)};
        end;
        CC := [ op(CC), {op(cc)} ];
      end;
    end;
    return Singleton, CC;
  end proc:

  #==========================================================================#
  #             _       _
  #  _ __  _ __(_)_ __ | |_
  # | '_ \| '__| | '_ \| __|
  # | |_) | |  | | | | | |_
  # | .__/|_|  |_|_| |_|\__|
  # |_|
  #
  #==========================================================================#
  print := proc( $ )
    local ids, id;
    ids := [indices(Parameters,'nolist')];
    if nops(ids) > 0 then
      if Parameters[ids[1]] = null then
        :-printf("%s",ids[1]);
      else
        :-printf("%s = %a",ids[1],Parameters[ids[1]]);
      end:
      for id in ids[2..-1] do
        if Parameters[id] = null then
          printf(", %s",id);
        else
          :-printf(", %s = %a",id,Parameters[id]);
        end:
      end:
      :-printf("\n");
    else
      :-printf("No Parameters\n");
    end:
    NULL;
  end proc:

  ##ModuleLoad();

end module:
