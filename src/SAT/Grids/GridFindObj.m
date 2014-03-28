  
function varargout=GridFindObj(Ant,varargin)

% [Points,Wires,Surfs]=GridFindObj(Ant) returns the grid objects
% in the antenna grid Ant. The objects are defined in the field
% Ant.Obj, which itself is a structure array having these fields:
%   Ant.Obj().Type  string determining the type of object:
%                   'Point', 'Wire' or 'Surf'
%   Ant.Obj().Name  string, name of object
%   Ant.Obj().Elem  vector of elements building up the object,
%                   giving nodes, segments or patches, respectively.
%   Ant.Obj().GraphProp structure of graphical (line or patch) properties.
% Points, Wires and Surfs return the indices of objects wich are composed
% of points, wires and surfaces, respectively. For instance, the wire
% objects can be accessed by Ant.Obj(Wires), etc.
%
% Objs=GridFindObj(Ant,varargin)
% finds the grid objects in Ant which have the properties given by
% varargin, which is any list of property specifications:
% {property name (string), property value, ...}.
% Objs returns for the found objects the indices into Ant.Obj.

varargout={[],[],[]};

if ~isfield(Ant,'Obj'),
  return
end

if nargin>1, % Objs=GridFindObj(Ant,varargin)
  
  f=varargin(1:2:end);
  v=varargin(2:2:end);
    
  Objs=ones(length(Ant.Obj),1);
  
  for n=1:length(Ant.Obj),
    Objn=Ant.Obj(n);
    for m=1:length(f),
      try 
        ofi=eval(['Objn.',f{m}]); %getfield(Objn,f{m})
      catch
        ofi=[];
        Objs(n)=0;
      end
      if ~isequal(v{m},ofi),
        Objs(n)=0;
        break
      end
    end
  end
  
  varargout={find(Objs)};
  
else % [Points,Wires,Surfs]=GridFindObj(Ant)
  
  if isempty(Ant.Obj), return, end
  
  t=Apply('char',{Ant.Obj.Type});
  Points=find(ismember(t,{'Point',char(0)}));
  Wires=find(ismember(t,{'Wire',char(1)}));
  Surfs=find(ismember(t,{'Surf',char(2)}));
  
  varargout={Points(:),Wires(:),Surfs(:)};
    
end
  