#! .. _Indigo-utils-package:
#!
#! Indigo utilities package
#! ==================================
#!
#!
IndigoUtils := module()

  description "Utilities for Optimal Control Problem";

  #Module defined as a package (i.e.) collection of procedures
  option package, load = ModuleLoad, unload = ModuleUnLoad;

  export dropPrefix,
         getPosition,
         checkParam,
         checkTable,
         checkTable2,
         catSymbol,
         toSymbol,
         toString,
         toStringAndSplit,
         toRubyString,
         toVector,
         joinSymbol,
         DIFF,
         doGradient,
         doJacobian,
         doHessian,
         extractSUBS,
         getFunctions,
         getSymbols,
         getSymbolsRecurr,
         getFunctionProto,
         getFunctionName,
         getFunctionBody,
         getFunctionsInList,
         isDependentOn,
         get_perm_sorted_list,
         compute_expression_cost,
         # error and warning message
         assert,
         warning,
         errorMessage,
         warningMessage,
         printTitle,
         printHeader,
         printMessage,
         cprintf;

  local  ModuleLoad, ModuleUnLoad;

  uses LinearAlgebra;

  #Function called at module instatiation or loaded from a repository.
  ModuleLoad := proc( )
    # display a message
    IndigoCopyright("IndigoUtils");
  end proc:

  #Function called when the module is destroyed
  ModuleUnLoad := proc( )
    # print a message
    # printf("Going away module 'IndigoUtils'\n");
  end proc:

  #==============================================================================
  #==============================================================================
  dropPrefix := proc( name::string, $)
    return StringTools[RegSubs]("([^#]+)#"="",name);
  end proc:

  #---------------------------------------------------------------------------#
  #{
  # Function: getPosition
  #   The *getPosition* command searches a list in order to find the position i of variable var
  #
  # Parameters:
  #  - var  = can be a symbol, function or integer
  #  - list = is a list of functions or symbols
  #
  # Return:
  #  i = position of variable var in the list.
  #}
  getPosition := proc( var::{symbol,function,integer}, lst::list, $)
    local i;
    # cerca la posizione
    if type(var,`function`) then
      i := ListTools[Search]( var, lst );
    elif type(var,`symbol`) then
      i := ListTools[Search]( var(zeta), lst ); #attenzione si suppone variabile indipendente zeta
      if i = 0 then
        i := ListTools[Search]( var, lst );
      end;
      if i = 0 then
        :IndigoUtils:-errorMessage(
          "getPosition failed for %s in %s\n",
          convert(var,string),
          convert(lst,string)
        );
      end;
    elif type(var,`integer`) then
      i;
    else
      :IndigoUtils:-errorMessage(
        "getPosition failed for %s in %s\n",
        convert(var,string),
        convert(lst,string)
      );
    end;
    return i;
  end proc:

  #---------------------------------------------------------------------------#
  #{
  # Function: checkParam
  #  The *checkParam* command checks the parameter type
  #
  # Parameters:
  #  - param      = parameter to be checked
  #  - nameParam  = parameter name
  #  - tp         = parameter type
  #
  # Return:
  #  NULL or warning
  #}
  # param  = parameter to be checked
  # tp     = parameter type
  # return = error
  checkParam := proc( param, nameParam::string, tp, where::string, $ )
    if not type(param,tp) then
      :-printf("Parameter `%s` = %a\n",nameParam,param);
      :IndigoUtils:-errorMessage(
        "\nParameter `%s` is of type `%s`, expected of type `%s` in %s\n",
        nameParam, convert(whattype(param),string), convert(tp,string), where
      );
    end;
    NULL;
  end:

  checkTable2 := proc( param::table, nameParam::string, tp, where::string, $ )
    local keywords;
    keywords := {indices(param,'nolist')};
    if not ( nameParam in keywords ) then
      :IndigoUtils:-errorMessage(
        "\nMissing keyword `%s` in %s\nkeywords: %a\n",
        convert(nameParam,string), where, keywords
      );
    end:
    if not type(param[nameParam],tp) then
      :-printf("Parameter `%s` = %a\n",nameParam,param[nameParam]);
      :IndigoUtils:-errorMessage(
        "\nParameter `%s` is of type `%s`, expected of type `%s` in %s\n",
        nameParam, convert(whattype(param[nameParam]),string),
        convert(tp,string), where
      );
    end;
    NULL;
  end:

  #---------------------------------------------------------------------------#
  #{
  # Function: checkEntry
  #  The *checkParam* command checks the parameter type
  #
  # Parameters:
  #  - param      = parameter to be checked
  #  - nameParam  = parameter name
  #  - tp         = parameter type
  #
  # Return:
  #  NULL or warning
  #}
  # param  = parameter to be checked
  # tp     = parameter type
  # return = error
  checkTable := proc( t, e::string, msg::string, tp, $ )
    if not type(t,`table`) then
      :IndigoUtils:-errorMessage(msg);
    end;
    if not member(e,[indices(t,'nolist')]) then
      :IndigoUtils:-errorMessage(msg);
    end;
    checkParam( t[e], e, tp, "checkTable" );
    NULL;
  end:

  #---------------------------------------------------------------------------#
  #{
  # Function: toString
  #   The *toString* command converts a symbol into a string
  #   Variables of type x[dot](t) are converted into x_dot(t)
  #
  # Parameters:
  #  - var  = symbol
  #
  # Return:
  #  string
  #}
  #
  toString := proc( var, $ )
    local VAR;
    if type(var,'string') then
      return var;
    else
      VAR := convert(var,string);
      VAR := StringTools[Substitute](VAR,"]","");
      VAR := StringTools[Substitute](VAR,"[","_");
      # non sostituisco " con \" ma ' con \'
      # VAR := StringTools[SubstituteAll](VAR,"""","\\""");
      VAR := StringTools[SubstituteAll](VAR,"'","\\'");
      # workaround per i numeri
      VAR := StringTools[RegSubs]("^-[.]([0-9])"="-0.\1",VAR);
      VAR := StringTools[RegSubs]("^[.]([0-9])"="0.\1",VAR);
      return VAR;
    end:
  end:
  #
  #
  #
  toStringAndSplit := proc( var, $ )
    local STR;
    if type(var,'string') then
      STR := var;
    else
      STR := toString(var);
    end:
    if StringTools[Length](STR) > 512 then
      STR := StringTools[Join]( [StringTools[LengthSplit](STR,512)], """+\n\t""" );
    end:
    # non sostituisco " con \" ma ' con \'
    ## STR := StringTools[SubstituteAll]( STR, "\"","\\\"" );
    STR := StringTools[SubstituteAll]( STR, "'","\\'" );
    return STR;
  end:

  #---------------------------------------------------------------------------#
  toRubyString := proc( var, $ )
    local STR;
    STR := toString(var);
    if StringTools[Length](STR) > 512 then
      STR := StringTools[Join]( [StringTools[LengthSplit](STR,512)], """+\n\t""" );
    end:
    return cat("""",STR,"""");
  end:

  #---------------------------------------------------------------------------#
  #{
  # Function: toSymbol
  #   The command *toSymbol* converta a symbol into a string
  #   Variables of type x[dot](t) are converted into x_dot(t)
  #
  # Parameters:
  #  - pre    = symbol or string
  #  - var    = string
  #  - post   = string
  #
  # Return:
  #   symbol
  #}
  catSymbol := proc()
    convert(cat(_passed),symbol);
  end:

  #---------------------------------------------------------------------------#
  #{
  # Function: toSymbol
  #   The command *toSymbol* converta a symbol into a string
  #   Variables of type x[dot](t) are converted into x_dot(t)
  #
  # Parameters:
  #  - pre    = symbol or string
  #  - var    = string
  #  - post   = string
  #
  # Return:
  #   symbol
  #}
  toSymbol := proc( pre, var, post, $ )
    local VAR;
    VAR := convert(op(0,var),string);
    VAR := StringTools[Substitute](VAR,"]","");
    VAR := StringTools[Substitute](VAR,"[","_");
    convert(cat(pre,VAR,post),symbol);
  end:

  #---------------------------------------------------------------------------#
  #{
  # Function: toVector
  #   The command *toVector* convert list matrix or anithing to a column vector
  #
  # Parameters:
  #  - v
  #
  # Return:
  #  Vector(v)
  #}
  toVector := proc( v, $ )
    convert(convert(v,list),Vector);
  end:

  #---------------------------------------------------------------------------#
  #{
  # Function: joinSymbol
  #   The command *joinSymbol* combines a list of string/symbols into a one unique symbol
  #
  # Parameters:
  #  - _passed[] = unspecified number of "list, vector, array???"
  #
  # Return:
  #  symbol
  #}
  joinSymbol := proc()
    local res, i;
    res := convert(_passed[1],symbol);
    for i from 2 to _npassed do
      res := cat(res,convert(_passed[i],symbol));
    end:
    res;
  end:

  #---------------------------------------------------------------------------#
  #{
  # Function: DIFF
  #   The command *DIFF* differentiates an expression with respect to a function.
  #
  # Parameters:
  #  - _passed[1] = espression
  #  - _passed[2] = function to differentiate by
  #
  # Return:
  #   expression
  #}
  DIFF := proc()
    local i, tmp, tmp2, expr;
    tmp2 := diff(subs(f=tmp,expr),tmp);
    subs(tmp=f,convert(tmp2,D));
    expr := _passed[1];
    for i from 2 to _npassed do
      tmp2 := diff(subs(_passed[i]=tmp,expr),tmp);
      expr := subs(tmp=_passed[i],convert(tmp2,D));
    end:
    expr;
  end:

  #---------------------------------------------------------------------------#
  #{
  # Function: doGradient
  #    The command *doGradient* differentiates an scalar expression with respect to a list of functions
  #
  # Parameters:
  #   - Fnc  = espression
  #   - xx   = list of functions to differentiate by
  #
  # Return:
  #  Vector of expressions: the gradient
  #}
  doGradient := proc( Fnc, xx::list, $)
    local i, nx, res :
    nx  := nops(xx);
    res := Vector(nx);
    for i from 1 to nx do
      res[i] := DIFF(Fnc,xx[i]):
    end:
    return res;
  end proc:

  #---------------------------------------------------------------------------#
  #{
  # Function: doJacobian
  #   The command *doJacobian* differentiates an vector of expressions with respect to a list of functions
  #
  # Parameters:
  #   - Fnc  = vector of expressions
  #   - xx   = list of functions to differentiate by
  #
  # Return:
  #  an Matrix of expressions: the jacobian
  #}
  doJacobian := proc( Fnc::Vector, xx::list, $)
    local i, j, nf, nx, res :
    nf  := LinearAlgebra[Dimension](Fnc);
    nx  := nops(xx);
    res := Matrix(nf,nx):
    for i from 1 to nf do
      for j from 1 to nx do
        res[i,j] := DIFF(Fnc[i],xx[j]):
      end:
    end:
    return res;
  end proc:
  #---------------------------------------------------------------------------#
  #{
  # Function: doHessian
  #   The command *doJacobian* differentiates an vector of expressions with respect to a list of functions
  #
  # Parameters:
  #   - Fnc  = vector of expressions
  #   - xx   = list of functions to differentiate by
  #
  # Return:
  #  an Matrix of expressions: the jacobian
  #}
  doHessian := proc( Fnc, xx::list, $)
    local i, j, nx, res :
    nx  := nops(xx);
    res := Matrix(nx,nx):
    for i from 1 to nx do
      for j from i to nx do
        res[i,j] := DIFF(Fnc,xx[i],xx[j]):
        res[j,i] := res[i,j];
      end:
    end:
    return res;
  end proc:

  #---------------------------------------------------------------------------#
  #{
  # Function: extractSUBS
  #   the command *extractSUBS* extracts the list of the substitution list.
  #
  # Parameters:
  #  - pars  = ...
  #
  # Return:
  #   list of variables to substitute.
  #}
  # return  =
  extractSUBS := proc( pars::list, $ )
    local  i, SS;
    checkParam( pars, "extractSUBS param", 'list', "extractSUBS" ):
    SS := [];
    for i from 1 to nops(pars) do
      if nops(pars[i]) > 1 then
        SS := [op(SS), pars[i]];
      end;
    od;
    return SS;
  end proc:

  #---------------------------------------------------------------------------#
  #{
  # Function: getFunctions
  #  The command *getFunctions* extracts the list of the functions in the expression E.
  #
  # Parameters:
  #  - E  = algebraic expression
  #
  # Return:
  #   list of functions
  #}
  getFunctions := proc ( E, onlyD::boolean := false, $ )
    local e, lst, tmp1, tmp2;
    lst := {};
    if type(E,'function') then
      tmp1 := op(0,E);
      if onlyD then
        tmp2 := op(0,tmp1);
        if type(tmp1,'function' ) and ( type(tmp2,'symbol' ) or type(tmp2,'indexed') ) then
          lst := {tmp1} union getFunctions(op(1,E),onlyD);
        end;
      else
        lst := {tmp1} union getFunctions(op(1,E),onlyD);
      end;
    else
      for e in E do
        if type(e,'constant') or type(e,'symbol') then
          ##print("symbol",e);
        elif type(e,'function') then
          ##print("symbol",e);
          lst := lst union getFunctions(e,onlyD);
        elif type(e,'algebraic') then
          ##print("algebraic",e);
          lst := lst union getFunctions(e,onlyD);
        end;
      end;
    end;
    lst;
  end proc:
  #=============================================================================#
  #=============================================================================#
  getFunctionsInList := proc ( E, fncs::list, $ )
    description
    "The command searches only the functions that are in the list given",
    "\nArgument:",
    " -E:    algebraic expression",
    " -fncs: list of functions to be searched",
    "\nReturn:",
    " -lst:  list of functions found that also appear in the given list",
    "\n";

    local e, lst, tmp1, tmp2;
    lst := {};
    if type(E,'function') then
      tmp1 := E: #op(0,E);
      ###print("function",op(0,E),op(1,E));
      if has(fncs,op(0,E)) then
        ##print("found",op(0,E),op(1,E));
        # controllo che l'argomento ci sia
        if nops(E) > 0 then
          lst := {tmp1} union getFunctionsInList(op(1,E),fncs);
        else
          lst := {tmp1};
        end;
      else
        if nops(E) > 0 then
          lst := {} union getFunctionsInList(op(1,E),fncs);
        end;
      end;
    else
      for e in E do
        if type(e,'constant') or type(e,'symbol') then
          ##print("symbol",e);
        elif type(e,'function') then
          ##print("symbol",e);
          lst := lst union getFunctionsInList(e,fncs);
        elif type(e,'algebraic') then
          ##print("algebraic",e);
          lst := lst union getFunctionsInList(e,fncs);
        end;
      end;
    end;
    lst;
  end proc:

  #---------------------------------------------------------------------------#
  #{
  # Function: getSymbols
  #   The command *getSYmbols* extracts the list of the symbols in the expression E.
  #
  # Parameters:
  #  - E  = algebraic expression.
  #
  # Return:
  #  list of symbols.
  #}
  getSymbols := proc( E, $ )
    local e, s, lst;
    lst := {};
    ##print("E=",E);
    for e in E do
      if type(e,'constant') then
        ##print("constant",e);
      elif type(e,'symbol') then
        s := eval(e);
        if type(s,'symbol') then
          ##print("symbol",e);
          lst := lst union {e};
        else
          lst := lst union getSymbols(s);
        end
      elif type(e,'algebraic') then
        ##print("algebraic",e);
        lst := lst union getSymbols(e);
      end;
    end;
    lst;
  end proc:

  #---------------------------------------------------------------------------#
  #{
  # Function: getFunctionProto
  #   The command *getFunctionProto* extracts a function ptototype f(x) from an expression of 'type f(x) = body' or 'f(x)'.
  #
  # Parameters:
  #   - expr
  #
  # Return:
  #   the function prototype
  #}
  getFunctionProto := proc ( expr, $ )
    if type(expr,`=`) then
      lhs(expr);
    else
      expr;
    end;
  end proc:

  #---------------------------------------------------------------------------#
  #{
  # Function: getFunctionName
  #   The command *getFunctionName* extracts from an expression of type f(x) = body or f(x) the function name f
  #
  # Parameters:
  #   - expr
  #
  # Return:
  #   the name of the function
  #}
  getFunctionName := proc ( expr_in, $ )
    local expr;
    if type(expr_in,`=`) then
      expr := op(1,expr_in);
    else
      expr := expr_in;
    end;
    if type(expr,function) then
      op(0,expr);
    else
      :IndigoUtils:-errorMessage(
        "in getFunctionName expected a function!\n"
      );
    end;
  end proc:

  #---------------------------------------------------------------------------#
  #{
  # Function: getFunctionBody
  #   The command *getFunctionBody* extracts from an expression of type f(x) = body or f(x) the function body
  #
  # Parameters:
  #   - expr
  #
  # Return:
  #   the body of the function
  #}
  getFunctionBody := proc ( expr, $ )
    if type(expr,`=`) then
      op(2,expr);
    else
      expr;
    end;
  end proc:

  #---------------------------------------------------------------------------#
  isDependentOn := proc ( expr::algebraic, vars::list(function), $ )
    local var;
    for var in vars do
      if ( has( expr, var ) ) then
        return true;
      end;
    end;
    return false;
  end proc:

  #===========================================================================
  #            _   ___            _         _    ___
  #   __ _ ___| |_/ __|_  _ _ __ | |__  ___| |__| _ \___ __ _  _ _ _ _ _
  #  / _` / -_)  _\__ \ || | '  \| '_ \/ _ \ (_-<   / -_) _| || | '_| '_|
  #  \__, \___|\__|___/\_, |_|_|_|_.__/\___/_/__/_|_\___\__|\_,_|_| |_|
  #  |___/             |__/
  #===========================================================================
  getSymbolsRecurr := proc ( data )
    local tmp, key, kv;

    if type(data,'indexed') then
      return {};
    end:

    if type(data,'Array') then
      return getSymbolsRecurr( convert(data,'list') );
    end:

    if type(data,'table') then
      return getSymbolsRecurr( op(2,op(1,data)) );
    end:

    if type(data,'list') then
      if nops(data) = 0 then
        return {};
      elif type(data,'list(table)') then
        tmp := {};
        for key in data do
          tmp := tmp union getSymbolsRecurr( key );
        end:
        return tmp;
      elif type(data,'list(function(symbol))') then
        return getSymbols(data);
      #elif type(data,'list({string,symbol})') then
      # dobbiamo controllare che non sia solo una lista di stringhe
      # mentre può essere una lista di parametri (simboli)
      elif type(data,'list({string})') then
        return {};
      elif type(data,'list(algebraic)') then
        return getSymbols(data);
      elif type(data,'list(anything=anything)') then
        tmp := {};
        for kv in data do
          tmp := tmp union getSymbolsRecurr( rhs(kv) );
        end:
        return tmp;
      elif type(data,'list(anything)') then
        tmp := {};
        for kv in data do
          tmp := tmp union getSymbolsRecurr( kv );
        end:
        return tmp;
      else
        return {};
      end:
    elif type(data,'anything=anything') then
      return getSymbols(rhs(data));
    elif type(data,'algebraic') then
      return getSymbols(data);
    elif type(data,'string') then
      return {};
    else
      return {};
    end:
  end proc:

  #               _                              _        _   _
  #   ___ ___ _ _| |_    _ __  ___ _ _ _ __ _  _| |_ __ _| |_(_)___ _ _
  #  (_-</ _ \ '_|  _|  | '_ \/ -_) '_| '  \ || |  _/ _` |  _| / _ \ ' \
  #  /__/\___/_|  \__|__| .__/\___|_| |_|_|_\_,_|\__\__,_|\__|_\___/_||_|
  #                 |___|_|
  #
  get_perm_sorted_list := proc(indx::list,$)
    local indx_sorted, perm, e:
    indx_sorted := sort(indx):
    perm := []:
    for e in indx do: perm :=[op(perm), ListTools[Search](e,indx_sorted)]: end:
    perm:
  end:
  #                              _                      _
  #   _____ ___ __ _ _ ___ _____(_)___ _ _    __ ___ __| |_
  #  / -_) \ / '_ \ '_/ -_|_-<_-< / _ \ ' \  / _/ _ (_-<  _|
  #  \___/_\_\ .__/_| \___/__/__/_\___/_||_| \__\___/__/\__|
  #          |_|
  #
  compute_expression_cost := proc(e::algebraic,$)
    description
    "The command compute the overall cost of an algebraic expression",
    "\nArgument:",
    " -E:    algebraic expression",
    "\nReturn:",
    " -cost:  overall number of mathematical operations (additions+multiplications+div+functions)",
    "\n";
    local cc;
    cc := codegen:-cost(e);
    cc := coeffs(cc,[additions,multiplications,functions,divisions]);
    add(cc);
  end:

  #   __  __
  #  |  \/  | ___  ___ ___  __ _  __ _  ___  ___
  #  | |\/| |/ _ \/ __/ __|/ _` |/ _` |/ _ \/ __|
  #  | |  | |  __/\__ \__ \ (_| | (_| |  __/\__ \
  #  |_|  |_|\___||___/___/\__,_|\__, |\___||___/
  #                              |___/
  cprintf := proc(fg,bg,fmt)
    print( Typesetting[mtext](
      sprintf(fmt,_passed[4..-1]),
      mathcolor=fg, mathbackground=bg, fontweight="bold"
    ));
  end;

  errorMessage := proc()
    local msg;
    cprintf("OrangeRed","white",_passed);
    msg := "fatal error:\n" + sprintf(_passed);
    error msg;
  end proc:

  warningMessage := proc()
    :IndigoUtils:-cprintf("magenta","white",_passed);
  end proc:

  printTitle := proc()
    local str, len;
    str := sprintf(_passed);
    len := StringTools[Length](str);
    printf(
      "\n%s\n%s\n\n",
      str, StringTools[SubString]("====================================================================================",1..len)
    );
  end proc:

  printHeader := proc()
    local str, len;;
    str := sprintf(_passed);
    len := StringTools[Length](str);
    printf(
      "\n%s\n%s\n",
      str, StringTools[SubString]("-------------------------------------------------------------------------------------",1..len)
    );
  end proc:

  printMessage := proc()
    printf(_passed);
  end proc:

  assert := proc( check )
    if not check then
      errorMessage( _passed[2..-1] );
    end
  end proc:

  warning := proc( check )
    if not check then
      warningMessage( _passed[2..-1] );
    end
  end proc:
  ##ModuleLoad();
end module:
