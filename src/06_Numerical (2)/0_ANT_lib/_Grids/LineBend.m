
function [x,y]=LineBend(L,b,n)

% [x,y]=LineBend(L,b,n) calculates bend function y(x) for wire antenna
% of length L and tip deviation b. n segments are used to represent 
% the antenna wire. If n is a vector, it defines the relative lengths of
% the subdivisions.
%
% The assumed bend is of square form, y=k*x^2.

% Rev. Feb. 2008:
% Original function name AntBend changed to LineBend;
% Implementation of n as rel.-lengths vector.

if numel(n)==1,
  n=ones(n,1)/n;
else
  n=n(:)/sum(n(:));
end

% x/L as a function of (y/L)^2 on the curve y=k*x^2 
% (L=length of curve, y<<L assumed):

XOL=inline(...
  'polyval([-44588/467775,346/14175,-92/945,-2/45,-2/3,1],yol2)',...
  'yol2');

% calculate x and y:

xend=XOL((b/L)^2)*L;
k=b/xend^2;

x=cumsum(n)*xend;
if x(1)~=0,
  x=[0;x(:)];
end

y=k*x.^2;
