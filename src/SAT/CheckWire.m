
function W=CheckWire(Ant)

% W=CheckWire(Ant) returns wire definition for each segment:
% W is of size s x 2, where s is the number of segments,
% each row containing the radius and conductivity of the 
% wire segment.

W=[];

if isfield(Ant,'Wire'),
  W=Ant.Wire;
end

ns=size(Ant.Desc,1);

if isempty(W),
  W=zeros(ns,2);
elseif isequal(size(W),[1,2]),
  W=repmat(W,ns,1);
elseif ~isequal(size(W),[ns,2]),
  error('Desc and Wire have inconsistent dimensions.');
end

[Points,Wires,Surfs]=GridFindObj(Ant);

if isempty(Wires),
  return
end
if ~isfield(Ant.Obj,'Prop'),
  return
end

for n=Wires(:)',
  s=Ant.Obj(n).Elem;
  if isfield(Ant.Obj(n).Prop,'Radius'),
    if ~isempty(Ant.Obj(n).Prop.Radius),
      W(s,1)=Ant.Obj(n).Prop.Radius;
    end
  end
  if isfield(Ant.Obj(n).Prop,'Cond'),
    if ~isempty(Ant.Obj(n).Prop.Cond),
      W(s,2)=Ant.Obj(n).Prop.Cond;
    end
  end
end
  
