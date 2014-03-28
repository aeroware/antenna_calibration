
function [E,H]=FieldNear(Ant,Op,r,Segs,Radii,Method)

% [E,H]=FieldNear(Ant,Op,r) calculates the near field excited
% by the antenna currents at the positions r. The radius vectors 
% of the observation points are the rows of r. Similarly, E and H 
% contain the respective field vectors as rows.
% [E,H]=FieldNear(Ant,Op,r,Segs) confines the calculation to the 
% currents on the given segments Segs.

NSegs=size(Ant.Desc,1);

if (nargin<4),
  Segs=1:NSegs;
end
if ischar(Segs),
  Segs=1:NSegs;
end  

if (nargin<5)|isempty(Radii),
  Radii=CheckWire(Ant);
end
if length(Radii)==1,
  Radii=repmat(Radii,NSegs,1);
elseif length(Radii)~=NSegs,
  error('Desc and wire Radii have inconsistent dimensions.');
end

if (nargin<6)|isempty(Method),
  Method=1;
end

[k,eps,mu]=Kepsmu(Op);
w=2*pi*Op.Freq;

nr=size(r,1);
H=zeros(nr,3);
E=zeros(nr,3);

for s=Segs(:)',
  
  r1=Ant.Geom(Ant.Desc(s,1),:);
  r2=Ant.Geom(Ant.Desc(s,2),:);
  
  I1=Op.Curr(s,1);  % I(z1)
  I2=Op.Curr(s,2);  % I(z2)
  
  [Eadd,Hadd]=FieldNear2(r1,r2,I1,I2,r,k,Radii(s),Method);
  
  E=E+Eadd;
  H=H+Hadd;
  
end

H=H./(4*pi*j*k);
E=E./(4*pi*j*w*eps);

