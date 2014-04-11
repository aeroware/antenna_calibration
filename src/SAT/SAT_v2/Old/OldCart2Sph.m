
function [r,t,p]=Cart2Sph(x,y,z)

% [r,t,p]=Cart2Sph(x,y,z) 
% transforms from cartesian to spherical coordinates. If x,y,z are 
% vectors or matrices, then r,t,p get the corresponding size. 
% In certain circumstances it is more convenient 
% to pass one matrix containing all coordinates of all points. In
% this case the matrix x must contain 3 rows or 3 columns. In case
% x is 3x3, each row is regarded as a point, i.e. an (x,y,z) triple.
% If a single output variable is demanded, all spherical coordinates
% are returned into one matrix of the same form as the input matrix x.


if nargin==1, % only x passed
  
  rows=(size(x,2)~=3); % row vectors?
  if rows, x=x';  end
  if size(x,2)~=3,
    error('Size mismatch: matrix must have 3 rows or 3 columns.');
  end
  if nargout==1,
    r=[sqrt(x(:,1).^2+x(:,2).^2+x(:,3).^2),...
       zeros(size(x,1),1),...
       atan2(x(:,2),x(:,1))];
    r(:,2)=acos(x(:,3)./r(:,1));
    if rows, r=r'; end
  else
    r=sqrt(x(:,1).^2+x(:,2).^2+x(:,3).^2);
    t=acos(x(:,3)./r);
    p=atan2(x(:,2),x(:,1));
    if rows, r=r'; t=t'; p=p'; end
  end
  
else   % x,y,z passed
  
  if nargout==1,
    [m,n]=size(x);
    if n>m, % arrange one above the other 
      r=[sqrt(x.^2+y.^2+z.^2); zeros(size(x)); atan2(y,x)];
      r(m+1:2*m,:)=acos(z./r(1:m,:));
    else    % arrange left to right
      r=[sqrt(x.^2+y.^2+z.^2), zeros(size(x)), atan2(y,x)];
      r(:,n+1:2*n)=acos(z./r(:,1:n));
    end
  else
    r=sqrt(x.^2+y.^2+z.^2);
    t=acos(z./r);
    p=atan2(y,x);
  end 
  
end 

