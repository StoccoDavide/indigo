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
    catch :
      IndigoUtils:-PrintMessage("Working directory already exists\n");
    end try;
    IndigoUtils:-PrintMessage("Working directory: %s\n", m_WorkingDirectory);
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
    return CodeGeneration[Translate](
      expr_list,
      language = "NewMatlab",
      op(op(eval(m_CodegenOptions))),
      output = string
    );
  end proc:

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export ApplyIndent := proc(
    ind::string,
    str::string,
    $)::string;

    description "Apply indentation <ind> to string <str>.";

    return sprintf(
      "%s  %s\n",
      ind, StringTools:-SubstituteAll(str, "\n", cat("\n  ", ind))
    );
  end proc: # ApplyIndent

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export VectorToMatlab := proc(
    name::string,
    vars::list(list(symbol)),
    vec::{list, Vector},
    data::list(symbol) := [],
    $)::string;

    description "Translate the vector <vec> with variables <vars> into a "
      "Matlab function named <name> and save it in the working directory.";

    local indent, properties, inputs, outputs, dims, i, j, lst, out;

    # Indentation string
    indent := "  ";

    # Extract the function properties
    properties := "";
    for i from 1 to nops(data) do
      properties := sprintf(
        "%s%s  %s = this.m_%s;\n",
        properties, indent, convert(data[i], string), convert(data[i], string)
      );
    end;

    # Extract the function inputs
    inputs := "";
    for j from 1 to nops(vars) do
      for i from 1 to nops(vars[j]) do
        inputs := sprintf(
          "%s%s  %s = in_%d(%d);\n",
          inputs, indent, convert(vars[j][i], string), j, i
        );
      end;
    end;

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
        outputs := sprintf(
          "%s%s  out_%s(%d) = out_%d;\n",
          outputs, indent, name, i, i
        );
      end;
    end;

    # Generate Matlab method header
    out := sprintf(
      "%sfunction out_%s = %s( this",
      indent, name, name
    );
    for j from 1 to nops(vars) do
      out := sprintf(
        "%s, in_%d",
        out, j
      );
    end;
    out := sprintf(
      "%s, t )\n",
      out, j
    );

    # Add the method body
    out := sprintf(
      "%s"
      "%s  %% Extract properties\n"
      "%s\n"
      "%s  %% Extract inputs\n"
      "%s\n"
      "%s  %% Generated function code\n",
      out, indent, properties, indent, inputs, indent
    );

    # Convert to Matlab code all the assigments
    out := cat(out, IndigoCodegen:-ApplyIndent(
      indent, IndigoCodegen:-TranslateToMatlab(lst)
    ));

    # Store the results
    out := sprintf(
      "%s"
      "%s  %% Store outputs\n"
      "%s  out_%s = zeros(%d,1);\n"
      "%s"
      "%send %% %s\n",
      out, indent, indent, name, dims, outputs, indent, name
    );

    # Return the code
    return out;
  end proc: # FunctionToMatlab

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export MatrixToMatlab := proc(
    name::string,
    vars::list(list(symbol)),
    mat::Matrix,
    data::list(symbol) := [],
    $)::string;

    description "Translate the matrix <mat> with variables <vars> into a "
     "Matlab function named <name> and save it in the working directory.";

    local indent, properties, inputs, outputs, rows, cols, i, j, lst, out;

    # Indentation string
    indent := "  ";

    # Extract the function properties
    properties := "";
    for i from 1 to nops(data) do
      properties := sprintf(
        "%s%s  %s = this.m_%s;\n",
        properties, indent, convert(data[i], string), convert(data[i], string)
      );
    end;

    # Extract the function inputs
    inputs := "";
    for j from 1 to nops(vars) do
      for i from 1 to nops(vars[j]) do
        inputs := sprintf(
          "%s%s  %s = in_%d(%d);\n",
          inputs, indent, convert(vars[j][i], string), j, i
        );
      end;
    end;

    # Extract the function as a list of assignments
    lst     := [];
    outputs := "";
    rows    := LinearAlgebra:-RowDimension(mat);
    cols    := LinearAlgebra:-ColumnDimension(mat);
    for i from 1 to rows do
      for j from 1 to cols do
        if evalb(mat[i,j] <> 0) then
          lst := [op(lst), convert("out_"||i||_||j, symbol) = mat[i,j]];
          outputs := sprintf(
            "%s%s  out_%s(%d,%d) = out_%d_%d;\n",
            outputs, indent, name, i, j, i, j
          );
        end;
      end;
    end;

    # Generate Matlab method header
    out := sprintf(
      "%sfunction out_%s = %s( this",
      indent, name, name
    );
    for j from 1 to nops(vars) do
      out := sprintf(
        "%s, in_%d",
        out, j
      );
    end;
    out := sprintf(
      "%s, t )\n",
      out, j
    );

    # Add the method body
    out := sprintf(
      "%s"
      "%s  %% Extract properties\n"
      "%s\n"
      "%s  %% Extract inputs\n"
      "%s\n"
      "%s  %% Generated function code\n",
      out, indent, properties, indent, inputs, indent
    );

    # Convert to Matlab code all the assigments
    out := cat(out, IndigoCodegen:-ApplyIndent(
      indent, IndigoCodegen:-TranslateToMatlab(lst)
    ));

    # Store the results
    out := sprintf(
      "%s"
      "%s  %% Store outputs\n"
      "%s  out_%s = zeros(%d,%d);\n"
      "%s"
      "%send %% %s\n",
      out, indent, indent, name, rows, cols, outputs, indent, name
    );

    # Return the code
    return out;
  end proc: # MatrixToMatlab

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  export RemoveDependencies := proc(
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

  export ImplicitSystem := proc(
    name::string,
    vars::{Vector(algebraic), list(algebraic)},
    eqns::{Vector(algebraic), list(algebraic)} := [NULL],
    invs::{Vector(algebraic), list(algebraic)} := [NULL],
    data::list(symbol = anything) := [],
    $)::string;

    description "Generate an implicit system for the equations <F> and invariants "
      "<h> with states variables <x> and states variables derivatives <x_dot>.";

    local eqns_tmp, invs_tmp, vars_tmp, vars_dot, x, x_dot, F, JF_x, JF_x_dot,
      h, Jh, mk_dot, rm_deps, properties;

    # Convert to proper types
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
    if type(vars, Vector) then
      vars_tmp := convert(vars, list);
    else
      vars_tmp := vars;
    end if;

    # Transform symbols diff(var,t) in var_dot(t)
    vars_dot :=  map(
      x -> convert(cat(op~(0, x), "_dot"), symbol)(op~(1..-1, x)), vars_tmp
    );
    mk_dot := diff(vars_tmp, t) =~ vars_dot;

    # Calculate jacobians
    eqns_tmp := subs(op(mk_dot), eqns_tmp);
    JF_x     := IndigoUtils:-DoJacobian(eqns_tmp, vars_tmp);
    JF_x_dot := IndigoUtils:-DoJacobian(eqns_tmp, vars_dot);
    Jh       := IndigoUtils:-DoJacobian(invs_tmp, vars_tmp);

    # Generate expressions without variable dependency
    rm_deps  := [op(vars_tmp), op(vars_dot)] =~ op~(0, [op(vars_tmp), op(vars_dot)]);
    x        := convert(subs(op(rm_deps), vars_tmp), list);
    x_dot    := convert(subs(op(rm_deps), vars_dot), list);
    F        := subs(op(rm_deps), eqns_tmp);
    JF_x     := subs(op(rm_deps), JF_x);
    JF_x_dot := subs(op(rm_deps), JF_x_dot);
    h        := subs(op(rm_deps), invs_tmp);
    Jh       := subs(op(rm_deps), Jh);

    # Return output string
    properties := lhs~(data);
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
      "  properties (SetAccess = protected, Hidden = true)\n",
      "    % User data\n",
      cat~(op(cat~("    m_", convert~(data, string), ";\n"))),
      "  end\n",
      "  methods\n",
      "\n",
      "    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n",
      "\n",
      "    function this = ", name, "( varargin )\n",
      "      % Superclass constructor\n",
      "      this = this@ImplicitSystem('", name, "', ",
        LinearAlgebra:-Dimension(F), ", ", LinearAlgebra:-Dimension(h), ");\n",
      "\n",
      "      % User data\n",
      "      if (nargin == 0)\n",
      "        % Set default values\n",
      "      elseif (nargin == ", nops(properties), ")\n",
      cat~(op(cat~("        this.m_", convert~(properties, string), " = varargin{",
        convert~([seq(1..nops(properties))], string), "};\n"))),
      "      else\n",
      "        error('wrong number of input arguments.');\n",
      "      end\n",
      "    end\n",
      "\n",
      "    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n",
      "\n",
      IndigoCodegen:-ApplyIndent(
        "", IndigoCodegen:-VectorToMatlab("F", [x, x_dot], F, properties)
      ),
      "    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n",
      "\n",
      "    function [out, out_dot] = JF( this, x, x_dot, t )\n",
      "      out     = this.JF_x(x, t);\n",
      "      out_dot = this.JF_x_dot(x_dot, t);\n",
      "    end % JF\n",
      "\n",
      "    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n",
      "\n",
      IndigoCodegen:-ApplyIndent(
        "", IndigoCodegen:-MatrixToMatlab("JF_x", [x], JF_x, properties)
      ),
      "    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n",
      "\n",
      IndigoCodegen:-ApplyIndent(
        "", IndigoCodegen:-MatrixToMatlab("JF_x_dot", [x_dot], JF_x_dot, properties)
      ),
      "    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n",
      "\n",
      IndigoCodegen:-ApplyIndent(
        "", IndigoCodegen:-VectorToMatlab("h", [x], h, properties)
      ),
      "    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n",
      "\n",
      IndigoCodegen:-ApplyIndent(
        "", IndigoCodegen:-MatrixToMatlab("Jh", [x], Jh, properties)
      ),
      "    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n",
      "\n",
      "  end\n",
      "end % ", name, "\n",
      "\n",
      "% That's All Folks!\n"
    );
  end proc: # ImplicitSystem

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

end module: # IndigoCodegen

# That's all folks!
