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
         CheckTableField,
         CheckTableName,
         ToString,
         ToRubyString,
         ToStringAndSplit,
         CatSymbol,
         ToSymbol,
         ToVector,
         JoinSymbols,
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

  description "Utilities for the 'Indigo' module.";

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ModuleLoad := proc()

    description "'IndigoUtils' module load procedure.";

    return NULL;
  end proc: # ModuleLoad

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ModuleUnload := proc()

    description "'IndigoUtils' module unload procedure.";

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

  DropPrefix := proc(
    str::{string},
    $)::{string};

    description "Drop the prefix of the input string <str>.";

    return StringTools:-RegSubs("([^#]+)#"="", str);
  end proc: # DropPrefix

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetPosition := proc(
    var::{symbol, function, integer},
    lst::{list},
    $)::{integer};

    description "Find the position of variable <var> in the list <lst>.";

    local i;

    # Find the position
    if type(var, function) then
      i := ListTools:-Search(var, lst);
    elif type(var, symbol) then
      # Attention: it is assumed that the independent variable is zeta!
      i := ListTools:-Search(var(zeta), lst);
      if (i = 0) then
        i := ListTools:-Search(var, lst);
      end if;
      if (i = 0) then
        ErrorMessage(
          "IndigoUtils::GetPosition(...): failed for %s in %s.\n",
          convert(var, string),
          convert(lst, string)
        );
      end if;
    elif type(var, integer) then
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

  CheckParam := proc(
    param::{anything},
    param_name::{string},
    param_type::{anything},
    where::{string},
    $)::{nothing};

    description "Check if the parameter <param>, with name <param_name> is of "
      "type <param_type>.";

    if not type(param, param_type) then
      printf(
        "IndigoUtils::GetPosition(...): parameter `%s` = %a\n",
        param_name, param
      );
      ErrorMessage(
        "IndigoUtils::GetPosition(...): parameter `%s` is of type `%s`, expected of type `%s` in %s\n",
        param_name, convert(whattype(param), string), convert(tp, string), where
      );
    end if;
    return NULL;
  end proc: # CheckParam

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  CheckTableField := proc(
    tab::{table},
    param_field::{string},
    msg::{string},
    param_type::{anything},
    $)::{nothing};

    description "Check if the parameter field <param_field> in table <tab> is "
      "of type <param_type>, if not print and error message <msg>.";

    if not type(tab, table) then
      IndigoUtils:-ErrorMessage(msg);
    end if;
    if not member(param_field, [indices(t, 'nolist')]) then
      IndigoUtils:-ErrorMessage(msg);
    end if;
    IndigoUtils:-CheckParam(tab[param_field], param_field, param_type, "CheckTableField");
    return NULL;
  end proc: # CheckTableField

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  CheckTableName := proc(
    tab::{table},
    param_name::{string},
    param_type::{anything},
    where::{string},
    $)::{nothing};

    description "Check is the parameter name <param_name> in table <tab> is of "
      "type <param_type>.";

    local keywords;

    keywords := {indices(tab,'nolist')};
    if not (param_name in keywords) then
      IndigoUtils:-ErrorMessage(
        "IndigoUtils::GetPosition(...): missing keyword `%s` in %s\nkeywords: %a.\n",
        convert(param_name, string), where, keywords
      );
    end if;
    if not type(tab[param_name], param_type) then
      printf("Parameter `%s` = %a\n", param_name, tab[param_name]);
      IndigoUtils:-ErrorMessage(
        "IndigoUtils::GetPosition(...): parameter `%s` is of type `%s`, expected of type `%s` in %s.\n",
        param_name, convert(whattype(tab[param_name]), string),
        convert(param_type, string), where
      );
    end if;
    return NULL;
  end proc: # CheckTableName

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ToString := proc(
    var::{anything},
    $)::{string};

    description "Convert a variable <var> into a string. Variables of type "
      "'x[dot](t)' are converted into 'x_dot(t)'.";

    local str;

    if type(var, string) then
      return var;
    else
      str := convert(var, string);
      str := StringTools:-Substitute(str, "]", "");
      str := StringTools:-Substitute(str, "[", "_");
      # We do not substitute " with \" but ' with \'
      str := StringTools:-SubstituteAll(str, "'", "\\'");
      # Workaround for numbers
      str := StringTools:-RegSubs("^-[.]([0-9])"="-0.\1", str);
      str := StringTools:-RegSubs("^[.]([0-9])"="0.\1", str);
      return str;
    end if;
  end proc: # ToString

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ToStringAndSplit := proc(
    var::{anything},
    $)::{string};

    description "Convert a variable <var> into multiple strings. Variables of "
      "type 'x[dot](t)' are converted into 'x_dot(t)'.";

    local str;

    if type(var, string) then
      str := var;
    else
      str := IndigoUtils:-ToString(var);
    end if;
    if (StringTools:-Length(str) > 512) then
      str := StringTools:-Join([StringTools:-LengthSplit(str, 512)], """+\n\t""");
    end if;
    # We do not substitute " with \" but ' with \'
    str := StringTools:-SubstituteAll(str, "'", "\\'");
    return str;
  end proc: # ToStringAndSplit

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ToRubyString := proc(
    var::{anything},
    $)::{string};

    description "Convert a variable <var> into a Ruby string. Variables of type "
      "'x[dot](t)' are converted into 'x_dot(t)'.";

    local str;

    str := IndigoUtils:-ToString(var);
    if (StringTools:-Length(str) > 512) then
      str := StringTools:-Join([StringTools:-LengthSplit(str, 512)], """+\n\t""");
    end if;
    return cat("""", str, """");
  end proc: # ToRubyString

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  CatSymbol := proc()::{symbol};

    description "Concatenates input symbols.";

    return convert(cat(_passed), symbol);
  end proc: # CatSymbol

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ToSymbol := proc(
    pre::{symbol, string},
    var::{symbol, string},
    post::{symbol, string},
    $)::{symbol};

    description "Convert variable <var> into a string with prefix <pre> and "
      "postfix <post>. Variables of type 'x[dot](t)' are converted into "
      "'x_dot(t)'.";

    local str_pre, str_var, str_post;

    str_pre  := convert(pre, string);
    str_var  := convert(var, string);
    str_post := convert(post, string);
    str_var  := StringTools:-Substitute(tmp_var, "]", "");
    str_var  := StringTools:-Substitute(tmp_var, "[", "_");
    return convert(cat(str_pre, str_var, str_post), symbol);
  end proc: # ToSymbol

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ToVector := proc(
    var::{anything},
    $)::{Vector};

    description "Convert a variable <var> to a column vector.";

    return convert(convert(var, list), Vector);
  end proc: # ToVector

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  JoinSymbols := proc()::{symbol};

    description "Combine a list of strings or symbols into one unique symbol.";

    local out, i;

    out := convert(_passed[1], symbol);
    for i from 2 to _npassed do
      out := cat(out, convert(_passed[i], symbol));
    end do;
    return out;
  end proc: # JoinSymbols

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #   ____  _  __  __                     _   _       _   _
  #  |  _ \(_)/ _|/ _| ___ _ __ ___ _ __ | |_(_) __ _| |_(_) ___  _ __
  #  | | | | | |_| |_ / _ \ '__/ _ \ '_ \| __| |/ _` | __| |/ _ \| '_ \
  #  | |_| | |  _|  _|  __/ | |  __/ | | | |_| | (_| | |_| | (_) | | | |
  #  |____/|_|_| |_|  \___|_|  \___|_| |_|\__|_|\__,_|\__|_|\___/|_| |_|
  #
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  DoDiff := proc()::{anything};

    description "Differentiate an expression with respect to a function.";

    local i, tmp1, tmp2, out;

    tmp2 := IndigoUtils:-DoDiff(subs(f = tmp1, out), tmp1);
    subs(tmp1 = f, convert(tmp2, D));
    out := _passed[1];
    for i from 2 to _npassed do
      tmp2 := IndigoUtils:-DoDiff(subs(_passed[i] = tmp1, out), tmp1);
      out  := subs(tmp1 = _passed[i], convert(tmp2, D));
    end do;
    return out;
  end proc: # DoDiff

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  DoGradient := proc(
    fnc::{anything},
    lst::{list},
    $)::{anything};

    description "Differentiate a scalar expression <fnc> with respect to a "
      "list of functions <lst>.";

    local i, n, out;

    n   := nops(lst);
    out := Vector(n);
    for i from 1 to n do
      out[i] := IndigoUtils:-DoDiff(fnc,lst[i]):
    end do;
    return out;
  end proc: # DoGradient

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  DoHessian := proc(
    fnc::{anything},
    lst::{list},
    $)::{anything};

    description "Differentiate a vector of expressions (gradient) <fnc> with "
      "respect to a list <lst> of functions.";

    local i, j, n, out;

    n   := nops(lst);
    out := Matrix(n, n);
    for i from 1 to n do
      for j from i to n do
        out[i, j] := IndigoUtils:-DoDiff(fnc, lst[i], lst[j]);
        out[j, i] := out[i, j];
      end do;
    end do;
    return out;
  end proc: # DoHessian

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  DoJacobian := proc(
    fnc::{Vector},
    lst::{list},
    $)::{anything};

    description "Differentiate a vector of expressions <fnc> with respect to a "
      "list <lst> of functions.";

    local i, j, m, n, out;

    m := LinearAlgebra:-Dimension(fnc);
    n := nops(lst);
    out := Matrix(m, n);
    for i from 1 to m do
      for j from 1 to n do
        out[i, j] := IndigoUtils:-DoDiff(fnc[i], lst[j]);
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

  ExtractSubs := proc(
    pars::{list},
    $)::{list};

    description "Extract the list variables to substitute from a list of "
      "parameters <pars>.";

    local  i, out;

    IndigoUtils:-CheckParam(pars, "ExtractSubs param", 'list', "ExtractSubs"):
    out := [];
    for i from 1 to nops(pars) do
      if (nops(pars[i]) > 1) then
        out := [op(out), pars[i]];
      end if;
    end do;
    return out;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetFunctions := proc (
    expr::{anything},
    onlyD::{boolean} := false,
    $)::{anything};

    description "Extract the list of the functions in the expression <expr>, "
     "where <onlyD> is boolean to extract only the functions of the form D(f).";

    local e, lst, tmp1, tmp2;

    lst := {};
    if type(expr, function) then
      tmp1 := op(0, expr);
      if onlyD then
        tmp2 := op(0, tmp1);
        if type(tmp1, function) and (type(tmp2, symbol) or
           type(tmp2, indexed)) then
          lst := {tmp1} union IndigoUtils:-GetFunctions(op(1, expr), onlyD);
        end if;
      else
        lst := {tmp1} union IndigoUtils:-GetFunctions(op(1, expr), onlyD);
      end if;
    else
      for e in expr do
        if type(e, constant) or type(e, symbol) then
        elif type(e, function) then
          lst := lst union IndigoUtils:-GetFunctions(e, onlyD);
        elif type(e, algebraic) then
          lst := lst union IndigoUtils:-GetFunctions(e, onlyD);
        end if;
      end do;
    end if;
    return lst;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetFunctionsInList := proc (
    expr::{anything},
    fncs::{list},
    $)::{anything};

    description "Extract the list of the functions in the expression <expr> "
      "that are also in the list of functions <fncs>.";

    local e, lst, tmp1, tmp2;

    lst := {};
    if type(expr, function) then
      tmp1 := expr: # op(0, expr);
      if has(fncs,op(0,expr)) then
        if nops(expr) > 0 then
          lst := {tmp1} union IndigoUtils:-GetFunctionsInList(op(1, expr), fncs);
        else
          lst := {tmp1};
        end if;
      else
        if nops(expr) > 0 then
          lst := {} union IndigoUtils:-GetFunctionsInList(op(1, expr), fncs);
        end if;
      end if;
    else
      for e in expr do
        if type(e, constant) or type(e, symbol) then
        elif type(e, function) then
          lst := lst union IndigoUtils:-GetFunctionsInList(e, fncs);
        elif type(e, algebraic) then
          lst := lst union IndigoUtils:-GetFunctionsInList(e, fncs);
        end if;
      end do
    end if;
    return lst;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetSymbols := proc(
    expr::{anything},
    $)::{anything};

    description "Extracts the list of the symbols in the expression <expr>.";

    local e, s, lst;

    lst := {};
    for e in expr do
      if type(e, constant) then
      elif type(e, symbol) then
        s := eval(e);
        if type(s, symbol) then
          lst := lst union {e};
        else
          lst := lst union IndigoUtils:-GetSymbols(s);
        end
      elif type(e, algebraic) then
        lst := lst union IndigoUtils:-GetSymbols(e);
      end if;
    end do;
    return lst;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetFunctionPrototype := proc(
    expr::{anything},
    $)::{anything};

    description "Extracts the function prototype from an expression <expr> of "
      "type 'f(x) = body' or 'f(x)'.";

    if type(expr, `=`) then
      return lhs(expr);
    else
      return expr;
    end if;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetFunctionName := proc(
    expr::{anything},
    $)::{anything};

    description "Extracts the function name from an expression <expr> of type "
      "'f(x) = body' or 'f(x)'.";

    local out;

    if type(expr, `=`) then
      out := op(1, expr);
    else
      out := expr;
    end if;
    if type(out, function) then
      return op(0, out);
    else
      IndigoUtils:-ErrorMessage(
        "IndigoUtils::GetFunctionName(...): function expected.\n"
      );
    end if;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetFunctionBody := proc(
    expr::{anything},
    $)::{anything};

    description "Extracts the body from an expression <expr> of type 'f(x) = "
      "body' or 'f(x)'.";

    if type(expr, `=`) then
      return op(2, expr);
    else
      return expr;
    end if;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  IsDependentOn := proc(
    expr::{algebraic},
    vars::{list(function)},
    $)::{boolean};

    description "Checks if the expression <expr> depends on the list of "
      "variables <vars>.";

    local i;

    for i in vars do
      if (has(expr, i)) then
        return true;
      end if;
    end do;
    return false;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetSymbolsRecurr := proc (
    expr::{anything},
    $)::{set, list};

    description "Extracts the set/list of the symbols recursively from the "
      "expression <expr>.";

    local tmp, key, kv;

    if type(expr, indexed) then
      return {};
    end if;

    if type(expr, Array) then
      return IndigoUtils:-GetSymbolsRecurr(convert(expr, list));
    end if;

    if type(expr, table) then
      return IndigoUtils:-GetSymbolsRecurr(op(2, op(1, expr)));
    end if;

    if type(expr, list) then
      if (nops(expr) = 0) then
        return {};
      elif type(expr, list(table)) then
        tmp := {};
        for key in expr do
          tmp := tmp union IndigoUtils:-GetSymbolsRecurr(key);
        end do;
        return tmp;
      elif type(expr, list(function(symbol))) then
        return IndigoUtils:-GetSymbols(expr);
      #elif type(expr, list({string,symbol})) then
      # We have to check that it is not only a list of strings,
      # while it can be a list of parameters (symbols)
      elif type(expr, list(string)) then
        return {};
      elif type(expr, list(algebraic)) then
        return IndigoUtils:-GetSymbols(expr);
      elif type(expr, list(anything = anything)) then
        tmp := {};
        for kv in expr do
          tmp := tmp union IndigoUtils:-GetSymbolsRecurr(rhs(kv));
        end do;
        return tmp;
      elif type(expr, list(anything)) then
        tmp := {};
        for kv in expr do
          tmp := tmp union IndigoUtils:-GetSymbolsRecurr(kv);
        end do;
        return tmp;
      else
        return {};
      end if;
    elif type(expr, anything = anything) then
      return IndigoUtils:-GetSymbols(rhs(expr));
    elif type(expr, algebraic) then
      return IndigoUtils:-GetSymbols(expr);
    elif type(expr, string) then
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

  GetPermSortedList := proc(
    var::{list},
    $)::{list};

    description "Compute the permutation that sorts a list <var>.";

    local var_sorted, perm, i;

    var_sorted := sort(var);
    perm       := [];
    for i in var do;
      perm := [op(perm), ListTools:-Search(i, var_sorted)];
    end do;
    return perm;
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  GetExpressionCost := proc(
    var::{algebraic},
    $)::{integer};

  description "Compute the overall cost of an algebraic expression <var> and "
    "return the overall cost number of mathematical operations as (additions + "
    "multiplications + divisions + functions)";

    local out;

    out := codegen:-cost(var);
    out := coeffs(out, [additions, multiplications, functions, divisions]);
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

  cprintf := proc(
    fg::{anything},
    bg::{anything},
    fmt::{anything}
    )::{nothing};

    description "Print a message in color where <fg> is the foreground color, "
      "<bg> is the background color, <fmt> is the format string, and the "
      "remaining inputs are string arguments";

    print(Typesetting:-mtext(
      sprintf(fmt, _passed[4..-1]),
      mathcolor = fg, mathbackground = bg#, fontweight = "bold"
    ));
    return NULL;
  end proc; # cprintf

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ErrorMessage := proc()::{nothing};

    description "Print an error message.";

    ERROR(cat(sprintf(_passed), "\n"));
    return NULL;
  end proc: # ErrorMessage

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  WarningMessage := proc()::{nothing};

    description "Print a warning message.";

    WARNING(cat(_passed, "\n"));
    return NULL;
  end proc: # WarningMessage

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  PrintTitle := proc()::{nothing};

    description "Print a title.";

    local str, len;

    str := sprintf(_passed);
    len := StringTools:-Length(str);
    printf(
      "\n%s\n%s\n\n",
      str, StringTools:-SubString(cat(
        "====================================================================",
        "===================================================================="
        ), 1..len)
    );
    return NULL;
  end proc: # PrintTitle

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  PrintHeader := proc()::{nothing};

    description "Print a header.";

    local str, len;

    str := sprintf(_passed);
    len := StringTools:-Length(str);
    printf(
      "\n%s\n%s\n",
      str, StringTools:-SubString(cat(
        "--------------------------------------------------------------------",
        "--------------------------------------------------------------------"
        ), 1..len)
    );
    return NULL;
  end proc: # PrintHeader

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  PrintMessage := proc()::{nothing};

    description "Print a message.";

    printf(_passed);
    return NULL;
  end proc: # PrintMessage

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Assert := proc(
    check::{anything}
    )::{nothing};

    description "Check if a condition <check> is true and prints an error "
      "message if it is not.";

    if not check then
      IndigoUtils:-ErrorMessage(_passed[2..-1]);
    end if;
    return NULL;
  end proc: # Assert

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Warning := proc(
    check::{anything}
    )::{nothing};

    description "Check if a condition <check> is true and prints a warning "
      "message if it is not.";

    if not check then
      IndigoUtils:-WarningMessage(_passed[2..-1]);
    end if;
    return NULL;
  end proc: # Warning

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

end module: # IndigoUtils

# That's all folks!