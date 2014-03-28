
function [hm,ht,tii]=PlotAnno(x,y,m,t)
  
% [hm,ht,tii]=PlotAnno(x,y,m,t) annotates plot in axis with handle ha 
% at positions (x,y) with the markers m and the text t.
% x and y are of type cell, m and t of type struct.
% x, y, m and t must be arrays of same size, where the n-th element 
% specifies the positions (x{n},y{n}), the marker definitions m(n) and the 
% text annotations t(n) of the n-th line, all displayed elements of which
% have the same properties. 
% x{n} and y{n} are vectors defining the points of the n-th line,
% which are to be marked by markers defined in m(n) and 
% annotated with the text given in t(n).
% m(n) is a struct containing all line properties for the marker definition
% of the n-th line, where each field must be a property name, non-present 
% properties are set to defaults. Pass m=[] if all default properties are
% to be used for the markers. The field 'ForceMark' is the only of m 
% that is not a graphic property. It is analogous to 'ForceAnno' in t 
% (see below). Default is to force no Markers, i.e. only the annotated
% poits get markers.
% t(n) is a struct the fields of which are used as text properties
% for the annotation strings. Only the field 'Anno' (and eventually 
% 'ForceAnno') is not used as property but used to give 
% the annotation text, i.e. a cell array of strings and/or
% numbers the length of which must agree with the length of x{n} and y{n}.
% Use ht{n}.Anno{q}='' or nan to indicate that the q-th marker of the n-th
% line has no annotation string.
% If all lines consist of the same number of points, t may also simply be
% the annotations for these lines (which are, then, the same for all
% lines). This amounts to pass in t what is passed in t.Anno when also the 
% text properties are to be defined. In this case only default text
% properties are used. Set t.ForceAnno to switch non-overlap automatic off 
% certain elements. The field ForceAnno is a numeric array of same length 
% as Anno, which forces annotation for the non-zeros, e.g. 
% t{n}.ForceAnno(q)==1 causes unrestricted annoation of the q-th mark 
% of the n-th line. Default if ForceAnno(q)=0 for all marks.
%
% hm and ht return handles, hm(n) being the handle to the markers of 
% the n-th line and ht(q) a handle to the q-th annotation string which 
% belongs to the tii(q,2)-th marker of the tii(q,1)-th line.
%
% The function automatically reduces the number of annotations in such a
% way that no overlaps occur. Numbers with less significant digits or
% shorter strings are preferred.
% The function may be called several times with different annotations,
% hold being on, so that certain line annotations may be in favor (those
% called first).

global Global_Annoxybuffer

Defaultm.Marker='.';
Defaultm.LineStyle='none';

hh=ishold;
hold on;
a=axis;

if isempty(Global_Annoxybuffer)||~hh,
  Global_Annoxybuffer=uint8(zeros(1000,1000));
end

Nlines=numel(x);

if isempty(m),
  m=repmat(Defaultm,size(x));
elseif numel(m)==1,
  m=repmat(m,size(x));
end

if isnumeric(t)||iscell(t),
  t=struct('Anno',t);
end
if numel(t)==1,
  t=repmat(t,size(x));
end

if ~isequal(Nlines,numel(y))||~isequal(Nlines,numel(m))||...
   ~isequal(Nlines,numel(t)),
  error('Sizes of x,y,m and t must agree.');
end

LineLen=zeros(Nlines,1);
for q=1:numel(x),
  LineLen(q)=numel(x{q});
end
Nmarkers=sum(LineLen);

for i1=1:Nlines,
  if isempty(t(i1).Anno),
    t(i1).Anno=nan(size(x{i1}));
  end
  try 
    fa=t(i1).ForceAnno;
  catch
    fa=[];
  end
  if isempty(fa),
    t(i1).ForceAnno=zeros(size(t(i1).Anno));
  elseif numel(fa)==1,
    t(i1).ForceAnno=repmat(t(i1).ForceAnno,size(t(i1).Anno));
  end
  try 
    fm=m(i1).ForceMark;
  catch
    fm=[];
  end
  if isempty(fm),
    m(i1).ForceMark=zeros(size(x{i1}));
  elseif numel(fm)==1,
    m(i1).ForceMark=repmat(m(i1).ForceMark,size(x{i1}));
  end
end

hm=zeros(Nlines,1);
ht=nan(Nmarkers,1);
tii=nan(Nmarkers,2);

% write annotation text:

tstr=cell(Nmarkers,1);
tsig=inf(Nmarkers,1);
tfa=zeros(Nmarkers,1);

