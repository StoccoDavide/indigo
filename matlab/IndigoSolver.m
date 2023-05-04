%
%> Wrapper for the Indigo Runge-Kutta method class instantiation.
%>
%> \param name The name of the Runge-Kutta method class.
%>
%> \return An instance of the requested Runge-Kutta method class.
%
function out = IndigoSolver( name )

  str = IndigoSolversList();
  k   = find(strcmpi(cellfun(@(x) x{1}, str, 'UniformOutput', false), name));
  if isempty(k)
    error(['IndigoSolver(...): invalid class ''', name, '''.']);
  end
  out = Indigo.RungeKutta.Methods.(str{k}{2}).(name)();
end
