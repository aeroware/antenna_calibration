
function [hp,hpt,hr,hrt,hpatch]=PolarAxis(p,r)

% PolarBackGround(p,r) adds polar plot axis and background with 
% azimuth annotation p (in radians) and radius annotation r to 
% the current axes.
% p and r may be scalars defining the distance between ticks (grid lines)
% or a vector of values defining the respective values where the
% lines are to be drawn.

deg=pi/180;

pmin=1;  % minimum p-spacing in degrees

fr=1.0;
fp=1.08;

if (nargin<2)|isempty(r)|isequal(r,0),
  a=axis;
  r=max(abs(a(1:4)));
end
r=unique(abs(r(:)));

if (nargin<1)|isempty(p),
  p=30*deg;  % default p
end
p=unique(p);

rmax=max(r);

h=ishold; hold on;

axis image;
axis([-rmax,rmax,-rmax,rmax]);

if length(r)==1,
  r=get(gca,'YTick');
  r=r(find(r>0));
end

phi=0:pi/60:2*pi;
hpatch=patch(rmax*cos(phi),rmax*sin(phi),'w');

hr=zeros(length(r),1);
hrt=hr;
for k=1:length(r),
  hr(k)=plot(r(k)*cos(phi),r(k)*sin(phi));
  hrt(k)=text(r(k)*fr*cos(82*deg),r(k)*fr*sin(82*deg),num2str(r(k)),...
    'HorizontalAlignment','left','VerticalAlignment','bottom');
end

if ~isequal(p,0),
  p=p/deg;
  if length(p)==1,
    n=max(1,round(360/max(pmin,abs(p))));
    p=(0:(n-1))*360/n;
  end
  p=round(p*1e3)/1e3;
  hp=zeros(length(p),1);
  hpt=hp;
  for k=1:length(p),
    hp(k)=line([0;rmax*cos(p(k)*deg)],[0,rmax*sin(p(k)*deg)]);
    hpt(k)=text(fp*rmax*cos(p(k)*deg),fp*rmax*sin(p(k)*deg),num2str(p(k)),...
      'HorizontalAlignment','center','VerticalAlignment','middle');
  end
end

if ~h, hold off; end

set([hp;hr],'Color','k','LineStyle',':','EraseMode','normal');
set([hpt;hrt],'Color','k','EraseMode','normal');
set(hpatch,'FaceColor','w','EdgeColor','k');

a=axis;
axis(10/9*a);

axis off;

hxy=[get(gca,'xlabel'),get(gca,'ylabel')];
set(hxy,'Visible','on')

if nargout==0,
  clear hp;
end

