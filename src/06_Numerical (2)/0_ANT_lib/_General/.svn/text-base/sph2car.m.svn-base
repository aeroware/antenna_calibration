
function [x,J]=Sph2Car(s,dim)

% [x,J]=Sph2Car(s,dim) calculate cartesian coordinates x from 
% spherical coordinates s. The optional argument dim defines the
% dimension counting the coordinates (default: first 3-element 
% dimension). For s the coordinates are (radius, colatitude, azimuth). 
% J returns the Jacobian matrix dx/ds, where dim counts the columns 
% and an additional dimension is inserted after dim to represent the 
% row index.

si=size(s);
d=find(si==3);
if isempty(d),
  error('Spherical coordinates must be counted by 3-element index.');
end
if (nargin<2)|isempty(dim),
  dim=d(1);
end
if ~ismember(dim,d),
  error('Given coordinate dimension must be of length 3.');
end

s=permute(s,[dim,1:dim-1,dim+1:ndims(s)]);

x=zeros(size(s));

x(1,:)=sin(s(2,:)).*cos(s(3,:));
x(2,:)=sin(s(2,:)).*sin(s(3,:));
x(3,:)=cos(s(2,:));

if nargout<2,
  x(:,:)=x(:,:).*repmat(s(1,:),3,1);
  x=permute(x,[2:dim,1,dim+1:ndims(x)]);
  return
end

J=zeros([3,size(x)]);

J(1,1,:)=x(1,:);
J(2,1,:)=x(2,:);
J(3,1,:)=x(3,:);

J(1,2,:)=s(1,:).*cos(s(2,:)).*cos(s(3,:));
J(2,2,:)=s(1,:).*cos(s(2,:)).*sin(s(3,:));
J(3,2,:)=-s(1,:).*sin(s(2,:));

x(:,:)=x(:,:).*repmat(s(1,:),3,1);

J(1,3,:)=-x(2,:);
J(2,3,:)=x(1,:);

x=permute(x,[2:dim,1,dim+1:ndims(x)]);
J=permute(J,[3:dim+1,1,2,dim+2:ndims(J)]);
