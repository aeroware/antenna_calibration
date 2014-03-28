
function [Nodes,Segs,Pats,NH,SH,PH]=PlotGrid(Ant,PObjs,PNodes,PSegs,PPats)

% [Nodes,Segs,Pats,NH,SH,PH]=PlotGrid(Ant,PObjs,PNodes,PSegs,PPats)
% plots objects PObjs, nodes PNodes, segments PSegs and patches PPats 
% of the antenna grid Ant. The graphical properties of nodes, segments 
% and patches not occurring in any object (Ant.Obj) are set according 
% to the defaults defined in the global variable PlotGridProp.
% PObjs may be a cell array of strings specifying object names of the 
% field Ant.Obj().Name. Pass an empty matrix (the string 'all') for PObjs, 
% PNodes, PSegs or PPats to plot no (all) elements of the respective 
% kind.
%
% [Nodes,Segs,Pats,NH,SH,PH]=PlotGrid(Ant) plots 'everything': 
% all nodes, segments, patches, points, wires and surfaces.
%
% In any case: If hold is on, all nodes, segments and patches yet present 
% in the plot are removed before the corresponding new ones are plotted. 
% In this respect the functions PlotNodes and PlotSegs behave different
% (they plot over existing elements).
% The output parameters (as defined in PlotRecog) return the graphical 
% representation of the antenna grid in the current axis after the 
% function call.

[Nodes,Segs,Pats]=deal([]);
[NH,SH,PH]=deal({});

if ~isfield(Ant,'Init'),
  Ant=GridInit(Ant);
end

if (nargin<1)||isempty(Ant.Geom),
  if ~ishold, cla('reset'); end
  if nargout==0,
    clear Nodes;
  end
  return
end

% determine nodes, segments and patches to plot:

if nargin<2,
  [PObjs,PNodes,PSegs,PPats]=deal('all');
end

% objects:

if ischar(PObjs),
  PObjs=1:length(Ant.Obj);
elseif iscell(PObjs),
  for n=1:length(PObjs),
    PObjs{n}=FindGridObj(Ant,'Name',PObjs{n});
  end
  PObjs=cat(1,PObjs{:});
end
PObjs=PObjs(:);

[PPoints,PWires,PSurfs]=FindGridObj(Ant);

PPoints=intersect(PPoints,PObjs);
PWires=intersect(PWires,PObjs);
PSurfs=intersect(PSurfs,PObjs);

% nodes:

if ~exist('PNodes','var'),
  PNodes=[];
elseif ischar(PNodes),
  PNodes=1:size(Ant.Geom,1);
end

for n=PPoints(:)',
  PNodes=[PNodes(:);Ant.Obj(n).Elem(:)];
end

PNodes=intersect((1:size(Ant.Geom,1))',abs(PNodes(:)));

% segments:

if ~exist('PSegs','var'),
  PSegs=[];
elseif ischar(PSegs),
  PSegs=1:size(Ant.Desc,1);
end

for n=PWires(:)',
  PSegs=[PSegs(:);Ant.Obj(n).Elem(:)];
end

PSegs=intersect((1:size(Ant.Desc,1))',abs(PSegs(:)));

% patches:

if ~exist('PPats','var'),
  PPats=[];
elseif ischar(PPats),
  PPats=1:length(Ant.Desc2d);
end

for n=PSurfs(:)',
  PPats=[PPats(:);Ant.Obj(n).Elem(:)];
end

PPats=intersect((1:length(Ant.Desc2d))',abs(PPats(:)));

% -------
% PLOT:
% -------

h=ishold;
if ~h, cla('reset'); hold on; end

% analyse and clean current plot according to PNodes,PSegs,PPats:

[Nodes,Segs,Pats,NH,SH,PH]=PlotRemove(Ant,PNodes,PSegs,PPats);

% plot patches:

PH(PPats)=num2cell(PlotPats(Ant.Geom,Ant.Desc2d,PPats));
Pats=union(Pats,PPats);

for n=PSurfs(:)',
  if ~isempty(Ant.Obj(n).Graf),
    set(cat(1,PH{abs(Ant.Obj(n).Elem)}),Ant.Obj(n).Graf);
  end
end

% plot segments:

SH(PSegs)=num2cell(PlotSegs(Ant.Geom,Ant.Desc,PSegs));
Segs=union(Segs,PSegs);

for n=PWires(:)',
  if ~isempty(Ant.Obj(n).Graf),
    set(cat(1,SH{abs(Ant.Obj(n).Elem)}),Ant.Obj(n).Graf);
  end
end

% plot nodes:

NH(PNodes)=num2cell(PlotNodes(Ant.Geom,PNodes));
Nodes=union(Nodes,PNodes);

for n=PPoints(:)',
  if ~isempty(Ant.Obj(n).Graf),
    set(cat(1,NH{abs(Ant.Obj(n).Elem)}),Ant.Obj(n).Graf);
  end
end

if ~h, hold off; end

if nargout==0,
  clear Nodes;
end
