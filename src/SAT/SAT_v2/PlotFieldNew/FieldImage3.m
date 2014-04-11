
function [x,y,E,H]=FieldImage3(Ant,Op,Or,dx,dy,nx,ny)

% [x,y,E,H]=FieldImage3(Ant,Op,Or,dx,dy,nx,ny) calculates
% the 3d fields for equally spaced points in the plane spanned
% by the corner Or and the vectors dx and dy, using nx times ny 
% points arranged so as to represent a rectangle, default nx=ny=10.
% dx defines not only the direction but also the length of one edge
% of the rectangle. The direction and length of dy is adjusted to 
% be perpendicular to dx and contain ny points with the same 
% spacing as the dx-direction (|dx|/nx).

if nargin<6,
  nx=10;
end

if nargin<7,
  ny=nx;
end

dx=dx(:)';
dy=dy(:)';

d=Mag(dx)/(nx-1);   % spacing

dy=cross(dx,cross(dy,dx));

dx=dx/Mag(dx);  % unit vector in x-direction
dy=dy/Mag(dy);  % unit vector in y-direction

x=repmat((0:nx-1)*d,ny,1);
x=x(:);
y=repmat((ny-1:-1:0)'*d,1,nx);
y=y(:);

r=repmat(Or(:)',[nx*ny,1])+x(:)*dx+y(:)*dy;

[E,H]=FieldNear(Ant,Op,r);
