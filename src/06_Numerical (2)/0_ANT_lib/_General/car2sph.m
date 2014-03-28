
function [s,J]=Car2Sph(x,dim)

% [s,J]=Car2Sph(x,dim) calculate spherical coordinates s from 
% cartesian coordinates x. The optional argument dim defines the
% dimension counting the coordinates (default: first 3-element 
% dimension). For s the coordinates are (radius, colatitude, azimuth). 
% J returns the Jacobian matrix ds/dx, where dim is the dimension counting
% the columns and an additional dimension is inserted after dim to 
% represent the row index.

si=size(x);
d=find(si==3);
if isempty(d),
  error('Coordinates must be counted by 3-element index.');
end
if (nargin<2)|isempty(dim),
  dim=d(1);
end
if ~ismember(dim,d),
  error('Given coordinate dimension must be of length 3.');
end

x=permute(x,[dim,1:dim-1,dim+1:ndims(x)]);

q=x(1,:).^2+x(2,:).^2;

s=zeros(size(x));

s(1,:)=sqrt(q+x(3,:).^2);            % radius r
s(2,:)=pi/2-atan2(x(3,:),sqrt(q));   % colatitude theta
s(3,:)=atan2(x(2,:),x(1,:));         % azimuth phi

if nargout<2,
  s=permute(s,[2:dim,1,dim+1:ndims(s)]);
  return
end

J=zeros([3,size(s)]);

J(1,1,:)=x(1,:)./s(1,:);
J(1,2,:)=x(2,:)./s(1,:);
J(1,3,:)=x(3,:)./s(1,:);

J(2,1,:)=x(1,:).*x(3,:);
J(2,2,:)=x(2,:).*x(3,:);
J(2,3,:)=-q;
J(2,:,:)=J(2,:,:)./shiftdim(repmat(sqrt(q).*s(1,:).^2,[3,1]),-1);

J(3,1,:)=-x(2,:)./q;
J(3,2,:)=x(1,:)./q;

s=permute(s,[2:dim,1,dim+1:ndims(s)]);
J=permute(J,[3:dim+1,1,2,dim+2:ndims(J)]);
