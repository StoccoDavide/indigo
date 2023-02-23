# # # # # # # # # # # # # # # # # # # # # # # # # # #
#  ___           _ _             _   _ _   _ _      #
# |_ _|_ __   __| (_) __ _  ___ | | | | |_(_) |___  #
#  | || '_ \ / _` | |/ _` |/ _ \| | | | __| | / __| #
#  | || | | | (_| | | (_| | (_) | |_| | |_| | \__ \ #
# |___|_| |_|\__,_|_|\__, |\___/ \___/ \__|_|_|___/ #
#                    |___/                          #
# # # # # # # # # # # # # # # # # # # # # # # # # # #

# Authors: Davide Stocco and Enrico Bertolazzi
# Date:    22/02/2023

IndigoUtils := module()

  # Exported variables
  export  # Symbol
          drop_prefix,
          get_position,
          check_param,
          check_table,
          check_table_2,
          to_string,
          to_ruby_string,
          to_string_and_split,
          cat_symbol,
          to_symbol,
          to_vector,
          join_symbol,
          # Differentiation
          do_diff,
          do_gradient,
          do_hessian,
          do_jacobian,
          # Function
          extract_subs,
          get_functions,
          get_functions_in_list,
          get_symbols,
          get_function_prototype,
          get_function_name,
          get_function_body,
          is_dependent_on,
          get_symbols_recurr,
          # Miscellaneous
          get_perm_sorted_list,
          compute_expression_cost,
          # Messages
          cprintf,
          error_message,
          warning_message,
          print_title,
          print_header,
          print_message,
          assert,
          warning;

  # Local variables
  local   module_load,
          module_unload,
          lib_base_path;

  # Package options
  option  package,
          load   = module_load,
          unload = module_unload;

  description "Utilities for the 'Indigo' module";

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: module_unload
  #  Routines to load the module.
  #}
  module_load := proc()
    #printf("Loading 'IndigoUtils'\n");
    return NULL;
  end proc: # module_load

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: module_unload
  #  Routines to unload the module.
  #}
  module_unload := proc()
    #printf("Unloading 'IndigoUtils'\n");
    return NULL;
  end proc: # module_unload

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #   ____                  _           _
  #  / ___| _   _ _ __ ___ | |__   ___ | |
  #  \___ \| | | | '_ ` _ \| '_ \ / _ \| |
  #   ___) | |_| | | | | | | |_) | (_) | |
  #  |____/ \__, |_| |_| |_|_.__/ \___/|_|
  #         |___/

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: drop_prefix
  #  Drop the prefix of a string.
  #
  # Parameters:
  #  - str = string to be processed
  #
  # Return:
  #  the string without prefix
  #}
  drop_prefix := proc( str::string, $ )
    return StringTools[RegSubs]("([^#]+)#"="", str);
  end proc: # drop_prefix

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: get_position
  #  Find a list in order to find the position of variable.
  #
  # Parameters:
  #  - var = symbol, function or integer to be processed
  #  - lst = is a list of functions or symbols
  #
  # Return:
  #  the position of variable var in the list.
  #}
  get_position := proc( var::{symbol,function,integer}, lst::list, $ )
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
        error_message(
          "IndigoUtils::get_position(...): failed for %s in %s.\n",
          convert(var, string),
          convert(lst, string)
        );
      end if;
    elif type(var, `integer`) then
      i;
    else
      error_message(
        "IndigoUtils::get_position(...): failed for %s in %s.\n",
        convert(var, string),
        convert(lst, string)
      );
    end if;
    return i;
  end proc: # get_position

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: check_param
  #  Check the parameter type.
  #
  # Parameters:
  #  - param      = parameter to be checked
  #  - param_name = parameter name
  #  - tp         = parameter type
  #
  # Return:
  #  NULL or warning
  #}
  check_param := proc( param, param_name::string, tp, where::string, $ )
    if not type(param, tp) then
      printf("IndigoUtils::get_position(...): parameter `%s` = %a\n", param_name, param);
      error_message(
        "IndigoUtils::get_position(...): parameter `%s` is of type `%s`, expected of type `%s` in %s\n",
        param_name, convert(whattype(param), string), convert(tp, string), where
      );
    end if;
    return NULL;
  end proc: # check_param

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # TODO
  (*
  check_table := proc( t, e::string, msg::string, tp, $ )
    if not type(t, `table`) then
      error_message(msg);
    end if;
    if not member(e, [indices(t, 'nolist')]) then
      error_message(msg);
    end if;
    check_param(t[e], e, tp, "check_table");
    return NULL;
  end proc: # check_table
  *)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # TODO
  (*
  check_table_2 := proc( param::table, nameParam::string, tp, where::string, $ )
    local keywords;
    keywords := {indices(param,'nolist')};
    if not (nameParam in keywords) then
      error_message(
        "IndigoUtils::get_position(...): missing keyword `%s` in %s\nkeywords: %a\n",
        convert(nameParam, string), where, keywords
      );
    end if;
    if not type(param[nameParam], tp) then
      printf("Parameter `%s` = %a\n", nameParam, param[nameParam]);
      error_message(
        "IndigoUtils::get_position(...): parameter `%s` is of type `%s`, expected of type `%s` in %s\n",
        nameParam, convert(whattype(param[nameParam]), string),
        convert(tp, string), where
      );
    end if;
    return NULL;
  end proc: # check_table_2
  *)

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: to_string
  #  Convert a symbol into a string. Variables of type 'x[dot](t)' are converted
  #  into 'x_dot(t)'.
  #
  # Parameters:
  #  - var = symbol to be converted
  #
  # Return:
  #  the string
  #}
  to_string := proc( var, $ )
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
  end proc: # to_string

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: to_string_and_split
  #  Convert a symbol or string into multiple strings. Variables of type
  #  'x[dot](t)' are converted into 'x_dot(t)'.
  #
  # Parameters:
  #  - var = symbol to be converted
  #
  # Return:
  #  the string
  #}
  to_string_and_split := proc( var, $ )
    local str;
    if type(var, 'string') then
      str := var;
    else
      str := to_string(var);
    end if;
    if (StringTools[Length](str) > 512) then
      str := StringTools[Join]([StringTools[LengthSplit](str, 512)], """+\n\t""");
    end if;
    # We do not substitute " with \" but ' with \'
    str := StringTools[SubstituteAll](str, "'", "\\'");
    return str;
  end proc: # to_string_and_split

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: to_ruby_string
  #  Convert a symbol or string into a Ruby string. Variables of type 'x[dot](t)'
  #  are converted into 'x_dot(t)'.
  #
  # Parameters:
  #  - var = symbol or string to be converted
  #
  # Return:
  #  the string
  #}
  to_ruby_string := proc( var, $ )
    local str;
    str := to_string(var);
    if (StringTools[Length](str) > 512) then
      str := StringTools[Join]([StringTools[LengthSplit](str, 512)], """+\n\t""");
    end if;
    return cat("""", str, """");
  end proc: # to_ruby_string

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: cat_symbol
  #  Concatenates symbols.
  #
  # Parameters:
  #  - _passed = symbols to be concatenated
  #
  # Return:
  #  the symbol
  #}
  cat_symbol := proc()
    return convert(cat(_passed), symbol);
  end proc: # cat_symbol

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: to_symbol
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
  to_symbol := proc( pre, var, post, $ )
    local tmp;
    tmp := convert(op(0, var), string);
    tmp := StringTools[Substitute](tmp, "]", "");
    tmp := StringTools[Substitute](tmp, "[", "_");
    return convert(cat(pre, tmp, post), symbol);
  end proc: # to_symbol

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: to_vector
  #  Convert list matrix or anithing to a column vector.
  #
  # Parameters:
  #  - v = list or matrix
  #
  # Return:
  #  the Vector(v)
  #}
  to_vector := proc( v, $ )
    return convert(convert(v, list), Vector);
  end proc: # to_vector

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: join_symbol
  #  Combine a list of string/symbols into one unique symbol.
  #
  # Parameters:
  #  - _passed[] = unspecified number of "list, vector, array???"
  #
  # Return:
  #  the symbol
  #}
  join_symbol := proc()
    local out, i;
    out := convert(_passed[1], symbol);
    for i from 2 to _npassed do
      out := cat(out, convert(_passed[i], symbol));
    end do;
    return out;
  end proc: # join_symbol

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #   ____  _  __  __                     _   _       _   _
  #  |  _ \(_)/ _|/ _| ___ _ __ ___ _ __ | |_(_) __ _| |_(_) ___  _ __
  #  | | | | | |_| |_ / _ \ '__/ _ \ '_ \| __| |/ _` | __| |/ _ \| '_ \
  #  | |_| | |  _|  _|  __/ | |  __/ | | | |_| | (_| | |_| | (_) | | | |
  #  |____/|_|_| |_|  \___|_|  \___|_| |_|\__|_|\__,_|\__|_|\___/|_| |_|
  #

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: do_diff
  #  Differentiate an expression with respect to a function.
  #
  # Parameters:
  #  - _passed[1] = expression
  #  - _passed[2] = function to differentiate by
  #
  # Return:
  #  the expression derivative
  #}
  do_diff := proc()
    local i, tmp1, tmp2, out;
    tmp2 := do_diff(subs(f = tmp1, out), tmp1);
    subs(tmp1 = f, convert(tmp2, D));
    out := _passed[1];
    for i from 2 to _npassed do
      tmp2 := do_diff(subs(_passed[i] = tmp1, out), tmp1);
      out := subs(tmp1 = _passed[i], convert(tmp2, D));
    end do;
    return out;
  end proc: # do_diff

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: do_gradient
  #  Differentiate an scalar expression with respect to a list of functions.
  #
  # Parameters:
  #  - fnc = expression
  #  - lst = list of functions to differentiate by
  #
  # Return:
  #  the expression gradient
  #}
  do_gradient := proc( fnc, lst::list, $ )
    local i, n_x, out;
    n_x := nops(lst);
    out := Vector(n_x);
    for i from 1 to n_x do
      out[i] := do_diff(fnc,lst[i]):
    end do;
    return out;
  end proc: # do_gradient

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: do_hessian
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
  do_hessian := proc( fnc, lst::list, $ )
    local i, j, n_x, out;
    n_x := nops(lst);
    out := Matrix(n_x, n_x);
    for i from 1 to n_x do
      for j from i to n_x do
        out[i,j] := do_diff(fnc, lst[i], lst[j]);
        out[j,i] := out[i,j];
      end do;
    end do;
    return out;
  end proc: # do_hessian

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: do_jacobian
  #  Differentiate an vector of expressions with respect to a list of functions.
  #
  # Parameters:
  #  - fnc = vector of expressions
  #  - lst = list of functions to differentiate by
  #
  # Return:
  #  the expressions jacobian
  #}
  do_jacobian := proc( fnc::Vector, lst::list, $ )
    local i, j, n_f, n_x, out;
    n_f := LinearAlgebra[Dimension](fnc);
    n_x := nops(lst);
    out := Matrix(n_f, n_x);
    for i from 1 to n_f do
      for j from 1 to n_x do
        out[i,j] := do_diff(fnc[i], lst[j]);
      end do;
    end do;
    return out;
  end proc: # do_jacobian

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #   _____                 _   _
  #  |  ___|   _ _ __   ___| |_(_) ___  _ __
  #  | |_ | | | | '_ \ / __| __| |/ _ \| '_ \
  #  |  _|| |_| | | | | (__| |_| | (_) | | | |
  #  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|
  #

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: extract_subs
  #  Extract the list of the substitution list.
  #
  # Parameters:
  #  - pars = list of parameters
  #
  # Return:
  #  the list of variables to substitute
  #}
  extract_subs := proc( pars::list, $ )
    local  i, out;
    check_param( pars, "extract_subs param", 'list', "extract_subs" ):
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
  # Function: get_functions
  #  Extract the list of the functions in the expression.
  #
  # Parameters:
  #  - expr = algebraic expression
  #  - onlyD = boolean to extract only the functions of the form D(f)
  #
  # Return:
  #  the list of functions
  get_functions := proc ( expr, onlyD::boolean := false, $ )
    local e, lst, tmp1, tmp2;
    lst := {};
    if type(expr, 'function') then
      tmp1 := op(0, expr);
      if onlyD then
        tmp2 := op(0, tmp1);
        if type(tmp1,'function') and (type(tmp2,'symbol') or
           type(tmp2, 'indexed')) then
          lst := {tmp1} union get_functions(op(1, expr), onlyD);
        end if;
      else
        lst := {tmp1} union get_functions(op(1, expr), onlyD);
      end if;
    else
      for e in expr do
        if type(e, 'constant') or type(e, 'symbol') then
          #print("symbol",e);
        elif type(e, 'function') then
          #print("symbol",e);
          lst := lst union get_functions(e, onlyD);
        elif type(e, 'algebraic') then
          #print("algebraic",e);
          lst := lst union get_functions(e, onlyD);
        end if;
      end do;
    end if;
    return lst;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: get_functions_in_list
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
  get_functions_in_list := proc ( expr, fncs::list, $ )
    local e, lst, tmp1, tmp2;
    lst := {};
    if type(expr,'function') then
      tmp1 := expr: #op(0, expr);
      #print("function", op(0, expr), op(1, expr));
      if has(fncs,op(0,expr)) then
        #print("found", op(0, expr), op(1, expr));
        if nops(expr) > 0 then
          lst := {tmp1} union get_functions_in_list(op(1, expr), fncs);
        else
          lst := {tmp1};
        end if;
      else
        if nops(expr) > 0 then
          lst := {} union get_functions_in_list(op(1, expr), fncs);
        end if;
      end if;
    else
      for e in expr do
        if type(e,'constant') or type(e,'symbol') then
          #print("symbol",e);
        elif type(e,'function') then
          #print("symbol",e);
          lst := lst union get_functions_in_list(e, fncs);
        elif type(e,'algebraic') then
          #print("algebraic",e);
          lst := lst union get_functions_in_list(e, fncs);
        end if;
      end do;
    end if;
    return lst;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: get_symbols
  #  Extracts the list of the symbols in the expression.
  #
  # Parameters:
  #  - expr  = algebraic expression.
  #
  # Return:
  #  the list of symbols
  #}
  get_symbols := proc( expr, $ )
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
          lst := lst union get_symbols(s);
        end
      elif type(e, 'algebraic') then
        #print("algebraic",e);
        lst := lst union get_symbols(e);
      end if;
    end do;
    return lst;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: get_function_prototype
  #  Extracts a function ptototype f(x) from an expression of type 'f(x) = body'
  #   or 'f(x)'.
  #
  # Parameters:
  #  - expr
  #
  # Return:
  #  the function prototype
  #}
  get_function_prototype := proc ( expr, $ )
    if type(expr,`=`) then
      return lhs(expr);
    else
      return expr;
    end if;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: get_function_name
  #  Extracts the function name from an expression of type 'f(x) = body' or
  #  'f(x)'.
  #
  # Parameters:
  #  - expr = algebraic expression
  #
  # Return:
  #  the name of the function
  #}
  get_function_name := proc ( expr, $ )
    local out;
    if type(expr, `=`) then
      out := op(1, expr);
    else
      out := expr;
    end if;
    if type(out, function) then
      return op(0, out);
    else
      error_message(
        "IndigoUtils::get_function_name(...): function expected.\n"
      );
    end if;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: get_function_body
  #  Extracts the body from an expression of type 'f(x) = body' or 'f(x)'.
  #
  # Parameters:
  #  - expr = function to be processed
  #
  # Return:
  #  the body of the function
  #}
  get_function_body := proc ( expr, $ )
    if type(expr,`=`) then
      return op(2, expr);
    else
      return expr;
    end if;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: is_dependent_on
  #  Checks if the expression expr depends on the variables in the list vars.
  #
  # Parameters:
  #  - expr = algebraic expression
  #  - vars = list of variables
  #
  # Return:
  #  true if expr depends on vars, false otherwise
  #}
  is_dependent_on := proc ( expr::algebraic, vars::list(function), $ )
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
  # Function: get_symbols_recurr
  #  Extracts the list of the symbols recursively from the expression.
  #
  # Parameters:
  #  - expr = algebraic expression
  #
  # Return:
  #  the list of symbols
  #}
  get_symbols_recurr := proc ( data )
    local tmp, key, kv;

    if type(data,'indexed') then
      return {};
    end if;

    if type(data, 'Array') then
      return get_symbols_recurr(convert(data,'list'));
    end if;

    if type(data, 'table') then
      return get_symbols_recurr(op(2,op(1,data)));
    end if;

    if type(data, 'list') then
      if nops(data) = 0 then
        return {};
      elif type(data, 'list(table)') then
        tmp := {};
        for key in data do
          tmp := tmp union get_symbols_recurr(key);
        end do;
        return tmp;
      elif type(data, 'list(function(symbol))') then
        return get_symbols(data);
      #elif type(data,'list({string,symbol})') then
      # we have to check that it is not only a list of strings
      # while it can be a list of parameters (symbols)
      elif type(data, 'list({string})') then
        return {};
      elif type(data, 'list(algebraic)') then
        return get_symbols(data);
      elif type(data, 'list(anything=anything)') then
        tmp := {};
        for kv in data do
          tmp := tmp union get_symbols_recurr(rhs(kv));
        end do;
        return tmp;
      elif type(data, 'list(anything)') then
        tmp := {};
        for kv in data do
          tmp := tmp union get_symbols_recurr(kv);
        end do;
        return tmp;
      else
        return {};
      end if;
    elif type(data, 'anything=anything') then
      return get_symbols(rhs(data));
    elif type(data, 'algebraic') then
      return get_symbols(data);
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
  # Function: get_perm_sorted_list
  #  Compute the permutation that sorts a list.
  #
  # Parameters:
  #  - idx = list to be sorted
  #
  # Return:
  #  the permutation that sorts the list
  #}
  get_perm_sorted_list := proc( idx::list, $ )
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
  # Function: compute_expression_cost
  #   Compute the overall cost of an algebraic expression.
  #
  # Parameters:
  #  - e = algebraic expression
  # Return:
  #  the overall cost number of mathematical operations
  #  (additions + multiplications + divisions + functions)
  #}
  compute_expression_cost := proc( e::algebraic, $ )
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
  # Function: error_message
  #  Print an error message in color and stops the
  #  execution.
  #
  # Parameters:
  #  - _passed = string to be printed
  #}
  error_message := proc()
    local msg;
    #cprintf("red", "white", _passed);
    #msg := cat("Fatal error: ", sprintf(_passed));
    error cat(sprintf(_passed), "\n");
  end proc: # error_message

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: warning_message
  #  Print a warning message in color.
  #
  # Parameters:
  #  - _passed = string to be printed
  #}
  warning_message := proc()
    #cprintf("magenta", "white", _passed);
    WARNING(cat(_passed, "\n"));
  end proc: # warning_message

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: print_title
  #  Print a title.
  #
  # Parameters:
  #  - _passed = string to be printed
  #}
  print_title := proc()
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
  end proc: # print_title

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: print_header
  #  Print an header.
  #
  # Parameters:
  #  - _passed = string to be printed
  #}
  print_header := proc()
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
  end proc: # print_header

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: print_message
  #  Print a message.
  #
  # Parameters:
  #  - _passed = string to be printed
  #}
  print_message := proc()
    printf(_passed);
  end proc: # print_message

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: assert
  #  Checks if a condition is true and prints an error message if it is not.
  #
  # Parameters:
  #  - check = condition to be checked
  #}
  assert := proc( check )
    if not check then
      error_message(_passed[2..-1]);
    end if;
  end proc: # assert

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #{
  # Function: warning
  #  Checks if a condition is true and prints a warning message if it is not.
  #
  # Parameters:
  #  - check = condition to be checked
  #}
  warning := proc( check )
    if not check then
      warning_message(_passed[2..-1]);
    end if;
  end proc: # warning

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

end module: # IndigoUtils

# That's all folks!