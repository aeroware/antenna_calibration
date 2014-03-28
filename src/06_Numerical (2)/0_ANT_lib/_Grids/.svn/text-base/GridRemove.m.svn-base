
function [Ant,NewO,NewN,NewS,NewP,AddS]=...
  GridRemove(Ant0,Objs,Nodes,Segs,Pats,Lin,FreeObjs)

% [Ant,NewO,NewN,NewS,NewP,AddS]=...
%   GridRemove(Ant0,Objs,Nodes,Segs,Pats,Lin,FreeObjs)
% removes given objects and elements from antenna grid Ant0, returning the
% result in Ant. With the given Nodes all segments and patches based on 
% them are removed, similarly all objects based on any removed elements 
% are removed. Negative values of Objs force removal of those elements of 
% removed objects which are not needed in any remaining object definition; 
% negative values of Segs and Pats force removal of those nodes of the 
% removed segments and patches which are not needed in any remaining 
% segment or patch definition.
%
% NewO, NewN, NewS and NewP are index maps from old to new index numbers,
% where 0 indicates that the corresponding object or element is removed. 
%
% If Lin is set to a positive integer, all grid-lines having end nodes 
% where a maximum of Lin segments meet are maintained, more precisely:
% whenever at least 2 nodes of such a grid-line remain, the line is 
% maintained by substituting the old segment string by a new one 
% connecting the remaining nodes. AddS returns the additional segments  
% which had to be added to render the lines.
%
% All input parameters after Ant0 are optional.
% Ant=GridRemove(Ant0) sets Ant=Ant0, but removes all grid contents
% (i.e. resets fields Geom, Desc, Desc2d and Obj).
%
% The optional argument FreeObjs causes removal of the given objects if
% any elements of the respective object are removed. Objects not contained
% in FreeObjs remain, but reduced by removed elements. FreeObjs='all' sets 
% all objects free. Default: FreeObjs=[].

Objs0=length(Ant0.Obj);
Nodes0=size(Ant0.Geom,1);
Segs0=size(Ant0.Desc,1);
Pats0=length(Ant0.Desc2d);

NewO=zeros(Objs0,1);
NewN=zeros(Nodes0,1);
NewS=zeros(Segs0,1);
NewP=zeros(Pats0,1);
AddS=[];

Ant=Ant0;

if nargin<2,
  Ant1=GridInit;
  Ant.Geom=Ant1.Geom;
  Ant.Desc=Ant1.Desc;
  Ant.Desc2d=Ant1.Desc2d;
  Ant.Obj=Ant1.Obj;
  return
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

if (nargin<6)||isempty(Lin),
  Lin=0;
end
Lin=abs(Lin);

if nargin<7,
  FreeObjs=[];
end
if ischar(FreeObjs),
  FreeObjs=1:length(Ant0.Obj);
end
FreeObjs=intersect(FreeObjs,1:length(Ant0.Obj));

% -----------------
% remove objects
% -----------------

eObjs=abs(intersect(Objs,-(1:Objs0)));  % objects to remove with elements

Objs=intersect(abs(Objs),1:Objs0);      % objects to remove

kObjs=setdiff(1:Objs0,Objs);            % objects to keep

Ant.Obj=Ant0.Obj(kObjs);

NewO(kObjs)=1:length(kObjs);

FreeObjs=NewO(FreeObjs);
FreeObjs=FreeObjs(FreeObjs~=0);

[Points,Wires,Surfs]=FindGridObj(Ant0);

% add object-segments to be deleted:

rs=abs(Gather({Ant0.Obj(intersect(Wires,eObjs)).Elem}));
ks=abs(Gather({Ant0.Obj(intersect(Wires,kObjs)).Elem}));
rs=setdiff(rs,ks);
Segs=[Segs(:);rs]; 

% add object-patches to be deleted:

