
function [Ant,NewNodes,NewSegs,NewPats,NewObjs]=...
           GridPack(Ant0,Dist,FreeNodes,Pack)

% [Ant,NewNodes,NewSegs,NewPats,NewObjs]=GridPack(Ant0,Dist,FreeNodes,Pack)
% identifies nodes which are closer to each other than the given 
% distance limit Dist. The nodes which may be removed can be confined 
% by the optional parameter FreeNodes. If omitted or any string, all 
% nodes are "free". If Dist is omitted, Dist=0 is assumed, i.e. only 
% multiple node definitions are reduced.
% Pack works as explained in GridUpdate.

% NewNodes associates to each node in Ant0.Geom the new node number in 
% Ant.Geom, NewSegs is the same for segments (negative values indicate 
% a change in orientation), NewPats for patches (negative for change 
% of circulation direction). NewSegs and NewPats get zero values for
% removed segments and patches, respectively.

% Multiple Point-, Wire- and Surf-objects are not removed
% so that different properties can be set to the same wire or 
% segment by including it into several objects. Nevertheless,
% objects containing removed nodes, segments or patches, 
% respectively, are deleted. The relation between old and new 
% arrangement is represented by NewObjs. 

% To be implemented in future:
% Recognition of nearly-intersecting segments and patches.

if ~isfield(Ant0,'Init'),
  Ant=GridInit(Ant0);
else
  Ant=Ant0;
end

n0=size(Ant.Geom,1);
if n0==0,
  return
end

if nargin<2,
  Dist=0;
end

if nargin<3,
  FreeNodes=1:n0;
elseif ischar(FreeNodes),
  FreeNodes=1:n0;
else
  FreeNodes=intersect(1:n0,FreeNodes);
end

if nargin<4,
  Pack=[0,0];
end

if ~isempty(FreeNodes),

  % group nodes which are to be identified (equivalent):
  
  k=ones(1,n0);   % nodes to keep
  nk=1;           % number of nodes to keep
  NewNodes=k;     % new node numbers 
  for n=2:n0,
    m=[];
    if ismember(n,FreeNodes),
      m=min(find(Mag(repmat(Ant.Geom(n,:),nk,1)-...
        Ant.Geom(k(1:nk),:),2)<=Dist));
    end
    if isempty(m),
      nk=nk+1;
      k(nk)=n;
      NewNodes(n)=nk;
    else
      NewNodes(n)=m;
    end
  end

  % select one node per group:
  
  Ant.Geom=Ant.Geom(k(1:nk),:);

else
  
  NewNodes=1:size(Ant.Geom,1);

end

% Update antenna grid:

[Ant,NewObjs,NewSegs,NewPats]=GridUpdate(Ant,'Nodes',NewNodes,Pack);

