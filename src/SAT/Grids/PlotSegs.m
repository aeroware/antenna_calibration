
function H=PlotSegs(Geom,Desc,Segs,LineCol,AnnoCol);

% H=PlotSegs(Geom,Desc,Segs,LineCol,AnnoCol) 
% plots the segments given in the vector Segs using the color given
% in LineCol. AnnoCol defines the color of the respective annotation 
% numbers. The colors may be given by the usual color specifications, 
% where several colors can be defined by rows of matrices. 
% If only Geom and Desc is given or Segs='all' (or any string), all 
% segments are drawn. H returns handles to the line objects, the
% handles of the annotation texts being saved as UserData property
% of the respective line objects.
% Default properties for segments and annotations are defined in
% the global variables PlotGridProp.Seg and PlotGridProp.SegAnno.

global PlotGridProp;

PlotGridProperty;

MaxSubDiv=15; % Maximum number of subdivisions for color interpolation

if nargin<3, 
  Segs=1:size(Desc,1); 
end
if ischar(Segs), 
  Segs=1:size(Desc,1); 
end
if isempty(Segs),
  if nargout>0,
    H=[];
  end
  return
end
SN=length(Segs);

if nargin<4,
  LineCol=[];
end
if ~isempty(LineCol),
  LineCol=RGBColor(LineCol,PlotGridProp.Seg.Color);
  n=mod((0:SN-1),size(LineCol,1))+1;
  LineCol=LineCol(n,:);
end

if nargin<5,
  AnnoCol=[];
end
Annotation=~isempty(AnnoCol);
if Annotation,
  AnnoCol=RGBColor(AnnoCol,PlotGridProp.SegAnno.Color);
  n=mod((0:SN-1),size(AnnoCol,1))+1;
  AnnoCol=AnnoCol(n,:);
end 
   
% Plot segments:

h=ishold;
if ~h, cla('reset'); hold on; end

H=line([Geom(Desc(Segs,1),1),Geom(Desc(Segs,2),1)]',...
       [Geom(Desc(Segs,1),2),Geom(Desc(Segs,2),2)]',...
       [Geom(Desc(Segs,1),3),Geom(Desc(Segs,2),3)]',...
       PlotGridProp.Seg);

if ~isempty(LineCol),
  set(H,{'Color'},num2cell(LineCol,2));
end

% Plot annotation numbers:

if Annotation,
  r=(Geom(Desc(Segs,1),:)+Geom(Desc(Segs,2),:))/2;
  c=deblank(cellstr(strjust(num2str(Segs(:)),'left')));
  HA=text(r(:,1),r(:,2),r(:,3),c,PlotGridProp.SegAnno);
  set(HA,{'Color'},num2cell(AnnoCol,2));
  set(H,{'UserData'},num2cell(HA(:),2));  
end

if ~h, hold off; end

if nargout==0,
  clear H;
end
