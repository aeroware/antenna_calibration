
function H=PlotNodes(Geom,Nodes,MarkerEdgeCol,MarkerFaceCol,AnnoCol)

% H=PlotNodes(Geom,Nodes,MarkerEdgeCol,MarkerFaceCol,AnnoCol) 
% plots the nodes given in the vector Nodes using given marker face-
% and edge-colors. AnnoCol defines the colors of annotation numbers.
% The colors may be given in the usual color specifications, where
% several colors can be defined by rows of matrices. If only Geom 
% is given or Nodes='all' is passed, all nodes in 
% Geom are drawn. H returns handles to the line objects, the handles
% of the annotations being saved as UserData property of the respective 
% lines. Default properties for nodes and annotation from
% PlotGridProp.Node and PlotGridProp.NodeAnno, respectively.

global PlotGridProp;

PlotGridProperty;

if nargin<2, 
  Nodes=1:size(Geom,1); 
end
if ischar(Nodes), 
  Nodes=1:size(Geom,1); 
end
if isempty(Nodes),
  if nargout>0,
    H=[];
  end
  return
end
NN=length(Nodes);

if (nargin<3)||isempty(MarkerEdgeCol),
  MarkerEdgeCol=PlotGridProp.Node.MarkerEdgeColor;
end
MarkerEdgeCol=RGBColor(MarkerEdgeCol,PlotGridProp.Node.MarkerEdgeColor);
n=mod((0:NN-1),size(MarkerEdgeCol,1))+1;
MarkerEdgeCol=MarkerEdgeCol(n,:);

if (nargin<4)||isempty(MarkerFaceCol),
  MarkerFaceCol=PlotGridProp.Node.MarkerFaceColor;
end
MarkerFaceCol=RGBColor(MarkerFaceCol,PlotGridProp.Node.MarkerFaceColor);
n=mod((0:NN-1),size(MarkerFaceCol,1))+1;
MarkerFaceCol=MarkerFaceCol(n,:);

if nargin<5,
  AnnoCol=[];
end
Annotation=~isempty(AnnoCol);
if Annotation,
  AnnoCol=RGBColor(AnnoCol,PlotGridProp.NodeAnno.Color);
  n=mod((0:NN-1),size(AnnoCol,1))+1;
  AnnoCol=AnnoCol(n,:);
end 
   
% Plot:

h=ishold;
if ~h, cla('reset'); hold on; end

H=zeros(NN,1);

MFC=PlotGridProp.Node.MarkerFaceColor;
MEC=PlotGridProp.Node.MarkerEdgeColor;
AC=PlotGridProp.NodeAnno.Color;

r=Geom(Nodes,:);

for n=1:NN,
  PlotGridProp.Node.MarkerEdgeColor=MarkerEdgeCol(n,:);
  PlotGridProp.Node.MarkerFaceColor=MarkerFaceCol(n,:);
  H(n)=line(r(n,1),r(n,2),r(n,3),PlotGridProp.Node);
  if Annotation,
    PlotGridProp.NodeAnno.Color=AnnoCol(n,:);
    HA=text(r(n,1),r(n,2),r(n,3),num2str(Nodes(n)),PlotGridProp.NodeAnno);
    set(H(n),'UserData',HA);
  end
end

PlotGridProp.Node.MarkerFaceColor=MFC;
PlotGridProp.Node.MarkerEdgeColor=MEC;
PlotGridProp.NodeAnno.Color=AC;

if ~h, hold off; end

if nargout==0,
  clear H;
end
