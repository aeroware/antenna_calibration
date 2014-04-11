function [x,y]=AntBend(L,d,n)

% [x,y]=AntBend(L,d,n) calculates bend function y(x) for wire antenna
% of length L and tip deviation d. n segments are used to represent 
% the antenna wire.

% x/L as a function of y/L on the curve y=k*x^2 (L=length of curve, y<<L assumed):

XOL=inline('polyval([-44588/467775,346/14175,-92/945,-2/45,-2/3,1],yol2)','yol2');

% calculate x and y:

x=XOL((d/L)^2)*L;
k=d/x^2;
x=([0,0.5,1:n])'/n*x;
y=k*x.^2;
return