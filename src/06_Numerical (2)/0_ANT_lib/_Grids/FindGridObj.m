  
function varargout=FindGridObj(Ant,varargin)

% [Points,Wires,Surfs]=FindGridObj(Ant) returns the grid objects
% in the antenna grid Ant. The objects are defined in the field
% Ant.Obj, which itself is a structure array having these fields:
%   Ant.Obj().Type  string determining the type of object:
%                   'Point', 'Wire' or 'Surf'
%   Ant.Obj().Name  string, name of object
%   Ant.Obj().Elem  vector of elements building up the object,
%                   giving nodes, segments or patches, respectively.
%   Ant.Obj().Graf structure of graphical (line or patch) properties.
% Points, Wires and Surfs return the indices of objects wich are composed
% of points, wires and surfaces, respectively. For instance, the wire
% objects can be accessed by Ant.Obj(Wires), etc.
%
% Objs=FindGridObj(Ant,varargin)
% finds the grid objects in Ant which have the properties given by
% varargin, which is any list of property specifications:
% {property name (string), property value, ...}.
% Objs returns for the found objects the indices into Ant.Obj.

% Rev. Feb. 2008
% Original name GridFindObj changed to FindGridObj to prevent 
% confusion with old version which worked differently.

varargout={[],[],[]};

if ~isfield(Ant,'Obj'),
  return
end

if nargin>1, % Objs=FindGridObj(Ant,varargin)
  
  f=varargin(1:2:end);
  v=varargin(2:2:end);
    
  Objs=ones(length(Ant.Obj),1);
  
  for n=1:length(Ant.Obj),
    Objn=Ant.Obj(n);
    for m=1:length(f),
      try 
        ofi=Objn.(f{m});
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
  
else % [Points,Wires,Surfs]=FindGridObj(Ant)
  
  if isempty(Ant.Obj), return, end
  
  t=cellfun(@(x)(lower(char(x))),{Ant.Obj.Type},'UniformOutput',false);
  Points=find(ismember(t,{'point',char(0)}));
  Wires=find(ismember(t,{'wire',char(1)}));
  Surfs=find(ismember(t,{'surf',char(2)}));
  
  varargout={Points(:),Wires(:),Surfs(:)};
    
end
  