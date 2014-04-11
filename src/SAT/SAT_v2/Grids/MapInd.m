
function y=MapInd(x,NewInd,IndDim)

% y=MapInd(x,NewInd) maps the first non-singleton dimension 
% of the array x as defined in NewInd to obtain the new array y.
% NewInd is a vector of the same length as the first non-singleton 
% dimension of x, associating to each index the respective new one, 
% for instance y(NewInd(k),...)=x(k,...). Zeros in NewInd indicate 
% indices to be removed, corresponding parts of x won't be 
% present in y.
%
% y=MapInd(x,NewInd,IndDim) works on the dimension IndDim.

d=size(x);

if nargin<3,
  IndDim=find(d>1);
end
if isempty(IndDim),
  IndDim=1;
end
IndDim=IndDim(1);

NewInd=abs(NewInd);

d=[d,ones(1,IndDim)];

n=length(NewInd);

if n~=d(IndDim),
  error('Incorrect size of index map (second input argument).');
end

d1=prod(d(1:IndDim-1));  % MATLAB calculates prod([])=1
d2=prod(d(IndDim+1:end));

x=reshape(x,[d1,n,d2]);

m=max(NewInd);
q=find(NewInd);

y=zeros([d1,m,d2]);
y(:,NewInd(q),:)=x(:,q,:);

d(IndDim)=m;
y=reshape(y,d);
