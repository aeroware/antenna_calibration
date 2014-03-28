
function [s,ecc,psi]=E2Stokes(E,e1,e2)

% [s,ecc,psi]=E2Stokes(E,e1,e2)
% calculates the Stokes parameters s=[s1,s2,s3] of the given E-field, 
% and from them the eccentricity ecc, and the angle psi between 
% the semimajor axis and the direction e1. E is projected onto the plane
% spanned by e1 and e2, e1 providing the x-reference direction in the 
% wave plane (if a wave is assumed). e2 needs not be perpendicular to e1,
% because an orthonormalization is done in the beginning with the direction
% of e1 being kept and the direction of e2 adapted in such a way that 
% (e1xe2)/|e1xe2| stays the same. Actually, the projection of E into the
% plane (e1,e2) is used to calculate the output parameters.
% The Stokes parameter s0 is not returned, since it can be easily obtained
% from s0=sqrt(s1.^2+s2.^2+s3.^2).
%
% [s,ecc,psi]=E2Stokes(E,er) is an alternative call where it is assumed 
% that er is a vector in the direction of propagation of a radiated wave, 
% and e1 and e2 are determined as theta and phi direction,
% e2 ~ ez x er, e1 ~ e2 x er.
%
% E,e1,e2,er may have many dimensions, the second must count the
% 3 coordinates, the others are treated in parallel, i.e. row vectors
% are assumed.

if (size(e1,2)~=3)||(size(E,2)~=3),
  error('Second dimension of arrays must count coordinates (size 3).');
elseif isempty(E)||isempty(e1),
  s=[];
  ecc=[];
  psi=[];
  return
end

if ~exist('e2','var')||isempty(e2), % er given in e1
  er=e1;
  e2=zeros(size(er));
  z=zeros(size(er(:,1,:)));
  e2(:,:,:)=cat(2,-er(:,2,:),er(:,1,:),z);
  e1=cross(e2,er,2);
end

if ~isequal(size(e1),size(e2)),
  error('Sizes of e1 and e2 must be the same.');
end

if ~isequal(size(e1),size(E)),
  q=ones(1,max(ndims(E),ndims(e1)));
  q1=q;
  q1(1:ndims(e1))=size(e1);
  q(1:ndims(E))=size(E);
  [q,q1]=deal(max(q,q1)/q,max(q,q1)/q1);
  if ~isequal(q,round(q))||~isequal(q1,round(q1)),
    error('Inconsistent dimensions of input parameters.');
  end
  e1=repmat(e1,q1);
  E=repmat(E,q);  
end

% orthonormalization:

e1=e1./repmat(Mag(e1,2),1,3);
e2=cross(cross(e1,e2,2),e1,2);
e2=e2./repmat(Mag(e2,2),1,3);

% at last calculate Stokes parameters and ellipses properties:

E1=sum(E(:,:,:).*e1(:,:,:),2);
E2=sum(E(:,:,:).*e2(:,:,:),2);

q=size(E);

q(2)=3; %q(2)=4;
s=zeros(q);
s(:,1,:)=abs(E1).^2-abs(E2).^2;
s(:,2,:)=2*real(E1.*conj(E2));
s(:,3,:)=2*imag(E1.*conj(E2));
%s(:,4,:)=abs(E1).^2+abs(E2).^2;

q(2)=3;
ss=zeros(q);
ss(:,:,:)=car2sph(s(:,1:3,:),2);

if nargout<2, return, end

q(2)=1;
ecc=zeros(q);
ecc(:,:,:)=sqrt(1-tan((pi/2-ss(:,2,:))/2).^2);

if nargout<3, return, end

q(2)=1;
psi=zeros(q);
psi(:,:,:)=ss(:,3,:)/2;

