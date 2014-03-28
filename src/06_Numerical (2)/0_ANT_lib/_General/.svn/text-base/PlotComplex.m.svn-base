
function [h1,h2,ht,htii]=PlotComplex(f,Z,Ty,Labels,fMarks,fAnno)

% [h1,h2]=PlotComplex(f,Z,Type,Labels) plots the complex function Z(f)
% as specified in Type:
%   Type = 1: f versus real(Z) and imag(Z)
%          2: f versus |Z| and arg(Z)
%          3: real(Z) versus imag(Z)
% Labels is an optional cell array of strings used for annotation of
%   {f,real(Z),imag(Z),|Z|,arg(Z),title},
% where f is the xlabel for Type=1,2; real(Z) and imag(Z) are the ylabels
% for Type=1; |Z| and arg(Z) are the ylabels for Type=2; title the overall
% title for any Type. h1 and h2 return handles to the respective
% subplot); h2 contains the lines of the lower plot in case Type=1 or 2, 
% and it contains handles to the markers for Type=3 (see below).
%
% [h1,h2,ht]=PlotComplex(f,Z,Ty,Labels,fMarks,fAnno)
% writes annotations to the f-values passed in fAnno and draws marks at 
% those defined by fMarks; this option is only possible for 
% real-versus-imag plots. Pass fAnno='auto' to cause automatic
% detection of the values to be annotated, and fAnno='all' or fMarks='all' 
% to annotate all values. At least the annotated values are given a mark.
% ht returns handles to the annotation texts.

MarkerProp.Marker='.';
MarkerProp.LineStyle='none';

deg=pi/180;

if ~exist('Ty','var')||isempty(Ty),
  Ty=1;
end
if ~exist('Labels','var')||isempty(Labels)||~iscell(Labels),
  Labels={[],[],[],[],[]};
end
if length(Labels)<6,
  Labels{6}=[];
end
if ~exist('fAnno','var')||isempty(fAnno),
  fAnno=[];
end
if ~exist('fMarks','var')||isempty(fMarks),
  fMarks=[];
end

hh=get(get(gcf,'Children'),'NextPlot');
if ischar(hh),
  hh={hh};
end
if any(ismember(hh,'add')),
  AddPlot=1;
else
  AddPlot=0;
  if Ty==3,
    cla reset
  else
    clf reset;
  end
end

f=f(:);
q=find(numel(f)==size(Z));
if isempty(q),
  error('f and Z input arguments have inconsistent sizes.');
end
q=q(1);
if q~=1,
  Z=permute(Z,[q,1:q-1,q+1:ndims(Z)]);
end

ht=[];

if isequal(Ty,3),

  % real(Z) versus imag(Z):
  % -----------------------

  hh=ishold;
  if AddPlot, 
    hold on; 
  end
  
  h1=plot(real(Z),imag(Z));
  
  % annotation of f-values:
  
  if ischar(fAnno)&&isequal(lower(fAnno),'all'),
    fAnno={f(:),[]};
  elseif ischar(fAnno)&&isequal(lower(fAnno),'auto'),
    fAnno={[],f(:)};
  elseif isnumeric(fAnno),
    fAnno={fAnno(:),[]};
  elseif ~iscell(fAnno)
    fAnno={[],[]};
  end

  fAnno{1}=unique(fAnno{1});
  fAnno{2}=setdiff(fAnno{2},fAnno{1});
  
  if ischar(fMarks)&&isequal(lower(fMarks),'all'),
    fMarks=f(:);
  end
  if ~isnumeric(fMarks),
    error('fMarks type not known.');
  end
  
  Forcem=fMarks(:); % forced marks
  fMarks=unique([fMarks(:);fAnno{1}(:);fAnno{2}(:)]); % potential marks
  
  n=ismember(f(:),fMarks);
  fn=f(n);
  
  m=MarkerProp;
  m.ForceMark=zeros(size(n));
  m.ForceMark(ismember(fn,Forcem))=1;
  
  x=num2cell(real(Z(n,:)),1);
  y=num2cell(imag(Z(n,:)),1);
  t.Anno=fn;
  t.Anno(~ismember(fn,union(fAnno{1},fAnno{2})))=nan;
  t.ForceAnno=zeros(size(fn));
  t.ForceAnno(ismember(fn,fAnno{1}))=1;  
    
  [h2,ht,htii]=PlotAnno(x,y,m,t);

  if ischar(Labels{3}),
    ylabel(Labels{3});
  end
  if ischar(Labels{2}),
    xlabel(Labels{2});
  end
  if ischar(Labels{6}),
    title(Labels{6});
  end
  grid on
  if ~hh,
    hold off;
  end
  
% hlink1=linkprop(a(1:end-1),{'Ylim','YTick','YTickLabel'});
% hlink2=linkprop(a,{'Xlim','XTick','XTickLabel'});
% set(a(1),'UserData',hlink1)
% set(a(end),'UserData',hlink2)
  
elseif Ty==2,

  % f versus |Z| and arg(Z):
  % ------------------------

  subplot(211);
  hh=ishold;
  if AddPlot,
    hold on;
  end
  h1=plot(f,abs(Z));
  if ischar(Labels{4}),
    ylabel(Labels{4});
  end
  if ~hh,
    hold off;
  end
  grid on
  if ischar(Labels{6}),
    title(Labels{6});
  end

  subplot(212);
  hh=ishold;
  if AddPlot,
    hold on;
  end
  h2=plot(f,dewrap(angle(Z))/deg);
  if ischar(Labels{5}),
    if isempty(Labels{5}),
      ylabel('Phase [deg]');
    else
      ylabel(Labels{5});
    end
  end
  if ischar(Labels{1}),
    xlabel(Labels{1});
  end
  grid on;
  if ~hh,
    hold off;
  end
  
else

  % Ty = 1:  f versus real(Z) and imag(Z):
  % --------------------------------------

  subplot(211);
  hh=ishold;
  if AddPlot,
    hold on;
  end
  h1=plot(f,real(Z));
  if ischar(Labels{2}),
    ylabel(Labels{2});
  end
  if ~hh,
    hold off;
  end
  grid on;
  if ischar(Labels{6}),
    title(Labels{6});
  end

  subplot(212);
  hh=ishold;
  if AddPlot,
    hold on;
  end
  h2=plot(f,imag(Z));
  if ischar(Labels{3}),
    ylabel(Labels{3});
  end
  if ischar(Labels{1}),
    xlabel(Labels{1});
  end
  grid on;
  if ~hh,
    hold off;
  end

end

end % PlotComplex

  

function p=dewrap(p0,dim)

% p=dewrap(p0,dim) keeps phase vector continuous along
% dimension dim, as far as possiple. Furthermore an
% overall 2*pi-multiple shift centers the mean along dim.
% Default for dim is the first non-singleton dimension.

s=size(p0);
if (nargin<2)||isempty(dim),
  dim=find(s>1);
  if isempty(dim),
    p=p0;
    return
  else
    dim=dim(1);
  end
end

dp=cumsum(round(diff(p0,[],dim)/2/pi),dim)*2*pi;

s(length(s)+1:dim)=1;
s(dim)=1;
p=p0-cat(dim,zeros(s),dp);

s(:)=1;
s(dim)=size(p,dim);
p=p-repmat(round(mean(p,dim)/2/pi)*2*pi,s);

end % dewrap

