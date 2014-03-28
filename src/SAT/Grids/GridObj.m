
function Ant1=GridObj(Ant,Type,Name,Elem,GraphProp,varargin)

% Ant1=GridObj(Ant,Type,Name,Elem,GraphProp,varargin)
% generates a new grid object with the given specifications. 
% varargin can take any list of property specifications:
% {property name (string), property value, ...}.
% The new object is appended to present ones (Ant.Obj).
% Defaults: Type = all types ('Point', 'Wire' and 'Surf'),
%           Name = '', 
%           Elem = all elements of given Type,
%           GraphProp = [].

if ~isfield(Ant,'Init'),
  Ant1=GridInit(Ant);
else
  Ant1=Ant;
end

if nargin>1,

  if ~(isequal(Type,'Point')|isequal(Type,'Wire')|isequal(Type,'Surf')),
    error('Invalid Type specification.');
  end
  if nargin<3,
    Name='';
  end
  if nargin<4,
    Elem='all';
  end
  if ischar(Elem),
    if isequal(Type,'Point')|isequal(Type,0),
      Elem=1:size(Ant1.Geom,1);
    end
    if isequal(Type,'Wire')|isequal(Type,1),
      Elem=1:size(Ant1.Desc,1);
    end
    if isequal(Type,'Surf')|isequal(Type,2),
      Elem=1:length(Ant1.Desc2d);
    end
  end
  if nargin<5,
    GraphProp=[];
  end
  
  AddObj=struct('Type',Type,'Name',Name,'Elem',Elem,...
    'GraphProp',GraphProp,varargin{:});
  
  Ant1.Obj=SetStruct(Ant1.Obj,0,AddObj);
  
else 

  Ant1=GridObj(Ant1,'Point');
  Ant1=GridObj(Ant1,'Wire');
  Ant1=GridObj(Ant1,'Surf');
      
end
