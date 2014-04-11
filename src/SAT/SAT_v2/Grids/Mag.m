
function m=Mag(x,d,p);

% Returns p-norm of vectors along the dimension d:
%   m=sum(abs(x).^p,d).^(1/p)
%   p=inf: m=max(abs(x),[],d); p=-inf: m=min(abs(x),[],d)
% Default values are d=first non-singleton dimension, p=2.

if (nargin<2)|isempty(d),
  d=min(find(size(x)>1));
  if isempty(d),
    m=abs(x);
    return
  end
end
d=max(1,min(d,ndims(x)));

if (nargin<3)|isempty(p),
  p=2;
end

if p==inf,
  m=max(abs(x),[],d);
elseif p==-inf,
  m=min(abs(x),[],d);
else
  m=sum(abs(x).^p,d).^(1/p); 
end

