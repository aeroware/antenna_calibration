
function Ant=GridCylinder(varargin)

% Ant=GridCylinder(Type,r,z1,z2,nz,p,np,base,ceiling) 
% draws a section of a circular cylinder with radius r
% and opening angle p, the mantle extending from z1 to z2. 
% The whole surface grid is composed of nz horizontal polygons 
% (representing circular arcs) around the z-axis and 
% segments connecting the corners of successive polygons.
% np defines the number of segments to be used to represent 
% the horizontal polygons. 
% Optional parameters are nz,p,np,base,ceiling with the 
% following default values: p=2*pi; if one of the parameters 
% nz or np is not given, it is adjusted in such a way that 
% horizontal and meridian segments have similar length. 
% If both are omitted (or empty), np is calculated to
% yield segments which extend about 18 degrees in azimuth
% and nz is adapted accordingly.
% In order to draw a cylinder base (floor), the corresponding
% variable base is used, which can be a scalar or vector of
% up to 5 components: 
%   [xtype,nr,npmin,rmin,height].
% xtype .. shape of the base (1=cone or disk, 2=sphere),
% nr .. number of horizontal circular arcs, default=automatic
% npmin .. minimum number of segments per arc (0=no variation)
% rmin .. minimum radius, default=0
% height .. height of the whole tip (for rmin=0), 
%           negative values cause drawing into the cylinder
% If not all components are given (only xtype is needed), canonic
% default values are used. The same holds for the ceiling.
%
% Type specifies the object-type(s) to be defined and is optional
% (for more details on Type see GridRevol).

% Rev. Feb. 2008:
% Implementation of Type (object-type).
%
% Revision June 2007:
% - Adaptation for change of meaning of sign(np) in GridRevol;
% - Subdivision of patches according to the global variable 
%   GlobalMaxPatchCorners (which is set to its default in GridInit)
%
% Revision 22.7.2003:
% correct removal of multiple occurrances at 
% base- and ceiling-contact with mantle

global Default2dObjType OnlyObj2dElem

% initializing global variables:
Ant=GridInit;           
Default2dObjTypeSave=Default2dObjType;
OnlyObj2dElemSave=OnlyObj2dElem;
Default2dObjType={};
OnlyObj2dElem=0;

[Type,r,z1,z2,nz,p,np,base,ceiling]=...
  FirstArgin(@(x)(ischar(x)||iscell(x)),'default',[],varargin{:});

if isempty(r)||isempty(z1)||isempty(z2)||(z1==z2),
  error('Invalid input parameters.');
end

r=abs(r);

[z1,z2]=deal(min(z1,z2),max(z1,z2));

if isempty(p),
  p=2*pi;
else
  p=p/2/pi;
  p=p-floor(p);
  if abs((p-1)*p)<1e-10,
    p=1;
  end
  p=p*2*pi;
end

if abs(p)<1e-10, 
  error('Too small cylindrical azimuth-extension requested.');
end

if abs(z2-z1)/(abs(z1)+abs(z2))<1e-10, 
  error('Requested cylinder length too small.');
end

% analyse and adapt nz and np:

npmin=3;

if isempty(nz),
  if isempty(np),
    np=10/pi*p;
  end
  np=max(npmin,abs(round(np)));
  nz=max(1,round(abs((z2-z1)*np/r/p)));
else
  nz=max(1,abs(nz));
  if isempty(np),
    np=r*p*nz/(z2-z1);    
  end
  np=max(npmin,abs(round(np)));
end

np=repmat(np,nz+1,1);

% calculate z- and r-vector of first meridian:

z=z1+(z2-z1)/nz*(0:nz)';
r=repmat(r,nz+1,1);

% generate grid of mantle:

Ant=GridRevol(z,r,np,p,0,[]);

nm=size(Ant.Geom,1); % number of nodes in mantle

nh=sum(Ant.Geom(:,3)==Ant.Geom(1,3)); % number of nodes at same height

