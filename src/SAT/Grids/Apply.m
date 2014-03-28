
function varargout=Apply(f,c,Expand);

% varargout=Apply(f,c,Expand) applies the function f
% to each component of the cell array c and returns the 
% results in a corresponding cell array. If Expand=1 is passed,
% the cell contents are returned as several output arguments.

y=cell(size(c));

for n=1:prod(size(c)),
  y{n}=feval(f,c{n});
end

if nargin>2,
  if isequal(Expand,1),
    varargout=y;
    return
  end
end

varargout={y};
