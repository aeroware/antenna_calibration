
function Ant=GridCuboid(a,b,c,ma,mb,mc,Omit)

% Ant=GridCuboid(a,b,c,ma,mb,mc) draws a cuboid
% extending into the first quadrant, with one corner at the origin.
% a, b and c define the edges meeting at the origin: scalars 
% determine the lengths of the edges, the respective directions 
% being assumed parallel to the principal axes; vectors define 
% vectorial edges, so that in general a parallelepiped can be
% drawn. ma, mb and mc determine the number of segments to 
% be used per edge, respectively (optional, default=1); they
% can also be vectors giving multiples of a, b and c, 
% respectively, thereby determining the lengths of successive
% segments on the 3 principal edges, starting from the origin.
% The optional parameter Omit defines faces of the cuboid which 
% are not drawn: 3, 1 or 2 for the face oriented towards a x b, 
% b x c or c x a, respectively. Negative values for the 
% corresponding opposite faces.

% Revision June 2007:
% - Subdivision of patches according to the global variable 
%   GlobalMaxPatchCorners (which is set to its default in GridInit)


if (nargin<4)|isempty(ma),
  ma=1;
end
if length(ma)==1,
  ma=0:ma;
elseif ma(1)~=0,
  ma(2:end+1)=ma;
  ma(1)=0;
end
na=length(ma);
if length(a)==1,
  a=[a,0,0];
end
a=ma(:)*a(:)'; % nodes on 1. principal edge

if (nargin<5)|isempty(mb),
  mb=1;
end
if length(mb)==1,
  mb=0:mb;
elseif mb(1)~=0,
  mb(2:end+1)=mb;
  mb(1)=0;
end
nb=length(mb);
if length(b)==1,
  b=[0,b,0];
end
b=mb(:)*b(:)'; % nodes on 2. principal edge

if (nargin<6)|isempty(mc),
  mc=1;
end
if length(mc)==1,
  mc=0:mc;
elseif mc(1)~=0,
  mc(2:end+1)=mc;
  mc(1)=0;
end
nc=length(mc);
if length(c)==1,
  c=[0,0,c];
end
c=mc(:)*c(:)'; % nodes on 3. principal edge

% determine the union of the (at most) 6 parallelograms 
% which are the faces of the parallelepiped:

if (nargin<7)|isempty(Omit),
  Omit=[];
end

Ant=GridInit;

[A1,A2]=GridCuboidPlanes(a,b,c(end,:));
if ~ismember(-3,Omit),
  Ant=GridJoin(Ant,A1);
end
if ~ismember(3,Omit),
  Ant=GridJoin(Ant,A2);
end

[A1,A2]=GridCuboidPlanes(b,c,a(end,:));
if ~ismember(-1,Omit),
  Ant=GridJoin(Ant,A1);
end
if ~ismember(1,Omit),
  Ant=GridJoin(Ant,A2);
end

[A1,A2]=GridCuboidPlanes(c,a,b(end,:));
if ~ismember(-2,Omit),
  Ant=GridJoin(Ant,A1);
end
if ~ismember(2,Omit),
  Ant=GridJoin(Ant,A2);
end

% remove multiple nodes and segments:

Ant=GridPack(Ant,0,'',[1,0]);

if Ant.Init>1,
  Ant.Init=Ant.Init-1;
end



function [A1,A2]=GridCuboidPlanes(r1,r2,d)

% Generate two parallelograms by using edges r1 and r2 as 
% explained in GridParallelogram.  The second par.
% is simply the first offset by the vector d and changed
% in its patch orientation.

[x,y,z]=GridParallelogram(r1,r2);
A1=GridMatrix(x,y,z);
A2=A1;
A2.Geom=A2.Geom+repmat(d(:)',[size(A2.Geom,1),1]);
for n=1:length(A1.Desc2d),
  A1.Desc2d{n}=A1.Desc2d{n}(end:-1:1);
end


function [x,y,z]=GridParallelogram(r1,r2)

% Generate plane grid of parallelogram form, r1 and r2
% being nodes along 2 outer edges which meet in the origin.
% x, y and z are matrices representing the plane surface.

n1=size(r1,1);
n2=size(r2,1);

x=repmat(r1(:,1),[1,n2])+repmat(r2(:,1)',[n1,1]);
y=repmat(r1(:,2),[1,n2])+repmat(r2(:,2)',[n1,1]);
z=repmat(r1(:,3),[1,n2])+repmat(r2(:,3)',[n1,1]);