ii=0;
for i1=1:Nlines,
  for i2=1:LineLen(i1),
    ii=ii+1;
    tii(ii,:)=[i1,i2];
    tt=t(i1).Anno(i2);
    tfa(ii)=t(i1).ForceAnno(i2);
    if iscell(tt),
      tt=tt{1};
    end
    if isnumeric(tt)&&~isnan(tt),
      tt=char(strtrim(AnnoNumber(tt)));
      tsig(ii)=length(tt);
    elseif ischar(tt)&&~isempty(tt),
      tt=AnnoNumber(tt);
      tsig(ii)=length(tt);
      while (tsig(ii)>0)&&(tt(tsig(ii))=='0'),
        tsig(ii)=tsig(ii)-1;
      end
    else
      tt='';
    end
    tstr{ii}=tt;
  end
end

[qq,q]=sortrows([-tfa(:),tsig(:)]);

co=get(gca,'ColorOrder');
nc=size(co,1);

for ii=q(:).',
  if isempty(tstr{ii}),
    continue
  end
  hx=text(x{tii(ii,1)}(tii(ii,2)),y{tii(ii,1)}(tii(ii,2)),tstr{ii});
  set(hx,'Color',co(mod(tii(ii,1)-1,nc)+1,:));
  pv=GetPropertyValuePairs(t(tii(ii,1)),{'Anno','ForceAnno'});
  if ~isempty(pv),
    set(hx,pv{:})
  end
  set(hx,'HorizontalAlignment','Center','VerticalAlignment','Bottom');
  if istobeplotted(get(hx,'Extent'),a,1+(tfa(ii)~=0)),
    ht(ii)=hx;
  else
    delete(hx);
  end
end

qq=~isnan(ht);
ht=ht(qq);
tii=tii(qq,:);

% plot markers:
 
for n=1:Nlines,
  q=union(find(m(n).ForceMark(:)),tii(tii(:,1)==n,2));
  if isempty(q),
    continue
  end
  pv=GetPropertyValuePairs(Defaultm,{});
  hm(n)=line(x{n}(q),y{n}(q),'Color',co(mod(n-1,nc)+1,:),pv{:});
  pv=GetPropertyValuePairs(m(n),{'ForceMark'});
  if ~isempty(pv),
    set(hm(n),pv{:});
  end  
end

if ~hh,
  hold off;
end

end  % PlotAnno



function s=AnnoNumber(x)

% returns cell array of strings obtained by conversion of numbers in x

AnnoFormat='%.4g';

s=cell(size(x));

for n=1:numel(x),
  sx=strtrim(sprintf(AnnoFormat,x(n)));
  m=strfind(sx,'+00');
  if ~isempty(m),
    sx(m(1):m(1)+2)='';
  else
    m=strfind(sx,'+0');
    if ~isempty(m),
      sx(m(1):m(1)+1)='';
    end
  end
  s{n}=sx;
end

end % AnnoNumber



function p=istobeplotted(Extent,a,plotit)

% p=istobeplotted(Extent,a,plotit) checks if the rectangle given by Extent
% can be plotted without overlaps, based on the Global_Annoxybuffer.
% Global_Annoxybuffer is an array which represents the plotting window,
% having zeros where the plot is still empty.
% a=[xmin,xmax,ymin,ymax] defines the borders of the window.
% Note that a and Extend use different ways to identify rectangles
% (see also the function GetOverlap).
%
% If plotit=1 is passed, the rectangle is also plotted into the buffer
% if istobeplotted=1 is returned. If plotit=2, the rectangle is plotted
% into the buffer in any case. Otherwise no plot into buffer.

global Global_Annoxybuffer

% frame around rectangle 
% (increases rectangle by given number of pixels at each side):
dxFrame=1.5;  
dyFrame=0;

x=[Extent(1),Extent(1)+Extent(3)];
x=round((x-a(1))/(a(2)-a(1))*size(Global_Annoxybuffer,1)+0.5+...
  [-dxFrame,dxFrame]);
x=[max(x(1),1),min(x(2),size(Global_Annoxybuffer,1))];

y=[Extent(2),Extent(2)+Extent(4)];
y=round((y-a(3))/(a(4)-a(3))*size(Global_Annoxybuffer,2)+0.5+...
  [-dyFrame,dyFrame]);
y=[max(y(1),1),min(y(2),size(Global_Annoxybuffer,2))];

p=0;

if (x(1)<=x(2))&&(y(1)<=y(2)),
  if ~any(any(Global_Annoxybuffer(x(1):x(2),y(1):y(2)))),
    p=1;
  end
end

if isequal(plotit,2)||(isequal(plotit,1)&&p),
  Global_Annoxybuffer(x(1):x(2),y(1):y(2))=1;
  p=1;
end

end % istobeplotted



function y=GetPropertyValuePairs(x,Exceptions)

if ~isstruct(x)||isempty(x),
  y={};
  return
end

n=setdiff(fieldnames(x),Exceptions);

y=cell(2,numel(n));
y(1,:)=n(:).';

for m=1:size(y,2),
  if isfield(x,y{1,m}),
    y{2,m}=x.(y{1,m});
  end
end

end % GetPropertyValuePairs

