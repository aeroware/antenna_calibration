
function [Nodes,Segs,Pats,NH,SH,PH]=PlotRecog(Ant,Recog)

% [Nodes,Segs,Pats,NH,SH,PH]=PlotRecog(Ant,Recog) finds the segments,
% nodes and patches in the current axis. Nodes, Segs and Pats return 
% vectors of found node-, segment- and patch-numbers, respectively. 
% NH, SH and PH return 1-dim cell arrays. NH is of length size(Ant.Geom,1), 
% NH(m) containing a vector of found handles for the m-th node; SH is 
% of length size(Ant.Desc,1), SH(m) containing a vector of found handles 
% for the m-th segment; PH is of length length(Ant.Desc2d), PH{m} being 
% a vector of found handles for the m-th patch of the given antenna Ant.
% Empty cells in NH, SH and PH represent non-drawn nodes, segments and
% patches, respectively. The search is restricted to the objects with
% the tags defined in the fields Node.Tag, Seg.Tag and Patch.Tag of 
% the global variable PlotGridProp (if Node.Tag, etc., is empty the 
% search is not restricted). The UserData property of the 
% found objects contain eventual handles to annotation numbers (which 
% are text objects, the tags of which are determined by NodeAnno.Tag, 
% SegAnno.Tag and PatchAnno.Tag of PlotGridProp).
% The search can be restricted to certain kinds of objects given by the 
% optional character parameter Recog, where the characters 'N', 'S' and
% 'P' represent nodes, segments and patches, respectively. For example
% PlotRecog(Ant,'pN') will find nodes and patches but no segments, so
% Segs=[] and SH={} are returned.

global PlotGridProp;

if nargout==0, return, end

PlotGridProperty;

[Nodes,Segs,Pats]=deal([]);
[NH,SH,PH]=deal({});

if nargin<2,
  Recog='nsp';
end
Recog=upper(Recog);

% Find nodes:

if any(Recog=='N'),
  
  if ischar(PlotGridProp.Node.Tag),
    L=findobj(gca,'Type','line','Tag',PlotGridProp.Node.Tag);
  else
    L=findobj(gca,'Type','line');
  end
  
  n=size(Ant.Geom,1);
  Nodes=zeros(n,1);
  NH=cell(n,1);
  
  if ~isempty(L),
    for m=1:n,
      NH{m}=findobj(L,'XData',Ant.Geom(m,1),...
        'YData',Ant.Geom(m,2),'ZData',Ant.Geom(m,3));
      Nodes(m)=~isempty(NH{m});
    end
  end
  
  Nodes=find(Nodes);
  
end

% Find segments:

if any(Recog=='S'),
  
  if ischar(PlotGridProp.Seg.Tag),
    L=findobj(gca,'Type','line','Tag',PlotGridProp.Seg.Tag);
  else
    L=findobj(gca,'Type','line');
  end
  
  n=size(Ant.Desc,1);
  Segs=zeros(n,1);
  SH=cell(n,1);
  
  if ~isempty(L),
    for m=1:n,
      g=Ant.Geom(Ant.Desc(m,:),:)';
      SH{m}=findobj(L,'XData',g(1,:),'YData',g(2,:),'ZData',g(3,:));
      Segs(m)=~isempty(SH{m});
    end
  end
  
  Segs=find(Segs);
  
end

% Find patches:

if any(Recog=='P'),
  
  if ischar(PlotGridProp.Patch.Tag),
    L=findobj(gca,'Type','patch','Tag',PlotGridProp.Patch.Tag);
  else
    L=findobj(gca,'Type','patch');
  end
  
  n=length(Ant.Desc2d);
  Pats=zeros(n,1);
  PH=cell(n,1);
  
  if ~isempty(L),
    for m=1:n,
      d=Ant.Desc2d{m};
      g=Ant.Geom(d,:);
      PH{m}=findobj(L,'Vertices',g,'Faces',1:length(d));
      Pats(m)=~isempty(PH{m});
    end
  end
  
  Pats=find(Pats);
  
end
