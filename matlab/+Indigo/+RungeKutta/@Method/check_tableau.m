function [out,order,e_order] = check_tableau( this, tbl )

  arguments
    this Indigo.RungeKutta.Method
    tbl  struct
  end

  CMD = 'Indigo.RungeKutta.Method.check_tableau(...): ';

  % Collect input data
  A   = tbl.A;
  b   = tbl.b;
  b_e = tbl.b_e;
  c   = tbl.c;

  % Prepare output
  out = true;

  % Check matrix A
  if ~all(isnumeric(A))
    warning([CMD, 'A must be a numeric matrix.']);
    out = false;
  end
  if (size(A, 1) ~= size(A, 2))
    warning([CMD, 'matrix A is not a square matrix.']);
    out = false;
  end
  if ~all(isfinite(A))
    warning([CMD, 'matrix A found with NaN or Inf values.']);
    out = false;
  end

  % Check vector b
  if ~all(isnumeric(b))
    warning([CMD, 'b must be a numeric vector.']);
    out = false;
  end
  if ~all(isfinite(b))
    warning([CMD, 'matrix b found with NaN or Inf values.']);
    out = false;
  end
  if (~isrow(b))
    warning([CMD, 'vector b is not a row vector.']);
    out = false;
  end
  if (size(A, 2) ~= size(b, 2))
    warning([CMD, 'vector b is not consistent with the size of matrix A.']);
    out = false;
  end

  % Check vector b_e
  if ~isempty(b_e)
    if (~isnumeric(b_e))
      warning([CMD, 'b_e must be a numeric vector.']);
      out = false;
    end
   if ~all(isfinite(b_e))
      warning([CMD, 'vector b_e found with NaN or Inf values.']);
      out = false;
    end
    if (~isrow(b_e))
      warning([CMD, 'vector b_e is not a row vector.']);
      out = false;
    end
    if (size(A, 2) ~= size(b_e, 2))
      warning([CMD, 'vector b_e is not consistent with the size of matrix A.']);
      out = false;
    end
  end

  % Check vector c
  if ~all(isnumeric(c))
    warning([CMD, 'c must be a numeric vector.']);
    out = false;
  end
  if ~all(isfinite(c))
    warning([CMD, 'vector c found with NaN or Inf values.']);
    out = false;
  end
  if (~iscolumn(c))
    warning([CMD, 'vector c is not a column vector.']);
    out = false;
  end
  if (size(A, 1) ~= size(c, 1))
    warning([CMD, 'vector c is not consistent with the size of matrix A.']);
    out = false;
  end

  % check consistency
  [order,msg] = this.tableau_order( A, b, c );

  if order ~= this.m_order
    warning( sprintf( '%s\norder %d not what expected %d.\n%s', CMD, order, this.m_order, msg ) );
    out = false;
  end

  if ~isempty(b_e)
    [e_order,msg] = this.tableau_order( A, b_e, c );
    %fprintf( '%s\norder = %d, embedded order = %d\n', CMD, order, e_order );
  else
    e_order = 0;
    %fprintf( '%s\norder = %d\n', CMD, order );
  end

end
