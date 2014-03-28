
function Ant=Grid2dObj(Ant,Type)

% Ant=Grid2dObj(Ant,Type) defines grid as 2d-object. 
% It removes all existing objects and defines new objects of 
% given Type, or the default objects Default2dObjType if Type is empty. 
% The elements not needed in these objects are deleted if OnlyObj2dElem. 
% Furthermore, the physical object dimension 2 is stored in the 
% field Ant.Obj.Phys.Dimension.
% The function is called by the 2d-grid generation functions.

% Written Feb. 2008

global Default2dObjType OnlyObj2dElem

if nargin<2,
  Type=Default2dObjType;
elseif isempty(Type),
  Type={};
elseif ischar(Type)&&~isempty(findstr(lower(Type),'default')),
  Type=Default2dObjType;
end

Ant.Obj(1:end)=[];

Ant=GridObj(Ant,Type,'all');

for n=1:numel(Ant.Obj),
  Ant.Obj(n).Phys.Dimension=2;
end

[po,wi,su]=FindGridObj(Ant);

if OnlyObj2dElem,
  if isempty(wi),
    Ant.Desc(1:end,:)=[];
  end
  if isempty(su),
    Ant.Desc2d(1:end,:)=[];
  end
end

