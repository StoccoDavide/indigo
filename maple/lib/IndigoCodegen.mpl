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

  local m_CodegenOptions,
        m_WorkingDirectory;

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
    out :=  StringTools:-Take(out, length(out) - length(ind));

    # Remove indentation empty lines or lines with only spaces
    out := StringTools:-SubstituteAll(out, "\n" || ind || "\n", "\n\n");

    return out
  end proc: # ApplyIndent

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local VectorToMatlab := proc(
    name::string,
    vars::list(list(symbol)),
    vec::{list, Vector},
    {
    algs::{Vector(algebraic) = algebraic,
           list(algebraic = algebraic)} := [],
    data::list(symbol)                  := [],
    info::string                        := "No function description provided."
    }, $)::string;

    description "Translate the vector <vec> with variables <vars> into a "
      "Matlab function named <name> and save it in the working directory.";

    local indent, properties, inputs, algs_tmp, assignments, outputs, dims, i,
      j, lst, out;

    # Indentation string
    indent := "  ";

    # Extract the function properties
    if (nops(data) > 0) then
      properties := "";
      for i from 1 to nops(data) do
        properties := cat(properties,
          indent, convert(data[i], string), " = this.m_", convert(data[i], string), ";\n"
        );
      end do;
    else
      properties := cat(indent, "% None\n");
    end if;

    # Extract the function inputs
    inputs := "";
    for j from 1 to nops(vars) do
      for i from 1 to nops(vars[j]) do
        inputs := cat(inputs,
          indent, convert(vars[j][i], string), " = in_", j, "(", i, ");\n"
        );
      end do;
    end do;

    # Extract the function as a list of assignments
    lst     := [];
    outputs := "";
    if type(vec, Vector) then
      dims := LinearAlgebra:-Dimension(vec);
    else
      dims := nops(vec);
    end if;
    for i from 1 to dims do
      if evalb(F[i] <> 0) then
        lst := [op(lst), convert("out_"||i, symbol) = vec[i]];
        outputs := cat(outputs,
          indent, "out_", name, "(", i, ") = out_", i, ";\n"
        );
      end if;
    end do;

    # Generate method header
    out := cat("function out_", name, " = ", name, "( this");
    for j from 1 to nops(vars) do
      out := cat(out, ", ", "in_", j);
    end do;
    out := cat(out, ", t )\n");

    # Add description
    out := cat(out,
      indent, "% ", info, "\n"
    );

    # Convert to code the algebraic assignments
    algs_tmp := map(x -> `if`(has(vec, lhs(x)), x, NULL), algs);
    IndigoCodegen:-TranslateToMatlab(algs_tmp);
    assignments := IndigoCodegen:-ApplyIndent(indent,
      `if`(% = "", "% None\n", %)
    );

    # Add the method body
    out := cat(out,
      "\n",
      indent, "% Extract properties\n",
      properties, "\n",
      indent, "% Extract inputs\n",
      inputs, "\n",
      indent, "% Generated assignments code\n",
      assignments, "\n",
      indent, "% Generated function code\n"
    );

    # Convert to Matlab code all the assigments
    IndigoCodegen:-TranslateToMatlab(lst);
    out := cat(out, IndigoCodegen:-ApplyIndent(indent,
      `if`(% = "", "% None\n", %)
    ));

    # Store the results
    out := cat(out,
      "\n",
      indent, "% Store outputs\n",
      indent, "out_", name, " = zeros(", dims, ",1);\n",
      outputs,
      "end % ", name, "\n"
    );

    # Return the code
    return out;
  end proc: # VectorToMatlab

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local MatrixToMatlab := proc(
    name::string,
    vars::list(list(symbol)),
    mat::Matrix,
    {
    algs::{Vector(algebraic) = algebraic,
           list(algebraic = algebraic)} := [],
    data::list(symbol)                  := [],
    info::string                        := "No function description provided."
    }, $)::string;

    description "Translate the matrix <mat> with variables <vars> into a "
     "Matlab function named <name> and save it in the working directory.";

    local indent, properties, inputs, algs_tmp, assignments, outputs, rows,
      cols, i, j, lst, out;

    # Indentation string
    indent := "  ";

    # Extract the function properties
    if (nops(data) > 0) then
      properties := "";
      for i from 1 to nops(data) do
        properties := cat(properties,
          indent, convert(data[i], string), " = this.m_", convert(data[i], string), ";\n"
        );
      end do;
    else
      properties := cat(indent, "% None\n");
    end if;

    # Extract the function inputs
    inputs := "";
    for j from 1 to nops(vars) do
      for i from 1 to nops(vars[j]) do
        inputs := cat(inputs,
          indent, convert(vars[j][i], string), " = in_", j, "(", i, ");\n"
        );
      end do;
    end do;

    # Extract the function as a list of assignments
    lst     := [];
    outputs := "";
    rows    := LinearAlgebra:-RowDimension(mat);
    cols    := LinearAlgebra:-ColumnDimension(mat);
    for i from 1 to rows do
      for j from 1 to cols do
        if evalb(mat[i, j] <> 0) then
          lst := [op(lst), convert("out_"||i||_||j, symbol) = mat[i, j]];
          outputs := cat(outputs,
            indent, "out_", name, "(", i, ",", j, ") = out_", i, "_", j, ";\n"
          );
        end if;
      end do;
    end do;

    # Generate method header
    out := cat("function out_", name, " = ", name, "( this");
    for j from 1 to nops(vars) do
      out := cat(out, ", ", "in_", j);
    end do;
    out := cat(out, ", t )\n");

    # Add description
    out := cat(out,
      indent, "% ", info, "\n"
    );

    # Convert to code the algebraic assignments
    algs_tmp := map(x -> `if`(has(vec, lhs(x)), x, NULL), algs);
    IndigoCodegen:-TranslateToMatlab(algs_tmp);
    assignments := IndigoCodegen:-ApplyIndent(indent,
      `if`(% = "", "% None\n", %)
    );

    # Add the method body
    out := cat(out,
      "\n",
      indent, "% Extract properties\n",
      properties, "\n",
      indent, "% Extract inputs\n",
      inputs, "\n",
      indent, "% Generated assignments code\n",
      assignments, "\n",
      indent, "% Generated function code\n"
    );

    # Convert to code all the assigments
    IndigoCodegen:-TranslateToMatlab(lst);
    out := cat(out, IndigoCodegen:-ApplyIndent(indent,
      `if`(% = "", "% None\n", %)
    ));

    # Store the results
    out := cat(out,
      "\n",
      indent, "% Store outputs\n",
      indent, "out_", name, " = zeros(", rows, ",", cols, ");\n",
      outputs,
      "end % ", name, "\n"
    );

    # Return the code
    return out;
  end proc: # MatrixToMatlab

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local TensorToMatlab := proc(
    name::string,
    vars::list(list(symbol)),
    ten::Array,
    {
    algs::{Vector(algebraic) = algebraic,
           list(algebraic = algebraic)} := [],
    data::list(symbol)                  := [],
    info::string                        := "No function description provided."
    }, $)::string;

    description "Translate the tensor <ten> with variables <vars> into a "
     "Matlab function named <name> and save it in the working directory.";

    local indent, properties, inputs, algs_tmp, assignments, outputs, dims, i,
      j, k, lst, out;

    # Indentation string
    indent := "  ";

    # Extract the function properties
    if (nops(data) > 0) then
      properties := "";
      for i from 1 to nops(data) do
        properties := cat(properties,
          indent, convert(data[i], string), " = this.m_", convert(data[i], string), ";\n"
        );
      end do;
    else
      properties := cat(indent, "% None\n");
    end if;

    # Extract the function inputs
    inputs := "";
    for j from 1 to nops(vars) do
      for i from 1 to nops(vars[j]) do
        inputs := cat(inputs,
          indent, convert(vars[j][i], string), " = in_", j, "(", i, ");\n"
        );
      end do;
    end do;

    # Extract the function as a list of assignments
    lst     := [];
    outputs := "";
    dims    := op~(2, [ArrayDims(ten)]);
    for i from 1 to dims[1] do
      for j from 1 to dims[2] do
        for k from 1 to dims[3] do
          if evalb(ten[i, j, k] <> 0) then
            lst := [op(lst), convert("out_"||i||_||j||_||k, symbol) = ten[i, j, k]];
            outputs := cat(outputs,
              indent, "out_", name, "(", i, ",", j, ",", k, ") = out_", i, "_", j, "_", k, ";\n"
            );
          end if;
        end do;
      end do;
    end do;

    # Generate method header
    out := cat("function out_", name, " = ", name, "( this");
    for j from 1 to nops(vars) do
      out := cat(out, ", ", "in_", j);
    end do;
    out := cat(out, ", t )\n");

    # Add description
    out := cat(out,
      indent, "% ", info, "\n"
    );

    # Convert to code the algebraic assignments
    algs_tmp := map(x -> `if`(has(vec, lhs(x)), x, NULL), algs);
    IndigoCodegen:-TranslateToMatlab(algs_tmp);
    assignments := IndigoCodegen:-ApplyIndent(indent,
      `if`(% = "", "% None\n", %)
    );

    # Add the method body
    out := cat(out,
      "\n",
      indent, "% Extract properties\n",
      properties, "\n",
      indent, "% Extract inputs\n",
      inputs, "\n",
      indent, "% Generated assignments code\n",
      assignments, "\n",
      indent, "% Generated function code\n"
    );

    # Convert to code all the assigments
    IndigoCodegen:-TranslateToMatlab(lst);
    out := cat(out, IndigoCodegen:-ApplyIndent(indent,
      `if`(% = "", "% None\n", %)
    ));

    # Store the results
    out := cat(out,
      "\n",
      indent, "% Store outputs\n",
      indent, "out_", name, " = zeros(",
        dims[1], ", ", dims[2], ", ", dims[3],
      ");\n",
      outputs,
      "end % ", name, "\n"
    );

    # Return the code
    return out;
  end proc: # TensorToMatlab

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local RemoveDependencies := proc(
    expr::anything,
    vars::{symbol, list(symbol)},
    $)::anything;

    description "Remove all dependencies of the variables <vars> from "
      "expression <expr>.";

    if type(vars, symbol) then
      return subs(vars = {op(0, vars)}, expr);
    else
      return subs(vars =~ op(0, vars), expr);
    return
    end if;
  end proc: # RemoveDependencies

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
    invs::{Vector(algebraic), list(algebraic)} := [],
    {
    algs::{Vector(algebraic) = algebraic,
           list(algebraic = algebraic)} := [],
    data::list(symbol = algebraic)      := [],
    info::string                        := "No class description provided."
    }, $)::string;

    description "Generate an implicit system for the firt-order differential "
      "equations <eqns>, invariants <invs> with states variables <vars> and "
      "states variables, system data <data> and description <info>.";

    local i, bar, vars_tmp, eqns_tmp, invs_tmp, algs_tmp, algs_var, algs_dot,
      vars_dot, x, x_dot, F, JF_x, JF_x_dot, h, Jh, A, GA, A_GA, mk_vars_dot,
      rm_deps, data_str, properties;

    # Indentation string
    i   := "  ";
    bar := "% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n";

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

    # Transform variables from diff(var,t) to var_dot(t)
    vars_dot := map(
      x -> convert(cat(op(0, x), "_dot"), symbol)(op(1..-1, x)),
      vars_tmp
    );
    mk_vars_dot := diff(vars_tmp, t) =~ vars_tmp;

    # Calculate jacobians
    eqns_tmp := subs(op(mk_vars_dot), eqns_tmp);
    JF_x     := IndigoUtils:-DoJacobian(eqns_tmp, vars_tmp);
    JF_x_dot := IndigoUtils:-DoJacobian(eqns_tmp, vars_dot);
    Jh       := IndigoUtils:-DoJacobian(invs_tmp, vars_tmp);

    # Calculate assignments derivatives
    algs_var    := [];
    algs_grd    := [];
    GA          := [];
    algs_dot    := [];
    mk_algs_dot := [];
    if (nops(algs_tmp) > 0) then
      algs_var := lhs~(algs_tmp);

      # Calculate assignments derivatives
      for u in algs_tmp do
        for v in vars_tmp do
          tmp := IndigoUtils:-DoDiff(lhs(u), v); print(%);
          if not evalb(tmp = 0) then
            algs_grd := [op(algs_grd), tmp];
            GA       := [op(GA), tmp = IndigoUtils:-DoDiff(rhs(u), v)];
          end if;
        end do;
      end do;
      print("algs_grd = ", algs_grd);
      print("GA = ", GA);

      # Transform assignments from D[i](var[j])(f) to D_i_var[j]
      algs_dot := zip((x, y) -> cat(x, "_", y),
        map(x -> `if`(
          type(x, indexed),
          cat(op(0, x), "_", op(1, x)),
          x
        ), op~(0, op~(0, algs_grd))),
        map(x -> `if`(
          type(x, indexed),
          op(0, x)[op(1, x)], x
        ), op~(1, op~(0, algs_grd)))
      );
      mk_algs_dot := algs_grd =~ algs_dot
    end if;

    # Generate expressions without variable dependency
    rm_deps  := [
      op(vars_tmp =~ op~(0, vars_tmp)), op(vars_dot =~ op~(0, vars_dot)),
      #op(algs_var =~ op~(0, algs_var)),
      op(mk_algs_dot)
    ]; print(%);
    x        := convert(subs(op(rm_deps), vars_tmp), list);
    x_dot    := convert(subs(op(rm_deps), vars_dot), list);
    F        := subs(op(rm_deps), eqns_tmp);
    JF_x     := subs(op(rm_deps), JF_x); print(%);
    JF_x_dot := subs(op(rm_deps), JF_x_dot); print(%);
    h        := subs(op(rm_deps), invs_tmp);
    Jh       := subs(op(rm_deps), Jh);
    A        := subs(op(rm_deps), algs_tmp);
    GA       := subs(op(rm_deps), GA);
    A_GA     := [op(A), op(GA)];

    # Generate properties
    if (nops(data) > 0) then
      data_str   := cat~(op(cat~(i, i, "m_", convert~(data, string), ";\n")));
      properties := lhs~(data);
    else
      data_str   := cat(i, i, "% None");
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
      "classdef ", name, " < ImplicitSystem\n",
      i, "%\n",
      i, "% ", info, "\n",
      i, "%\n",
      i, "properties (SetAccess = protected, Hidden = true)\n",
      i, i, "% User data\n",
      data_str, "\n",
      i, "end\n",
      i, "%\n",
      i, "methods\n",
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      i, i, "function this = ", name, "( varargin )\n",
      i, i, i, "% Constructor for '", name, "'' class.\n",
      "\n",
      i, i, i, "% Superclass constructor\n",
      i, i, i, "this = this@ImplicitSystem('", name, "', ",
        LinearAlgebra:-Dimension(eqns_tmp), ", ", LinearAlgebra:-Dimension(invs_tmp),
      ");\n",
      i, i, i, "% User data\n",
      i, i, i, "if (nargin == 0)\n",
      i, i, i, i, "% Keep default values\n",
      i, i, i, "elseif (nargin == ", nops(properties), ")\n",
      cat~(op(cat~("        this.m_", convert~(properties, string), " = varargin{",
        convert~([seq(1..nops(properties))], string), "};\n"))),
      i, i, i, "else\n",
      i, i, i, i, "error('wrong number of input arguments.');\n",
      i, i, i, "end\n",
      i, i, "end\n",
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "F", [x, x_dot], F,
          parse("algs") = A,
          parse("data") = properties,
          parse("info") = "Calculate the residual of the implicit system F(x, x_dot)."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      i, i, "function [out, out_dot] = JF( this, x, x_dot, t )\n",
      "\n",
      i, i, i, "% Calulate Jacobians\n",
      i, i, i, "out     = this.JF_x(x, t);\n",
      i, i, i, "out_dot = this.JF_x_dot(x_dot, t);\n",
      i, i, "end % JF\n",
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "JF_x", [x], JF_x,
          parse("algs") = A_GA,
          parse("data") = properties,
          parse("info") = "Calculate the Jacobian of F with respect to x."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "JF_x_dot", [x_dot], JF_x_dot,
          parse("algs") = A_GA,
          parse("data") = properties,
          parse("info") = "Calculate the Jacobian of F with respect to x_dot."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "h", [x], h,
          parse("algs") = A,
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
          parse("algs") = A_GA,
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
    algs::{Vector(algebraic) = algebraic,
           list(algebraic = algebraic)} := [],
    data::list(symbol = algebraic)      := [],
    info::string                        := "No class description provided."
    }, $)::string;

    description "Generate an explicit system for the firt-order differential "
      "equations <eqns>, invariants <invs> with states variables <vars> and "
      "states variables, system data <data> and description <info>.";

    local i, bar, vars_tmp, eqns_tmp, invs_tmp, algs_tmp, vars_dot, x, x_dot, A,
      b, f, Jf, h, Jh, mk_vars_dot, rm_deps, data_str, properties;

    # Indentation string
    i   := "  ";
    bar := "% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n";

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

    # Extract f from: F = x_dot - f(x,t)
    eqns_tmp := subs(op(mk_vars_dot), eqns_tmp);
    A, b:= LinearAlgebra:-GenerateMatrix(convert(eqns_tmp, list), vars_dot);

    # Check if A is full rank
    if (LinearAlgebra:-Rank(A) <> LinearAlgebra:-ColumnDimension(A)) then
      error(
        "the system cannot be transformed into an explicit form, the matrix A "
        "is not full rank."
      );
      return NULL;
    end if;

    # Solve for x_dot
    f := LinearAlgebra:-LinearSolve(A, b);

    # Calculate tensor and jacobians
    eqns_tmp := subs(op(mk_vars_dot), eqns_tmp);
    Jf := IndigoUtils:-DoJacobian(f, vars_tmp);
    Jh := IndigoUtils:-DoJacobian(invs_tmp, vars_tmp);

    # Generate expressions without variable dependency
    rm_deps  := [op(vars_tmp), op(vars_dot)] =~ op~(0, [op(vars_tmp), op(vars_dot)]);
    x        := convert(subs(op(rm_deps), vars_tmp), list);
    x_dot    := convert(subs(op(rm_deps), vars_dot), list);
    f        := subs(op(rm_deps), f);
    Jf       := subs(op(rm_deps), Jf);
    h        := subs(op(rm_deps), invs_tmp);
    Jh       := subs(op(rm_deps), Jh);

    # Generate properties
    if (nops(data) > 0) then
      data_str   := cat~(op(cat~(i, i, "m_", convert~(data, string), ";\n")));
      properties := lhs~(data);
    else
      data_str   := cat(i, i, "% None");
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
      data_str, "\n",
      i, "end\n",
      i, "%\n",
      i, "methods\n",
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      i, i, "function this = ", name, "( varargin )\n",
      i, i, i, "% Constructor for '", name, "'' class.\n",
      "\n",
      i, i, i, "% Superclass constructor\n",
      i, i, i, "this = this@ExplicitSystem('", name, "', ",
        LinearAlgebra:-Dimension(eqns_tmp), ", ", LinearAlgebra:-Dimension(invs_tmp),
      ");\n",
      "\n",
      i, i, i, "% User data\n",
      i, i, i, "if (nargin == 0)\n",
      i, i, i, i, "% Keep default values\n",
      i, i, i, "elseif (nargin == ", nops(properties), ")\n",
      cat~(op(cat~("        this.m_", convert~(properties, string), " = varargin{",
        convert~([seq(1..nops(properties))], string), "};\n"))),
      i, i, i, "else\n",
      i, i, i, i, "error('wrong number of input arguments.');\n",
      i, i, i, "end\n",
      i, i, "end\n",
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "f", [x], f,
          parse("algs") = algs_tmp,
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
          parse("algs") = algs_tmp,
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
          parse("algs") = algs_tmp,
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
          parse("algs") = algs_tmp,
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
    algs::{Vector(algebraic) = algebraic,
           list(algebraic = algebraic)} := [],
    data::list(symbol = algebraic)      := [],
    info::string                        := "No class description provided."
    }, $)::string;

    description "Generate a semi explicit system for the firt-order differential "
      "equations <eqns>, invariants <invs> with states variables <vars> and "
      "states variables, system data <data> and description <info>.";

    local i, bar, vars_tmp, eqns_tmp, invs_tmp, algs_tmp, vars_dot, x, x_dot, A,
      TA, b, Jb, h, Jh, mk_vars_dot, rm_deps, data_str, properties;

    # Indentation string
    i   := "  ";
    bar := "% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n";

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

    # Check if A is full rank
    if (LinearAlgebra:-Rank(A) <> LinearAlgebra:-ColumnDimension(A)) then
      error(
        "the system cannot be transformed into an explicit form, the matrix A "
        "is not full rank."
      );
      return NULL;
    end if;

    # Calculate tensor and jacobians
    eqns_tmp := subs(op(mk_vars_dot), eqns_tmp);
    algs_tmp := subs(op(mk_vars_dot), algs_tmp);
    TA := IndigoUtils:-DoTensor(A, vars_tmp);
    Jb := IndigoUtils:-DoJacobian(b, vars_tmp);
    Jh := IndigoUtils:-DoJacobian(invs_tmp, vars_tmp);

    # Generate expressions without variable dependency
    rm_deps  := [op(vars_tmp), op(vars_dot)] =~ op~(0, [op(vars_tmp), op(vars_dot)]);
    x        := convert(subs(op(rm_deps), vars_tmp), list);
    x_dot    := convert(subs(op(rm_deps), vars_dot), list);
    A        := subs(op(rm_deps), A);
    TA       := subs(op(rm_deps), TA);
    b        := subs(op(rm_deps), b);
    Jb       := subs(op(rm_deps), Jb);
    h        := subs(op(rm_deps), invs_tmp);
    Jh       := subs(op(rm_deps), Jh);

    # Generate properties
    if (nops(data) > 0) then
      data_str   := cat~(op(cat~(i, i, "m_", convert~(data, string), ";\n")));
      properties := lhs~(data);
    else
      data_str   := cat(i, i, "% None");
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
      data_str, "\n",
      i, "end\n",
      i, "%\n",
      i, "methods\n",
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      i, i, "function this = ", name, "( varargin )\n",
      i, i, i, "% Constructor for '", name, "'' class.\n",
      "\n",
      i, i, i, "% Superclass constructor\n",
      i, i, i, "this = this@SemiExplicitSystem('", name, "', ",
        LinearAlgebra:-Dimension(eqns_tmp), ", ", LinearAlgebra:-Dimension(invs_tmp),
      ");\n",
      "\n",
      i, i, i, "% User data\n",
      i, i, i, "if (nargin == 0)\n",
      i, i, i, i, "% Keep default values\n",
      i, i, i, "elseif (nargin == ", nops(properties), ")\n",
      cat~(op(cat~("        this.m_", convert~(properties, string), " = varargin{",
        convert~([seq(1..nops(properties))], string), "};\n"))),
      i, i, i, "else\n",
      i, i, i, i, "error('wrong number of input arguments.');\n",
      i, i, i, "end\n",
      i, i, "end\n",
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "A", [x], A,
          parse("algs") = algs_tmp,
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
          parse("algs") = algs_tmp,
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
          parse("algs") = algs_tmp,
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
          parse("algs") = algs_tmp,
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
          parse("algs") = algs_tmp,
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
          parse("algs") = algs_tmp,
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
