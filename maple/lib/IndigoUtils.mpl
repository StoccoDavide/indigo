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
# This is a module for the 'IndigoUtils' module. It contains the auxiliary
# functions to be used in the 'Indigo' module.

IndigoUtils := module()

  description "Utilities for the 'Indigo' module.";

  option package,
         load   = ModuleLoad,
         unload = ModuleUnload;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local ModuleLoad := proc()
    description "'IndigoUtils' module load procedure.";
    return NULL;
  end proc: # ModuleLoad

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local ModuleUnload := proc()
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

  export DropPrefix := proc(
    str::string,
    $)::string;

    description "Drop the prefix of the input string <str>.";

    return StringTools:-RegSubs("([^#]+)#"="", str);
  end proc: # DropPrefix

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetPosition := proc(
    var::{symbol, function, integer},
    lst::list,
    $)::integer;

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
        error(
          "failed for %s in %s.",
          convert(var, string), convert(lst, string)
        );
      end if;
    elif type(var, integer) then
      i;
    else
      error(
        "failed for %s in %s.",
        convert(var, string), convert(lst, string)
      );
    end if;
    return i;
  end proc: # GetPosition

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export CheckParam := proc(
    param::anything,
    param_name::string,
    param_type::anything,
    where::string,
    $)

    description "Check if the parameter <param>, with name <param_name> is of "
      "type <param_type>.";

    if not type(param, param_type) then
      printf(
        "IndigoUtils::GetPosition(...): parameter `%s` = %a\n",
        param_name, param
      );
      error(
        "parameter `%s` is of type `%s`, expected of type `%s` in %s\n",
        param_name, convert(whattype(param), string), convert(tp, string), where
      );
    end if;
    return NULL;
  end proc: # CheckParam

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export CheckTableField := proc(
    tab::table,
    param_field::string,
    msg::string,
    param_type::anything,
    $)

    description "Check if the parameter field <param_field> in table <tab> is "
      "of type <param_type>, if not print and error message <msg>.";

    if not type(tab, table) then
      error(msg);
    end if;
    if not member(param_field, [indices(t, 'nolist')]) then
      error(msg);
    end if;
    IndigoUtils:-CheckParam(
      tab[param_field], param_field, param_type, "CheckTableField"
    );
    return NULL;
  end proc: # CheckTableField

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export CheckTableName := proc(
    tab::table,
    param_name::string,
    param_type::anything,
    where::string,
    $)

    description "Check is the parameter name <param_name> in table <tab> is of "
      "type <param_type>.";

    local keywords;

    keywords := {indices(tab,'nolist')};
    if not (param_name in keywords) then
      error(
        "missing keyword `%s` in %s.\nKeywords: %a.",
        convert(param_name, string), where, keywords
      );
    end if;
    if not type(tab[param_name], param_type) then
      printf("Parameter `%s` = %a\n", param_name, tab[param_name]);
      error(
        "parameter `%s` is of type `%s`, expected of type `%s` in %s.",
        param_name, convert(whattype(tab[param_name]), string),
        convert(param_type, string), where
      );
    end if;
    return NULL;
  end proc: # CheckTableName

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ToString := proc(
    var::anything,
    $)::string;

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

  export ToStringAndSplit := proc(
    var::anything,
    $)::string;

    description "Convert a variable <var> into multiple strings. Variables of "
      "type 'x[dot](t)' are converted into 'x_dot(t)'.";

    local str;

    if type(var, string) then
      str := var;
    else
      str := IndigoUtils:-ToString(var);
    end if;
    if (StringTools:-Length(str) > 512) then
      str := StringTools:-Join(
        [StringTools:-LengthSplit(str, 512)], """+\n\t"""
      );
    end if;
    # We do not substitute " with \" but ' with \'
    str := StringTools:-SubstituteAll(str, "'", "\\'");
    return str;
  end proc: # ToStringAndSplit

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ToRubyString := proc(
    var::anything,
    $)::string;

    description "Convert a variable <var> into a Ruby string. Variables of type "
      "'x[dot](t)' are converted into 'x_dot(t)'.";

    local str;

    str := IndigoUtils:-ToString(var);
    if (StringTools:-Length(str) > 512) then
      str := StringTools:-Join(
        [StringTools:-LengthSplit(str, 512)], """+\n\t"""
      );
    end if;
    return cat("""", str, """");
  end proc: # ToRubyString

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export CatSymbol := proc(
    # _passed
    )::symbol;

    description "Concatenates input symbols.";

    return convert(cat(_passed), symbol);
  end proc: # CatSymbol

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ToSymbol := proc(
    pre::{symbol, string},
    var::{symbol, string},
    post::{symbol, string},
    $)::symbol;

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

  export ToVector := proc(
    var::anything,
    $)::Vector;

    description "Convert a variable <var> to a column vector.";

    return convert(convert(var, list), Vector);
  end proc: # ToVector

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export JoinSymbols := proc(
    # _passed
    )::symbol;

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

  export DoDiff := proc(
    # _passed
    )::anything;

    description "Differentiate an expression with respect to a function.";

    local i, tmp1, tmp2, out;

    tmp2 := diff(subs(f = tmp1, out), tmp1);
    subs(tmp1 = f, convert(tmp2, D));
    out := _passed[1];
    for i from 2 to _npassed do
      tmp2 := diff(subs(_passed[i] = tmp1, out), tmp1);
      out  := subs(tmp1 = _passed[i], convert(tmp2, D));
    end do;
    return out;
  end proc: # DoDiff

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export DoGradient := proc(
    fnc::algebraic,
    lst::{Vector, list},
    $)::Vector;

    description "Differentiate a scalar expression <fnc> with respect to a "
      "list of functions <lst>.";

    local i, n, out;

    # Extract dimensions
    if type(lst, Vector) then
      n := LinearAlgebra:-Dimension(lst);
    else
      n := nops(lst);
    end if;

    # Differentiate
    out := Vector(n);
    for i from 1 to n do
      out[i] := IndigoUtils:-DoDiff(fnc, lst[i]):
    end do;
    return out;
  end proc: # DoGradient

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export DoHessian := proc(
    fnc::algebraic,
    lst::{Vector, list},
    $)::Matrix;

    description "Differentiate a vector of expressions (gradient) <fnc> with "
      "respect to a list <lst> of functions.";

    local i, j, n, out;

    # Extract dimensions
    if type(lst, Vector) then
      n := LinearAlgebra:-Dimension(lst);
    else
      n := nops(lst);
    end if;

    # Differentiate
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

  export DoJacobian := proc(
    fnc::Vector,
    lst::{Vector, list},
    $)::Matrix;

    description "Differentiate a vector of expressions <fnc> with respect to a "
      "list <lst> of functions.";

    local i, j, m, n, out;

    # Extract dimensions
    m := LinearAlgebra:-Dimension(fnc);
    if type(lst, Vector) then
      n := LinearAlgebra:-Dimension(lst);
    else
      n := nops(lst);
    end if;

    # Differentiate
    out := Matrix(m, n);
    for i from 1 to m do
      for j from 1 to n do
        out[i, j] := IndigoUtils:-DoDiff(fnc[i], lst[j]);
      end do;
    end do;
    return out;
  end proc: # DoJacobian

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export DoTensor := proc(
    mat::Matrix,
    lst::{Vector, list},
    $)::Array;

    description "Differentiate a matrix <mat> with respect to a list of "
      "functions <lst>.";

    local i, j, k, m, n, l, out;

    # Extract dimensions
    m := LinearAlgebra:-RowDimension(mat);
    n := LinearAlgebra:-ColumnDimension(mat);
    if type(lst, Vector) then
      l := LinearAlgebra:-Dimension(lst);
    else
      l := nops(lst);
    end if;

    # Differentiate
    out := Array(1..m, 1..n, 1..l);
    for i from 1 to m do
      for j from 1 to n do
        for k from 1 to l do
          out[i, j, k] := IndigoUtils:-DoDiff(mat[i, j], lst[k]);
        end do;
      end do;
    end do;
    return out;
  end proc: # DoTensor

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #   _____                 _   _
  #  |  ___|   _ _ __   ___| |_(_) ___  _ __
  #  | |_ | | | | '_ \ / __| __| |/ _ \| '_ \
  #  |  _|| |_| | | | | (__| |_| | (_) | | | |
  #  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|
  #
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ExtractSubs := proc(
    pars::list,
    $)::list;

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
  end proc: # ExtractSubs

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetFunctions := proc(
    expr::anything,
    onlyD::boolean := false,
    $ )::anything;

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
  end proc: # GetFunctions

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetFunctionsInList := proc(
    expr::anything,
    fncs::list,
    $)::anything;

    description "Extract the list of the functions in the expression <expr> "
      "that are also in the list of functions <fncs>.";

    local e, lst, tmp1, tmp2;

    lst := {};
    if type(expr, function) then
      tmp1 := expr: # op(0, expr);
      if has(fncs, op(0, expr)) then
        if (nops(expr) > 0) then
          lst := {tmp1} union IndigoUtils:-GetFunctionsInList(op(1, expr), fncs);
        else
          lst := {tmp1};
        end if;
      else
        if (nops(expr) > 0) then
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
  end proc: # GetFunctionsInList

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetSymbols := proc(
    expr::anything,
    $)::anything;

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
  end proc: # GetSymbols

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetFunctionPrototype := proc(
    expr::anything,
    $)::anything;

    description "Extracts the function prototype from an expression <expr> of "
      "type 'f(x) = body' or 'f(x)'.";

    if type(expr, `=`) then
      return lhs(expr);
    else
      return expr;
    end if;
  end proc: # GetFunctionPrototype

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetFunctionName := proc(
    expr::anything,
    $)::anything;

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
      error("invalid input detected.");
    end if;
  end proc: # GetFunctionName

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetFunctionBody := proc(
    expr::anything,
    $)::anything;

    description "Extracts the body from an expression <expr> of type 'f(x) = "
      "body' or 'f(x)'.";

    if type(expr, `=`) then
      return op(2, expr);
    else
      return expr;
    end if;
  end proc: # GetFunctionBody

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export IsDependentOn := proc(
    expr::algebraic,
    vars::list(function),
    $)::boolean;

    description "Checks if the expression <expr> depends on the list of "
    "variables <vars>.";

    local i;

    for i in vars do
      if (has(expr, i)) then
        return true;
      end if;
    end do;
    return false;
  end proc: # IsDependentOn

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetSymbolsRecurr := proc(
    expr::anything,
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
      #elif type(expr, list({string, symbol})) then
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
  end proc: # GetSymbolsRecurr

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #   __  __ _              _ _
  #  |  \/  (_)___  ___ ___| | | __ _ _ __   ___  ___  _   _ ___
  #  | |\/| | / __|/ __/ _ \ | |/ _` | '_ \ / _ \/ _ \| | | / __|
  #  | |  | | \__ \ (_|  __/ | | (_| | | | |  __/ (_) | |_| \__ \
  #  |_|  |_|_|___/\___\___|_|_|\__,_|_| |_|\___|\___/ \__,_|___/
  #
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetPermSortedList := proc(
    var::list,
    $)::list;

    description "Compute the permutation that sorts a list <var>.";

    local var_sorted, perm, i;

    var_sorted := sort(var);
    perm       := [];
    for i in var do;
      perm := [op(perm), ListTools:-Search(i, var_sorted)];
    end do;
    return perm;
  end proc: # GetPermSortedList

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

end module: # IndigoUtils

# That's all folks!
