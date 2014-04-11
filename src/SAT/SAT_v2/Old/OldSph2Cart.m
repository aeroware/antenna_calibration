
function [x,y,z]=Sph2Cart(r,t,p);

% Transform spherical to cartesian coordinates.
% If only one argument is passed, the matrix r must have 
% exactly 3 columns or rows representing r,t,p. Similarly, 
% if only 1 output argument is requested, x is returned
% in the form [x,y,z] or [x;y;z], each column or row representing 
% one coordinate, respectively.


if nargin==1,  % only r passed
  
  rows=(size(r,2)~=3); 
  if rows, r=r'; end
  if size(r,2)~=3,
    error('Size mismatch: matrix must have 3 rows or 3 columns.');
  end
  if nargout==1,
    x=[r(:,1).*sin(r(:,2)).*cos(r(:,3)),...
       r(:,1).*sin(r(:,2)).*sin(r(:,3)),...
       r(:,1).*cos(r(:,2))];
    if rows, x=x'; end
  else
    x=r(:,1).*sin(r(:,2)).*cos(r(:,3));
    y=r(:,1).*sin(r(:,2)).*sin(r(:,3));
    z=r(:,1).*cos(r(:,2));  
    if rows, x=x'; y=y'; z=z'; end
  end  
  
else   % r,t,p passed
  
  if nargout==1,
    [m,n]=size(r);
    if n>m, % arrange one above the other 
      x=[r.*sin(t).*cos(p); r.*sin(t).*sin(p); r.*cos(t)];
    else    % arrange left to right
      x=[r.*sin(t).*cos(p), r.*sin(t).*sin(p), r.*cos(t)];
    end
  else  
    x=r.*sin(t).*cos(p);
    y=r.*sin(t).*sin(p);
    z=r.*cos(t);
  end
  
end  

