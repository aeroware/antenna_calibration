
function c=ToCellstr(a,m)

% c=ToCellstr(a,m) converts a to 1-dim cell array c of strings.
% m is the length of c. If a is shorter than c, a is used as often
% as necessary to fill up c.

if iscell(a),
  a=a(:);
end

if (nargin<2)|isempty(m),
  m=size(a,1);
end

n=size(a,1);

if ischar(a),
  c=cellstr(a);
elseif iscellstr(a),
  c=a;
else
  c=cell(n,1);
  for k=1:n;
    c{k}=num2str(a(k,:));
  end  
end

c=c(mod(0:m-1,n)+1,1);
