
function Ant1=GridObj(Ant,Type,Elem,varargin)

% Ant1=GridObj(Ant,Type,Elem,varargin)
% generates (adds) a new grid object with the given specifications. 
% varargin can take any list of property specifications:
% property name (string), property value, ...;
% e.g. 'Name','Sphere1','Graf',struct('Color','r').
% The new object is appended to present ones (Ant.Obj).
% 
% If no object is defined yet (Ant.Obj empty) and Elem is empty, 
% this call defines the whole grid as object of given Type.
% Type may also be a list (cell vector) of types, e.g.
% {'Wire','Surf'}; in this case Elem must be a list of corresponding 
% element sets or 'all':
% Elem='all' causes all elements of given Type to be used in the 
% new object(s).

% Rev. Jan. 2009:
% The field Phys.Dimension of the generated object gets the 
% dimension of the object (1, 2 and 3 for point, wire and surf objects, resp.) 
% The input parameters have been changed:
% Passing the object-fields 'Name' and 'GrafProp' is not obligate any 
% longer, but they can be passed as (property,value) pairs from the 
% 4th input parameter onwards.
% Now 'all' has to be passed to get all Type(s) or Elem(ents). 

if ~isfield(Ant,'Init'),
  Ant1=GridInit(Ant);
  return
else
  Ant1=Ant;
end

if ~exist('Elem','var')||ischar(Elem),
  Elem='all';
end

% check Type:

if ~exist('Type','var'),
  error('No object type defined.');
end

if isempty(Type),
  return
end

if iscell(Type),
  if ~iscell(Elem),
    Elem={Elem};
  end
  if numel(Elem)==1,
    Elem=repmat(Elem,size(Type));
  end
  [Type,ii]=unique(Type);
  Elem=Elem(ii);
  for ty=1:numel(Type),
     Ant1=GridObj(Ant1,Type{ty},Elem{ty},varargin{:});
  end
  return
end

Type=strtrim(Type);

if ~(isequal(Type,'Point')||isequal(Type,'Wire')||isequal(Type,'Surf')),
  error('Invalid Type specification.');
end

% check Elem:

if ischar(Elem),
  if isequal(Type,'Point')||isequal(Type,0),
    Elem=1:size(Ant1.Geom,1);
  end
  if isequal(Type,'Wire')||isequal(Type,1),
    Elem=1:size(Ant1.Desc,1);
  end
  if isequal(Type,'Surf')||isequal(Type,2),
    Elem=1:length(Ant1.Desc2d);
  end
end

% check default dimension:

if isequal(Type,'Point')||isequal(Type,0),
  DefaultDim=0;
end
if isequal(Type,'Wire')||isequal(Type,1),
  DefaultDim=1;
end
if isequal(Type,'Surf')||isequal(Type,2),
  DefaultDim=2;
end


% add object:

AddObj=struct('Type',Type,'Elem',Elem);

AddObj.Phys.Dimension=DefaultDim;

for n=1:floor(length(varargin)/2),
  eval(['AddObj.',varargin{n*2-1},'=varargin{n*2};']);
end

Ant1.Obj=AppStruct(Ant1.Obj,AddObj);

