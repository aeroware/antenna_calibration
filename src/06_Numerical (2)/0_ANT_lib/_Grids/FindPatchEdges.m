
function EdgeDesc=FindPatchEdges(Ant,Objs,Pats)

% EdgeDesc=FindPatchEdges(Ant,Objs,Pats) finds edges of the patches Pats and 
% the patches in the objects Objs, returning a corresponding description 
% matrix EdgeDesc which contains the start nodes of the edges in the 
% first column and the end nodes in the second column.
% The orientation of the edges in EdgeDesc is the same as in the 
% respective patch definition (positive circulation sense around patch). 
% Pass Pats='all' or Objs='all' to find all patches or all patches in 
% objects, respectively. 
%
% EdgeDesc=FindPatchEdges(Ant) finds all patch edges.

if ~exist('Objs','var'),
  Objs=[];
  Pats='all';
end
if ischar(Objs),
  Objs=1:numel(Ant.Obj);
end

if ~exist('Pats','var'),
  Pats=[];
end
if ischar(Pats),
  Pats=1:numel(Ant.Desc2d);
elseif ~isempty(Objs),
  [Pos,Wis,Sus]=FindGridObj(Ant);
  Sus=intersect(Sus,Objs);
  for n=1:length(Sus),
    Pats=[Pats(:);Ant.Obj(Sus(n)).Elem(:)];
  end
end

Pats=unique(Pats(:));

le=cellfun(@length,Ant.Desc2d(:),'UniformOutput',true);
EdgeDesc=zeros(sum(le(Pats)),2);
lastp=0;

for p=Pats(:).',

  d=Ant.Desc2d{p}(:);
  EdgeDesc(lastp+1:lastp+le(p),1)=d;
  EdgeDesc(lastp+1:lastp+le(p),2)=[d(2:end);d(1)];
  
  lastp=lastp+le(p);
  
end

EdgeDesc=unique(sort(EdgeDesc,2),'rows');




