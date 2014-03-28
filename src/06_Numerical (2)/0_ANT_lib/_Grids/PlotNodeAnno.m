
function PlotNodeAnno(Ant,Nodes,Action,Anno)

% PlotNodeAnno(Ant,Nodes,Action,Anno) sets or changes the annotation 
% of the given Nodes, according to the passed Action parameter (default=1):
%   Action=0 ... remove present annotations
%   Action=1 ... set new annotations and reset present ones
%   Action=2 ... set annotations only if not yet present
%   Action=3 ... only reset annotations that are present
% The Anno parameter defines the annotation strings. It can be a single 
% string or a cell array of strings of the same length as Nodes. 
% It can also be a numeric array, then it is transformed into strings 
% using num2str. Anno is optional, if omitted or empty the node numbers 
% are used for annotation.

global PlotGridProp;

if nargin<2,
  return
elseif ischar(Nodes),
  Nodes=1:size(Ant.Geom,1);
end
if isempty(Nodes), return, end
Nodes=Nodes(:);

if (nargin<4)||isempty(Anno),
  Anno=Nodes;
end

if (nargin<3)||isempty(Action),
  Action=1;
end

[Nodes,m,N]=unique(Nodes);

q=length(Nodes);
[Nodes,m]=intersect(Nodes,1:size(Ant.Geom,1));
q=zeros(q,1);
q(m)=1:length(m);
N=MapComp(N,q);

[PNodes,PSegs,PPats,NH]=PlotRecog(Ant,'N');

q=length(Nodes);
[Nodes,m]=intersect(Nodes,PNodes);
q=zeros(q,1);
q(m)=1:length(m);
N=MapComp(N,q);

if Action~=0,
  Anno=ToCellstr(Anno,length(N));
  [q,m]=unique(N);
  Anno=Anno(m);
end

switch Action,
  
case 0,
  
  hn=Gather(NH(Nodes));
  ha=Gather(get(hn,'UserData'));
  delete(ha);
  set(hn,'UserData',[]);
  
case 1,
  
  r=Ant.Geom(Nodes,:);
  for k=1:length(Nodes),
    hn=NH{Nodes(k)};
    ha=get(hn,'UserData');
    if ~isempty(ha)&&~isequal(ha,0),
      delete(ha);
    end
    ha=text(r(k,1),r(k,2),r(k,3),Anno{k},PlotGridProp.NodeAnno);
    set(hn,'UserData',ha);
  end
  
case 2,
  
  r=Ant.Geom(Nodes,:);
  for k=1:length(Nodes),
    hn=NH{Nodes(k)};
    ha=get(hn,'UserData');
    if isempty(ha)||isequal(ha,0),
      ha=text(r(k,1),r(k,2),r(k,3),Anno{k},PlotGridProp.NodeAnno);
      set(hn,'UserData',ha);
    end
  end
  
case 3,
  
  r=Ant.Geom(Nodes,:);
  for k=1:length(Nodes),
    hn=NH{Nodes(k)};
    ha=get(hn,'UserData');
    if ~isempty(ha)&&~isequal(ha,0),
      delete(ha);
      ha=text(r(k,1),r(k,2),r(k,3),Anno{k},PlotGridProp.NodeAnno);
      set(hn,'UserData',ha);
    end
  end

end

