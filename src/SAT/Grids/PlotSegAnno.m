
function PlotSegAnno(Ant,Segs,Action,Anno);

% PlotSegAnno(Ant,Segs,Action,Anno) sets or changes the annotation of the 
% given segments Segs, according to the passed Action parameter (default=1):
%   Action=0 ... remove present annotations
%   Action=1 ... set new annotations and reset present ones
%   Action=2 ... set annotations only if not yet present
%   Action=3 ... only reset annotations that are present
% The Anno parameter defines the annotation strings. It can be a single string
% or a cell array of strings of the same length as Segs. It can also be a 
% numeric array, then it is transformed into strings using num2str. Anno is 
% optional, if omitted or empty the segment numbers are used for annotation.

global PlotGridProp;

if nargin<2,
  return
elseif ischar(Segs),
  Segs=1:size(Ant.Desc,1);
end
if isempty(Segs), return, end
Segs=Segs(:);

if (nargin<4)|isempty(Anno),
  Anno=Segs;
end

if (nargin<3)|isempty(Action),
  Action=1;
end

[Segs,m,N]=unique(Segs);

q=length(Segs);
[Segs,m]=intersect(Segs,1:size(Ant.Desc,1));
q=zeros(q,1);
q(m)=1:length(m);
N=MapComp(N,q);

[PNodes,PSegs,PPats,NH,SH,PH]=PlotRecog(Ant,'S');

q=length(Segs);
[Segs,m]=intersect(Segs,PSegs);
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
  
  hs=Gather(SH(Segs));
  ha=Gather(get(hs,'UserData'));
  delete(ha);
  set(hs,'UserData',[]);
  
case 1,
  
  r=(Ant.Geom(Ant.Desc(Segs,1),:)+Ant.Geom(Ant.Desc(Segs,2),:))/2;
  for k=1:length(Segs),
    hs=SH{Segs(k)};
    ha=get(hs,'UserData');
    if ~isempty(ha)&~isequal(ha,0),
      delete(ha);
    end
    ha=text(r(k,1),r(k,2),r(k,3),Anno{k},PlotGridProp.SegAnno);
    set(hs,'UserData',ha);
  end
  
case 2,
  
  r=(Ant.Geom(Ant.Desc(Segs,1),:)+Ant.Geom(Ant.Desc(Segs,2),:))/2;
  for k=1:length(Segs),
    hs=SH{Segs(k)};
    ha=get(hs,'UserData');
    if isempty(ha)|isequal(ha,0),
      ha=text(r(k,1),r(k,2),r(k,3),Anno{k},PlotGridProp.SegAnno);
      set(hs,'UserData',ha);
    end
  end
  
case 3,
  
  r=(Ant.Geom(Ant.Desc(Segs,1),:)+Ant.Geom(Ant.Desc(Segs,2),:))/2;
  for k=1:length(Segs),
    hs=SH{Segs(k)};
    ha=get(hs,'UserData');
    if ~isempty(ha)&~isequal(ha,0),
      delete(ha);
      ha=text(r(k,1),r(k,2),r(k,3),Anno{k},PlotGridProp.SegAnno);
      set(hs,'UserData',ha);
    end
  end

end

