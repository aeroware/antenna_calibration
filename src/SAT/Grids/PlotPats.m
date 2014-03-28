
function H=PlotPats(Geom,Desc2d,Pats,FaceCol,AnnoCol);

% H=PlotPats(Geom,Desc2d,Pats,FaceCol,AnnoCol)
% plots the patches given in the vector Pats using the color given
% in FaceCol. AnnoCol defines the color of the respective annotation 
% numbers. The colors may be given by the usual color specifications, 
% where several colors can be defined by rows of matrices. 
% If only Geom and Desc is given or Pats='all' (or any string), all 
% patches are drawn. H returns handles to the patch objects, the
% handles of the annotation texts being saved as UserData property
% of the respective patch objects.
% Default properties for patches and annotations are defined in
% the global variables PlotGridProp.Patch and PlotGridProp.PatchAnno.

global PlotGridProp;

PlotGridProperty;

if nargin<3, 
  Pats=1:length(Desc2d); 
end
if ischar(Pats), 
  Pats=1:length(Desc2d); 
end
if isempty(Pats),
  if nargout>0,
    H=[];
  end
  return
end
PN=length(Pats);

if nargin<4,
  FaceCol=[];
end
if ~isempty(FaceCol),
  FaceCol=RGBColor(FaceCol,PlotGridProp.Patch.FaceColor);
  n=mod((0:PN-1),size(FaceCol,1))+1;
  FaceCol=FaceCol(n,:);
end

if nargin<5,
  AnnoCol=[];
end
Annotation=~isempty(AnnoCol);
if Annotation,
  AnnoCol=RGBColor(AnnoCol,PlotGridProp.PatchAnno.Color);
  n=mod((0:PN-1),size(AnnoCol,1))+1;
  AnnoCol=AnnoCol(n,:);
end 
   
% Plot Patches:

h=ishold;
if ~h, cla('reset'); hold on; end

c=zeros(PN,3);  % centers of patches
H=zeros(PN,1);

for p=1:PN,
  n=Desc2d{Pats(p)};
  g=Geom(n,:);
  c(p,:)=mean(g,1);
  H(p)=patch('Vertices',g,'Faces',1:length(n),PlotGridProp.Patch);
end

if ~isempty(FaceCol),
  set(H,{'FaceColor'},num2cell(FaceCol,2));
end

% Plot annotation numbers:

if Annotation,
  s=deblank(cellstr(strjust(num2str(Pats(:)),'left')));
  HA=text(c(:,1),c(:,2),c(:,3),s,PlotGridProp.PatchAnno);
  set(HA,{'Color'},num2cell(AnnoCol,2));
  set(H,{'UserData'},num2cell(HA(:),2));  
end

if ~h, hold off; end

if nargout==0,
  clear H;
end