% generate base:

if isempty(base), 
  base=[]; 
end
if ~isempty(base),
  if isequal(base(1),0),
    base=[];
  end
end
nb=0;
if ~isempty(base),
  A=GridCylinderTip(r(1),p,np(1),base);
  if ~isempty(A),
    A.Geom(:,3)=-A.Geom(:,3)+min(z1,z2);
    for n=1:length(A.Desc2d),           
      A.Desc2d{n}=flipud(A.Desc2d{n}(:))'; % change patch orientation 
    end
    nb=size(A.Geom,1);
    Ant=GridJoin(Ant,A);
  end
end  

% generate ceiling:

if isempty(ceiling), 
  ceiling=[]; 
end
if ~isempty(ceiling),
  if isequal(ceiling(1),0),
    ceiling=[];
  end
end
nc=0;
if ~isempty(ceiling),
  A=GridCylinderTip(r(1),p,np(1),ceiling);
  if ~isempty(A),
    A.Geom(:,3)=A.Geom(:,3)+max(z1,z2);
    nc=size(A.Geom,1);
    Ant=GridJoin(Ant,A);
  end
end  

% remove multiple occurrances of nodes and segments
% (joints of base and ceiling with mantle):

if isempty(base), 
  NewNodesBase=[];
else
  NewNodesBase=[1:nh,nm+(1:nb-nh)];
end

if isempty(ceiling), 
  NewNodesCeiling=[];
else
  NewNodesCeiling=[nm-nh+1:nm,nm+max(nb-nh,0)+(1:nc-nh)];
end
NewNodes=[1:nm,NewNodesBase,NewNodesCeiling];

Ant.Geom=Ant.Geom([1:nm,nm+1+nh:nm+nb,nm+nb+1+nh:nm+nb+nc],:);

Ant=GridUpdate(Ant,'Nodes',NewNodes,[1,0]);

% define objects:

Default2dObjType=Default2dObjTypeSave;
OnlyObj2dElem=OnlyObj2dElemSave;

Ant=Grid2dObj(Ant,Type);

end % GridCylinder


% --------- subfunction -----------

function T=GridCylinderTip(r,p,np,x)

% This function is used by the function GridCylinder.
% Create tip for cylinder, with basis at z=0 and
% extending into the upper hemisphere for positive
% height x(5), and in the negative hemisphere otherwise.
% r is the radius and p the azimuth angle of the 
% cylinder section, which is devided into np segments. 
% x represents the variable base or ceiling, 
% respectively: x=(xtype,nr,npmin,rmin,height).

x=x(:);
xtype=max(0,x(1));
if length(x)>1,
  nr=x(2);
  if nr<=0, nr=[]; end
else
  nr=[];
end
if length(x)>2,
  npmin=x(3);
  if npmin<0, npmin=2; end
else
  npmin=2;
end
if length(x)>3,
  rmin=max(0,x(4));
else
  rmin=0;
end
if length(x)>4,
  height=abs(x(5));
else
  if xtype==2,
    height=r;
  else
    height=0;
  end
end

if height<1e-5*r(1),
  xtype=1;
end

switch xtype,
  
case 1, % cone
  
  if height==0,
    t=pi/2;
  else
    t=atan(r/height);
  end
  
  T=GridCone(t,-r,-rmin,nr,p,-np,npmin);
  T.Geom(:,3)=T.Geom(:,3)+height;
  
case 2, % sphere
  
  a=(r^2+height^2)/2/height;
  t1=acos((a-height)/a);
  t2=asin(rmin/a);
  T=GridSphere(a,t1,t2,nr,p,-np,npmin);
  T.Geom(:,3)=T.Geom(:,3)-a+height;
  
%case 3, % paraboloid
  
  
otherwise
  
  T=[];
  return
  
end

if length(x)>4,
  if x(5)<0,
    T.Geom(:,3)=-T.Geom(:,3);
  end
end

end % GridCylinderTip
