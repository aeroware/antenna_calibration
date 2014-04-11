
function Ant=GridFlip(Ant0,Segs,Pats)

% Ant=GridFlip(Ant0,Segs,Pats) reverses the order of nodes in the 
% definition of the segments Segs and the patches Pats. So the 
% orientations of the given segments and patches are changed.

% ADDED to grid toolbox 15.4.2003

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

for n=Pats(:)',
  Ant.Desc2d{n}=Ant0.Desc2d{n}(end:-1:1);
end

