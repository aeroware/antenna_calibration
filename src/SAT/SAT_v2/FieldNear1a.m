
function [E,H]=FieldNear1a(r1,r2,r,k,Radius)

% [E,H]=FieldNear1a(r1,r2,r,k,Radius) calculates electric (E) and 
% magnetic (H) field of a straight wire extending from r1 to r2, excited 
% by a sinusoidal current. The positive current direction is from r1 to r2, 
% where the current is I(r1)=0 and I(r2)=1.
% The fields are calculated at the positions r (radius vectors as rows).
% k is the wave konstant k=w*sqrt(eps*mu), w=2*pi*frequency.
%
% The routine differs from FieldNear2 in that it does not
% take into account the point-source at the end of the segment.
% Firthermore it does no accuracy-improvement for small distance
% from the segment axis.
%
% Radius is optional and defines the radius of the wire, default=0:
% points inside the wire are shifted radially onto its surface to
% calculate Ez, Erho and Hphi. However for such points only the 
% Ez-component is returned in E and 0 in H (as no clear definition of 
% ephi and erho is found for zero or very small distance rho from the 
% wire). Set Radius=0 (or empty) to accept arbitrarily small rho.
%
% E actually returns E*(4*pi*j*w*eps).

if (nargin<7)|isempty(Radius),
  Radius=0;
end

if (nargin<8)|isempty(Method),
  Method=1;
end

r1=r1(:).';
r2=r2(:).';

nr=size(r,1);

R1v=r-repmat(r1,[nr,1]);  % r-r1
R1=Mag(R1v,2);            % R1=|r-r1|

R2v=r-repmat(r2,[nr,1]);  % r-r2
R2=Mag(R2v,2);            % R2=|r-r2|

L=Mag(r2-r1,2);           % Length of segment.

ez=(r2-r1)/L;             % Unit vector in segment direction.

L1=R1v*ez.';              % z-z1 = ez.(r-r1)
L2=R2v*ez.';              % z-z2 = ez.(r-r1)

ephi=R1v;                 % For the calculation of ephi, erho and 
n=find(R2<R1);            % rho prefer R1v or R2v whichever is 
ephi(n,:)=R2v(n,:);       % smaller to get better numerical accuracy. 
ephi=cross(repmat(ez,[nr,1]),ephi,2);

rho=Mag(ephi,2);          % distance normal to segment line

if Radius~=0,
  n=(L1>=0)&(L2<=0)&(rho<Radius*(1-8*eps));
  rho(n)=0;
  ephi(n,:)=0;
end

Ez=zeros(nr,1);
Erho=zeros(nr,1);
Hphi=zeros(nr,1);

n=find(rho~=0);
ephi(n,:)=ephi(n,:)./repmat(rho(n,:),[1,3]);
erho=cross(ephi,repmat(ez,[nr,1]),2);
if nargout>1,
  [Ez(n),Erho(n),Hphi(n)]=FieldNear0(L,rho(n),L1(n),k);
else
  [Ez(n),Erho(n)]=FieldNear0(L,rho(n),L1(n),k);
end

n=find((rho==0)&((L1<-L*8*eps)|(L2>L*8*eps)));
Ez(n)=FieldNear0(L,rho(n),L1(n),k);

E=erho.*repmat(Erho,[1,3])+Ez*ez;
if nargout>1,
  H=ephi.*repmat(Hphi,[1,3]);
end

