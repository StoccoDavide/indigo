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

  export TranslateToMatlab := proc(
    expr_list::list,
    $)

    description "Convert a list of expressions <expr_list> into Matlab code.";

    local i, lang_fncs;

    # Define language functions
    lang_fncs := ["floor", "ceil", "round", "trunc", "erf", "sin", "cos", "tan"];

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
    vars::list(list({symbol, string})),
    {
    skipnull::boolean := true,
    indent::string := "  "
    }, $)::string;

    description "Generate inputs code from a list of variables <vars> and "
      "optional indentation <indent>.";

    local i, j, out;

    out := "";
    for j from 1 to nops(vars) do
      for i from 1 to nops(vars[j]) do
        if not (skipnull and type(vars[j][i], string)) then
          convert(vars[j][i], string);
          out := cat(out, indent, %, " = in_", j, "(", i, ");\n");
        end if;
      end do;
    end do;
    return out;
  end proc: # GenerateInputs

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local ExtractElements := proc(
    name::string,
    func::{list, Vector, Matrix, Array},
    dims::list(nonnegint),
    {
    skipnull::boolean := true,
    label::string     := "out",
    indent::string    := "  "
    }, $)::list, string;

    description "Extract elements for a n-dimensional function <func> with "
      "name <name>, dimensions <dims>, and optional veilig label <label> and "
      "indentation <indent>.";

    local i, j, idx, lst, out, cur, tmp, str1, str2;

    lst  := [];
    out  := "";
    for i from 1 to mul(dims) do
      cur := [];
      idx := i-1;
      for j from 1 to nops(dims) do
        cur := [op(cur), irem(idx, dims[j], 'idx')+1];
      end do;
      tmp := func[op(cur)];
      if not (skipnull and (tmp = 0)) then
        map(x -> (x, "_"), cur); str1 := cat(label, "_", op(%))[1..-2];
        lst := [op(lst), convert(str1, symbol) = tmp];
        map(x -> (x, ", "), cur); str2 := cat("", op(%))[1..-3];
        out := cat(out, indent, "out_", name, "(", str2, ") = ", str1, ";\n");
      end if;
    end do;
    return lst, out;
  end proc: # ExtractElements

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local GenerateHeader := proc(
    name::string,
    vars::list(list(symbol)),
    {
    skipthis::boolean := false,
    skiptime::boolean := false,
    info::string      := "No description provided.",
    indent::string    := "  "
    }, $)::string;

    description "Generate a function header for a function <name> with "
    "variables <vars>, optional description <info>, indentation <indent>, and "
    "skip class object input <skipthis> and time input <skiptime>.";

    local i, out;

    out := cat("function out_", name, " = ", name, "( ");
    if skipthis then #and (add(map(nops, vars)) = 0) then
      out := cat(out, "~");
    else
      out := cat(out, "this");
    end if;

    for i from 1 to nops(vars) do
      if (nops(vars[i]) > 0) then
        out := cat(out, ", ", "in_", i);
      else
        out := cat(out, ", ", "~");
      end if;
    end do;

    if skiptime then
      out := cat(out, ", ", "~");
    else
      out := cat(out, ", ", "t");
    end if;
    return cat(out, " )\n", indent, "% ", info, "\n\n");
  end proc: # GenerateHeader

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local GenerateElements := proc(
    func::{list, Vector, Matrix, Array},
    {
    indent::string := "  "
    }, $)::string;

    description "Generate code for elements <func> with optional indentation "
      "<indent>.";

    IndigoCodegen:-TranslateToMatlab(func);
    return IndigoCodegen:-ApplyIndent(indent,
      `if`(% = "", "% No body\n", cat(%%, %))
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

    local tmp, i;

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
    skipnull::boolean  := true,
    data::list(symbol) := [],
    info::string       := "No info",
    label::string      := "out",
    indent::string     := "  ",
    verbose::boolean   := false
    }, $)::string;

    description "Translate the vector <vec> with variables <vars> into a "
      "Matlab function named <name> and return it as a string. The optional "
      "arguments areclass properties <data>, function description <info>, "
      "veilig label <label>, and indentation string <indent>. If <verbose> "
      "is true, the function prints the progress on the screen.";

    local header, properties, inputs, veils, elements, outputs, dims, lst,
      tmp_data, vec_inds, tmp_vars, tmp_vars_rm, tmp_vars_nl;

    if verbose then
      printf("Generating vector function '%s'... ", name);
    end if;

    # Extract the function properties
    tmp_data := convert(data, set) intersect indets(vec, symbol);
    tmp_data := remove[flatten](j -> not (j in tmp_data), data);
    properties := IndigoCodegen:-GenerateProperties(
      tmp_data, parse("indent") = indent
    );

    # Extract the function elements
    dims := [LinearAlgebra:-Dimension(vec)];
    lst, outputs := IndigoCodegen:-ExtractElements(
      name, vec, dims, parse("skipnull") = skipnull, parse("indent") = indent,
      parse("label") = label
    );

    # Extract the function inputs
    vec_inds    := indets(vec, symbol);
    tmp_vars    := map(i -> i intersect vec_inds, map(convert, vars, set));
    tmp_vars_rm := zip((i, j) -> remove[flatten](k -> not (k in j), i), vars, tmp_vars);
    tmp_vars_nl := zip((i, j) -> map(k -> `if`(not (k in j), "", k), i), vars, tmp_vars);
    inputs := IndigoCodegen:-GenerateInputs(
      tmp_vars_nl, parse("indent") = indent, parse("skipnull") = true
    );

    # Generate the method header
    header := IndigoCodegen:-GenerateHeader(
      name, tmp_vars_rm, parse("info") = info, parse("indent") = indent,
      parse("skipthis") = evalb(nops(tmp_data) = 0),
      parse("skiptime") = not has(indets(vec, symbol), 't')
    );

    # Generate the elements
    elements := IndigoCodegen:-GenerateElements(lst);

    if verbose then
      printf("DONE\n");
    end if;

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
    skipnull::boolean  := true,
    data::list(symbol) := [],
    info::string       := "No info",
    label::string      := "out",
    indent::string     := "  ",
    verbose::boolean   := false
    }, $)::string;

    description "Translate the vector <vec> with variables <vars> into a "
      "Matlab function named <name> and return it as a string. The optional "
      "arguments areclass properties <data>, function description <info>, "
      "veilig label <label>, and indentation string <indent>. If <verbose> "
      "is true, the function prints the progress on the screen.";

    local header, properties, inputs, veils, elements, outputs, dims, lst,
      tmp_data, mat_inds, tmp_vars, tmp_vars_rm, tmp_vars_nl;

    if verbose then
      printf("Generating matrix function '%s'... ", name);
    end if;

    # Extract the function properties
    tmp_data := convert(data, set) intersect indets(mat, symbol);
    tmp_data := remove[flatten](j -> not (j in tmp_data), data);
    properties := IndigoCodegen:-GenerateProperties(
      tmp_data, parse("indent") = indent
    );

    # Extract the function elements
    dims := [LinearAlgebra:-Dimensions(mat)];
    lst, outputs := IndigoCodegen:-ExtractElements(
      name, mat, dims, parse("skipnull") = skipnull, parse("indent") = indent,
      parse("label") = label
    );

    # Extract the function inputs
    mat_inds    := indets(mat, symbol);
    tmp_vars    := map(i -> i intersect mat_inds, map(convert, vars, set));
    tmp_vars_rm := zip((i, j) -> remove[flatten](k -> not (k in j), i), vars, tmp_vars);
    tmp_vars_nl := zip((i, j) -> map(k -> `if`(not (k in j), "", k), i), vars, tmp_vars);
    inputs := IndigoCodegen:-GenerateInputs(
      tmp_vars_nl, parse("indent") = indent, parse("skipnull") = true
    );

    # Generate the method header
    header := IndigoCodegen:-GenerateHeader(
      name, tmp_vars_rm, parse("info") = info, parse("indent") = indent,
      parse("skipthis") = evalb(nops(tmp_data) = 0),
      parse("skiptime") = not has(indets(mat, symbol), 't')
    );

    # Generate the elements
    elements := IndigoCodegen:-GenerateElements(lst);

    if verbose then
      printf("DONE\n");
    end if;

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
    skipnull::boolean  := true,
    data::list(symbol) := [],
    info::string       := "No info",
    label::string      := "out",
    indent::string     := "  ",
    verbose::boolean   := false
    }, $)::string;

    description "Translate the vector <vec> with variables <vars> into a "
      "Matlab function named <name> and return it as a string. The optional "
      "arguments areclass properties <data>, function description <info>, "
      "veilig label <label>, and indentation string <indent>. If <verbose> "
      "is true, the function prints the progress on the screen.";

    local header, properties, inputs, veils, elements, outputs, dims, lst,
      tmp_data, ten_inds, tmp_vars, tmp_vars_rm, tmp_vars_nl;

    if verbose then
      printf("Generating tensor function '%s'... ", name);
    end if;

    # Extract the function properties
    tmp_data := convert(data, set) intersect indets(ten, symbol);
    tmp_data := remove[flatten](j -> not (j in tmp_data), data);
    properties := IndigoCodegen:-GenerateProperties(
      tmp_data, parse("indent") = indent
    );

    # Extract the function elements
    dims := op~(2, [ArrayDims(ten)]);
    lst, outputs := IndigoCodegen:-ExtractElements(
      name, ten, dims, parse("skipnull") = skipnull, parse("indent") = indent,
      parse("label") = label
    );

    # Extract the function inputs
    ten_inds    := indets(ten, symbol);
    tmp_vars    := map(i -> i intersect ten_inds, map(convert, vars, set));
    tmp_vars_rm := zip((i, j) -> remove[flatten](k -> not (k in j), i), vars, tmp_vars);
    tmp_vars_nl := zip((i, j) -> map(k -> `if`(not (k in j), "", k), i), vars, tmp_vars);
    inputs := IndigoCodegen:-GenerateInputs(
      tmp_vars_nl, parse("indent") = indent, parse("skipnull") = true
    );

    # Generate the method header
    header := IndigoCodegen:-GenerateHeader(
      name, tmp_vars_rm, parse("info") = info, parse("indent") = indent,
      parse("skipthis") = evalb(nops(tmp_data) = 0),
      parse("skiptime") = not has(indets(ten, symbol), 't')
    );

    # Generate the elements
    elements := IndigoCodegen:-GenerateElements(lst);

    if verbose then
      printf("DONE\n");
    end if;

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
      "(v[j])(f) to v_j and from D[i](v[j])(f) to D_v_j_i. The function also "
      "requires the system states <vars>.";

    local v, v_dot, x, x_lst, rm_v_deps, rm_v_dot_deps, i, v_tmp, v_dot_tmp,
      tmp_l, tmp_r, tmp_i, tmp_j;

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
    if not type(vars, list) then
      x_lst :=  convert(vars, list);
    else
      x_lst := vars;
    end if;

    # Compute transformations
    rm_v_deps     := [];
    rm_v_dot_deps := [];
    if (nops(v) > 0) then

      # Transform veil variables (v[i])(f) -> v_i
      v_tmp := Array(v);
      for i from 1 to op(2, ArrayDims(v_tmp)) do
        # (v[i])(f) -> v[i]
        if type(v_tmp[i], function) then
          v_tmp[i] := op(0, v_tmp[i]);
        end if;
        # v[i] -> v_i
        if type(v_tmp[i], indexed) then
          v_tmp[i] := convert(
            cat(op(0, v_tmp[i]), "_", op(1..-1, v_tmp[i])), symbol
          );
        end if;
      end do;
      rm_v_deps := v =~ convert(v_tmp, list);

      # Calculate veils derivatives
      # from   [..., v, ...] -> [..., grad(v), ...]
      # remove [..., 0, ...] -> [..., ...]
      v_dot := remove[flatten](j -> (j = 0),
        convert(IndigoUtils:-DoJacobian(convert(v, Vector), x), list)
      );

      # Transform veils derivatives from D[i](v[j])(f) to D_v_j_i
      v_dot_tmp := Array(v_dot);
      for i from 1 to op(2, ArrayDims(v_dot_tmp)) do
        # D[i](var[j])(f) -> D_i
        tmp_l := op(0, op(0, v_dot_tmp[i]));
        # D[i](var[j])(f) -> D_i
        if type(tmp_l, indexed) then
          tmp_i := op(1..-1, tmp_l);
          tmp_l := op(0, tmp_l);
        end if;
        if (nops([tmp_i]) <> 1) then
          error("invalid variable derivative detected.");
        end if;
        # D[i](var[j])(f) -> D_i
        tmp_r := op(1, op(0, v_dot_tmp[i]));
        # D[i](var[j])(f) -> var_j
        if type(tmp_r, indexed) then
          tmp_j := op(1..-1, tmp_r);
          tmp_r := op(0, tmp_r);
        end if;
        if (nops([tmp_j]) <> 1) then
          error("invalid component derivative detected.");
        end if;
        v_dot_tmp[i] := convert(
          #cat(tmp_l, "_", tmp_r, "_", tmp_j, "_", tmp_i), symbol
          cat(tmp_l, "_", tmp_r, "_", tmp_j, "_", ListTools:-Search(
            op(tmp_i, v_dot_tmp[i]), x_lst
          )), symbol
        );
      end do;
      rm_v_dot_deps := v_dot =~ convert(v_dot_tmp, list);

    end if;

    # Return output
    return rm_v_deps, rm_v_dot_deps;
  end proc: # GetVeilSubs

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local GenerateConstructor := proc(
    name::string,
    sys_type::string,
    {
    num_fncs::nonnegint := 0,
    num_veil::nonnegint := 0,
    num_invs::nonnegint := 0,
    data::list(symbol)  := [],
    info::string        := "Class constructor.",
    indent::string      := "  "
    }, $)::string;

    description "Generate a constructor for a system named <name> with "
      "system type <sys_type>, number of functions <num_fncs>, number of "
      "veils <num_veil>, number of invariants <num_invs>, system data "
      "<data> and description <info>.";

    return cat("function this = ", name, "( varargin )\n",
      IndigoCodegen:-ApplyIndent(
        indent, cat(
        "% ", info, "\n",
        "\n",
        "% Superclass constructor\n",
        "num_eqns = ", num_fncs, ";\n",
        "num_veil = ", num_veil, ";\n",
        "num_invs = ", num_invs, ";\n",
        "this = this@Indigo.DAE.", sys_type, "('", name, "', num_eqns, num_veil, num_invs);\n",
        `if`(nops(data) > 0, cat(
        "\n",
        "% User data\n",
        # No input arguments
        "if (nargin == 0)\n",
        indent, "% Keep default values\n",
        # Struct input argument
        "elseif (nargin == 1 && isstruct(varargin{1}))\n",
        cat~(op(cat~(indent, "this.m_", convert~(data, string), " = varargin{1}.",
          convert~(data, string), ";\n"))
        ),
        # Many input arguments
        "elseif (nargin == ", nops(data), ")\n",
        cat~(op(cat~(indent, "this.m_", convert~(data, string), " = varargin{",
          convert~([seq(1..nops(data))], string), "};\n"))
        ),
        # Wrong number of input arguments
        "else\n",
        indent, "error('wrong number of input arguments.');\n",
        "end\n"
        ), "")
      )),
      "end % ", name, "\n");

  end proc: # GenerateConstructor

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
    pvts::Matrix(algebraic)             := Matrix([]),
    data::list(symbol = algebraic)      := [],
    info::string                        := "No class description provided.",
    label::string                       := "out",
    indent::string                      := "  "
    }, $)::string;

    description "Generate an implicit system for the firt-order differential "
      "equations <eqns>, pivots <pvts>, invariants <invs> with states variables "
      "<vars> and states variables, system data <data>, veilig label <label>, and "
      "description <info>.";

    local x, x_dot, F, pvts_tmp, JF_x, JF_x_dot, v, v_fncs, Jv_x, JF_v, h, Jh_x,
      Jh_v, rm_deps, rm_v_dot_deps, rm_v_deps, rm_x_deps, rm_x_dot_deps, mk_x_dot,
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
    JF_x_dot := IndigoUtils:-DoJacobian(F, x_dot);
    JF_v     := IndigoUtils:-DoJacobian(F, v);

    # Store system invariants and calculate Jacobian
    if not type(invs, Vector) then
      h := convert(invs, Vector);
    else
      h := invs;
    end if;
    Jh_v := IndigoUtils:-DoJacobian(h, v);
    h    := subs(op(rm_v_deps), h);
    Jh_x := IndigoUtils:-DoJacobian(h, x);

    # Compose substitutions
    rm_deps := [
      op(rm_v_dot_deps), # D[i](v[j])(f) -> D_v_j_i
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
    JF_v     := subs(op(rm_deps), JF_v);
    v        := convert(subs(op(rm_deps), v), list);
    v_fncs   := subs(op(rm_deps), v_fncs);
    Jv_x     := subs(op(rm_deps), Jv_x);
    h        := subs(op(rm_deps), h);
    Jh_x     := subs(op(rm_deps), Jh_x);
    Jh_v     := subs(op(rm_deps), Jh_v);
    pvts_tmp := subs(op(rm_deps), pvts);

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
      "classdef ", name, " < Indigo.DAE.Implicit\n",
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
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        GenerateConstructor(
          name, "Implicit",
          parse("num_fncs") = LinearAlgebra:-Dimension(F),
          parse("num_veil") = LinearAlgebra:-Dimension(v_fncs),
          parse("num_invs") = LinearAlgebra:-Dimension(h),
          parse("data")     = properties,
          parse("info")     = "Class constructor.",
          parse("indent")   = i
      )),
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
          parse("data")  = properties,
          parse("label") = label,
          parse("info")  = "Evaluate the the veils v."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "Jv_x", [x, v], Jv_x,
          parse("skipnull") = false,
          parse("data")     = properties,
          parse("label")    = cat("D_", label),
          parse("info")     = "Evaluate the Jacobian of v with respect to x."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "h", [x, v], h,
          parse("data")  = properties,
          parse("info")  = "Calculate the residual of the invariants h."
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
          "pivots", [x, v], pvts_tmp,
          parse("data") = properties,
          parse("info") = "Calculate the pivoting values"
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
      i, i, "function out = in_domain( ~, ~, ~ )\n",
      i, i, i, "out = true;\n",
      i, i, "end % in_domain\n",
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
    {
    invs::{Vector(algebraic), list(algebraic)} := [],
    veil::{Vector(algebraic) = algebraic,
           list(algebraic = algebraic)} := [],
    pvts::Matrix(algebraic)             := Matrix([]),
    data::list(symbol = algebraic)      := [],
    info::string                        := "No class description provided.",
    label::string                       := "out",
    indent::string                      := "  "
    }, $)::string;

    description "Generate an explicit system for the firt-order differential "
      "equations <eqns>, pivots <pvts>, invariants <invs> with states variables "
      "<vars> and states variables, system data <data>, veilig label <label> and "
      "description <info>.";

    local x, x_dot, F, A, b, f, pvts_tmp, Jf_x, v, v_fncs, Jv_x, Jf_v, h, Jh_x,
      Jh_v, rm_deps, rm_v_dot_deps, rm_v_deps, rm_x_deps, rm_x_dot_deps, mk_x_dot,
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
    F := subs(op(mk_x_dot), op(rm_v_deps), F);

    # Extract f from: F(x,x',v,t) = A(x,v,t) * x' - b(x,v,t)
    A, b := LinearAlgebra:-GenerateMatrix(convert(F, list), convert(x_dot, list));

    if (LinearAlgebra:-RowDimension(A) <> LinearAlgebra:-ColumnDimension(A) ) or
       (LinearAlgebra:-Rank(A) <> LinearAlgebra:-ColumnDimension(A)) then
      error("the system cannot be transformed into an explicit form, the "
        "matrix A is not square or full rank.");
      return NULL;
    end if;

    f    := LinearAlgebra:-LinearSolve(A, b);
    Jf_x := IndigoUtils:-DoJacobian(f, x);
    Jf_v := IndigoUtils:-DoJacobian(f, v);

    # Store system invariants and calculate Jacobian
    if not type(invs, Vector) then
      h := convert(invs, Vector);
    else
      h := invs;
    end if;
    Jh_v := IndigoUtils:-DoJacobian(h, v);
    h    := subs(op(rm_v_deps), h);
    Jh_x := IndigoUtils:-DoJacobian(h, x);

    # Compose substitutions
    rm_deps := [
      op(rm_v_dot_deps), # D[i](v[j])(f) -> D_v_j_i
      op(rm_v_deps),     # (v[j])(f) -> v_j
      op(rm_x_deps),     # x(t) -> x
      op(rm_x_dot_deps)  # x_dot(t) -> x_dot
    ];

    # Generate expressions with proper variables dependencices
    x        := convert(subs(op(rm_deps), x), list);
    x_dot    := convert(subs(op(rm_deps), x_dot), list);
    f        := subs(op(rm_deps), f);
    Jf_x     := subs(op(rm_deps), Jf_x);
    Jf_v     := subs(op(rm_deps), Jf_v);
    v        := convert(subs(op(rm_deps), v), list);
    v_fncs   := subs(op(rm_deps), v_fncs);
    Jv_x     := subs(op(rm_deps), Jv_x);
    h        := subs(op(rm_deps), h);
    Jh_x     := subs(op(rm_deps), Jh_x);
    Jh_v     := subs(op(rm_deps), Jh_v);
    pvts_tmp := subs(op(rm_deps), pvts);


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
      "classdef ", name, " < Indigo.DAE.Explicit\n",
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
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        GenerateConstructor(
          name, "Explicit",
          parse("num_fncs") = LinearAlgebra:-Dimension(f),
          parse("num_veil") = LinearAlgebra:-Dimension(v_fncs),
          parse("num_invs") = LinearAlgebra:-Dimension(h),
          parse("data")     = properties,
          parse("info")     = "Class constructor.",
          parse("indent")   = i
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "f", [x, v], f,
          parse("data") = properties,
          parse("info") = "Evaluate the function f."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "Jf_x", [x, v], Jf_x,
          parse("data") = properties,
          parse("info") = "Evaluate the Jacobian of f with respect to x."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "Jf_v", [x, v], Jf_v,
          parse("data") = properties,
          parse("info") = "Evaluate the Jacobian of f with respect to v."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "v", [x], v_fncs,
          parse("data")  = properties,
          parse("label") = label,
          parse("info")  = "Evaluate the the veils v."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "Jv_x", [x, v], Jv_x,
          parse("skipnull") = false,
          parse("data")     = properties,
          parse("label")    = cat("D_", label),
          parse("info")     = "Evaluate the Jacobian of v with respect to x."
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
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "pivots", [x, v], pvts_tmp,
          parse("data") = properties,
          parse("info") = "Calculate the pivoting values"
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      i, i, "function out = in_domain( ~, ~, ~ )\n",
      i, i, i, "out = true;\n",
      i, i, "end % in_domain\n",
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
    {
    invs::{Vector(algebraic), list(algebraic)} := [],
    veil::{Vector(algebraic) = algebraic,
           list(algebraic = algebraic)} := [],
    pvts::Matrix(algebraic)             := Matrix([]),
    data::list(symbol = algebraic)      := [],
    info::string                        := "No class description provided.",
    label::string                       := "out",
    indent::string                      := "  "
    }, $)::string;

    description "Generate a semi explicit system for the firt-order differential "
      "equations <eqns>, pivots <pvts>, invariants <invs> with states variables "
      "<vars> and states variables, system data <data>, veilig label <label> and "
      "description <info>.";

    local x, x_dot, F, A, b, pvts_tmp, TA_x, TA_v, Jb_x, Jb_v, v, v_fncs, Jv_x,
      h, Jh_x, Jh_v, rm_deps, rm_v_dot_deps, rm_v_deps, rm_x_deps, rm_x_dot_deps,
      mk_x_dot, i, bar, data_str, properties;

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
    F := subs(op(mk_x_dot), op(rm_v_deps), F);

    # Extract f from: F(x,x',v,t) = A(x,v,t) * x' - b(x,v,t)
    A, b := LinearAlgebra:-GenerateMatrix(convert(F, list), convert(x_dot, list));

    if (LinearAlgebra:-RowDimension(A) <> LinearAlgebra:-ColumnDimension(A)) or
       (LinearAlgebra:-Rank(A) <> LinearAlgebra:-ColumnDimension(A)) then
      error("the system cannot be transformed into an explicit form, the "
        "matrix A is not square or full rank.");
      return NULL;
    end if;

    TA_x := IndigoUtils:-DoTensor(A, x);
    TA_v := IndigoUtils:-DoTensor(A, v);
    Jb_x := IndigoUtils:-DoJacobian(b, x);
    Jb_v := IndigoUtils:-DoJacobian(b, v);

    # Store system invariants and calculate Jacobian
    if not type(invs, Vector) then
      h := convert(invs, Vector);
    else
      h := invs;
    end if;
    Jh_v := IndigoUtils:-DoJacobian(h, v);
    h    := subs(op(rm_v_deps), h);
    Jh_x := IndigoUtils:-DoJacobian(h, x);

    # Compose substitutions
    rm_deps := [
      op(rm_v_dot_deps), # D[i](v[j])(f) -> D_v_j_i
      op(rm_v_deps),     # (v[j])(f) -> v_j
      op(rm_x_deps),     # x(t) -> x
      op(rm_x_dot_deps)  # x_dot(t) -> x_dot
    ];

    # Generate expressions with proper variables dependencices
    x        := convert(subs(op(rm_deps), x), list);
    x_dot    := convert(subs(op(rm_deps), x_dot), list);
    A        := subs(op(rm_deps), A);
    TA_x     := subs(op(rm_deps), TA_x);
    TA_v     := subs(op(rm_deps), TA_v);
    b        := subs(op(rm_deps), b);
    Jb_x     := subs(op(rm_deps), Jb_x);
    Jb_v     := subs(op(rm_deps), Jb_v);
    v        := convert(subs(op(rm_deps), v), list);
    v_fncs   := subs(op(rm_deps), v_fncs);
    Jv_x     := subs(op(rm_deps), Jv_x);
    h        := subs(op(rm_deps), h);
    Jh_x     := subs(op(rm_deps), Jh_x);
    Jh_v     := subs(op(rm_deps), Jh_v);
    pvts_tmp := subs(op(rm_deps), pvts);

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
      "classdef ", name, " < Indigo.DAE.SemiExplicit\n",
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
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        GenerateConstructor(
          name, "SemiExplicit",
          parse("num_fncs") = LinearAlgebra:-Dimension(F),
          parse("num_veil") = LinearAlgebra:-Dimension(v_fncs),
          parse("num_invs") = LinearAlgebra:-Dimension(h),
          parse("data")     = properties,
          parse("info")     = "Class constructor.",
          parse("indent")   = i
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "A", [x, v], A,
          parse("data") = properties,
          parse("info") = "Evaluate the matrix A."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-TensorToMatlab(
          "TA_x", [x, v], TA_x,
          parse("data") = properties,
          parse("info") = "Evaluate the tensor of A with respect to x."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-TensorToMatlab(
          "TA_v", [x, v], TA_v,
          parse("data") = properties,
          parse("info") = "Evaluate the tensor of A with respect to v."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "b", [x, v], b,
          parse("data") = properties,
          parse("info") = "Calculate the vector b of the explicit system."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "Jb_x", [x, v], Jb_x,
          parse("data") = properties,
          parse("info") = "Calculate the Jacobian of b with respect to x."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "Jb_v", [x, v], Jb_v,
          parse("data") = properties,
          parse("info") = "Calculate the Jacobian of b with respect to v."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-VectorToMatlab(
          "v", [x], v_fncs,
          parse("data")  = properties,
          parse("label") = label,
          parse("info")  = "Evaluate the the veils v."
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "Jv_x", [x, v], Jv_x,
          parse("skipnull") = false,
          parse("data")     = properties,
          parse("label")    = cat("D_", label),
          parse("info")     = "Evaluate the Jacobian of v with respect to x."
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
      IndigoCodegen:-ApplyIndent(
        cat(i, i),
        IndigoCodegen:-MatrixToMatlab(
          "pivots", [x, v], pvts_tmp,
          parse("data") = properties,
          parse("info") = "Calculate the pivoting values"
      )),
      i, i, "%\n",
      i, i, bar,
      i, i, "%\n",
      i, i, "function out = in_domain( ~, ~, ~ )\n",
      i, i, i, "out = true;\n",
      i, i, "end % in_domain\n",
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
