
function y=DefaultStruct(x,d,Empty2Default)

% y=DefaultStruct(x,d) returns a struct which is
% composed of all fields of the struct x and of the fields of 
% d which are not present in x. So the fields of d serve as defaults.
%
% y=DefaultStruct(x,d,1) uses also for empty x-fields the default 
% value from d. 

if (nargin<3)|isempty(Empty2Default),
  Empty2Default=0;
end

y=d;

n=fieldnames(x);

for m=1:length(n(:)),
  f=n{m};
  xf=getfield(x,f);
  if ~(isempty(xf)&Empty2Default),
    y=setfield(y,f,xf);
  end
end
