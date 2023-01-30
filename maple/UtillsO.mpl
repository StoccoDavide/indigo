#! .. _Indigo-io-package:
#!
#! ==================
#! Indigo IO package
#! ==================
#!
#!

IndigoIO := module()

  description "Module for I/O operation to automatic code generation. Used by Indigo Library\n";

  # Module defined as a package (i.e.) collection of procedures
  option package, load = ModuleLoad, unload = ModuleUnLoad;

  export setWorkDir,
         clearFile,
         expressionToC,
         expressionToRuby,
         generate_code,
         fullVectorWrite,
         fullVectorWriteWithNull,
         sparseMatrixWrite,
         fullMatrixWrite,
         addDefs,
         setCodegenOptions;

  local  ModuleLoad,
         ModuleUnLoad,
         convertNumber,
         convertNumberAndSplit,
         optionsForCodegen,
         translateToC;

  global WorkDir; # directory di lavoro

  uses LinearAlgebra, IndigoUtils;

  # PROCEDURE () ------------------------------------------------------------#
  # Function called at module instatiation or loaded from a repository.
  ModuleLoad := proc( )
    # display a message
    copyright("IndigoIO");
    optionsForCodegen := [
      ### optimize=true,
      digits=30,
      deducereturn=false,
      coercetypes=false,
      deducetypes=false,
      reduceanalysis=true,
      defaulttype=numeric,
      functionprecision=double
    ];
    NULL;
  end proc:

  # PROCEDURE () ------------------------------------------------------------#
  # Function called at module instatiation or loaded from a repository.
  setWorkDir := proc( dirname::string, $ )
    WorkDir := cat(currentdir(),"/",dirname,"/"):
    try
      mkdir(WorkDir):
    catch :
      printf("Working directory already exists\n"):
    end try;
    printf("Working directory: %s\n",WorkDir):
    NULL;
  end proc:

  # PROCEDURE () ------------------------------------------------------------#
  # Function called when the module is destroyed
  ModuleUnLoad := proc( )
    # print a message
    # printf("Going away module 'I/O'\n");
    NULL;
  end proc:

  # PROCEDURE () ------------------------------------------------------------#
  # Procedure that creates an empty file.
  # param fname = file name
  # return  none.
  clearFile := proc( fname )
    local fd;
    fd := fopen(fname, WRITE);
    fprintf(fd, "\n"):
    fclose(fd);
  end proc:

  # PROCEDURE () ------------------------------------------------------------#
  # Set options for CodeGeneration
  #
  setCodegenOptions := proc ( opts::list:=[], $ )
    optionsForCodegen := opts;
  end proc:

  expressionToC := proc( EXPR )
    local res;
    if type( EXPR, string ) then
      res :=  cat("\"",EXPR,"\"");
    else
      res := CodeGeneration[C](
        EXPR,
        optimize=false,
        deducereturn=false,
        coercetypes=false,
        deducetypes=false,
        defaulttype=numeric,
        functionprecision=double,
        resultname=_,
        output=string
      );
    end:
    res;
  end proc:

  expressionToRuby := proc( EXPR )
    local res;
    if type( EXPR, string ) then
      res := cat("\"",EXPR,"\"");
    else
      res := EXPR;
    end:
    res;
  end proc:

  # PROCEDURE () ------------------------------------------------------------#
  # Procedure that writes, into a given file name the passed expression translated into C code.
  # param EXPR  = expression
  # param fname = file name
  # return  = none.
  #===========================================================================
  #   _                       _       _      _____      ____
  #  | |_ _ __ __ _ _ __  ___| | __ _| |_ __|_   _|__  / ___|
  #  | __| '__/ _` | '_ \/ __| |/ _` | __/ _ \| |/ _ \| |
  #  | |_| | | (_| | | | \__ \ | (_| | ||  __/| | (_) | |___
  #   \__|_|  \__,_|_| |_|___/_|\__,_|\__\___||_|\___/ \____|
  #===========================================================================
  #
  translateToC := proc( EXPR, fname, do_optimize :: boolean := false )
    description
    "The command converts a list of expressions into an optimized C code.",
    "\nArguments:",
    "  -EXPR:  algebraic expression, or list of expression",
    "  -fname: file name where converted code is written into.\n";
    local i, userFun, FunProc, userPars, arg, tmp;
    clearFile(fname);
    userFun := [
      "floor", "ceil", "round", "trunc", "erf",
      op(IndigoSUBS:-getFunctionNames())
    ];

    CodeGeneration[LanguageDefinition]:-Define(
      "NewC", extend="C",
      seq( AddFunction(userFun[i], anything::numeric, userFun[i]),i=1..nops(userFun))
    );

    # [optimize = true, digits = 30, deducereturn = false, coercetypes = false, deducetypes = false, reduceanalysis = false, defaulttype = numeric, functionprecision = double]
    # da aggiungere ottimizzazione
    # -------
    if not (type(EXPR,'list') and nops(EXPR) = 0) then # in MAPLE 18 se gli arriva una lista vuota crepa!
      CodeGeneration[Translate](
        EXPR, language="NewC",
        op(optionsForCodegen),
        optimize=do_optimize,
        output=fname
      );
    end:
  end proc:

  # PROCEDURE () ------------------------------------------------------------#
  # Procedure that writes, in append mode, into a given file name the passed
  # expression translated into C code.
  # param EXPR  = expression
  # param fname = file name
  # return  = none.
  #===========================================================================
  #                                   _                        _
  #    __ _  ___ _ __   ___ _ __ __ _| |_ ___     ___ ___   __| | ___
  #   / _` |/ _ \ '_ \ / _ \ '__/ _` | __/ _ \   / __/ _ \ / _` |/ _ \
  #  | (_| |  __/ | | |  __/ | | (_| | ||  __/  | (_| (_) | (_| |  __/
  #   \__, |\___|_| |_|\___|_|  \__,_|\__\___|___\___\___/ \__,_|\___|
  #   |___/                                 |_____|
  #===========================================================================
  #
  generate_code := proc(
    LIST::list(algebraic=algebraic),
    FNAME::string,
    do_optimize,
    do_optimize_list,
    $
  )
    description
    "The command converts a list of expressions into an optimized C/MATLAB code.",
    "\nArguments:",
    "  -EXPR:  algebraic expression, or list of expression",
    "  -fname: file name where converted code is written into.\n";
    if do_optimize_list then
      translateToC([codegen[optimize](LIST)],cat(WorkDir,FNAME,".c_code"),do_optimize);
    else
      translateToC(LIST,cat(WorkDir,FNAME,".c_code"),do_optimize);
    end;
  end proc:

  # PROCEDURE () ------------------------------------------------------------#
  # Procedure that writes, in append mode, into a given file name the passed
  # vector of expressions translated into C code.
  # param vec   = vector of expressions
  # param FNAME = file name
  # return  = none.
  #===========================================================================
  #    __      _ ___   __      _         __      __   _ _
  #   / _|_  _| | \ \ / /__ __| |_ ___ _ \ \    / / _(_) |_ ___
  #  |  _| || | | |\ V / -_) _|  _/ _ \ '_\ \/\/ / '_| |  _/ -_)
  #  |_|  \_,_|_|_| \_/\___\__|\__\___/_|  \_/\_/|_| |_|\__\___|
  #
  #===========================================================================
  fullVectorWriteWithNull := proc(
    fd::integer,
    vec::Vector,
    FNAME::string,
    do_optimize::boolean := false
  )
    description
    "The command converts a vector of expressions into an optimized C code.",
    "The command calling sequence has the following parameters:\n",
    "  fd    = file descriptior output of dimension",
    "  vec   = vector of algebraic expressions",
    "  fname = file name where converted code is written into.\n";
    local i, lst;
    lst := [];
    for i from 1 to Dimension(vec) do
      if vec[i] <> null then
        if type(vec[i],`=`) then
          if convert(lhs(vec[i]),string) = "dummy__" then
            lst := [op(lst),cat(dummy__,i) = rhs(vec[i])];
          else
            lst := [op(lst),vec[i]];
          end
        else
          lst := [op(lst),result__[i]=vec[i]];
        end;
      end;
    end;
    generate_code( lst, FNAME, do_optimize, true );
    fprintf(fd, "  DATA[:%s_n_eqns] = %d\n", FNAME, Dimension(vec)):
  end proc :

  # PROCEDURE () ------------------------------------------------------------#
  # Procedure that writes, in append mode, into a given file name the passed
  # vector of expressions translated into C code.
  # param vec   = vector of expressions
  # param FNAME = file name
  # return  = none.
  #===========================================================================
  #    __      _ ___   __      _         __      __   _ _
  #   / _|_  _| | \ \ / /__ __| |_ ___ _ \ \    / / _(_) |_ ___
  #  |  _| || | | |\ V / -_) _|  _/ _ \ '_\ \/\/ / '_| |  _/ -_)
  #  |_|  \_,_|_|_| \_/\___\__|\__\___/_|  \_/\_/|_| |_|\__\___|
  #
  #===========================================================================
  fullVectorWrite := proc (
    fd::integer,
    vec::Vector,
    FNAME::string,
    do_optimize::boolean := false
  )
    description
    "The command converts a vector of expressions into an optimized C code.",
    "The command calling sequence has the following parameters:\n",
    "  fd    = file descriptior output of dimension",
    "  vec   = vector of algebraic expressions",
    "  fname = file name where converted code is written into.\n";
    local i, dim;
    dim := Dimension(vec);
    generate_code( [seq(result__[i]=vec[i],i=1..dim)], FNAME, do_optimize, true );
    fprintf(fd, "  DATA[:%s_n_eqns] = %d\n", FNAME, dim):
  end proc :

  # PROCEDURE () ------------------------------------------------------------#
  # Procedure that writes, in append mode, into a given file name the passed
  # matrix of expressions translated into C code. The matrix is written in
  # sparse mode.
  # param A     = matrix of expressions
  # param FNAME = file name
  # return  = none.
  #===========================================================================
  #===========================================================================
  sparseMatrixWrite := proc(
    fd::integer,
    A,
    FNAME::string,
    indent::string := "  ",
    do_optimize :: boolean := false,
    $
  )
    description
    "The command converts a matrix of expressions into an optimized C code.",
    "Only non zero elements, and indices of row and column positions are stored."
    "The command calling sequence has the following parameters:\n",
    "  fd    = file descriptior output of dimension",
    "  A     = matrix of algebraic expressions",
    "  fname = file name where converted code is written into.\n";

    local fname, nr, nc, i, j, nnz, i_index, j_index, sp_mat, cnt, tmp;

    i_index := [];
    j_index := [];
    sp_mat  := [];
    nnz     := 0;

    nr, nc := Dimension(A);
    for i from 1 to nr do
      for j from 1 to nc do
        #tmp := simplify( A[i,j], 'size' );
        tmp := A[i,j];
        if tmp <> 0 then
          nnz     := nnz + 1;
          sp_mat  := [ op(sp_mat), result__[nnz]=tmp ]; #list on non-zero elements
          i_index := [ op(i_index), i-1 ];    #list of row number of non-zero elements according C index order (start form 0)
          j_index := [ op(j_index), j-1 ];    #list of column number of non-zero elements according C index order (start form 0)
        fi;
      od;
    od;

    # write non-zero element into a file
    generate_code( sp_mat, FNAME, do_optimize, true );

    # save pattern in OCP.rb
    fprintf( fd, "\nclass COMMON_Build\n%sDATA[:%s] = {\n", indent, FNAME ):
    fprintf( fd, "%s  :n_rows  => %d,\n", indent, nr  ):
    fprintf( fd, "%s  :n_cols  => %d,\n", indent, nc  ):
    fprintf( fd, "%s  :nnz     => %d,\n", indent, nnz ):
    if nnz > 1 then
      fprintf( fd, "%s  :pattern => [", indent ):
      cnt := 0;
      for i from 1 to nnz do
        if cnt = 0 then
          fprintf(fd,"\n%s    [%3d, %3d],", indent, i_index[i], j_index[i] );
          cnt := 5;
        else
          fprintf(fd," [%3d, %3d],", i_index[i], j_index[i] );
          cnt := cnt -1;
        end:
      od:
      fprintf(fd,"\n%s  ],\n", indent );
    elif nnz > 0 then
      fprintf(fd,"%s  :pattern => [ [%d, %d] ],\n", indent, i_index[nnz], j_index[nnz] );
    else
      fprintf( fd, "%s  :pattern => [],\n", indent ):
    end:
    fprintf( fd, "%s}\nend\n\n", indent ):
  end proc:

  #===========================================================================
  #===========================================================================
  fullMatrixWrite := proc(
    fd::integer,
    A,
    FNAME::string,
    indent::string := "  ",
    do_optimize :: boolean := false,
    $
  )
    description
    "The command converts a matrix of expressions into an optimized C code.",
    "Only non zero elements, and indices of row and column positions are stored."
    "The command calling sequence has the following parameters:\n",
    "  fd    = file descriptior output of dimension",
    "  A     = matrix of algebraic expressions",
    "  fname = file name where converted code is written into.\n";

    local fname, nr, nc, i, j, sp_mat, nnz;

    nnz    := 0;
    nr, nc := Dimension(A);
    nnz    := nr*nc;
    sp_mat := [
      codegen[optimize]([ seq( seq( cat(tmp_,i-1,_,j-1)=A[i,j], i=1..nr), j=1..nc) ]),
      seq( seq( Indigo__result(i-1,j-1)=cat(tmp_,i-1,_,j-1), i=1..nr), j=1..nc)
    ]; #list on non-zero elements

    # write non-zero element into a file
    generate_code( sp_mat, FNAME, do_optimize, false ); # deve essere FALSE!

    # save pattern in OCP.rb
    fprintf( fd, "\n%sDATA[:%s] = {\n", indent, FNAME ):
    fprintf( fd, "%s  :n_rows  => %d,\n", indent, nr  ):
    fprintf( fd, "%s  :n_cols  => %d,\n", indent, nc  ):
    fprintf( fd, "%s}\n\n", indent ):
  end proc:

  #===========================================================================
  #===========================================================================
  convertNumber := proc(val,$)
    if type(val,'truefalse') or type(val,'integer') then
      convert(val,'string');
    elif type(val,'float') then
      sprintf("%.20g",val);
    else
      StringTools[TrimLeft](convert(val,'string'));
    end:
  end proc:
  #===========================================================================
  #===========================================================================
  convertNumberAndSplit := proc(val,$)
    local STR;
    STR := convertNumber(val);
    if StringTools[Length](STR) > 512 then
      STR := StringTools[Join]( [StringTools[LengthSplit](STR,512)], """+\n\t""" );
    end:
    return STR;
  end proc:

  # PROCEDURE () ------------------------------------------------------------#
  # Procedure that writes, in append mode, into a given file name the passed
  # list of parameter descriptors translated into C code.
  #
  # param desc  = list of variable/parameter descriptors
  # param FNAME = file name
  # return  = none.
  #===========================================================================
  #           _    _ ___       __
  #   __ _ __| |__| |   \ ___ / _|___
  #  / _` / _` / _` | |) / -_)  _(_-<
  #  \__,_\__,_\__,_|___/\___|_| /__/
  #===========================================================================
  addDefs := proc(
    fd::integer,
    name::string,
    desc,
    indent::string := "  ",
    first_level::boolean := true
  )
    description
    "The command generates the definitions of default and user defined parameters.",
    "The command check if the default values are defined for the list of parameters that need a definition......."
    "The command calling sequence has the following parameters:\n",
    "  FNAME = name of the file where definition are written into.",
    "  desc  = list of parameters that need a definition.\n";

    local key, kv, mlen, val, last_comma;

    if type(desc,'Array') then
      key := convert(desc,'list');
      addDefs( fd, name, key, indent, first_level );
      return NULL;
    end:

    if type(desc,'table') then
      key := op(2,op(1,desc));
      addDefs( fd, name, key, indent, first_level );
      return NULL;
    end:

    if name <> "" then
      if first_level then
        fprintf( fd, "%sDATA[:%s] = ", indent, name );
      else
        fprintf( fd, "%s:%s => ", indent, name );
      end
    end:

    if type(desc,'list') or type(desc,'set') then
      if nops(desc) = 0 then
        # lista vuota
        fprintf( fd, "[]"):
      elif type(desc,'list(table)') or type(desc,'set(table)') then
        # lista con nomi di funzioni
        fprintf( fd, "[\n" ):
        for key in desc do
          fprintf( fd, "%s  ", indent ) :
          addDefs( fd, "", key, cat(indent,"  "), false );
        end:
        fprintf( fd, "%s]", indent ):
      elif type(desc,'list(function(symbol))') or
           type(desc,'set(function(symbol))') then
        # lista con nomi di funzioni
        fprintf( fd, "[ '%s'", IndigoUtils:-toStringAndSplit(op(0,desc[1])) ):
        for key in map2(op,0,desc[2..-1]) do
          fprintf( fd, ", '%s'",  IndigoUtils:-toStringAndSplit(key) ):
        end:
        fprintf( fd, " ]" ):
      elif type(desc,'list({string,symbol})') or
           type(desc,'set({string,symbol})') then
        # lista con nomi stringhe
        if nops(desc) < 6 then
          fprintf( fd, "[ '%s'", IndigoUtils:-toStringAndSplit(desc[1]) ):
          for key in desc[2..-1] do
            fprintf( fd, ", '%s'", IndigoUtils:-toStringAndSplit(key) ):
          end:
          fprintf( fd, " ]" ):
        else
          fprintf( fd, "[\n" ):
          for key in desc do
            fprintf( fd, "%s  '%s',\n", indent, IndigoUtils:-toStringAndSplit(key) ):
          end:
          fprintf( fd, "%s]", indent ):
        end:
      elif type(desc,'list(algebraic)') or
           type(desc,'set(algebraic)') then
        # lista semplice
        fprintf( fd, "[ '%s'", convertNumberAndSplit(desc[1]) ):
        for key in desc[2..-1] do
          fprintf( fd, ", '%s'", convertNumberAndSplit(key) ):
        end:
        fprintf( fd, " ]" ):
      elif type(desc,'list({string,symbol}={algebraic,string})') or
           type(desc,'set({string,symbol}={algebraic,string})') then
        # calcolo lunghezza massima chiave
        mlen := 0;
        for kv in desc do
          key := length(convert(lhs(kv),'string'));
          if key > mlen then mlen := key end:
        end:
        fprintf( fd, "{\n" ):
        for kv in desc do
          key := convert(lhs(kv),'string');
          fprintf( fd, "%s  :%-*s => '%s',\n", indent, mlen, key, convertNumberAndSplit(rhs(kv)) );
        end:
        fprintf( fd, "%s}", indent ):
      elif type(desc,'list({string,symbol}=anything)') or
           type(desc,'set({string,symbol}=anything)') then
        fprintf( fd, "{\n" ):
        for kv in desc do
          key := convert(lhs(kv),'string');
          addDefs( fd, key, rhs(kv), cat(indent,"  "), false  )
        end:
        fprintf( fd, "%s}", indent ):
      elif type(desc,'list(`=`)') or type(desc,'set(`=`)') then
        # calcolo lunghezza massima chiave
        mlen := 0;
        for kv in desc do
          key := length(convert(lhs(kv),'string'));
          if key > mlen then mlen := key end:
        end:
        fprintf( fd, "{\n" );
        for kv in desc do
          key := cat("'",convert(lhs(kv),'string'),"'");
          fprintf( fd, "%s  %-*s => '%s',\n", indent, mlen+2, key, convertNumberAndSplit(rhs(kv)) );
        end:
        fprintf( fd, "%s}", indent ):
      else
        # lista con nomi di funzioni
        fprintf( fd, "[\n" ):
        for key in desc do
          fprintf( fd, "%s  ", indent ) :
          addDefs( fd, "", key, cat(indent,"  "), false  );
        end:
        fprintf( fd, "%s]", indent ):
      end:
    elif type(desc,'symbol=algebraic') or type(desc,'string=algebraic') then
      key := convert(lhs(desc),'string');
      fprintf( fd, ":%s => '%s'", key, convertNumberAndSplit(rhs(desc)) ):
    elif type(desc,'algebraic') then
      fprintf( fd, "'%s'", convertNumberAndSplit(desc) ):
    elif type(desc,'string') then
      fprintf( fd, "'%s'", IndigoUtils:-toStringAndSplit(desc) ):
    elif type(desc,`<`) or type(desc,`=`) or type(desc,`<=`) then
      fprintf( fd, "'%s'", IndigoUtils:-toStringAndSplit(desc) ):
    else
      fprintf( fd, "addDefs::cannot convert %s: %s\n", whattype(desc), convert(desc,'string')):
      :IndigoUtils:-warningMessage("addDefs::cannot convert `%s`\n",convert(desc,string));
    end:
    if first_level then
      fprintf( fd, "\n" );
    else
      fprintf( fd, ",\n" );
    end
  end proc:

  # Explicitly call ModuleLoad here so the type is registered when this
  # code is cut&pasted in.  ModuleLoad gets called when the module is
  # read from the repository, but the code used to define a module
  # (like the command below) is not called at library read time.
  ##ModuleLoad();

end module:
