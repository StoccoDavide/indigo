#! .. _Indigo-io-package:
#!
#! ==========================
#! Indigo Parameters package
#! ==========================
#!
#!

IndigoSUBS := module()

  description "Module for Storing and Manipulate Substitution Rules. Used by Indigo Library\n";

  # Module defined as a package (i.e.) collection of procedures
  option package, load = ModuleLoad, unload = ModuleUnLoad;

  export reset,
         addSUBS,
         addSUBS_L,
         addSUBS_R,
         addSUBS_M,
         addALIAS,
         applySUBS,
         applySUBS_L,
         applySUBS_R,
         applySUBSALL,
         addKnownSUBS,
         addFunctionSUBS,
         addFunctionALIAS,
         getFunctionNames,
         getCalias,
         getCaliasNames,
         addFunctionNames,
         info,
         check;

  local  ModuleLoad,
         ModuleUnLoad,
         SUBS,
         SUBS_L,
         SUBS_R,
         SUBS_M,
         ALIAS,
         C_ALIAS,
         FUNCNAMES,
         applySUBSone,
         applySUBSone_L,
         applySUBSone_R,
         applySUBSoneALL;

  uses LinearAlgebra, IndigoUtils;

  # PROCEDURE () ------------------------------------------------------------#
  # Function called at module instatiation or loaded from a repository.
  ModuleLoad := proc( )
    # display a message
    IndigoCopyright("IndigoSUBS");
    NULL;
  end proc:

  # PROCEDURE () ------------------------------------------------------------#
  # Function called when the module is destroyed
  ModuleUnLoad := proc( )
    # print a message
    #:-printf("Going away module 'Substitutions'\n");
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  reset := proc( $ )
    description "Reset the list of substitutions";
    SUBS      := Array([]);
    SUBS_L    := Array([]);
    SUBS_R    := Array([]);
    SUBS_M    := Array([]);
    ALIAS     := Array([]);
    C_ALIAS   := Array([]);
    FUNCNAMES := Array([]);
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  addSUBS := proc(
    srule::{algebraic=algebraic,list(algebraic=algebraic),set(algebraic=algebraic)},
    $
  )
    description "Add a substitution rule";
    if type(srule,'list') then
      SUBS := ArrayTools[Concatenate]( 2, SUBS, Array(srule) );
    elif type(srule,'set') then
      SUBS := ArrayTools[Concatenate]( 2, SUBS, Array([op(srule)]) );
    else
      SUBS := ArrayTools[Concatenate]( 2, SUBS, Array([srule]) );
    end:
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  addSUBS := proc(
    srule::{algebraic=algebraic,list(algebraic=algebraic),set(algebraic=algebraic)},
    $
  )
    description "Add a substitution rule";
    if type(srule,'list') then
      SUBS := ArrayTools[Concatenate]( 2, SUBS, Array(srule) );
    elif type(srule,'set') then
      SUBS := ArrayTools[Concatenate]( 2, SUBS, Array([op(srule)]) );
    else
      SUBS := ArrayTools[Concatenate]( 2, SUBS, Array([srule]) );
    end:
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  addSUBS_L := proc(
    srule::{algebraic=algebraic,list(algebraic=algebraic),set(algebraic=algebraic)},
    $
  )
    description "Add a substitution rule";
    if type(srule,'list') then
      SUBS_L := ArrayTools[Concatenate]( 2, SUBS_L, Array(srule) );
    elif type(srule,'set') then
      SUBS_L := ArrayTools[Concatenate]( 2, SUBS_L, Array([op(srule)]) );
    else
      SUBS_L := ArrayTools[Concatenate]( 2, SUBS_L, Array([srule]) );
    end:
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  addSUBS_R := proc(
    srule::{algebraic=algebraic,list(algebraic=algebraic),set(algebraic=algebraic)},
    $
  )
    description "Add a substitution rule";
    if type(srule,'list') then
      SUBS_R := ArrayTools[Concatenate]( 2, SUBS_R, Array(srule) );
    elif type(srule,'set') then
      SUBS_R := ArrayTools[Concatenate]( 2, SUBS_R, Array([op(srule)]) );
    else
      SUBS_R := ArrayTools[Concatenate]( 2, SUBS_R, Array([srule]) );
    end:
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  addSUBS_M := proc(
    srule::{algebraic=algebraic,list(algebraic=algebraic),set(algebraic=algebraic)},
    $
  )
    description "Add a substitution rule";
    if type(srule,'list') then
      SUBS_M := ArrayTools[Concatenate]( 2, SUBS_M, Array(srule) );
    elif type(srule,'set') then
      SUBS_M := ArrayTools[Concatenate]( 2, SUBS_M, Array([op(srule)]) );
    else
      SUBS_M := ArrayTools[Concatenate]( 2, SUBS_M, Array([srule]) );
    end:
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  addALIAS := proc( srule::{algebraic=algebraic,list(algebraic=algebraic),set(algebraic=algebraic)}, $ )
    description "Add alias rule";
    if type(srule,'list') then
      ALIAS := ArrayTools[Concatenate]( 2, ALIAS, Array(srule) );
    elif type(srule,'set') then
      ALIAS := ArrayTools[Concatenate]( 2, ALIAS, Array([op(srule)]) );
    else
      ALIAS := ArrayTools[Concatenate]( 2, ALIAS, Array([srule]) );
    end:
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  applySUBSone := proc( expr, $ )
    description "Apply substitutions";
    local tmp, rule;
    tmp := expr;
    for rule in SUBS  do; tmp := subs(rule,tmp); end:
    for rule in ALIAS do; tmp := subs(rule,tmp); end: # ATTENZIONE ALIAS VA PER ULTIMO!
    tmp;
  end proc:

  #==========================================================================#
  #==========================================================================#
  applySUBSone_L := proc( expr, $ )
    description "Apply substitutions";
    local tmp, rule;
    tmp := expr;
    for rule in SUBS_L do; tmp := subs(rule,tmp); end:
    for rule in ALIAS  do; tmp := subs(rule,tmp); end: # ATTENZIONE ALIAS VA PER ULTIMO!
    tmp;
  end proc:

  #==========================================================================#
  #==========================================================================#
  applySUBSone_R := proc( expr, $ )
    description "Apply substitutions";
    local tmp, rule;
    tmp := expr;
    for rule in SUBS_R do; tmp := subs(rule,tmp); end:
    for rule in ALIAS  do; tmp := subs(rule,tmp); end: # ATTENZIONE ALIAS VA PER ULTIMO!
    tmp;
  end proc:

  #==========================================================================#
  #==========================================================================#
  applySUBS := proc( expr, $ )
    description "Apply substitutions";
    local tmp, res;
    if type(expr,'list') or type(expr,'Array') or type(expr,'Vector') then
      return map(applySUBSone,expr);
    else
      return applySUBSone(expr);
    end:
  end proc:

  #==========================================================================#
  #==========================================================================#
  applySUBS_L := proc( expr, $ )
    description "Apply substitutions";
    local tmp, res;
    if type(expr,'list') or type(expr,'Array') or type(expr,'Vector') then
      return map(applySUBSone_L,expr);
    else
      return applySUBSone_L(expr);
    end:
  end proc:

  #==========================================================================#
  #==========================================================================#
  applySUBS_R := proc( expr, $ )
    description "Apply substitutions";
    local tmp, res;
    if type(expr,'list') or type(expr,'Array') or type(expr,'Vector') then
      return map(applySUBSone_R,expr);
    else
      return applySUBSone_R(expr);
    end:
  end proc:

  #==========================================================================#
  #==========================================================================#
  applySUBSoneALL := proc( expr, $ )
    description "Apply substitutions";
    local tmp, rule;
    tmp := expr;
    for rule in SUBS_L do; tmp := subs(rule,tmp); end:
    for rule in SUBS_R do; tmp := subs(rule,tmp); end:
    for rule in SUBS_M do; tmp := subs(rule,tmp); end:
    for rule in SUBS   do; tmp := subs(rule,tmp); end:
    for rule in ALIAS  do # ATTENZIONE ALIAS VA PER ULTIMO!
      tmp := subs(rule,tmp);
    od:
    tmp;
  end proc;

  #==========================================================================#
  #==========================================================================#
  applySUBSALL := proc( expr, $ )
    description "Apply substitutions";
    local tmp, res;
    if type(expr,'list') or type(expr,'Array') or type(expr,'Vector') then
      return map(applySUBSoneALL,expr);
    else
      return applySUBSoneALL(expr);
    end:
  end proc:

  #==========================================================================#
  #==========================================================================#
  addFunctionALIAS := proc(
    alias::{D(symbol)=symbol,(D@@2)(symbol)=symbol,(D@@3)(symbol)=symbol},
    $
  )
    ALIAS := ArrayTools[Concatenate]( 2, ALIAS, Array([alias]) );
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  addFunctionNames := proc( f::{string,list(string),set(string)}, $ )
    if type(srule,'list') then
      FUNCNAMES := ArrayTools[Concatenate]( 2, FUNCNAMES, Array(f) );
    elif type(srule,'set') then
      FUNCNAMES := ArrayTools[Concatenate]( 2, FUNCNAMES, Array([op(f)]) );
    else
      FUNCNAMES := ArrayTools[Concatenate]( 2, FUNCNAMES, Array([f]) );
    end:
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  addFunctionSUBS := proc(
    funcName::{string,symbol},
    narguments::integer          := 1,
    funcMapName::{string,symbol} := "",
    nderiv::integer              := 2,
    params::list                 := [],
    $
  )
    local i, j, f, fs, tmp, prefix, lhsarg, rhsarg;
    #:-printf("updateUserSUBS: add derivative rules for: %a\n",funcName);

    f  := convert(funcName,symbol);
    fs := convert(funcName,string);

    if StringTools[Length](convert(funcMapName,string)) > 0 then
      prefix := convert(cat(funcMapName,"_"),string);
    else
      prefix := convert(cat(funcName,"."),string); # un underscore in meno
    end;
    FUNCNAMES := ArrayTools[Concatenate]( 2, FUNCNAMES, Array([fs]) );

    #
    # Attenzione all'ordine delle sostituzioni gli alias vanno in ordine inverso di complessità
    #
    if narguments = 0 then
      lhsarg := [];
      if nops(params) = 0 then
        rhsarg := [];
      else
        rhsarg := params;
      end:
    else
      lhsarg := [__t1];
      for i from 2 to narguments do
        lhsarg := [op(lhsarg),cat(__t,i)];
      end:
      if nops(params) = 0 then
        rhsarg := lhsarg;
      else
        rhsarg := [op(lhsarg),op(params)];
      end:
    end:
    if nops(lhsarg) = 0 then
      lhsarg := "(___dummy___)";
    else
      lhsarg := cat("(",convert(lhsarg,string)[2..-2],")");
    end:

    if cat(fs) <> prefix[1..-2] then
      tmp     := Array( [ cat(fs,lhsarg) = prefix[1..-2](op(rhsarg)) ] );
      C_ALIAS := ArrayTools[Concatenate]( 2, tmp, C_ALIAS );
    end:

    if nderiv > 0 and narguments > 0 then
      if narguments <= 1 then
        if nderiv > 1 then
          # eliminazione delle derivate
          tmp       := Array( [ (D@@2)(f)=cat(f,"_DD"), D(f)=cat(f,"_D") ] );
          ALIAS     := ArrayTools[Concatenate]( 2, tmp, ALIAS );

          # nome noto di funzione per CodeGeneration
          tmp       := Array( [ cat(fs,"_DD"), cat(fs,"_D") ] );
          FUNCNAMES := ArrayTools[Concatenate]( 2, FUNCNAMES, tmp );

          # sostituzioni da fare nel codice C/C++
          if cat(fs,"_") <> prefix then
            tmp       := Array( [ cat(fs,"_DD",lhsarg) = cat(prefix,"DD")(op(rhsarg)),
                                  cat(fs,"_D",lhsarg)  = cat(prefix,"D")(op(rhsarg)) ] );
            C_ALIAS   := ArrayTools[Concatenate]( 2, tmp, C_ALIAS );
          end:
        else
          # eliminazione delle derivate
          tmp       := Array( [ D(f)=cat(f,"_D") ] );
          ALIAS     := ArrayTools[Concatenate]( 2, tmp, ALIAS );

          # nome noto di funzione per CodeGeneration
          tmp       := Array( [ cat(fs,"_D") ] );
          FUNCNAMES := ArrayTools[Concatenate]( 2, FUNCNAMES, tmp );

          # sostituzioni da fare nel codice C/C++
          if cat(fs,"_") <> prefix then
            tmp       := Array( [ cat(fs,"_D",lhsarg)  = cat(prefix,"D")(op(rhsarg)) ] );
            C_ALIAS   := ArrayTools[Concatenate]( 2, tmp, C_ALIAS );
          end:
        end:
      else
        if nderiv > 1 then
          for i from 1 to narguments do
            for j from i to narguments do
              # eliminazione delle derivate
              tmp       := Array( [ D[i,j](f)=cat(f,"_D_",i,"_",j) ] );
              ALIAS     := ArrayTools[Concatenate]( 2, tmp, ALIAS );

              # nome noto di funzione per CodeGeneration
              tmp       := Array( [ cat(fs,"_D_",i,"_",j) ] );
              FUNCNAMES := ArrayTools[Concatenate]( 2, FUNCNAMES, tmp );

              # sostituzioni da fare nel codice C/C++
              if cat(fs,"_") <> prefix then
                tmp       := Array( [ cat(fs,"_D_",i,"_",j,lhsarg) = cat(prefix,"D_",i,"_",j)(op(rhsarg)) ] );
                C_ALIAS   := ArrayTools[Concatenate]( 2, tmp, C_ALIAS );
              end:
            od:
          od:
        end:
        for i from 1 to narguments do
          # eliminazione delle derivate
          tmp       := Array( [ D[i](f)=cat(f,"_D_",i) ] );
          ALIAS     := ArrayTools[Concatenate]( 2, tmp, ALIAS );

          # nome noto di funzione per CodeGeneration
          tmp       := Array( [ cat(fs,"_D_",i) ] );
          FUNCNAMES := ArrayTools[Concatenate]( 2, FUNCNAMES, tmp );

          # sostituzioni da fare nel codice C/C++
          if cat(fs,"_") <> prefix then
            tmp       := Array( [ cat(fs,"_D_",i,lhsarg) = cat(prefix,"D_",i)(op(rhsarg)) ] );
            C_ALIAS   := ArrayTools[Concatenate]( 2, tmp, C_ALIAS );
          end:
        od:
      end:
    end:
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  addKnownSUBS := proc(
    funcName::{string,symbol},
    narguments::integer,
    nderiv::integer,
    $
  )
    local i, j, f, fs, tmp;
    #:-printf("updateUserSUBS: add derivative rules for: %a\n",funcName);

    f  := convert(funcName,symbol);
    fs := convert(funcName,string);

    FUNCNAMES := ArrayTools[Concatenate]( 2, FUNCNAMES, Array([fs]) );

    if nderiv > 0 and narguments > 0 then
      if narguments <= 1 then
        if nderiv > 1 then
          # eliminazione delle derivate
          tmp       := Array( [ (D@@2)(f)=cat(f,"_DD"), D(f)=cat(f,"_D") ] );
          ALIAS     := ArrayTools[Concatenate]( 2, tmp, ALIAS );

          # nome noto di funzione per CodeGeneration
          tmp       := Array( [ cat(fs,"_DD"), cat(fs,"_D") ] );
          FUNCNAMES := ArrayTools[Concatenate]( 2, FUNCNAMES, tmp );

        else
          # eliminazione delle derivate
          tmp       := Array( [ D(f)=cat(f,"_D") ] );
          ALIAS     := ArrayTools[Concatenate]( 2, tmp, ALIAS );

          # nome noto di funzione per CodeGeneration
          tmp       := Array( [ cat(fs,"_D") ] );
          FUNCNAMES := ArrayTools[Concatenate]( 2, FUNCNAMES, tmp );
        end:
      else
        if nderiv > 1 then
          for i from 1 to narguments do
            for j from i to narguments do
              # eliminazione delle derivate
              tmp       := Array( [ D[i,j](f)=cat(f,"_D_",i,"_",j) ] );
              ALIAS     := ArrayTools[Concatenate]( 2, tmp, ALIAS );

              # nome noto di funzione per CodeGeneration
              tmp       := Array( [ cat(fs,"_D_",i,"_",j) ] );
              FUNCNAMES := ArrayTools[Concatenate]( 2, FUNCNAMES, tmp );
            od:
          od:
        end:
        for i from 1 to narguments do
          # eliminazione delle derivate
          tmp       := Array( [ D[i](f)=cat(f,"_D_",i) ] );
          ALIAS     := ArrayTools[Concatenate]( 2, tmp, ALIAS );

          # nome noto di funzione per CodeGeneration
          tmp       := Array( [ cat(fs,"_D_",i) ] );
          FUNCNAMES := ArrayTools[Concatenate]( 2, FUNCNAMES, tmp );
        od:
      end:
    end:
    NULL;
  end proc:

  #==========================================================================#
  #==========================================================================#
  getFunctionNames := proc($)
    convert(FUNCNAMES,list);
  end proc:

  #==========================================================================#
  #==========================================================================#
  getCalias := proc($)
    local i, tmp, tmp1, rhs_C, rpars;
    tmp := [];
    for i from 1 to numelems(C_ALIAS) do
      # converto in C eventuali parametri
      rhs_C := rhs(C_ALIAS[i]);
      rpars := "";
      for tmp1 in op(1..-1,rhs_C) do
        if type(tmp1,'string') then
          rpars := cat(rpars,",\"",tmp1,"\"");
        else
          rpars := cat(rpars,",",CodeGeneration[C](applySUBS(tmp1),
                                                   optimize=false,
                                                   deducereturn=false,
                                                   coercetypes=false,
                                                   deducetypes=false,
                                                   defaulttype=numeric,
                                                   functionprecision=double,
                                                   resultname=_,
                                                   output=string)[4..-3]);
        end;
      end;
      rpars := cat("(",rpars[2..-1],")");
      tmp := [ op(tmp), cat("#define ALIAS_",lhs(C_ALIAS[i])," ",op(0,rhs_C),rpars) ];
    end:
    return tmp;
  end proc:

  #==========================================================================#
  #==========================================================================#

  getCaliasNames := proc($)
    local i, tmp, str, pos;
    tmp := [];
    for i from 1 to numelems(C_ALIAS) do
      # converto in C eventuali parametri
      str := lhs(C_ALIAS[i]);
      pos := searchtext("(",str);
      tmp := [ op(tmp), substring(str,1..pos-1) ];
    end:
    return tmp;
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
  info := proc( $ )
    :-printf("SUBS\n");
    :-print(convert(SUBS,list));
    :-printf("SUBS_L\n");
    :-print(convert(SUBS_L,list));
    :-printf("SUBS_R\n");
    :-print(convert(SUBS_R,list));
    :-printf("ALIAS\n");
    :-print(convert(ALIAS,list));
    :-printf("C_ALIAS\n");
    :-print(convert(C_ALIAS,list));
    :-printf("FUNCNAMES\n");
    :-print(convert(FUNCNAMES,list));
    NULL;
  end proc:

  #==========================================================================#
  #    ____ _               _
  #   / ___| |__   ___  ___| | __
  #  | |   | '_ \ / _ \/ __| |/ /
  #  | |___| | | |  __/ (__|   <
  #   \____|_| |_|\___|\___|_|\_\
  #==========================================================================#
  check := proc( $ )
  local tmp, tmp2, idx, lSUBS, rSUBS;
    lSUBS := map(lhs,convert(SUBS,list));
    rSUBS := map(rhs,convert(SUBS,list));
    for tmp in ListTools[FindRepetitions](lSUBS) do
      tmp2 := {};
      for idx in [ListTools[SearchAll](tmp,lSUBS)] do
        tmp2 := {op(tmp2),SUBS[idx]}
      end;
      if nops(tmp2) > 1 then
        :IndigoUtils:-warningMessage("Conflicting Substitution");
        :-print(<op(tmp2)>);
      end;
    end;
    for tmp in ListTools[FindRepetitions](rSUBS) do
      tmp2 := {};
      for idx in [ListTools[SearchAll](tmp,lSUBS)] do
        tmp2 := {op(tmp2),SUBS[idx]}
      end;
      if nops(tmp2) > 1 then
        :IndigoUtils:-warningMessage("Conflicting Substitution");
        :-print(<op(tmp2)>);
      end;
    end;

    lSUBS := map(lhs,convert(ALIAS,list));
    rSUBS := map(rhs,convert(ALIAS,list));
    for tmp in ListTools[FindRepetitions](lSUBS) do
      tmp2 := {};
      for idx in [ListTools[SearchAll](tmp,lSUBS)] do
        tmp2 := {op(tmp2),ALIAS[idx]}
      end;
      if nops(tmp2) > 1 then
        :IndigoUtils:-warningMessage("Conflicting Aliasing");
        :-print(<op(tmp2)>);
      end;
    end;
    for tmp in ListTools[FindRepetitions](rSUBS) do
      tmp2 := {};
      for idx in [ListTools[SearchAll](tmp,rSUBS)] do
        tmp2 := {op(tmp2),ALIAS[idx]}
      end;
      if nops(tmp2) > 1 then
        :IndigoUtils:-warningMessage("Conflicting Aliasing");
        :-print(<op(tmp2)>);
      end;
    end;

    lSUBS := map(lhs,convert(C_ALIAS,list));
    rSUBS := map(rhs,convert(C_ALIAS,list));
    for tmp in ListTools[FindRepetitions](lSUBS) do
      tmp2 := {};
      for idx in [ListTools[SearchAll](tmp,lSUBS)] do
        tmp2 := {op(tmp2),C_ALIAS[idx]}
      end;
      if nops(tmp2) > 1 then
        :IndigoUtils:-warningMessage("Conflicting C-mapping");
        :-print(<op(tmp2)>);
      end;
    end;
    for tmp in ListTools[FindRepetitions](rSUBS) do
      tmp2 := {};
      for idx in [ListTools[SearchAll](tmp,rSUBS)] do
        tmp2 := {op(tmp2),C_ALIAS[idx]}
      end;
      if nops(tmp2) > 1 then
        :IndigoUtils:-warningMessage("Mapping to the same C-function");
        :-print(<op(tmp2)>);
      end;
    end;
  end proc:

  ##ModuleLoad();

end module:
