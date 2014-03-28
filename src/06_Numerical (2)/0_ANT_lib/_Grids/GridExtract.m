
function [Ant,NewO,NewN,NewS,NewP]=GridExtract(Ant0,Objs,Nodes,Segs,Pats)

% [Ant,NewO,NewN,NewS,NewP]=GridExtract(Ant0,Objs,Nodes,Segs,Pats)
% extracts part of the antenna grid Ant0. The objects, nodes, 
% segments and patches which are to be taken are defined by Obj, Nodes, 
% Segs and Pats. The nodes which are needed to define the extracted 
% segments and patches are added to the extracted nodes, they need 
% not be given explicitly. If only certain segments or patches and 
% their end nodes shall be extracted, set Nodes=[]; similarly, all 
% elements building the objects Objs are automatically extracted.
% Pass 'all' (or any string) to extract all objects or elements of the 
% respective type. Pass only Ant0 to extract all objects, segments and 
% patches, which amounts to removing 'unused' nodes. 
%
% NewO, NewN, NewS and NewP are index vectors which give the new 
% object-, node-, segment- and patch-numbers as a function of the old 
% ones, respectively. Indices of removed elements are set to 0.

Objs0=length(Ant0.Obj);
Nodes0=size(Ant0.Geom,1);
Segs0=size(Ant0.Desc,1);
Pats0=length(Ant0.Desc2d);

if nargin<2,
  Objs=1:Objs0;
  Nodes=[];
  Segs=1:Segs0;
  Pats=1:Pats0;
end

if ischar(Objs),
  Objs=1:Objs0;
end

if ~exist('Nodes','var'),
  Nodes=[];
end
if ischar(Nodes),
  Nodes=1:Nodes0;
end

if ~exist('Segs','var'),
  Segs=[];
end
if ischar(Segs),
  Segs=1:Segs0;
end

if ~exist('Pats','var'),
  Pats=[];
end
if ischar(Pats),
  Pats=1:Pats0;
end

% copy antenna grid:

Ant=Ant0;  

% extract objects and add object-composing elements:

Objs=intersect(abs(Objs),1:Objs0);

Ant.Obj=Ant0.Obj(Objs);          

for n=1:length(Ant.Obj),
  switch Ant.Obj(n).Type,
  case 'Point',
    Nodes=[Nodes(:);Ant.Obj(n).Elem(:)];
  case 'Wire',
    Segs=[Segs(:);Ant.Obj(n).Elem(:)];
  case 'Surf',
    Pats=[Pats(:);Ant.Obj(n).Elem(:)];
  end
end

NewO=zeros(Objs0,1);
NewO(Objs)=(1:length(Objs))';

% extract segments and add segment-defining nodes:

Segs=intersect(abs(Segs),1:Segs0);

Ant.Desc=Ant0.Desc(Segs,:);      

Nodes=[Nodes(:);Ant.Desc(:)];

NewS=zeros(Segs0,1);
NewS(Segs)=(1:length(Segs))';

Ant=GridUpdate(Ant,'Segs',NewS);

% extract patches and add patch-defining nodes:

Pats=intersect(abs(Pats),1:Pats0);

Ant.Desc2d=Ant0.Desc2d(Pats);    

for n=1:length(Ant.Desc2d),
  Nodes=[Nodes(:);Ant.Desc2d{n}(:)];
end

NewP=zeros(Pats0,1);
NewP(Pats)=(1:length(Pats))';

Ant=GridUpdate(Ant,'Pats',NewP);

% extract nodes:

Nodes=intersect(abs(Nodes),1:Nodes0);

Ant.Geom=Ant0.Geom(Nodes,:);     

NewN=zeros(Nodes0,1);
NewN(Nodes)=(1:length(Nodes))';

Ant=GridUpdate(Ant,'Nodes',NewN);

