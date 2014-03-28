
function [E,H]=FieldNear1(r1,r2,r,k)

% [E,H]=FieldNear1(r1,r2,r,k) calculates electric (E) and 
% magnetic (H) field of a straight wire extending from r1 to r2, 
% excited by a sinusoidal current. The positive current direction 
% is from r1 to r2, where is I(r1)=0 and I(r2)=1.
% The fields are calculated at the positions r (radius vectors as rows).
% k is the wave konstant k=w*sqrt(eps*mu), w=2*pi*frequency.
% E actually returns E*(4*pi*j*w*eps).
%
% The routine differs from FieldNear2 in that it does not
% take into account the point-source at the end of the segment.
% Furthermore it does no accuracy-improvement for small distances
% from the segment axis.

nr=size(r,1);

r1=r1(:).';
r2=r2(:).';

L=Mag(r2-r1,2);           % Length of segment.
ez=(r2-r1)/L;             % Unit vector in segment direction.

R1v=r-repmat(r1,[nr,1]);  % r-r1

z=R1v*ez(:);

erho=R1v-z*ez;
rho=sqrt(sum(erho.^2,2));

Ez=zeros(nr,1);
Erho=zeros(nr,1);

n=find(rho);
if ~isempty(n),
  erho(n,:)=erho(n,:)./repmat(rho(n,1),1,3);
  if nargout>1,
    Hphi=zeros(nr,1);
    [Ez(n),Erho(n),Hphi(n)]=FieldNear0(L,rho(n),z(n),k);
  else
    [Ez(n),Erho(n)]=FieldNear0(L,rho(n),z(n),k);
  end
end

n=find(rho==0);
if ~isempty(n),
  Ez(n)=FieldNear0(L,rho(n),z(n),k);
end

E=erho.*repmat(Erho,1,3)+Ez*ez;

if nargout>1,
  H=cross(repmat(ez,nr,1),erho);
  H=H.*repmat(Hphi,1,3);
end
  