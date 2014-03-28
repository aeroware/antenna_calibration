
function Toscale(M,Margin)

% Toscale(M,Margin) sets current axes to scale M.
% The optional Margin is a numeric vector of 0, 2 or 4 elements
% defining [left,bottom,right,top] margins between figure
% edges and respective axes edges; non-defined margins default
% to the margins of the original figure.
%
% If Margin is a 0- or 4-element numeric vector, the figure size 
% is adapted to cover the axes with margins. If Margin is of 
% length 2, the figure size is not adapted, so the part of the 
% axes extending beyond (above and to the right of) the figure window 
% is clipped. Similarly, if Margin='fix' is passed, the bottom-left 
% corner of the original axes and the figure window size are 
% not changed.
%
% If the figure window size is to be changed, it is done by changing 
% the bottom-left corner so that the top-right window buttons stay 
% accessible. If the window is too large to fit onto the screen, it 
% is not changed at all and a warning is displayed. Nevertheless, the 
% paperposition is adapted accordingly so that to-scale printing is 
% possible as long as the figure fits onto the printer page.
%
% Plot coordinates and Margin are supposed to be given
% in centimeters!

% REVISIONS
% 10.4.03: 
% - passing axes handles not possible any longer to prevent 
%   ambiguities, now works always on current axes;
% - refresh of figure before return.

if nargin<2,
  Margin=[];
end

h=gca;

x=get(h,'XLim');
y=get(h,'YLim');
z=get(h,'ZLim');

if ~isequal(camtarget(h,'mode'),'auto'),
  campos(h,[mean(x),mean(y),mean(z)]+campos(h)-camtarget(h));
end

camtarget auto;
camva auto;

axis(h,'equal');
set(h,'XLim',x,'YLim',y,'ZLim',z);

[x,y,z]=meshgrid(x,y,z);

T=view(h);

set(h,'PlotBoxAspectRatioMode','manual');
r=get(h,'PlotBoxAspectRatio');

xy=T*[x(:)/r(1),y(:)/r(2),z(:)/r(3),ones([numel(x),1])]';
xy(1:2,:)=xy(1:2,:)./repmat(xy(4,:),2,1);

dx=max(xy(1,:))-min(xy(1,:));
dy=max(xy(2,:))-min(xy(2,:));

% figure window:

Pa=get(h,'Parent');
u=get(Pa,'Units');
set(Pa,'Units','centimeters');
Pap=get(Pa,'Position');

% position of axes in figure and print page:

set(h,'Units','centimeters');
p=get(h,'Position');

if isempty(Margin),
  Margin=[p(1:2),Pap(3:4)-p(3:4)-p(1:2)]; % use margins of original figure
elseif ischar(Margin),
  Margin=p(1:2);
elseif length(Margin)>1,
  p(1)=Margin(1);
  p(2)=Margin(2);
end
Margin=max(Margin,0);

p(3:4)=[dx,dy]*M;

set(gcf,'PaperUnits','centimeters');
ps=get(gcf,'PaperSize');

if length(Margin)>2,  % adapt figure to enclose axes with Margin

  if length(Margin)==3,
    Margin(4)=Margin(2);
  end
  q=Margin(1)+Margin(3)+p(3);
  Pap(1)=Pap(1)+Pap(3)-q;
  Pap(3)=q;
  q=Margin(2)+Margin(4)+p(4);
  Pap(2)=Pap(2)+Pap(4)-q;
  Pap(4)=q;
  if any(Pap<0),
    warning('Could not adapt figure, it would extend out of screen.');
  else
    set(Pa,'Position',Pap);
  end

  m=(ps-Pap(3:4))/2;  % paper margin for printing
  
else  % do not adapt figure, but adapt paper margin for printing:
  
  m=(ps-p(3:4)-p(1:2))/2;
  if m(1)<0,
    m(1)=(ps(1)-p(3))/2;
  end
  if m(2)<0,
    m(2)=(ps(2)-p(4))/2;
  end
  
end

if any(m<0),
  warning('Figure exceeds page margins when printing.');
end
m=max(0,m);

set(gcf,'PaperPosition',[m,ps-2*m]);

set(h,'Position',p);

set(Pa,'Units',u);

refresh(Pa);
