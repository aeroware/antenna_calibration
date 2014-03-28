
function [Nodes,Segs,Pats,NH,SH,PH]=PlotRemove(Ant,RNodes,RSegs,RPats,Anno)

% [Nodes,Segs,Pats,NH,SH,PH]=PlotRemove(Ant,RNodes,RSegs,RPats,Anno)
% removes nodes RNodes, segments RSegs and patches RPats of given antenna
% Ant from the current axis. Nodes, Segs and Pats return the remaining 
% nodes, segments and patches, the corresponding handles are returned 
% in NH, SH and PH, respectively (see also PlotRecog).
% PlotRemove(Ant) removes all segments, nodes and patches of Ant.
% If Anno~=0 is passed, only the annotation numbers of the corresponding 
% elements are removed (default Anno=0). 

global PlotGridProp;

if nargout==0, return, end

PlotGridProperty;

if (nargin<2)|ischar(RNodes),
  RNodes=1:size(Ant.Geom,1);
end

if (nargin<3)|ischar(RSegs),
  RSegs=1:size(Ant.Desc,1);
end

if (nargin<4)|ischar(RPats),
  RPats=1:length(Ant.Desc2d);
end

if nargin<5,
  Anno=0;
end

[Nodes,Segs,Pats,NH,SH,PH]=PlotRecog(Ant);

% Remove nodes:

RNodes=intersect(Nodes(:),RNodes(:));

r=cat(1,NH{RNodes}); % node handles to be removed

a=get(r,'UserData'); % annotation handles to be removed
if iscell(a), 
  a=cat(1,a{:});
end

if Anno,
  if ischar(PlotGridProp.NodeAnno.Tag),
    a=findobj(a,'Tag',PlotGridProp.NodeAnno.Tag);
    if ~isempty(a),
      r=findobj(r,{'UserData'},num2cell(a(:),2));  
    else
      r=[];
    end
  end
  delete(a);
  set(r,'UserData',[]);
else
  delete(a);
  delete(r);
  NH(RNodes)=cell(length(RNodes),1);
  Nodes=setdiff(Nodes,RNodes);
end

% Remove segments:

RSegs=intersect(Segs(:),RSegs(:));

r=cat(1,SH{RSegs}); % segment handles to be removed

a=get(r,'UserData'); % annotation handles to be removed
if iscell(a), 
  a=cat(1,a{:});
end

if Anno,
  if ischar(PlotGridProp.SegAnno.Tag),
    a=findobj(a,'Tag',PlotGridProp.SegAnno.Tag);
    if ~isempty(a),
      r=findobj(r,{'UserData'},num2cell(a(:),2));  
    else
      r=[];
    end
  end
  delete(a);
  set(r,'UserData',[]);
else
  delete(a);
  delete(r);
  SH(RSegs)=cell(length(RSegs),1);
  Segs=setdiff(Segs,RSegs);
end

% Remove patches:

RPats=intersect(Pats(:),RPats(:));

r=cat(1,PH{RPats}); % patches handles to be removed

a=get(r,'UserData'); % annotation handles to be removed
if iscell(a), 
  a=cat(1,a{:});
end

if Anno,
  if ischar(PlotGridProp.PatchAnno.Tag),
    a=findobj(a,'Tag',PlotGridProp.PatchAnno.Tag);
    if ~isempty(a),
      r=findobj(r,{'UserData'},num2cell(a(:),2));  
    else
      r=[];
    end
  end
  delete(a);
  set(r,'UserData',[]);
else
  delete(a);
  delete(r);
  PH(RPats)=cell(length(RPats),1);
  Pats=setdiff(Pats,RPats);
end

