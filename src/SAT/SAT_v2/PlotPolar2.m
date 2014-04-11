
function [hp,hr,ha]=PlotPolar2(p,r,LogScale)

% [hp,hr,ha]=PlotPolar2(p,r) creates a polar plot
% where p is azimuth and r is radius.  
% hp, hr and ha return handles to the plot lines, the
% radius annotations and the angle annotations, respectively.
%
% [hp,hr,ha]=PlotPolar2(p,r,LogScale) uses logarithmic instead
% of linear plot. LogScale=[dBmin,r0dB] is a 2-element vector
% defining the minimum dB at the origin and the gain value used 
% as reference for the dB-scale (corresponding to zero dB).

if (nargin<3),
  LogScale=[];
end
if isempty(LogScale),
  dBmin=0;
else
  dBmin=LogScale(1);
  if length(LogScale)>1,
    r0dB=LogScale(2);
  else
    r0dB=nan;
  end
  if isnan(r0dB),
    r0dB=max(r(:));
  end
  r=10*log10(max(r/r0dB,realmin));
  if isnan(dBmin),
    dBmin=min(r(:));
  end
end

r=max(r,dBmin);

% plot:

if isempty(LogScale),
  hp=polar(p,r);
else
  hp=polar(p,r-dBmin);
end

hr=[];
ha=[];

hi=get(0,'ShowHiddenHandle');
set(0,'ShowHiddenHandle','on');
ht=findobj(gca,'Type','text');
set(0,'ShowHiddenHandle',hi);

if length(ht)<10,
  return
end

ht=setdiff(ht,findobj(ht,'String',''));
p=get(ht,'Position');
if iscell(p),
  p=cat(1,p{:});
end
a=round(atan2(p(:,2),p(:,1))/eps/8)*eps*8; % angles of text items
u=unique(a);
n=histc(a,u);
[q,m]=max(n);

n=find(a==u(m));
hr=ht(n);
[q,n]=sort(Mag(p(n,:),2));
hr=hr(n);

q=str2num(char(get(hr,'String')));
set(hr,{'String'},cellstr([repmat('  ',length(q),1),num2str(q+dBmin)]));

n=find(a~=u(m));
ha=ht(n);
[ig,n]=sort(mod(a(n),2*pi));
ha=ha(n);

