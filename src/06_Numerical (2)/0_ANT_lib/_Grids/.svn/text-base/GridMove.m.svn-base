
function Geom=GridMove(Geom0,R,t,dir)

% Ant=GridMove(Ant0,R,t,dir) or Geom=GridMove(Geom0,R,t,dir) 
% moves the grid given by the antenna structure Ant0  or
% by the geometry matrix Geom0 into a new position. 
% The motion is defined by the rotation matrix R and 
% the translation vector t, so rnew=R*rold+t. Instead 
% of the rotation matrix a revolution vector can be 
% passed, which is parallel to the revolution axis and 
% the magnitude of which gives the revolution angle.
% Another alternative is to define 3 initial points
% in the columns of R and the corresponding 3 final 
% points (after motion) in the columns of t. R or t
% can be omitted or left empty to assume no rotation
% or no translation, respectively. The moved grid 
% geometry is returned in the antenna structure Ant or 
% in the geometry field Geom, respectively (depending 
% on the first input argument).  If the optional 
% parameter dir is set to 1, the first column of R and 
% t are not interpreted as points but as initial and 
% final directions, respectively. For dir=2 two colums
% (the first and the second) of R and t are treated 
% in this way.

if (nargin<2)||isempty(R),
  R=eye(3);
end

if (nargin<3)||isempty(t),
  t=[0;0;0];
end

if nargin<4,
  dir=[];
end

% if necessary calculate rotation matrix and 
% translation vector :

if isequal(size(t),[3,3]),  % given 3 initial and 3 final points 

  [R,t]=Motion(R,t,dir);
  
elseif ~isequal(size(R,1),size(R,2)),  % given revolution vector
  
  R=Motion(R);
  
end

% calculate motion (rotation and successive translation):

if isstruct(Geom0),
  Geom=Geom0;
  Geom.Geom=Geom0.Geom*R'+repmat(t(:)',size(Geom0.Geom,1),1);
else
  Geom=Geom0*R'+repmat(t(:)',size(Geom0,1),1);
end
