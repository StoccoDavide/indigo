%
%> Wrapper for the Indigo Runge-Kutta method class instantiation.
%>
%> \param name The name of the Runge-Kutta method class.
%>
%> \return An instance of the requested Runge-Kutta method class.
%
function out = IndigoSolver( name )
  str = IndigoSolversList();
  k   = find(strcmpi(str,name));
  if isempty(k)
    %str
    error(['IndigoSolver(...): cant find solver ''', name, '''.']);
  end
  out = Indigo.Tableau.(name)();
end
