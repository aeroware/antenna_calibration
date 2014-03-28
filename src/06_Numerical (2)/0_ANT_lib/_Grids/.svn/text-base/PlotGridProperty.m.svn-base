
function PlotGridProperty(Reset)

% PlotGridProperty(Reset) initializes the structure PlotGridProp. 
% It contains the default plot properties of nodes and segments 
% as fields Node, NodeAnno, Seg, SegAnno.
% Node and Seg are structures of Line properties, 
% NodeAnno and SegAnno structures of Text properties.
% For instance PlotGridProp.Node.Marker defines the default
% Markers used to plot nodes.
% Reset~=0 forces the properties to be reset to default values
% (even if already initialized); Reset=0 (default) only 
% resets if PlotGridProp is empty (i.e. not yet initialized).

% Revision June 2007:
% Changed PlotGridProp.Patch.EdgeColor from 'none' to
% a color so that edges which are not represented by segments 
% can be seen.

global PlotGridProp;

if nargin<1,
  Reset=0;
end

if ~(Reset||isempty(PlotGridProp)),
  return
end

PlotGridProp.Node.Tag='Node';
PlotGridProp.Node.LineStyle='none';
PlotGridProp.Node.Marker='o';
PlotGridProp.Node.MarkerSize=3;
PlotGridProp.Node.MarkerEdgeColor=[0 0.2 1];
PlotGridProp.Node.MarkerFaceColor=[0 0.2 1];

PlotGridProp.NodeAnno.Tag='NodeAnno';
PlotGridProp.NodeAnno.Color=[0 0.2 1]*0.4;
PlotGridProp.NodeAnno.VerticalAlignment='bottom';
PlotGridProp.NodeAnno.HorizontalAlignment='left';
PlotGridProp.NodeAnno.EraseMode='xor';

PlotGridProp.Seg.Tag='Seg';
PlotGridProp.Seg.LineStyle='-';
PlotGridProp.Seg.Marker='none';
PlotGridProp.Seg.Color=[0 0.6 0];
PlotGridProp.Seg.LineWidth=1.5;

PlotGridProp.SegAnno.Tag='SegAnno';
PlotGridProp.SegAnno.Color=[0 0.5 0]*0.4;
PlotGridProp.SegAnno.VerticalAlignment='bottom';
PlotGridProp.SegAnno.HorizontalAlignment='left';
PlotGridProp.SegAnno.EraseMode='xor';

PlotGridProp.Patch.Tag='Patch';
PlotGridProp.Patch.FaceColor=[0.80,0.68,0.38]*1.15;
PlotGridProp.Patch.EdgeColor=[0.9,0.7,0.5]*0.7;
PlotGridProp.Patch.FaceAlpha=1;
PlotGridProp.Patch.Marker='none';

PlotGridProp.PatchAnno.Tag='PatchAnno';
PlotGridProp.PatchAnno.Color=[0.9,0.8,0.5]*0.4;
PlotGridProp.PatchAnno.VerticalAlignment='middle';
PlotGridProp.PatchAnno.HorizontalAlignment='center';
PlotGridProp.PatchAnno.EraseMode='xor';

