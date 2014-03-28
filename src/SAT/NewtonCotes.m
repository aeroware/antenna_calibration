
function [c]=NewtonCotes(x,p);

% c=NewtonCotes(x) calculates Newton-Cotes coefficients of 
% the integral from 0 through 1 for the abszissa points x.
% Use symbolic values to get accurate results.
% E.g. newtoncotes(sym(0:2)/2) yields the simpson rule coefficients. 

if isempty(x),
  c=[];
  return
end

x=x(:).';
n=length(x);

if (nargin<2)|isempty(p)
  p=n-1;
end

A=[ones(1,n);repmat(x,p,1)];
for k=3:size(A,1),
  A(k,:)=A(k,:).*A(k-1,:);
end
  
y=(1./(1:p+1)');

c=A\y;

