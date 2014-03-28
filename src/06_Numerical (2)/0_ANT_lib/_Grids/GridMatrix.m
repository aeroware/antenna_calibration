
function [Ant,NewPats,SubDiv]=GridMatrix(varargin)

% Ant=GridMatrix(Type,x,y,z,Close,EndCap) generates a surface grid 
% from the matrices x, y and z, which give the coordinates 
% of points lying on the surface. The indices of the matrices
% serve as parameters for the surface description.
% The optional argument Close determines if the surface 
% should be closed in the first (Close=1) or second (Close=2)
% parameter (matrix dimension). EndCap defines optional
% end caps: -1 for a cap enclosed by the first coordinate line
% of the first parameter (index), i.e. lowest second parameter;
% -2 for the first coordinate line of the second parameter 
% (index), i.e. lowest first parameter; positive values 
% indicate the respective last coordinate lines (highest 
% index value of fixed parameter). Define several end caps 
% by a vector of values.
% All returned patches have the same orientation, namely
% expressed in matrix indices: (1,1) (1,2) (2,2) (2,1).
%
% Type specifies the object type(s) to be defined and is optional
% (for more details on Type see GridRevol.m).

% Rev. Feb. 2008:
% Implementation of Type
%
% Revision June 2007:
% - Subdivision of patches according to the global variable 
%   GlobalMaxPatchCorners (which is set to its default in GridInit)


global GlobalMaxPatchCorners;

[Type,x,y,z,Close,EndCap]=...
  FirstArgin(@(x)(ischar(x)||iscell(x)),'default',[],varargin{:});

Ant=GridInit;

if isempty(Close),
  Close=0;
end

% matrix of node numbers for patch corners:

p=size(x);
if any(p<1),
  return
end
nn=reshape(1:prod(p),p);
if isequal(Close,1)&&~isequal(p(1),1),
  nn=[nn;nn(1,:)];
elseif isequal(Close,2)&&~isequal(p(2),1),
  nn=[nn,nn(:,1)];
else 
  Close=0;
end

% generate nodes:

Ant.Geom=[x(:),y(:),z(:)];

% generate segments:

if isequal(Close,1),
  f1=nn(1:end-1,:);
  t1=nn(2:end,:);
  f2=nn(1:end-1,1:end-1);
  t2=nn(1:end-1,2:end);
elseif isequal(Close,2),
  f1=nn(1:end-1,1:end-1);
  t1=nn(2:end,1:end-1);
  f2=nn(:,1:end-1);
  t2=nn(:,2:end);
else
  f1=nn(1:end-1,:);
  t1=nn(2:end,:);
  f2=nn(:,1:end-1);
  t2=nn(:,2:end);
end

Ant.Desc=[f1(:),t1(:);f2(:),t2(:)];

% generate patches:

f1=nn(1:end-1,1:end-1);
f2=nn(2:end,1:end-1);
t2=nn(2:end,2:end);
t1=nn(1:end-1,2:end);

D=num2cell([t1(:),t2(:),f2(:),f1(:)],2);

% generate end caps:

if isempty(EndCap),
  EndCap='';
end

if isnumeric(EndCap),
  
  EndCap=unique(EndCap);
  s=size(x);

  for c=EndCap(:)',
    switch c,
      case -1,
        D{end+1,1}=nn(1:s(1),1)';
      case -2,
        D{end+1,1}=nn(1,s(2):-1:1);
      case 1,
        D{end+1,1}=nn(s(1):-1:1,s(2))';
      case 2,
        D{end+1,1}=nn(s(1),1:s(2));
    end
    if length(D{end})<3,
      D=D(1:end-1);
    end
  end

end

Ant.Desc2d=D;

% subdivide patches with more than GlobalMaxPatchCorners nodes:

if isequal(GlobalMaxPatchCorners,3)&&~isempty(Ant.Desc2d),
  [Ant,NewPats,SubDiv]=GridSubPatches(Ant,'all',GlobalMaxPatchCorners);
end

% define objects:

Ant=Grid2dObj(Ant,Type);
