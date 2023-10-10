%
%> Get the list of available method classes.
%>
%> \return A cell array of strings containing the names of the available
%>         method classes and their corresponding type.
%
function out = IndigoSolversList()
  lst = dir([mfilename('fullpath') '/../+Indigo/+Tableau']);
  out = {};
  for k=1:length(lst)
    n = lst(k).name;
    if length(n) > 2
      if n(end) == 'm' && n(end-1) == '.'
        out{end+1} = n(1:end-2);
      end
    end
  end
end