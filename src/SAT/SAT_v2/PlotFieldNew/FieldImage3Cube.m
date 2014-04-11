function [x,y,z,E,H]=FieldImage3Cube(Ant,Op,Or,nx,ny,nz)

% [x,y,z,E,H]=FieldImage3Cube(Ant,Op,Or,nx,ny,nz) calculates
% the fields for points lying on a cubic grid,
% with the center at Or and nx,ny,nz nodes in direction
% of x,y,z.

if nx>1
    x=repmat((Or(1):-Or(1)/(nx-1)*2:-Or(1))',ny*nz,1);
    x=x(:);
else
    x=repmat(Or(1),ny*nz,1);
end


if ny>1
    y=repmat((Or(2):-Or(2)/(ny-1)*2:-Or(2)),nx,1);
    y=y(:);
    y=repmat(y,nz,1);
else
    y=repmat(Or(2),nx,1);
    y=y(:);
    y=repmat(y,nz,1);
end



if nz>1
    z=repmat((Or(3):-Or(3)/(nz-1)*2:-Or(3)),nx*ny,1);
    z=z(:);
else
    z=repmat(Or(3),nx*ny,1);
    z=z(:);
end

[E,H]=FieldNear(Ant,Op,[x,y,z]);