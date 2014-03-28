
function Ant=Grid1dObj(Ant,Type)

% Ant=Grid1dObj(Ant,Type) defines the whole grid as 1d-object. 
% It removes all existing objects and defines new objects of 
% given Type, or the default objects type 'Wire' if Type is 
% 'default' or omitted. 
% The elements (Desc or Desc2d) not needed in these objects are deleted. 
% Furthermore, the physical object dimension 1 is stored in the 
% field Ant.Obj.Phys.Dimension.
% The function is called by the 1d-grid generation functions.

% Written Feb. 2008

if nargin<2,
  Type='Wire';
elseif isempty(Type),
  Type={};
elseif ischar(Type)&&~isempty(findstr(lower(Type),'default')),
  Type='Wire';
end

Ant.Obj(1:end)=[];

Ant=GridObj(Ant,Type,'all');

for n=1:numel(Ant.Obj),
  Ant.Obj(n).Phys.Dimension=1;
end

[po,wi,su]=FindGridObj(Ant);

if isempty(wi),
  Ant.Desc(1:end,:)=[];
end
if isempty(su),
  Ant.Desc2d(1:end,:)=[];
end
