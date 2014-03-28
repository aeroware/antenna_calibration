
function Ant=GridCircle(r,phi,n);

% Ant=GridCircle(r,phi,n) draws a circular arc 
% with radius r and opening angle |phi| in the xy-plane. 
% The arc is drawn counterclockwise or clockwise around 
% the z-axis, depending on wether phi>0 or phi<0. 
% The arc is represented by a polygon of n segments, 
% starting at point (r,0,0). The function returns a 
% closed polygon when phi is omitted or an integer 
% multiple of 2*pi is passed. 

Ant=GridInit;

pi2=2*pi;

if nargin<2,
  ClosedCircle=1;
  phi=pi2;
else
  phi=phi-fix(phi/pi2)*pi2;
  ClosedCircle=abs((abs(phi)-pi2)*phi)<1e-10;
  if ClosedCircle,
    phi=pi2;
  end
end

if nargin<3,
  n=max(1,round(abs(phi)/pi*10));  
end;

nn=n+1-ClosedCircle;;     % number of nodes

phi=phi/n*(0:nn-1)';  

Ant.Geom=abs(r)*[cos(phi),sin(phi),zeros(nn,1)];

Ant.Desc=zeros(n,2);

if ClosedCircle,
  Ant.Desc=[1:n;2:n,1]';
else
  Ant.Desc=[1:n;2:n+1]';
end

