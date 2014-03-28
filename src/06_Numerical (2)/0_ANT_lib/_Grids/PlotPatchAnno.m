
function PlotPatchAnno(Ant,Pats,Action,Anno)

% PlotPatchAnno(Ant,Pats,Action,Anno) sets or changes the annotation of the 
% given patches Pats, according to the passed Action parameter (default=1):
%   Action=0 ... remove present annotations
%   Action=1 ... set new annotations and reset present ones
%   Action=2 ... set annotations only if not yet present
%   Action=3 ... only reset annotations that are present
% The Anno parameter defines the annotation strings. It can be a single 
% string or a cell array of strings of the same length as Pats. 
% It can also be a numeric array, then it is transformed into strings 
% using num2str. Anno is optional, if omitted or empty the patch numbers 
% are used for annotation.

global PlotGridProp;

if nargin<2,
  return
elseif ischar(Pats),
  Pats=1:length(Ant.Desc2d);
end
if isempty(Pats), return, end
Pats=Pats(:);

if (nargin<4)||isempty(Anno),
  Anno=Pats;
end

if (nargin<3)||isempty(Action),
  Action=1;
end

[Pats,m,N]=unique(Pats);

q=length(Pats);
[Pats,m]=intersect(Pats,1:length(Ant.Desc2d));
q=zeros(q,1);
q(m)=1:length(m);
N=MapComp(N,q);

[PNodes,PSegs,PPats,NH,SH,PH]=PlotRecog(Ant,'P');

q=length(Pats);
[Pats,m]=intersect(Pats,PPats);
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
  
  hp=Gather(PH(Pats));
  ha=Gather(get(hp,'UserData'));
  delete(ha);
  set(hp,'UserData',[]);
  
case 1,
  
  for k=1:length(Pats),
    r=mean(Ant.Geom(Ant.Desc2d{Pats(k)},:),1);
    hp=PH{Pats(k)};
    ha=get(hp,'UserData');
    if ~isempty(ha)&&~isequal(ha,0),
      delete(ha);
    end
    ha=text(r(1),r(2),r(3),Anno{k},PlotGridProp.PatchAnno);
    set(hp,'UserData',ha);
  end
  
case 2,
  
  for k=1:length(Pats),
    r=mean(Ant.Geom(Ant.Desc2d{Pats(k)},:),1);
    hp=PH{Pats(k)};
    ha=get(hp,'UserData');
    if isempty(ha)||isequal(ha,0),
      ha=text(r(1),r(2),r(3),Anno{k},PlotGridProp.PatchAnno);
      set(hp,'UserData',ha);
    end
  end
  
case 3,
  
  for k=1:length(Pats),
    r=mean(Ant.Geom(Ant.Desc2d{Pats(k)},:),1);
    hp=PH{Pats(k)};
    ha=get(hp,'UserData');
    if ~isempty(ha)&&~isequal(ha,0),
      delete(ha);
      ha=text(r(1),r(2),r(3),Anno{k},PlotGridProp.PatchAnno);
      set(hp,'UserData',ha);
    end
  end

end