rp=abs(Gather({Ant0.Obj(intersect(Surfs,eObjs)).Elem}));
kp=abs(Gather({Ant0.Obj(intersect(Surfs,kObjs)).Elem}));
rp=setdiff(rp,kp);
Pats=[Pats(:);rp]; 

% add object-nodes to be deleted:

rn=abs(Gather({Ant0.Obj(intersect(Points,eObjs)).Elem}));
rn=[rn;Gather(Ant0.Desc2d(rp));Gather(Ant0.Desc(rs,:))]; 

kn=abs(Gather({Ant0.Obj(intersect(Points,kObjs)).Elem}));
kn=[kn;Gather(Ant0.Desc2d(kp));Gather(Ant0.Desc(ks,:))]; 

Nodes=[Nodes(:);setdiff(rn,kn)]; 

% ----------------
% remove patches
% ----------------

nPats=abs(intersect(Pats,-(1:Pats0)));  % patches to remove with nodes

Pats=intersect(abs(Pats),1:Pats0);      % patches to remove

kPats=setdiff(1:Pats0,Pats);            % patches to keep

Ant.Desc2d=Ant0.Desc2d(kPats);

NewP(kPats)=1:length(kPats);

[Ant,NewObjs]=GridUpdate(Ant,'Patches',NewP,[],FreeObjs);

FreeObjs=NewObjs(FreeObjs);
FreeObjs=FreeObjs(FreeObjs~=0);

NewO=MapComp(NewO,NewObjs);

r=Gather(Ant0.Desc2d(nPats));           % removable patch-nodes
k=Gather(Ant.Desc2d);                   % patch-nodes to keep

% ----------------
% remove segments
% ----------------

nSegs=abs(intersect(Segs,-(1:Segs0)));  % segments to remove with nodes

Segs=intersect(abs(Segs),1:Segs0);      % segments to remove

kSegs=setdiff(1:Segs0,Segs);            % segments to keep

Ant.Desc=Ant0.Desc(kSegs,:);

NewS(kSegs)=1:length(kSegs);

[Ant,NewObjs]=GridUpdate(Ant,'Segments',NewS,[],FreeObjs);

FreeObjs=NewObjs(FreeObjs);
FreeObjs=FreeObjs(FreeObjs~=0);

NewO=MapComp(NewO,NewObjs);

r=[r;Gather(Ant0.Desc(nSegs,:))];       % add removable segment-nodes 
k=[k;Ant.Desc(:)];                      % add segment-nodes to keep

% --------------
% remove nodes
% --------------

if Lin,
  [LNodes,LSegs,LLen]=GridLines(Ant.Desc,Lin); 
end

% add segment- and patch-nodes to be removed:

Nodes=[Nodes(:);setdiff(r,k)]; 

% nodes to keep:

kNodes=setdiff(1:Nodes0,abs(Nodes));    

Ant.Geom=Ant.Geom(kNodes,:);

NewN(kNodes)=1:length(kNodes);

[Ant,NewObjs,NewSegs,NewPats]=GridUpdate(Ant,'Nodes',NewN,[],FreeObjs);

NewO=MapComp(NewO,NewObjs);
NewS=MapComp(NewS,NewSegs);
NewP=MapComp(NewP,NewPats);

if Lin,
  
  AddD=[];
    
  D=[Ant.Desc;fliplr(Ant.Desc)];
  
  for L=1:length(LLen);
    n=LNodes{L}(1:LLen(L));
    [s,i]=intersect(n,kNodes);
    if length(s)>1,
      s=NewN(n(sort(i)));
      s=s(:);
      if (length(LNodes{L})~=LLen(L))&&(length(s)>2), 
        s=[s;s(1)];                                   % close line
      end
      s=[s(1:end-1),s(2:end)];
      AddD=[AddD;setdiff(s,D,'rows')];
    end
  end
  
  AddS=size(Ant.Desc,1)+(1:size(AddD,1));

  Ant.Desc=[Ant.Desc;AddD];
  
end

