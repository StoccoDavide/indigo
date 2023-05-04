# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#    ___           _ _              ____          _                           #
#   |_ _|_ __   __| (_) __ _  ___  / ___|___   __| | ___  __ _  ___ _ __      #
#    | || '_ \ / _` | |/ _` |/ _ \| |   / _ \ / _` |/ _ \/ _` |/ _ \ '_ \     #
#    | || | | | (_| | | (_| | (_) | |__| (_) | (_| |  __/ (_| |  __/ | | |    #
#   |___|_| |_|\__,_|_|\__, |\___/ \____\___/ \__,_|\___|\__, |\___|_| |_|    #
#                      |___/                             |___/                #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Authors: Davide Stocco (University of Trento)
#          Enrico Bertolazzi (University of Trento)
#
# License: BSD 3-Clause License
#
# This is a module for the 'IndigoCodegen' module. It contains the functions to
# translate the Maple code into Matlab code.

IndigoCodegen := module()

  description "Code Generation for the 'IndigoCodegen' module.";

  option package,
         load   = ModuleLoad,
         unload = ModuleUnload;

  local m_CodegenOptions;
  local m_WorkingDirectory;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local ModuleLoad := proc()
    description "'IndigoCodegen' module load procedure.";
    m_CodegenOptions := table([
      optimize          = true,
      digits            = 30,
      deducereturn      = false,
      coercetypes       = false,
      deducetypes       = false,
      reduceanalysis    = true,
      defaulttype       = numeric,
      functionprecision = double
    ]);
    return NULL;
  end proc: # ModuleLoad

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local ModuleUnload := proc()
    description "'IndigoCodegen' module unload procedure.";
    return NULL;
  end proc: # ModuleUnload

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export SetWorkingDirectory := proc(
    dname::string,
    $)

    description "Set the working directory to <dname> for the code generation.";

    m_WorkingDirectory := cat(currentdir(), "/", dname, "/");
    try
      mkdir(m_WorkingDirectory);
    catch:
      printf("Working directory already exists.\n");
    end try;
    printf("Working directory: %s\n", m_WorkingDirectory);
    return NULL;
  end proc: # SetWorkingDirectory

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GenerateFile := proc(
    fname::string,
    str::string,
    $)

    description "Generate a file named <fname> with the content <str>.";

    local file;

    file := FileTools:-Text:-Open(fname, create = true, overwrite = true);
    FileTools:-Text:-WriteString(file, str);
    FileTools:-Text:-Close(file);
    return NULL;
  end proc: # GenerateFile

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ClearFile := proc(
    fname::string,
    $)

    description "Procedure that creates an empty file <fname>.";

    local file;

    file := FileTools:-Text:-Open(fname, create = true, overwrite = true);
    FileTools:-Text:-WriteString(file, "\n");
    FileTools:-Text:-Close(file);
    return NULL;
  end proc: # ClearFile

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export SetCodegenOptions := proc({
      optimize::boolean         := m_CodegenOptions[parse("optimize")],
      digits::posint            := m_CodegenOptions[parse("digits")],
      deducereturn::boolean     := m_CodegenOptions[parse("deducereturn")],
      coercetypes::boolean      := m_CodegenOptions[parse("coercetypes")],
      deducetypes::boolean      := m_CodegenOptions[parse("deducetypes")],
      reduceanalysis::boolean   := m_CodegenOptions[parse("reduceanalysis")],
      defaulttype::symbol       := m_CodegenOptions[parse("defaulttype")],
      functionprecision::symbol := m_CodegenOptions[parse("functionprecision")]
    }, $)

    description "Set options for code generation optimization.";

    m_CodegenOptions[parse("optimize")]          := optimize;
    m_CodegenOptions[parse("digits")]            := digits;
    m_CodegenOptions[parse("deducereturn")]      := deducereturn;
    m_CodegenOptions[parse("coercetypes")]       := coercetypes;
    m_CodegenOptions[parse("deducetypes")]       := deducetypes;
    m_CodegenOptions[parse("reduceanalysis")]    := reduceanalysis;
    m_CodegenOptions[parse("defaulttype")]       := defaulttype;
    m_CodegenOptions[parse("functionprecision")] := functionprecision;
    return NULL;
  end proc: # SetCodegenOptions

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export GetCodegenOptions := proc(
    field::string := "all",
    $)

    description "Get options for CodeGeneration.";

    if (field = "all") then
      return m_CodegenOptions;
    else
      return m_CodegenOptions[parse(field)];
    end if;
  end proc: # GetCodegenOptions

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local TranslateToMatlab := proc(
    expr_list::list,
    $)

    description "Convert a list of expressions <expr_list> into Matlab code.";

    local i, lang_fncs;

    # Define language functions
    lang_fncs := ["floor", "ceil", "round", "trunc", "erf"];

    # Define new language
    CodeGeneration:-LanguageDefinition:-Define(
      "NewMatlab", extend = "Matlab",
      seq(AddFunction(
        lang_fncs[i], anything::numeric, lang_fncs[i]
      ), i = 1..nops(lang_fncs))
    );

    # Generate code
    return CodeGeneration:-Translate(
      expr_list,
      language = "NewMatlab",
      op(op(eval(m_CodegenOptions))),
      output = string
    );
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local ApplyIndent := proc(
    ind::string,
    str::string,
    $)::string;

    description "Apply indentation <ind> to string <str>.";

    local out;

    # Apply initial indentation
    out := cat(ind, str);

    # Apply indentation to each line
    out := StringTools:-SubstituteAll(out, "\n", cat("\n", ind));

    # Remove indentation from last line
    out := StringTools:-Take(out, length(out) - length(ind));

    # Remove indentation empty lines or lines with only spaces
    out := StringTools:-SubstituteAll(out, "\n" || ind || "\n", "\n\n");

    return out
  end proc: # ApplyIndent

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local GenerateProperties := proc(
    data::list(symbol),
    {
    indent::string := "  "
    }, $)::string;

    description "Generate properties code from a list of data <data> and "
      "optional indentation <indent>.";

    local i, out;

    if (nops(data) > 0) then
      out := "";
      for i from 1 to nops(data) do
        convert(data[i], string);
        out := cat(out, indent, %, " = this.m_", %, ";\n");
      end do;
    else
      out := cat(indent, "% No properties\n");
    end if;
    return out;
  end proc: # GenerateProperties

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local GenerateInputs := proc(
    vars::list(list(symbol)),
    {
    indent::string := "  "
    }, $)::string;

    description "Generate inputs code from a list of variables <vars> and "
      "optional indentation <indent>.";

    local i, j, out;

    out := "";
    for j from 1 to nops(vars) do
      for i from 1 to nops(vars[j]) do
        convert(vars[j][i], string);
        out := cat(out, indent, %, " = in_", j, "(", i, ");\n");
      end do;
    end do;
    return out;
  end proc: # GenerateInputs

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local ExtractElements := proc(
    name::string,
    func::{list, Vector, Matrix, array},
    dims::list(nonnegint),
    {
    indent::string := "  "
    }, $)::list, string;

    description "Extract elements for a n-dimensional function <func> with "
      "name <name>, dimensions <dims> and optional indentation <indent>.";

    local i, j, idx, lst, out, cur, tmp, str1, str2;

    lst  := [];
    out  := "";
    for i from 1 to mul(dims) do
      cur := [];
      idx := i-1;
      for j from 1 to nops(dims) do
        cur := [op(cur), irem(idx, dims[j],'idx')+1 ];
      end;
      tmp := func[op(cur)];
      if evalb(tmp <> 0) then
        map(x -> (x, "_"), cur); str1 := cat("out_", op(%))[1..-2];
        lst := [op(lst), convert(str1, symbol) = tmp];
        map(x -> (x, ", "), cur); str2 := cat("", op(%))[1..-3];
        out := cat(out, indent, "out_", name, "(", str2, ") = ", str1, ";\n");
      end if;
    end do;
    return lst, out;
  end proc: # GenerateInputs

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local GenerateHeader := proc(
    name::string,
    vars::list(list(symbol)),
    {
    info::string   := "No description provided.",
    indent::string := "  "
    }, $)::string;

    description "Generate a function header for a function <name> with "
      "variables <vars>, optional description <info> and indentation "
      "<indent>.";

    local i, out;

    out := cat("function out_", name, " = ", name, "( this");
    for i from 1 to nops(vars) do
      out := cat(out, ", ", "in_", i);
    end do;
    return cat(out, ", t )\n", indent, "% ", info, "\n\n");
    return out;
  end proc: # GenerateHeader

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local GenerateElements := proc(
    func::{list, Vector, Matrix, array},
    {
    indent::string := "  "
    }, $)::string;

    description "Generate code for elements <func> with optional indentation "
      "<indent>.";

    IndigoCodegen:-TranslateToMatlab(func);
    return IndigoCodegen:-ApplyIndent(indent,
      `if`(% = "", "% No elements\n", %)
    );
  end proc: # GenerateElements

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local GenerateBody := proc(
    name::string,
    dims::list(nonnegint),
    {
    header::string      := "No header",
    properties::string  := "No properties",
    inputs::string      := "No inputs",
    veils::string       := "No veils",
    elements::string    := "No elements",
    outputs::string     := "No outputs",
    indent::string      := "  "
    }, $)::string;

    description "Generate code for function body for a function <name> with "
      "dimensions <dims>, optional header <header>, properties <properties>, "
      "inputs <inputs>, veils <veils>, elements <elements> and "
      "indentation <indent>.";

    local tmp;

    tmp := cat(seq(cat(dims[i], ", "), i = 1..nops(dims)-1), dims[-1]);
    if (nops(dims) <= 1) then
      tmp := cat(tmp, ", 1");
    end if;

    return cat(
      header,
      indent, "% Extract properties\n", properties, "\n",
      indent, "% Extract inputs\n",     inputs,     "\n",
      indent, "% Evaluate function\n",  elements,   "\n",
      indent, "% Store outputs\n",
      indent, "out_", name, " = zeros(", tmp, ");\n",
      outputs,
      "end % ", name, "\n"
    );
  end proc: # GenerateBody

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local VectorToMatlab := proc(
    name::string,
    vars::list(list(symbol)),
    vec::{list, Vector},
    {
    data::list(symbol) := [],
    info::string       := "No info",
    indent::string     := "  "
    }, $)::string;

    description "Translate the vector <vec> with variables <vars> into a "
      "Matlab function named <name> and return it as a string. The optional "
      "arguments areclass properties <data>, function description <info>, and "
      "indentation string <indent>.";

    local header, properties, inputs, veils, elements, outputs, dims, lst;

    # Extract the function properties
    properties := IndigoCodegen:-GenerateProperties(
      data, parse("indent") = indent
    );

    # Extract the function inputs
    inputs := IndigoCodegen:-GenerateInputs(
      vars, parse("indent") = indent
    );

    # Extract the function elements
    dims := [LinearAlgebra:-Dimension(vec)];
    lst, outputs := IndigoCodegen:-ExtractElements(
      name, vec, dims, parse("indent") = indent
    );

    # Generate the method header
    header := IndigoCodegen:-GenerateHeader(
      name, vars, parse("info") = info, parse("indent") = indent
    );

    # Generate the elements
    elements := IndigoCodegen:-GenerateElements(lst);

    # Generate the generated code
    return IndigoCodegen:-GenerateBody(
      name, dims,
      parse("header") = header, parse("properties") = properties,
      parse("inputs") = inputs, parse("elements")   = elements,
      parse("indent") = indent, parse("outputs")    = outputs
    );
  end proc: # VectorToMatlab

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local MatrixToMatlab := proc(
    name::string,
    vars::list(list(symbol)),
    mat::Matrix,
    {
    data::list(symbol) := [],
    info::string       := "No info",
    indent::string     := "  "
    }, $)::string;

    description "Translate the vector <vec> with variables <vars> into a "
      "Matlab function named <name> and return it as a string. The optional "
      "arguments areclass properties <data>, function description <info>, and "
      "indentation string <indent>.";

    local header, properties, inputs, veils, elements, outputs, dims, lst;

    # Extract the function properties
    properties := IndigoCodegen:-GenerateProperties(
      data, parse("indent") = indent
    );

    # Extract the function inputs
    inputs := IndigoCodegen:-GenerateInputs(
      vars, parse("indent") = indent
    );

    # Extract the function elements
    dims := [LinearAlgebra:-Dimensions(mat)];
    lst, outputs := IndigoCodegen:-ExtractElements(
      name, mat, dims, parse("indent") = indent
    );

    # Generate the method header
    header := IndigoCodegen:-GenerateHeader(
      name, vars, parse("info") = info, parse("indent") = indent
    );

    # Generate the elements
    elements := IndigoCodegen:-GenerateElements(lst);

    # Store the results
    return IndigoCodegen:-GenerateBody(
      name, dims,
      parse("header") = header, parse("properties") = properties,
      parse("inputs") = inputs, parse("elements")   = elements,
      parse("indent") = indent, parse("outputs")    = outputs
    );
  end proc: # MatrixToMatlab

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local TensorToMatlab := proc(
    name::string,
    vars::list(list(symbol)),
    ten::Array,
    {
    data::list(symbol) := [],
    info::string       := "No info",
    indent::string     := "  "
    }, $)::string;

    description "Translate the vector <vec> with variables <vars> into a "
      "Matlab function named <name> and return it as a string. The optional "
      "arguments areclass properties <data>, function description <info>, and "
      "indentation string <indent>.";

    local header, properties, inputs, veils, elements, outputs, dims, lst;

    # Extract the function properties
    properties := IndigoCodegen:-GenerateProperties(
      data, parse("indent") = indent
    );

    # Extract the function inputs
    inputs := IndigoCodegen:-GenerateInputs(
      vars, parse("indent") = indent
    );

    # Extract the function elements
    dims := [op~(2, [ArrayDims(ten)])];
    lst, outputs := IndigoCodegen:-ExtractElements(
      name, ten, dims, parse("indent") = indent
    );

    # Generate the method header
    header := IndigoCodegen:-GenerateHeader(
      name, vars, parse("info") = info, parse("indent") = indent
    );

    # Generate the elements
    elements := IndigoCodegen:-GenerateElements(lst);

    # Generate the generated code
    return IndigoCodegen:-GenerateBody(
      name, dims,
      parse("header") = header, parse("properties") = properties,
      parse("inputs") = inputs, parse("elements")   = elements,
      parse("indent") = indent, parse("outputs")    = outputs
    );
  end proc: # TensorToMatlab

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local GetVeilSubs := proc(
    veil::{Vector(algebraic), list(algebraic)},
    vars::{Vector(algebraic), list(algebraic)},
    $)

    description "Get the substitutions to transform veils <vars> from "
      "(v[j])(f) to v_j and from D[i](v[j])(f) to D_i_v_j. The function also "
      "requires the system states <vars>.";

    local v, v_dot, x, rm_v_deps, rm_v_dot_deps, i, v_tmp, v_dot_tmp, tmp_l, tmp_r;

    # Store veiling variables
    if not type(veil, list) then
      v := convert(veil, list);
    else
      v := veil;
    end if;

    # Store system states
    if not type(vars, Vector) then
      x := convert(vars, Vector);
    else
      x := vars;
    end if;

    # Compute transformations
    if (nops(v) > 0) then

      # Transform veil variables (v[i,j])(f) -> v_ij
      v_tmp := v;
      for i from 1 to nops(v_tmp) do
        # (v[i,j])(f) -> v[i,j]
        if type(v_tmp[i], function) then
          v_tmp[i] := op(0, v_tmp[i]);
        end if;
        # v[i,j] -> v_ij
        if type(v_tmp[i], indexed) then
          v_tmp[i] := convert(
            cat(op(0, v_tmp[i]), "_", op(1..-1, v_tmp[i])), symbol
          );
        end if;
      end do;
      rm_v_deps := v =~ v_tmp;

      # Calculate veils derivatives
      # from   [..., v, ...] -> [..., grad(v), ...]
      # remove [..., 0, ...] -> [..., ...]
      v_dot := map(k -> op(convert(
          remove[flatten](j -> j = 0, IndigoUtils:-DoGradient(k, x)),
        list)), v
      );

      # Transform veils derivatives from D[i](v[j])(f) to D_i_v_j
      v_dot_tmp := v_dot;
      for i from 1 to nops(v_dot_tmp) do
        # D[i](var[j])(f) -> D_i
        tmp_l := op(0, op(0, v_dot_tmp[i]));
        # D[i](var[j])(f) -> D_i
        if type(tmp_l, indexed) then
          tmp_l := convert(cat(op(0, tmp_l), "_", op(1..-1, tmp_l)), symbol);
        end if;
        # D[i](var[j])(f) -> D_i
        tmp_r := op(1, op(0, v_dot_tmp[i]));
        # D[i](var[j])(f) -> var_j
        if type(tmp_r, indexed) then
          tmp_r := convert(cat(op(0, tmp_r), "_", op(1..-1, tmp_r)), symbol);
        end if;
        v_dot_tmp[i] := convert(cat(tmp_l, "_", tmp_r), symbol);
      end do;
      rm_v_dot_deps := v_dot =~ v_dot_tmp;

    end if;

    # Return output
    return rm_v_deps, rm_v_dot_deps;
  end proc: # GetVeilSubs

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #   ___                 _ _      _ _
  #  |_ _|_ __ ___  _ __ | (_) ___(_) |_
  #   | || '_ ` _ \| '_ \| | |/ __| | __|
  #   | || | | | | | |_) | | | (__| | |_
  #  |___|_| |_| |_| .__/|_|_|\___|_|\__|
  #                |_|
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ImplicitSystemToMatlab := proc(
    name::string,
    vars::{Vector(algebraic), list(algebraic)},
    eqns::{Vector(algebraic), list(algebraic)},
    {
    invs::{Vector(algebraic), list(algebraic)} := [],
    veil::{Vector(algebraic) = algebraic,
           list(algebraic = algebraic)} := [],
    data::list(symbol = algebraic)      := [],
    info::string                        := "No class description provided.",
    indent::string                      := "  "
    }, $)::string;

    description "Generate an implicit system for the firt-order differential "
      "equations <eqns>, invariants <invs> with states variables <vars> and "
      "states variables, system data <data> and description <info>.";

    local x, x_dot, F, JF_x, JF_x_dot, v, v_fncs, Jv_x, JF_v, h, Jh_x, Jh_v,
      rm_deps, rm_v_dot_deps, rm_v_deps, rm_x_deps, rm_x_dot_deps, mk_x_dot,
      i, bar, data_str, properties;

    # Store system states and derivatives
    if not type(vars, Vector) then
      x := convert(vars, Vector);
    else
      x := vars;
    end if;
    x_dot := map(x -> convert(cat(op(0, x), "_dot"), symbol)(op(1..-1, x)), x);

    # Prepare veriables for substitution
    # diff(x, t) -> x_dot(t)
    mk_x_dot := convert(diff(x, t) =~ x_dot, list);
    # x(t) -> x
    rm_x_deps := convert(x =~ op~(0, x), list);
    # x_dot(t) -> x_dot
    rm_x_dot_deps := convert(x_dot =~ op~(0, x_dot), list);

    # Store system veils and calculate Jacobians
    if not type(veil, Vector) then
      v_fncs := rhs~(convert(veil, Vector));
    else
      v_fncs := rhs~(veil);
    end if;
    v    := lhs~(veil);
    Jv_x := IndigoUtils:-DoJacobian(v_fncs, x);

    # Get substitutions for veils to remove dependencies
    rm_v_deps, rm_v_dot_deps := IndigoCodegen:-GetVeilSubs(lhs~(veil), x);

    # Store system function and calculate Jacobians
    if not type(eqns, Vector) then
      F := convert(eqns, Vector);
    else
      F := eqns;
    end if;
    F        := subs(op(mk_x_dot), op(rm_v_deps), F);
    JF_x     := IndigoUtils:-DoJacobian(F, x);
    JF_x_dot := IndigoUtils:-DoJacobian(F, x);
    JF_v     := IndigoUtils:-DoJacobian(F, v);

    # Store system invariants and calculate Jacobian
    if not type(invs, Vector) then
      h := convert(invs, Vector);
    else
      h := invs;
    end if;
    h    := subs(op(rm_v_deps), h);
    Jh_x := IndigoUtils:-DoJacobian(h, x);
    Jh_v := IndigoUtils:-DoJacobian(h, v);

    # Compose substitutions
    rm_deps := [
      op(rm_v_dot_deps), # D[i](v[j])(f) -> D_i_v_j
      op(rm_v_deps),     # (v[j])(f) -> v_j
      op(rm_x_deps),     # x(t) -> x
      op(rm_x_dot_deps)  # x_dot(t) -> x_dot
    ];

    # Generate expressions with proper variables dependencices
    x        := convert(subs(op(rm_deps), x), list);
    x_dot    := convert(subs(op(rm_deps), x_dot), list);
    F        := subs(op(rm_deps), F);
    JF_x     := subs(op(rm_deps), JF_x);
    JF_x_dot := subs(op(rm_deps), JF_x_dot);
    v        := convert(subs(op(rm_deps), v), list);
    v_fncs   := subs(op(rm_deps), v_fncs);
    Jv_x     := subs(op(rm_deps), Jv_x);
    JF_v     := subs(op(rm_deps), JF_v);
    h        := subs(op(rm_deps), h);
    Jh_x     := subs(op(rm_deps), Jh_x);
    Jh_v     := subs(op(rm_deps), Jh_v);

    # Function utilities strings
    i   := indent;
    bar := "% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n";

    # Generate properties
    if (nops(data) > 0) then
      data_str   := cat~(op(cat~(i, i, "m_", convert~(data, string), ";\n")));
      properties := lhs~(data);
    else
      data_str   := cat(i, i, "% No Properties\n");
      properties := [];
    end if;

    # Return output string
    return cat(
      "% +--------------------------------------------------------------------------+\n",
      "% | 'Indigo' module version 1.0 - BSD 3-Clause License - Copyright (c) 2023  |\n",
      "% | Current version authors:                                                 |\n",
      "% |   Davide Stocco and Enrico Bertolazzi.                                   |\n",
      "% +--------------------------------------------------------------------------+\n",
      "\n",
      "% Matlab generated code for implicit system: ", name, "\n",
      "% This file has been automatically generated by Indigo.\n",
      "% DISCLAIMER: If you need to edit it, do it wisely!\n",
      "\n",
      "classdef ", name, " < Indigo.Systems.Implicit\n",
      i, "%\n",
      i, "% ", info, "\n",
      i, "%\n",
      i, "properties (SetAccess = protected, Hidden = true)\n",
      i, i, "% User data\n",
      data_str,
      i, "end\n",
      i, "%\n",
      i, "methods\n",
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      i, i, "function this = ", name, "( varargin )\n",
      i, i, i, "% Constructor for '", name, "' class.\n",
      "\n",
      i, i, i, "% Superclass constructor\n",
      i, i, i, "num_eqns = ", LinearAlgebra:-Dimension(F), ";\n",
      i, i, i, "num_veil = ", LinearAlgebra:-Dimension(v_fncs), ";\n",
      i, i, i, "num_invs = ", LinearAlgebra:-Dimension(h), ";\n",
      i, i, i, "this = this@Indigo.Systems.Implicit('", name, "', num_eqns, num_veil, num_invs);\n",
      `if`(nops(data) > 0, cat(
      "\n",
      i, i, i, "% User data\n",
      i, i, i, "if (nargin == 0)\n",
      i, i, i, i, "% Keep default values\n",
      i, i, i, "elseif (nargin == ", nops(properties), ")\n",
      cat~(op(cat~("        this.m_", convert~(properties, string), " = varargin{",
        convert~([seq(1..nops(properties))], string), "};\n"))),
      i, i, i, "else\n",
      i, i, i, i, "error('wrong number of input arguments.');\n",
      i, i, i, "end\n"
      ), ""),
      i, i, "end % ", name, "\n",
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "F", [x, x_dot, v], F,
          parse("data") = properties,
          parse("info") = "Evaluate the function F."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "JF_x", [x, x_dot, v], JF_x,
          parse("data") = properties,
          parse("info") = "Evaluate the Jacobian of F with respect to x."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "JF_x_dot", [x, x_dot, v], JF_x_dot,
          parse("data") = properties,
          parse("info") = "Evaluate the Jacobian of F with respect to x_dot."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "JF_v", [x, x_dot, v], JF_v,
          parse("data") = properties,
          parse("info") = "Evaluate the Jacobian of F with respect to v."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "v", [x], v_fncs,
          parse("data") = properties,
          parse("info") = "Evaluate the the veils v."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "Jv_x", [x], Jv_x,
          parse("data") = properties,
          parse("info") = "Evaluate the Jacobian of v with respect to x."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "h", [x, v], h,
          parse("data") = properties,
          parse("info") = "Calculate the residual of the invariants h."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "Jh_x", [x, v], Jh_x,
          parse("data") = properties,
          parse("info") = "Calculate the Jacobian of h with respect to x."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "Jh_v", [x, v], Jh_v,
          parse("data") = properties,
          parse("info") = "Calculate the Jacobian of h with respect to v."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      i, "end\n",
      "end % ", name, "\n",
      "\n",
      "% That's All Folks!\n"
    );
  end proc: # ImplicitSystem

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  _____            _ _      _ _
  # | ____|_  ___ __ | (_) ___(_) |_
  # |  _| \ \/ / '_ \| | |/ __| | __|
  # | |___ >  <| |_) | | | (__| | |_
  # |_____/_/\_\ .__/|_|_|\___|_|\__|
  #            |_|
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ExplicitSystemToMatlab := proc(
    name::string,
    vars::{Vector(algebraic), list(algebraic)},
    eqns::{Vector(algebraic), list(algebraic)},
    invs::{Vector(algebraic), list(algebraic)} := [],
    {
    indent::string                      := "  ",
    algs::{Vector(algebraic) = algebraic,
           list(algebraic = algebraic)} := [],
    data::list(symbol = algebraic)      := [],
    info::string                        := "No class description provided."
    }, $)::string;

    description "Generate an explicit system for the firt-order differential "
      "equations <eqns>, invariants <invs> with states variables <vars> and "
      "states variables, system data <data> and description <info>.";

    local i, bar, vars_tmp, eqns_tmp, invs_tmp, algs_tmp, vars_dot, x, x_dot, A,
      b, f, Jf, h, Jh, GA, mk_algs_var, mk_algs_dot, mk_vars_dot, rm_deps,
      data_str, algs_fun, algs_grd, properties, tmp, tmp1, tmp2;

    # Convert to proper types
    if type(vars, Vector) then
      vars_tmp := convert(vars, list);
    else
      vars_tmp := vars;
    end if;
    if type(eqns, list) then
      eqns_tmp := convert(eqns, Vector);
    else
      eqns_tmp := eqns;
    end if;
    if type(invs, list) then
      invs_tmp := convert(invs, Vector);
    else
      invs_tmp := invs;
    end if;
    if type(algs, Vector) then
      algs_tmp := convert(algs, list);
    else
      algs_tmp := algs;
    end if;

    # Transform symbols diff(var,t) in var_dot(t)
    vars_dot := map(
      x -> convert(cat(op~(0, x), "_dot"), symbol)(op~(1..-1, x)), vars_tmp
    );
    mk_vars_dot := diff(vars_tmp, t) =~ vars_dot;

    # Extract f from: F = A(x,t) * x_dot - b(x,t)
    eqns_tmp := subs(op(mk_vars_dot), eqns_tmp);
    A, b     := LinearAlgebra:-GenerateMatrix(convert(eqns_tmp, list), vars_dot);

    # Check if A is square and full rank
    if (LinearAlgebra:-RowDimension(A) <> LinearAlgebra:-ColumnDimension(A)) or
       (LinearAlgebra:-Rank(A) <> LinearAlgebra:-ColumnDimension(A)) then
      error(
        "the system cannot be transformed into an explicit form, the matrix A "
        "is not square or full rank."
      );
      return NULL;
    end if;

    # Solve for x_dot
    f := LinearAlgebra:-LinearSolve(A, b);

    # Calculate tensor and Jacobians
    eqns_tmp := subs(op(mk_vars_dot), eqns_tmp);
    Jf := IndigoUtils:-DoJacobian(f, vars_tmp);
    Jh := IndigoUtils:-DoJacobian(invs_tmp, vars_tmp);

    # Calculate veils derivatives
    GA          := [];
    mk_algs_var := [];
    mk_algs_dot := [];

    if (nops(algs_tmp) > 0) then
      # Transform veils from (var[j])(f) to var_j
      tmp := map(x -> `if`(
          type(x, function),
          op(0, x),
          x
        ), lhs~(algs_tmp)
      );
      tmp := map(x -> `if`(
          type(x, indexed),
          convert(cat(op(0, x), "_", op(1..-1, x)), symbol),
          x
        ), tmp
      );
      mk_algs_var := lhs~(algs_tmp) =~ map(
        x -> `if`(
          type(op(0, x), indexed),
          convert(cat(op(0, op(0, x)), op(1..-1, op(0, x))), symbol),
          x
        ), tmp
      );

      # Calculate assignments derivatives
      # from     [..., L = R, ...] -> [..., Grad(L) = Grad(R), ...]
      # removing [..., 0 = 0, ...] -> [..., ...]
      GA := map(y -> op(convert(
        remove[flatten](x -> lhs(x) = 0 and rhs(x) = 0,
          IndigoUtils:-DoGradient(lhs(y), vars_tmp) =~
          IndigoUtils:-DoGradient(rhs(y), vars_tmp)
        ), list)), algs_tmp);

      # Transform assignments derivatives from D[i](var[j])(f) to D_i_var_j
      tmp  := lhs~(GA);
      tmp1 := map(
        x -> `if`(type(x, indexed), convert(cat(op(0, x), "_", op(1..-1, x)), symbol), x),
        op~(0, op~(0, %)) # D[i](var[j])(f) -> D[i]
      ); # D[i](var[j])(f) -> D_i
      tmp2 := map(
        x -> `if`(type(x, indexed), convert(cat(op(0, x), "_", op(1..-1, x)), symbol), x),
        op~(1, op~(0, %)) # D[i](var[j])(f) -> var[j]
      ); # D[i](var[j])(f) -> var_j
      # D[i](var[j])(f) -> D_i_var_j
      mk_algs_dot := tmp =~ zip((x, y) -> cat(x, "_", y), tmp1, tmp2 );
    end if;

    # Generate expressions without variable dependency
    rm_deps := [
      op(mk_algs_dot),                  # D[i](var[j])(f) -> D_i_var_j
      op(mk_algs_var),                  # (var[j])(f) -> var_j
      op(vars_tmp =~ op~(0, vars_tmp)), # var(x) -> var
      op(vars_dot =~ op~(0, vars_dot))  # var_dot(x) -> var_dot
    ];
    x        := convert(subs(op(rm_deps), vars_tmp), list);
    x_dot    := convert(subs(op(rm_deps), vars_dot), list);
    f        := subs(op(rm_deps), f);
    Jf       := subs(op(rm_deps), Jf);
    h        := subs(op(rm_deps), invs_tmp);
    Jh       := subs(op(rm_deps), Jh);

    # Generate assignments
    algs_fun := subs(op(rm_deps), algs_tmp);
    algs_grd := [op(algs_fun), op(subs(op(rm_deps), GA))];

    # Function utilities strings
    i   := indent;
    bar := "% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n";

    # Generate properties
    if (nops(data) > 0) then
      data_str   := cat~(op(cat~(i, i, "m_", convert~(data, string), ";\n")));
      properties := lhs~(data);
    else
      data_str   := cat(i, i, "% No Properties\n");
      properties := [];
    end if;

    # Return output string
    return cat(
      "% +--------------------------------------------------------------------------+\n",
      "% | 'Indigo' module version 1.0 - BSD 3-Clause License - Copyright (c) 2023  |\n",
      "% | Current version authors:                                                 |\n",
      "% |   Davide Stocco and Enrico Bertolazzi.                                   |\n",
      "% +--------------------------------------------------------------------------+\n",
      "\n",
      "% Matlab generated code for implicit system: ", name, "\n",
      "% This file has been automatically generated by Indigo.\n",
      "% DISCLAIMER: If you need to edit it, do it wisely!\n",
      "\n",
      "classdef ", name, " < ExplicitSystem\n",
      i, "%\n",
      i, "% ", info, "\n",
      i, "%\n",
      i, "properties (SetAccess = protected, Hidden = true)\n",
      i, i, "% User data\n",
      data_str,
      i, "end\n",
      i, "%\n",
      i, "methods\n",
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      i, i, "function this = ", name, "( varargin )\n",
      i, i, i, "% Constructor for '", name, "' class.\n",
      "\n",
      i, i, i, "% Superclass constructor\n",
      i, i, i, "num_eqns = ", LinearAlgebra:-Dimension(eqns_tmp), ";\n",
      i, i, i, "num_invs = ", LinearAlgebra:-Dimension(invs_tmp), ";\n",
      i, i, i, "this = this@ExplicitSystem('", name, "', num_eqns, num_invs);\n",
      `if`(nops(data) > 0, cat(
      "\n",
      i, i, i, "% User data\n",
      i, i, i, "if (nargin == 0)\n",
      i, i, i, i, "% Keep default values\n",
      i, i, i, "elseif (nargin == ", nops(properties), ")\n",
      cat~(op(cat~("        this.m_", convert~(properties, string), " = varargin{",
        convert~([seq(1..nops(properties))], string), "};\n"))),
      i, i, i, "else\n",
      i, i, i, i, "error('wrong number of input arguments.');\n",
      i, i, i, "end\n"
      ), ""),
      i, i, "end % ", name, "\n",
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "f", [x], f,
          parse("algs") = algs_fun,
          parse("data") = properties,
          parse("info") = "Calculate the vector f of the semiexplicit system."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "Jf", [x], Jf,
          parse("algs") = algs_grd,
          parse("data") = properties,
          parse("info") = "Calculate the Jacobian of f with respect to x."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "h", [x], h,
          parse("algs") = algs_fun,
          parse("data") = properties,
          parse("info") = "Calculate the residual of the invariants h."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "Jh", [x], Jh,
          parse("algs") = algs_grd,
          parse("data") = properties,
          parse("info") = "Calculate the Jacobian of h with respect to x."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      i, "end\n",
      "end % ", name, "\n",
      "\n",
      "% That's All Folks!\n"
    );
    end proc: # ExplicitSystem

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  ____                 _ _____            _ _      _ _
  # / ___|  ___ _ __ ___ (_) ____|_  ___ __ | (_) ___(_) |_
  # \___ \ / _ \ '_ ` _ \| |  _| \ \/ / '_ \| | |/ __| | __|
  #  ___) |  __/ | | | | | | |___ >  <| |_) | | | (__| | |_
  # |____/ \___|_| |_| |_|_|_____/_/\_\ .__/|_|_|\___|_|\__|
  #                                   |_|
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export SemiExplicitSystemToMatlab := proc(
    name::string,
    vars::{Vector(algebraic), list(algebraic)},
    eqns::{Vector(algebraic), list(algebraic)},
    invs::{Vector(algebraic), list(algebraic)} := [],
    {
    indent::string                      := "  ",
    algs::{Vector(algebraic) = algebraic,
           list(algebraic = algebraic)} := [],
    data::list(symbol = algebraic)      := [],
    info::string                        := "No class description provided."
    }, $)::string;

    description "Generate a semi explicit system for the firt-order differential "
      "equations <eqns>, invariants <invs> with states variables <vars> and "
      "states variables, system data <data> and description <info>.";

    local i, bar, vars_tmp, eqns_tmp, invs_tmp, algs_tmp, vars_dot, x, x_dot, A,
      TA, b, Jb, h, Jh, GA, mk_algs_var, mk_algs_dot, mk_vars_dot, rm_deps,
      data_str, algs_fun, algs_grd, properties, tmp, tmp1, tmp2;

    # Convert to proper types
    if type(vars, Vector) then
      vars_tmp := convert(vars, list);
    else
      vars_tmp := vars;
    end if;
    if type(eqns, list) then
      eqns_tmp := convert(eqns, Vector);
    else
      eqns_tmp := eqns;
    end if;
    if type(invs, list) then
      invs_tmp := convert(invs, Vector);
    else
      invs_tmp := invs;
    end if;
    if type(algs, Vector) then
      algs_tmp := convert(algs, list);
    else
      algs_tmp := algs;
    end if;

    # Transform symbols diff(var,t) in var_dot(t)
    vars_dot := map(
      x -> convert(cat(op~(0, x), "_dot"), symbol)(op~(1..-1, x)), vars_tmp
    );
    mk_vars_dot := diff(vars_tmp, t) =~ vars_dot;

    # Extract A and b from: F = x_dot - f(x,t) = A(x)*x_dot - b(x) = 0
    eqns_tmp := subs(op(mk_vars_dot), eqns_tmp);
    A, b:= LinearAlgebra:-GenerateMatrix(convert(eqns_tmp, list), vars_dot);

    # Check if A is square and full rank
    if (LinearAlgebra:-RowDimension(A) <> LinearAlgebra:-ColumnDimension(A) ) or
       (LinearAlgebra:-Rank(A) <> LinearAlgebra:-ColumnDimension(A)) then
      error(
        "the system cannot be transformed into an explicit form, the matrix A "
        "is not square or full rank."
      );
      return NULL;
    end if;

    # Calculate tensor and jacobians
    eqns_tmp := subs(op(mk_vars_dot), eqns_tmp);
    TA := IndigoUtils:-DoTensor(A, vars_tmp);
    Jb := IndigoUtils:-DoJacobian(b, vars_tmp);
    Jh := IndigoUtils:-DoJacobian(invs_tmp, vars_tmp);

    # Calculate assignments derivatives
    GA          := [];
    mk_algs_var := [];
    mk_algs_dot := [];

    if (nops(algs_tmp) > 0) then
      # Transform assignments from (var[j])(f) to var_j
      tmp := map(x -> `if`(
          type(x, function),
          op(0, x),
          x
        ), lhs~(algs_tmp)
      );
      tmp := map(x -> `if`(
          type(x, indexed),
          convert(cat(op(0, x), "_", op(1..-1, x)), symbol),
          x
        ), tmp
      );
      mk_algs_var := lhs~(algs_tmp) =~ map(
        x -> `if`(
          type(op(0, x), indexed),
          convert(cat(op(0, op(0, x)), op(1..-1, op(0, x))), symbol),
          x
        ), tmp
      );

      # Calculate assignments derivatives
      # from     [..., L = R, ...] -> [..., Grad(L) = Grad(R), ...]
      # removing [..., 0 = 0, ...] -> [..., ...]
      GA := map(y -> op(convert(
        remove[flatten](x -> lhs(x) = 0 and rhs(x) = 0,
          IndigoUtils:-DoGradient(lhs(y), vars_tmp) =~
          IndigoUtils:-DoGradient(rhs(y), vars_tmp)
        ), list)), algs_tmp);

      # Transform assignments derivatives from D[i](var[j])(f) to D_i_var_j
      tmp  := lhs~(GA);
      tmp1 := map(
        x -> `if`(type(x, indexed), convert(cat(op(0, x), "_", op(1..-1, x)), symbol), x),
        op~(0, op~(0, %)) # D[i](var[j])(f) -> D[i]
      ); # D[i](var[j])(f) -> D_i
      tmp2 := map(
        x -> `if`(type(x, indexed), convert(cat(op(0, x), "_", op(1..-1, x)), symbol), x),
        op~(1, op~(0, %)) # D[i](var[j])(f) -> var[j]
      ); # D[i](var[j])(f) -> var_j
      # D[i](var[j])(f) -> D_i_var_j
      mk_algs_dot := tmp =~ zip((x, y) -> cat(x, "_", y), tmp1, tmp2 );
    end if;

    # Generate expressions without variable dependency
    rm_deps := [
      op(mk_algs_dot),                  # D[i](var[j])(f) -> D_i_var_j
      op(mk_algs_var),                  # (var[j])(f) -> var_j
      op(vars_tmp =~ op~(0, vars_tmp)), # var(x) -> var
      op(vars_dot =~ op~(0, vars_dot))  # var_dot(x) -> var_dot
    ];
    x     := convert(subs(op(rm_deps), vars_tmp), list);
    x_dot := convert(subs(op(rm_deps), vars_dot), list);
    A     := subs(op(rm_deps), A);
    TA    := subs(op(rm_deps), TA);
    b     := subs(op(rm_deps), b);
    Jb    := subs(op(rm_deps), Jb);
    h     := subs(op(rm_deps), invs_tmp);
    Jh    := subs(op(rm_deps), Jh);

    # Generate assignments
    algs_fun := subs(op(rm_deps), algs_tmp);
    algs_grd := [op(algs_fun), op(subs(op(rm_deps), GA))];

    # Function utilities strings
    i   := indent;
    bar := "% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n";

    # Generate properties
    if (nops(data) > 0) then
      data_str   := cat~(op(cat~(i, i, "m_", convert~(data, string), ";\n")));
      properties := lhs~(data);
    else
      data_str   := cat(i, i, "% No Properties\n");
      properties := [];
    end if;

    # Return output string
    return cat(
      "% +--------------------------------------------------------------------------+\n",
      "% | 'Indigo' module version 1.0 - BSD 3-Clause License - Copyright (c) 2023  |\n",
      "% | Current version authors:                                                 |\n",
      "% |   Davide Stocco and Enrico Bertolazzi.                                   |\n",
      "% +--------------------------------------------------------------------------+\n",
      "\n",
      "% Matlab generated code for implicit system: ", name, "\n",
      "% This file has been automatically generated by Indigo.\n",
      "% DISCLAIMER: If you need to edit it, do it wisely!\n",
      "\n",
      "classdef ", name, " < SemiExplicitSystem\n",
      i, "%\n",
      i, "% ", info, "\n",
      i, "%\n",
      i, "properties (SetAccess = protected, Hidden = true)\n",
      i, i, "% User data\n",
      data_str,
      i, "end\n",
      i, "%\n",
      i, "methods\n",
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      i, i, "function this = ", name, "( varargin )\n",
      i, i, i, "% Constructor for '", name, "' class.\n",
      "\n",
      i, i, i, "% Superclass constructor\n",
      i, i, i, "num_equations  = ", LinearAlgebra:-Dimension(eqns_tmp), ";\n",
      i, i, i, "num_invariants = ", LinearAlgebra:-Dimension(invs_tmp), ";\n",
      i, i, i, "this = this@SemiExplicitSystem('", name, "', num_equations, num_invariants);\n",
      `if`(nops(data) > 0, cat(
      "\n",
      i, i, i, "% User data\n",
      i, i, i, "if (nargin == 0)\n",
      i, i, i, i, "% Keep default values\n",
      i, i, i, "elseif (nargin == ", nops(properties), ")\n",
      cat~(op(cat~("        this.m_", convert~(properties, string), " = varargin{",
        convert~([seq(1..nops(properties))], string), "};\n"))),
      i, i, i, "else\n",
      i, i, i, i, "error('wrong number of input arguments.');\n",
      i, i, i, "end\n"
      ), ""),
      i, i, "end % ", name, "\n",
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "A", [x], A,
          parse("algs") = algs_fun,
          parse("data") = properties,
          parse("info") = "Calculate the matrix A of the explicit system."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-TensorToMatlab(
          "TA", [x], TA,
          parse("algs") = algs_grd,
          parse("data") = properties,
          parse("info") = "Calculate the tensor of A with respect to x."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "b", [x], b,
          parse("algs") = algs_fun,
          parse("data") = properties,
          parse("info") = "Calculate the vector b of the explicit system."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "Jb", [x], Jb,
          parse("algs") = algs_grd,
          parse("data") = properties,
          parse("info") = "Calculate the Jacobian of b with respect to x."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "h", [x], h,
          parse("algs") = algs_fun,
          parse("data") = properties,
          parse("info") = "Calculate the residual of the invariants h."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "Jh", [x], Jh,
          parse("algs") = algs_grd,
          parse("data") = properties,
          parse("info") = "Calculate the Jacobian of h with respect to x."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      i, "end\n",
      "end % ", name, "\n",
      "\n",
      "% That's All Folks!\n"
    );
    end proc: # SemiExplicitSystem

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

end module: # IndigoCodegen

# That's all folks!
