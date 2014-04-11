
function [p,r,v]=PolyFitM(x,y,n)

% [p,r,v]=PolyFitM(x,y,n) is the matrix form of polyfit.
% It calculates polynomial fit of order n for (x,y) where 
% y may be any array the first dimension of which must 
% agree with the length of the vector x. 
% p returns the polynomial coefficients in an array 
% of size [n+1,s(2:end)] with s=size(y), the first index m
% counting the polynomial order m-1 (in this respect PolyFitM
% differs from polyfit, which uses the reverse convention!).
% r is an array of residuals, the same size as y.
% v is the vandermode matrix of size [length(x),n+1] built
% from the vector x: v(:,m)=x(:).^(m-1).

if length(x)~=size(y,1),
  error('Inconsistent dimensions of input parameters.');
end

v=zeros(length(x),n+1);

v(:,1)=ones(length(x),1);  % construct Vandermonde matrix v
for j=1:n,
   v(:,j+1)=x(:).*v(:,j);
end

[Q,R]=qr(v,0);

s=size(y);

CalcResiduals=nargout>1;
if CalcResiduals,
  r=zeros(s);
end

p=zeros([n+1,s(2:end)]);

for k=1:prod(s(2:end)),  
  p(:,k)=R\(Q'*y(:,k));
  if CalcResiduals,
    r(:,k)=y(:,k)-v*p(:,k);
  end
end

  