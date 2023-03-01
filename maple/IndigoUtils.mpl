# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#               ___           _ _             _   _ _   _ _                   #
#              |_ _|_ __   __| (_) __ _  ___ | | | | |_(_) |___               #
#               | || '_ \ / _` | |/ _` |/ _ \| | | | __| | / __|              #
#               | || | | | (_| | | (_| | (_) | |_| | |_| | \__ \              #
#              |___|_| |_|\__,_|_|\__, |\___/ \___/ \__|_|_|___/              #
#                                 |___/                                       #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Authors: Davide Stocco (University of Trento)
#          Enrico Bertolazzi (University of Trento)
#
# License: BSD 3-Clause License
#
# This is a module for the 'IndigoUtils' package. It contains the auxiliary
# functions to be used in the 'Indigo' package.

IndigoUtils := module()

  export # Symbol
         DropPrefix,
         GetPosition,
         CheckParam,
         CheckTable,
         CheckTable_2,
         ToString,
         ToRubyString,
         ToStringAndSplit,
         CatSymbol,
         ToSymbol,
         ToVector,
         JoinSymbol,
         # Differentiation
         DoDiff,
         DoGradient,
         DoHessian,
         DoJacobian,
         # Function
         ExtractSubs,
         GetFunctions,
         GetFunctionsInList,
         GetSymbols,
         GetFunctionPrototype,
         GetFunctionName,
         GetFunctionBody,
         IsDependentOn,
         GetSymbolsRecurr,
         # Miscellaneous
         GetPermSortedList,
         GetExpressionCost,
         # Messages
         cprintf,
         ErrorMessage,
         WarningMessage,
         PrintTitle,
         PrintHeader,
         PrintMessage,
         Assert,
         Warning;

  local  ModuleLoad,
         ModuleUnload,
         lib_base_path;

  option package,
         load   = ModuleLoad,
         unload = ModuleUnload;

  description "Utilities for the 'Indigo' module";

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: ModuleUnload
  #  Routines to load the module.
  #}
  ModuleLoad := proc()

    description "'IndigoUtils' module load procedure";

    #printf("Loading 'IndigoUtils'\n");
    return NULL;
  end proc: # ModuleLoad

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: ModuleUnload
  #  Routines to unload the module.
  #}
  ModuleUnload := proc()

    description "'IndigoUtils' module unload procedure";

    #printf("Unloading 'IndigoUtils'\n");
    return NULL;
  end proc: # ModuleUnload

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #   ____                  _           _
  #  / ___| _   _ _ __ ___ | |__   ___ | |
  #  \___ \| | | | '_ ` _ \| '_ \ / _ \| |
  #   ___) | |_| | | | | | | |_) | (_) | |
  #  |____/ \__, |_| |_| |_|_.__/ \___/|_|
  #         |___/

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: DropPrefix
  #  Drop the prefix of a string.
  #
  # Parameters:
  #  - str = string to be processed
  #
  # Return:
  #  the string without prefix
  #}
  DropPrefix := proc(
    str::{string},
    $)::{string};

    description "Drop the prefix of the input string <str>.";

    return StringTools[RegSubs]("([^#]+)#"="", str);
  end proc: # DropPrefix

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: GetPosition
  #  Find a list in order to find the position of variable.
  #
  # Parameters:
  #  - var = symbol, function or integer to be processed
  #  - lst = is a list of functions or symbols
  #
  # Return:
  #  the position of variable var in the list.
  #}
  GetPosition := proc( var::{symbol, function, integer}, lst::{list}, $ )
    local i;
    # Find the position
    if type(var,` function`) then
      i := ListTools[Search](var, lst);
    elif type(var, `symbol`) then
      # Attention it is assumed that the independent variable is zeta
      i := ListTools[Search](var(zeta), lst);
      if (i = 0) then
        i := ListTools[Search](var, lst);
      end if;
      if (i = 0) then
        ErrorMessage(
          "IndigoUtils::GetPosition(...): failed for %s in %s.\n",
          convert(var, string),
          convert(lst, string)
        );
      end if;
    elif type(var, `integer`) then
      i;
    else
      ErrorMessage(
        "IndigoUtils::GetPosition(...): failed for %s in %s.\n",
        convert(var, string),
        convert(lst, string)
      );
    end if;
    return i;
  end proc: # GetPosition

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: CheckParam
  #  Check the parameter type.
  #
  # Parameters:
  #  - param      = parameter to be checked
  #  - param_name = parameter name
  #  - tp         = parameter type
  #
  # Return:
  #  NULL or Warning
  #}
  CheckParam := proc( param, param_name::string, tp, where::string, $ )
    if not type(param, tp) then
      printf("IndigoUtils::GetPosition(...): parameter `%s` = %a\n", param_name, param);
      ErrorMessage(
        "IndigoUtils::GetPosition(...): parameter `%s` is of type `%s`, expected of type `%s` in %s\n",
        param_name, convert(whattype(param), string), convert(tp, string), where
      );
    end if;
    return NULL;
  end proc: # CheckParam

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # TODO
  (*
  CheckTable := proc( t, e::string, msg::string, tp, $ )
    if not type(t, `table`) then
      ErrorMessage(msg);
    end if;
    if not member(e, [indices(t, 'nolist')]) then
      ErrorMessage(msg);
    end if;
    CheckParam(t[e], e, tp, "CheckTable");
    return NULL;
  end proc: # CheckTable
  *)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # TODO
  (*
  CheckTable_2 := proc( param::table, nameParam::string, tp, where::string, $ )
    local keywords;
    keywords := {indices(param,'nolist')};
    if not (nameParam in keywords) then
      ErrorMessage(
        "IndigoUtils::GetPosition(...): missing keyword `%s` in %s\nkeywords: %a\n",
        convert(nameParam, string), where, keywords
      );
    end if;
    if not type(param[nameParam], tp) then
      printf("Parameter `%s` = %a\n", nameParam, param[nameParam]);
      ErrorMessage(
        "IndigoUtils::GetPosition(...): parameter `%s` is of type `%s`, expected of type `%s` in %s\n",
        nameParam, convert(whattype(param[nameParam]), string),
        convert(tp, string), where
      );
    end if;
    return NULL;
  end proc: # CheckTable_2
  *)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: ToString
  #  Convert a symbol into a string. Variables of type 'x[dot](t)' are converted
  #  into 'x_dot(t)'.
  #
  # Parameters:
  #  - var = symbol to be converted
  #
  # Return:
  #  the string
  #}
  ToString := proc( var, $ )
    local str;
    if type(var,'string') then
      return var;
    else
      str := convert(var,string);
      str := StringTools[Substitute](str, "]", "");
      str := StringTools[Substitute](str, "[", "_");
      # We do not substitute " with \" but ' with \'
      str := StringTools[SubstituteAll](str, "'", "\\'");
      # Workaround for numbers
      str := StringTools[RegSubs]("^-[.]([0-9])"="-0.\1", str);
      str := StringTools[RegSubs]("^[.]([0-9])"="0.\1", str);
      return str;
    end if;
  end proc: # ToString

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: ToStringAndSplit
  #  Convert a symbol or string into multiple strings. Variables of type
  #  'x[dot](t)' are converted into 'x_dot(t)'.
  #
  # Parameters:
  #  - var = symbol to be converted
  #
  # Return:
  #  the string
  #}
  ToStringAndSplit := proc( var, $ )
    local str;
    if type(var, 'string') then
      str := var;
    else
      str := ToString(var);
    end if;
    if (StringTools[Length](str) > 512) then
      str := StringTools[Join]([StringTools[LengthSplit](str, 512)], """+\n\t""");
    end if;
    # We do not substitute " with \" but ' with \'
    str := StringTools[SubstituteAll](str, "'", "\\'");
    return str;
  end proc: # ToStringAndSplit

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: ToRubyString
  #  Convert a symbol or string into a Ruby string. Variables of type 'x[dot](t)'
  #  are converted into 'x_dot(t)'.
  #
  # Parameters:
  #  - var = symbol or string to be converted
  #
  # Return:
  #  the string
  #}
  ToRubyString := proc( var, $ )
    local str;
    str := ToString(var);
    if (StringTools[Length](str) > 512) then
      str := StringTools[Join]([StringTools[LengthSplit](str, 512)], """+\n\t""");
    end if;
    return cat("""", str, """");
  end proc: # ToRubyString

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: CatSymbol
  #  Concatenates symbols.
  #
  # Parameters:
  #  - _passed = symbols to be concatenated
  #
  # Return:
  #  the symbol
  #}
  CatSymbol := proc()
    return convert(cat(_passed), symbol);
  end proc: # CatSymbol

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: ToSymbol
  #  Convert a symbol into a string. Variables of type 'x[dot](t)' are converted
  #  into 'x_dot(t)'.
  #
  # Parameters:
  #  - pre  = symbol or string prefix
  #  - var  = string
  #  - post = symbol or string postfix
  #
  # Return:
  #  the symbol
  #}
  ToSymbol := proc( pre, var, post, $ )
    local tmp;
    tmp := convert(op(0, var), string);
    tmp := StringTools[Substitute](tmp, "]", "");
    tmp := StringTools[Substitute](tmp, "[", "_");
    return convert(cat(pre, tmp, post), symbol);
  end proc: # ToSymbol

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: ToVector
  #  Convert list matrix or anithing to a column vector.
  #
  # Parameters:
  #  - v = list or matrix
  #
  # Return:
  #  the Vector(v)
  #}
  ToVector := proc( v, $ )
    return convert(convert(v, list), Vector);
  end proc: # ToVector

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: JoinSymbol
  #  Combine a list of string/symbols into one unique symbol.
  #
  # Parameters:
  #  - _passed[] = unspecified number of "list, vector, array???"
  #
  # Return:
  #  the symbol
  #}
  JoinSymbol := proc()
    local out, i;
    out := convert(_passed[1], symbol);
    for i from 2 to _npassed do
      out := cat(out, convert(_passed[i], symbol));
    end do;
    return out;
  end proc: # JoinSymbol

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #   ____  _  __  __                     _   _       _   _
  #  |  _ \(_)/ _|/ _| ___ _ __ ___ _ __ | |_(_) __ _| |_(_) ___  _ __
  #  | | | | | |_| |_ / _ \ '__/ _ \ '_ \| __| |/ _` | __| |/ _ \| '_ \
  #  | |_| | |  _|  _|  __/ | |  __/ | | | |_| | (_| | |_| | (_) | | | |
  #  |____/|_|_| |_|  \___|_|  \___|_| |_|\__|_|\__,_|\__|_|\___/|_| |_|
  #

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: DoDiff
  #  Differentiate an expression with respect to a function.
  #
  # Parameters:
  #  - _passed[1] = expression
  #  - _passed[2] = function to differentiate by
  #
  # Return:
  #  the expression derivative
  #}
  DoDiff := proc()
    local i, tmp1, tmp2, out;
    tmp2 := DoDiff(subs(f = tmp1, out), tmp1);
    subs(tmp1 = f, convert(tmp2, D));
    out := _passed[1];
    for i from 2 to _npassed do
      tmp2 := DoDiff(subs(_passed[i] = tmp1, out), tmp1);
      out := subs(tmp1 = _passed[i], convert(tmp2, D));
    end do;
    return out;
  end proc: # DoDiff

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: DoGradient
  #  Differentiate an scalar expression with respect to a list of functions.
  #
  # Parameters:
  #  - fnc = expression
  #  - lst = list of functions to differentiate by
  #
  # Return:
  #  the expression gradient
  #}
  DoGradient := proc( fnc, lst::list, $ )
    local i, n_x, out;
    n_x := nops(lst);
    out := Vector(n_x);
    for i from 1 to n_x do
      out[i] := DoDiff(fnc,lst[i]):
    end do;
    return out;
  end proc: # DoGradient

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: DoHessian
  #  Differentiate a vector of expressions (gradient) with respect to a list of
  #  functions.
  #
  # Parameters:
  #  - fnc = vector of expressions
  #  - lst = list of functions to differentiate by
  #
  # Return:
  #  the expressions hessian
  #}
  DoHessian := proc( fnc, lst::list, $ )
    local i, j, n_x, out;
    n_x := nops(lst);
    out := Matrix(n_x, n_x);
    for i from 1 to n_x do
      for j from i to n_x do
        out[i,j] := DoDiff(fnc, lst[i], lst[j]);
        out[j,i] := out[i,j];
      end do;
    end do;
    return out;
  end proc: # DoHessian

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: DoJacobian
  #  Differentiate an vector of expressions with respect to a list of functions.
  #
  # Parameters:
  #  - fnc = vector of expressions
  #  - lst = list of functions to differentiate by
  #
  # Return:
  #  the expressions jacobian
  #}
  DoJacobian := proc( fnc::Vector, lst::list, $ )
    local i, j, n_f, n_x, out;
    n_f := LinearAlgebra[Dimension](fnc);
    n_x := nops(lst);
    out := Matrix(n_f, n_x);
    for i from 1 to n_f do
      for j from 1 to n_x do
        out[i,j] := DoDiff(fnc[i], lst[j]);
      end do;
    end do;
    return out;
  end proc: # DoJacobian

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #   _____                 _   _
  #  |  ___|   _ _ __   ___| |_(_) ___  _ __
  #  | |_ | | | | '_ \ / __| __| |/ _ \| '_ \
  #  |  _|| |_| | | | | (__| |_| | (_) | | | |
  #  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|
  #

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: ExtractSubs
  #  Extract the list of the substitution list.
  #
  # Parameters:
  #  - pars = list of parameters
  #
  # Return:
  #  the list of variables to substitute
  #}
  ExtractSubs := proc( pars::list, $ )
    local  i, out;
    CheckParam( pars, "ExtractSubs param", 'list', "ExtractSubs" ):
    out := [];
    for i from 1 to nops(pars) do
      if (nops(pars[i]) > 1) then
        out := [op(out), pars[i]];
      end if;
    end do;
    return out;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: GetFunctions
  #  Extract the list of the functions in the expression.
  #
  # Parameters:
  #  - expr = algebraic expression
  #  - onlyD = boolean to extract only the functions of the form D(f)
  #
  # Return:
  #  the list of functions
  GetFunctions := proc ( expr, onlyD::boolean := false, $ )
    local e, lst, tmp1, tmp2;
    lst := {};
    if type(expr, 'function') then
      tmp1 := op(0, expr);
      if onlyD then
        tmp2 := op(0, tmp1);
        if type(tmp1,'function') and (type(tmp2,'symbol') or
           type(tmp2, 'indexed')) then
          lst := {tmp1} union GetFunctions(op(1, expr), onlyD);
        end if;
      else
        lst := {tmp1} union GetFunctions(op(1, expr), onlyD);
      end if;
    else
      for e in expr do
        if type(e, 'constant') or type(e, 'symbol') then
          #print("symbol",e);
        elif type(e, 'function') then
          #print("symbol",e);
          lst := lst union GetFunctions(e, onlyD);
        elif type(e, 'algebraic') then
          #print("algebraic",e);
          lst := lst union GetFunctions(e, onlyD);
        end if;
      end do;
    end if;
    return lst;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: GetFunctionsInList
  #  Extract the list of the functions in the expression expr that are also in
  #  the list fncs.
  #
  # Parameters:
  #  - expr = algebraic expression
  #  - fncs = list of functions to be searched
  #
  # Return:
  #  the list of functions found that also appear in the given list
  #}
  GetFunctionsInList := proc ( expr, fncs::list, $ )
    local e, lst, tmp1, tmp2;
    lst := {};
    if type(expr,'function') then
      tmp1 := expr: #op(0, expr);
      #print("function", op(0, expr), op(1, expr));
      if has(fncs,op(0,expr)) then
        #print("found", op(0, expr), op(1, expr));
        if nops(expr) > 0 then
          lst := {tmp1} union GetFunctionsInList(op(1, expr), fncs);
        else
          lst := {tmp1};
        end if;
      else
        if nops(expr) > 0 then
          lst := {} union GetFunctionsInList(op(1, expr), fncs);
        end if;
      end if;
    else
      for e in expr do
        if type(e,'constant') or type(e,'symbol') then
          #print("symbol",e);
        elif type(e,'function') then
          #print("symbol",e);
          lst := lst union GetFunctionsInList(e, fncs);
        elif type(e,'algebraic') then
          #print("algebraic",e);
          lst := lst union GetFunctionsInList(e, fncs);
        end if;
      end do;
    end if;
    return lst;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: GetSymbols
  #  Extracts the list of the symbols in the expression.
  #
  # Parameters:
  #  - expr  = algebraic expression.
  #
  # Return:
  #  the list of symbols
  #}
  GetSymbols := proc( expr, $ )
    local e, s, lst;
    lst := {};
    #print("expr=",expr);
    for e in expr do
      if type(e, 'constant') then
        #print("constant",e);
      elif type(e, 'symbol') then
        s := eval(e);
        if type(s, 'symbol') then
          #print("symbol",e);
          lst := lst union {e};
        else
          lst := lst union GetSymbols(s);
        end
      elif type(e, 'algebraic') then
        #print("algebraic",e);
        lst := lst union GetSymbols(e);
      end if;
    end do;
    return lst;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: GetFunctionPrototype
  #  Extracts a function ptototype f(x) from an expression of type 'f(x) = body'
  #   or 'f(x)'.
  #
  # Parameters:
  #  - expr
  #
  # Return:
  #  the function prototype
  #}
  GetFunctionPrototype := proc ( expr, $ )
    if type(expr,`=`) then
      return lhs(expr);
    else
      return expr;
    end if;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: GetFunctionName
  #  Extracts the function name from an expression of type 'f(x) = body' or
  #  'f(x)'.
  #
  # Parameters:
  #  - expr = algebraic expression
  #
  # Return:
  #  the name of the function
  #}
  GetFunctionName := proc ( expr, $ )
    local out;
    if type(expr, `=`) then
      out := op(1, expr);
    else
      out := expr;
    end if;
    if type(out, function) then
      return op(0, out);
    else
      ErrorMessage(
        "IndigoUtils::GetFunctionName(...): function expected.\n"
      );
    end if;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: GetFunctionBody
  #  Extracts the body from an expression of type 'f(x) = body' or 'f(x)'.
  #
  # Parameters:
  #  - expr = function to be processed
  #
  # Return:
  #  the body of the function
  #}
  GetFunctionBody := proc ( expr, $ )
    if type(expr,`=`) then
      return op(2, expr);
    else
      return expr;
    end if;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: IsDependentOn
  #  Checks if the expression expr depends on the variables in the list vars.
  #
  # Parameters:
  #  - expr = algebraic expression
  #  - vars = list of variables
  #
  # Return:
  #  true if expr depends on vars, false otherwise
  #}
  IsDependentOn := proc ( expr::algebraic, vars::list(function), $ )
    local var;
    for var in vars do
      if (has(expr, var)) then
        return true;
      end if;
    end do;
    return false;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: GetSymbolsRecurr
  #  Extracts the list of the symbols recursively from the expression.
  #
  # Parameters:
  #  - expr = algebraic expression
  #
  # Return:
  #  the list of symbols
  #}
  GetSymbolsRecurr := proc ( data )
    local tmp, key, kv;

    if type(data,'indexed') then
      return {};
    end if;

    if type(data, 'Array') then
      return GetSymbolsRecurr(convert(data,'list'));
    end if;

    if type(data, 'table') then
      return GetSymbolsRecurr(op(2,op(1,data)));
    end if;

    if type(data, 'list') then
      if nops(data) = 0 then
        return {};
      elif type(data, 'list(table)') then
        tmp := {};
        for key in data do
          tmp := tmp union GetSymbolsRecurr(key);
        end do;
        return tmp;
      elif type(data, 'list(function(symbol))') then
        return GetSymbols(data);
      #elif type(data,'list({string,symbol})') then
      # we have to check that it is not only a list of strings
      # while it can be a list of parameters (symbols)
      elif type(data, 'list({string})') then
        return {};
      elif type(data, 'list(algebraic)') then
        return GetSymbols(data);
      elif type(data, 'list(anything=anything)') then
        tmp := {};
        for kv in data do
          tmp := tmp union GetSymbolsRecurr(rhs(kv));
        end do;
        return tmp;
      elif type(data, 'list(anything)') then
        tmp := {};
        for kv in data do
          tmp := tmp union GetSymbolsRecurr(kv);
        end do;
        return tmp;
      else
        return {};
      end if;
    elif type(data, 'anything=anything') then
      return GetSymbols(rhs(data));
    elif type(data, 'algebraic') then
      return GetSymbols(data);
    elif type(data, 'string') then
      return {};
    else
      return {};
    end if;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #   __  __ _              _ _
  #  |  \/  (_)___  ___ ___| | | __ _ _ __   ___  ___  _   _ ___
  #  | |\/| | / __|/ __/ _ \ | |/ _` | '_ \ / _ \/ _ \| | | / __|
  #  | |  | | \__ \ (_|  __/ | | (_| | | | |  __/ (_) | |_| \__ \
  #  |_|  |_|_|___/\___\___|_|_|\__,_|_| |_|\___|\___/ \__,_|___/
  #

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: GetPermSortedList
  #  Compute the permutation that sorts a list.
  #
  # Parameters:
  #  - idx = list to be sorted
  #
  # Return:
  #  the permutation that sorts the list
  #}
  GetPermSortedList := proc( idx::list, $ )
    local idx_sorted, perm, e;
    idx_sorted := sort(idx);
    perm := [];
    for e in idx do;
      perm :=[op(perm), ListTools[Search](e, idx_sorted)];
    end do;
    return perm;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: GetExpressionCost
  #   Compute the overall cost of an algebraic expression.
  #
  # Parameters:
  #  - e = algebraic expression
  # Return:
  #  the overall cost number of mathematical operations
  #  (additions + multiplications + divisions + functions)
  #}
  GetExpressionCost := proc( e::algebraic, $ )
    local out;
    out := codegen:-cost(e);
    out := coeffs(out,[additions,multiplications,functions,divisions]);
    return add(out);
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #   __  __
  #  |  \/  | ___  ___ ___  __ _  __ _  ___  ___
  #  | |\/| |/ _ \/ __/ __|/ _` |/ _` |/ _ \/ __|
  #  | |  | |  __/\__ \__ \ (_| | (_| |  __/\__ \
  #  |_|  |_|\___||___/___/\__,_|\__, |\___||___/
  #                              |___/

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: cprintf
  #  Print a message in color.
  #
  # Parameters:
  #  - fg  = foreground color
  #  - bg  = background color
  #  - fmt = format string
  #  - ... = string arguments
  #}
  cprintf := proc( fg, bg, fmt )
    print(Typesetting[mtext](
      sprintf(fmt, _passed[4..-1]),
      mathcolor = fg, mathbackground = bg#, fontweight = "bold"
    ));
  end proc; # cprintf

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: ErrorMessage
  #  Print an error message in color and stops the
  #  execution.
  #
  # Parameters:
  #  - _passed = string to be printed
  #}
  ErrorMessage := proc()
    local msg;
    #cprintf("red", "white", _passed);
    #msg := cat("Fatal error: ", sprintf(_passed));
    error cat(sprintf(_passed), "\n");
  end proc: # ErrorMessage

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: WarningMessage
  #  Print a Warning message in color.
  #
  # Parameters:
  #  - _passed = string to be printed
  #}
  WarningMessage := proc()
    #cprintf("magenta", "white", _passed);
    Warning(cat(_passed, "\n"));
  end proc: # WarningMessage

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: PrintTitle
  #  Print a title.
  #
  # Parameters:
  #  - _passed = string to be printed
  #}
  PrintTitle := proc()
    local str, len;
    str := sprintf(_passed);
    len := StringTools[Length](str);
    printf(
      "\n%s\n%s\n\n",
      str, StringTools[SubString](cat(
        "====================================================================",
        "===================================================================="
        ), 1..len)
    );
  end proc: # PrintTitle

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: PrintHeader
  #  Print an header.
  #
  # Parameters:
  #  - _passed = string to be printed
  #}
  PrintHeader := proc()
    local str, len;
    str := sprintf(_passed);
    len := StringTools[Length](str);
    printf(
      "\n%s\n%s\n",
      str, StringTools[SubString](cat(
        "--------------------------------------------------------------------",
        "--------------------------------------------------------------------"
        ), 1..len)
    );
  end proc: # PrintHeader

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: PrintMessage
  #  Print a message.
  #
  # Parameters:
  #  - _passed = string to be printed
  #}
  PrintMessage := proc()
    printf(_passed);
  end proc: # PrintMessage

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: Assert
  #  Checks if a condition is true and prints an error message if it is not.
  #
  # Parameters:
  #  - check = condition to be checked
  #}
  Assert := proc( check )
    if not check then
      ErrorMessage(_passed[2..-1]);
    end if;
  end proc: # Assert

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: Warning
  #  Checks if a condition is true and prints a Warning message if it is not.
  #
  # Parameters:
  #  - check = condition to be checked
  #}
  Warning := proc( check )
    if not check then
      WarningMessage(_passed[2..-1]);
    end if;
  end proc: # Warning

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

end module: # IndigoUtils

# That's all folks!