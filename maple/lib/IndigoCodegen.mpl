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
# This is a module for the 'IndigoCodegen' module.

IndigoCodegen := module()

  local m_optionsForCodegen,
        m_WorkingDirectory;

  option package,
         load   = ModuleLoad,
         unload = ModuleUnload;

  description "Code Generation for the 'IndigoCodegen' module.";

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local ModuleLoad := proc()
    description "'IndigoCodegen' module load procedure.";
    m_optionsForCodegen := [
      ### optimize=true,
      digits=30,
      deducereturn=false,
      coercetypes=false,
      deducetypes=false,
      reduceanalysis=true,
      defaulttype=numeric,
      functionprecision=double
    ];
    return NULL;
  end proc: # ModuleLoad

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  local ModuleUnload := proc()
    description "'IndigoCodegen' module unload procedure.";
    return NULL;
  end proc: # ModuleUnload

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # PROCEDURE () ------------------------------------------------------------#
  # Function called at module instatiation or loaded from a repository.
  export SetWorkingDirectory := proc( dirname::string, $ )
    m_WorkingDirectory := cat(currentdir(),"/",dirname,"/"):
    try
      mkdir(m_WorkingDirectory):
    catch :
      IndigoUtils:-PrintMessage( "Working directory already exists\n" ):
    end try;
    IndigoUtils:-PrintMessage( "Working directory: %s\n",m_WorkingDirectory ):
    NULL;
  end proc:

  # PROCEDURE () ------------------------------------------------------------#
  # Procedure that creates an empty file.
  # param fname = file name
  # return  none.
  export ClearFile := proc( fname )
    local fd;
    fd := fopen(fname, WRITE);
    fprintf(fd, "\n"):
    fclose(fd);
  end proc:


  # PROCEDURE () ------------------------------------------------------------#
  # Set options for CodeGeneration
  #
  export SetCodegenOptions := proc ( opts::list:=[], $ )
    m_optionsForCodegen := opts;
  end proc:

  # PROCEDURE () ------------------------------------------------------------#
  # Procedure that writes, into a given file name the passed expression
  # translated into MATLAB code.
  # param EXPR  = expression
  # param fname = file name
  # param fname = file name
  # return  = none.
  #===========================================================================
  #  _____                 _      _      _____    __  __      _   _      _
  # |_   _| _ __ _ _ _  __| |__ _| |_ __|_   _|__|  \/  |__ _| |_| |__ _| |__
  #   | || '_/ _` | ' \(_-< / _` |  _/ -_)| |/ _ \ |\/| / _` |  _| / _` | '_ \
  #   |_||_| \__,_|_||_/__/_\__,_|\__\___||_|\___/_|  |_\__,_|\__|_\__,_|_.__/
  #===========================================================================
  #
  local TranslateToMatlab := proc( ELIST::list, do_optimize::boolean := false )
    description
    "The command converts a list of expressions into an optimized C code.",
    "\nArguments:",
    "  -EXPR:  algebraic expression, or list of expression",
    "  -fname: file name where converted code is written into.\n";
    local i, userFun, FunProc, userPars, arg, tmp;
    IndigoCodegen:-ClearFile(fname);
    userFun := [ "floor", "ceil", "round", "trunc", "erf" ];

    CodeGeneration[LanguageDefinition]:-Define(
      "NewMatlab", extend="Matlab",
      seq( AddFunction( userFun[i], anything::numeric, userFun[i] ),i=1..nops(userFun) )
    );

    # [optimize = true, digits = 30, deducereturn = false, coercetypes = false, deducetypes = false, reduceanalysis = false, defaulttype = numeric, functionprecision = double]
    # da aggiungere ottimizzazione
    # -------
    return CodeGeneration[Translate](
      ELIST, language="NewMatlab",
      op(m_optionsForCodegen),
      optimize=do_optimize,
      output='string'
    );
  end:
  #
  #  F_in = map to be transated
  #  vars = variable names
  export F2Matlab := proc( name::string, vars::list(list({symbol,string})), F::list, do_optimize := true )
    local i, j, varsj, LST, vars_extracted, res_extracted, ind, str, out;
    ind := "  ";
    # variable extract
    vars_extracted := "";
    for j from 1 to nops(vars) do
      varsj := vars[j];
      for i from 1 to nops(varsj) do
        vars_extracted := sprintf(
          "%s%s  %s = vars%d(%d);\n",
          vars_extracted, ind, convert(varsj[i],string), j, i
        );
      end;
    end;
    # extract function as a list os assignment
    LST           := []:
    res_extracted := "";
    for i from 1 to nops(F) do
      if evalb(F[i] <> 0) then
        LST := [op(LST), convert("res__"||i,symbol) = F[i] ];
        res_extracted := sprintf(
          "%s%s  res__%s(%d) = res__%d;\n",
          res_extracted, ind, name, i, i
        );
      end;
    end;
    # generate complete MATLAB method into a class
    out := sprintf("%sfunction res__%s = %s( self", ind, name, name );
    # add arguments
    for j from 1 to nops(vars) do
      out := sprintf("%s, vars%d", out, j );
    end;
    out := sprintf("%s, t)\n", out, j );
    out := sprintf(
      "%s"
      "%s  %% extract vars by name\n"
      "%s"
      "%s  %% generated code\n",
      out, ind, vars_extracted, ind
    );
    # convert to Matab code all the assigment
    str := IndigoCodegen:-TranslateToMatlab(LST,do_optimize);
    out := sprintf("%s%s  %s\n", out, ind, StringTools[SubstituteAll]( str, "\n", cat("\n  ",ind) ));
    out := sprintf(
      "%s"
      "%s  %% store computation on output\n"
      "%s  res__%s = zeros(%d,1);\n"
      "%s"
      "%send\n",
      out, ind, ind, name, nops(F), res_extracted, ind
    );
  end proc:


# JF_TO_MATLAB := proc( JF, vars, name )
#   local val, pat, NR, NC, i, j, str, ind, LST;
#   NR  := LinearAlgebra[RowDimension](JF);
#   NC  := LinearAlgebra[ColumnDimension](JF);
#   LST := []:
#   pat := "";
#   ind := "    ";
#   for i from 1 to NR do
#     for j from 1 to NC do
#       val := simplify(JF[i,j]);
#       if evalb(val <> 0) then
#         LST := [op(LST), convert("res__"||i||_||j,symbol) = val];
#         pat := cat(pat,sprintf("%s  res__%s(%d,%d) = res__%d_%d;\n",ind,name,i,j,i,j));
#       end;
#     end;
#   end;
#   str := CodeGeneration[Matlab](LST,optimize=true,coercetypes=false,deducetypes=false,output=string);
#   printf("%sfunction res__%s = %s( self, t, vars__ )\n",ind,name,name);
#   printf("\n%s  %% extract states\n",ind);
#   for i from 1 to nops(vars) do
#
#
#   end proc:


end module: # IndigoCodegen

# That's all folks!
