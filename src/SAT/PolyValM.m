
function y=PolyValM(p,x,n)

% y=PolyValM(p,x) is the matrix form of polyval.
% The polynomials given by the polynomial coefficients p
% are evaluated at the points given in the vector x.
% The first dimension of p counts the polynomial powers in 
% increasing order (different from polyfit which uses the 
% reverse convention). 
% Given the optional parameter n, only the polynomial coefficients 
% in n are used, for instance n=0:nmax cuts the polynomial at
% the order nmax, neglecting all powers greater than nmax;
% n=3 calculates only the power-of-3 term x.^3*p(end-3,:,..).

nn=size(p,1)-1;
if nargin<3,
  n=0:nn;
else
  n=unique(n);
  n=sort(n(find(n<=nn)));
end

v=zeros(length(x),length(n));  % construct excerpt of Vandermonde matrix v
for k=1:length(n),
   v(:,k)=x(:).^n(k);
end

s=size(p);

y=reshape(v*p(n+1,:),[length(x),s(2:end)]);
