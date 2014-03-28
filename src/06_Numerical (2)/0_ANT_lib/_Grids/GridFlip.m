
function Ant=GridFlip(Ant0,Segs,Pats,AdaptObjs)

% Ant=GridFlip(Ant0,Segs,Pats) reverses the order of nodes in the 
% definition of the segments Segs and the patches Pats. So the 
% orientations of the given segments and patches are changed.
%
% Ant=GridFlip(Ant0,Segs,Pats,AdaptObjs) additionaly adapts the
% objects AdaptObjs so that their elements keep the same orientation.
% This is achieved by changing the sign of those elements of 
% Ant.Obj(AdaptObj).Elem which are identified by Segs or Pats.
% All other object elements do not change sign, so they 
% change their orientation if in Segs/Pats because the respective
% segments or patches are flipped.

% Added to grid toolbox 15.4.2003
%
% Rev. Feb. 2008:
% Object adaptation for AdaptObjs implemented.

if nargin<2,
  Segs=[];
elseif ischar(Segs),
  Segs=1:size(Ant0.Desc,1);
end
Segs=intersect(1:size(Ant0.Desc,1),abs(Segs));

if nargin<3,
  Pats=[];
elseif ischar(Pats),
  Pats=1:length(Ant0.Desc2d);
end
Pats=intersect(1:length(Ant0.Desc2d),abs(Pats));

Ant=Ant0;

Ant.Desc(Segs,:)=fliplr(Ant0.Desc(Segs,:));  

for n=Pats(:).',
  Ant.Desc2d{n}=Ant0.Desc2d{n}(end:-1:1);
end

if nargin<4,
  AdaptObjs=[];
elseif ischar(AdaptObjs),
  AdaptObjs=1:length(Ant0.Obj);
end
AdaptObjs=unique(intersect(1:length(Ant0.Obj),abs(AdaptObjs)));

if isempty(AdaptObjs),
  return
end

[Points,Wires,Surfs]=FindGridObj(Ant);

if ~isempty(Segs),
  for n=intersect(AdaptObjs(:),Wires(:)).'
    m=ismember(abs(Ant.Obj(n).Elem),Segs);
    Ant.Obj(n).Elem(m)=-Ant.Obj(n).Elem(m);
  end
end

if ~isempty(Pats),
  for n=intersect(AdaptObjs(:),Surfs(:)).'
    m=ismember(abs(Ant.Obj(n).Elem),Pats);
    Ant.Obj(n).Elem(m)=-Ant.Obj(n).Elem(m);
  end
end

    
    