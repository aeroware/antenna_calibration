
function [hs,hc,ha,hco,c,hsurf]=PlotPolar3(t,p,r,LogScale,ColScale,...
  rContour,tmax,ContourAnno)

% [hs,hc,ha]=PlotPolar3(t,p,r) creates a 3-dimensional polar plot.
% t and p are matrices defining the colatitude and azimuth points
% for which the radius is given in r. Lines of constant latitude 
% (parallels) and lines of constant azimuth (meridians) are drawn.
% The surface is colored using the colormap of the current axes.
% hs, hc and ha return handles to the plot surface, the colorbar
% and the drawn axeslines, respectively.
%
% [hs,hc,ha]=PlotPolar3(t,p,r,rmin) defines by the scalar rmin
% the minimum value for r which represents the origin of the 3d polar plot. 
% Values of r below rmin are mapped to rmin (this also applies to 
% contour 2d-plots, see below).
% 
% [hs,hc,ha]=PlotPolar3(t,p,r,LogScale,ColScale) can be used to define 
% a logarithmic instead of a linear scale and how colors shall be used.
% The optional LogScale=[dBmin,r0dB] is a 2-element vector, which
% defines the minimum dB at the origin, and the gain value used 
% as reference for the dB-scale (corresponding to zero dB).
% The optional ColScale=[rCmin,rCmax] defines how the colors are scaled:
% Cmin and Cmax are the values (gain for linear scale or dB for defined 
% LogScale) correponding to the lowest and highest color in the colormap,
% respectively. ColScale='symm' uses a scale symmetric round zero.
%
% [hs,hc,ha,hco,c]=PlotPolar3(t,p,r,LogScale,ColScale,rContour)
% draws countour lines instead of theta- and phi-lines, where
% rContour is the number of contour lines to be drawn. If rContour
% is a vector, it gives directly the radius values for which the 
% contours are drawn.
% 
% [hcola,hc,ha,hco,c,hsurf]=PlotPolar3(t,p,r,LogScale,ColScale,...
%   rContour,tmax,ContourAnno)
% plot 2-dim polar plot where t is drawn as radius and p as azimuth,
% the surface is colored as defined by the shown colorbar and contour lines
% are drawn. tmax sets the maximum t-value (outermost level), and 
% rContour is the number of contours to be plotted (if a vector is given, 
% it defines directly the contour levels), ContourAnno=1 causes annotation 
% of contour lines (a vector defines the levels to be annotated). 
%   hc color bar handle, 
%   ha axis lines,
%   hco contour handles, 
%   hcola contourlabel handle, 
%   c contours,
%   hsurf handle of transparent surface

ContourPatches=0;    % 0/1 .. draw lines/patches for contours

[hs,hc,ha,hco,c,hsurf]=deal([]);

if (nargin<4)|isempty(LogScale),
  LogScale=nan;
end
if length(LogScale)>1,  % dB-plot
  r0dB=LogScale(2);
  if isnan(r0dB),
    r0dB=max(r(:));
  end
  r=10*log10(max(r/r0dB,realmin));
end
rmin=LogScale(1);
if isnan(rmin),
  rmin=min(r(:));
end
r=max(r,rmin);

if (nargin<5)|isempty(ColScale),
  ColScale=[nan,nan];
end
if ischar(ColScale),
  if upper(ColScale(1))=='S',     % scale symmetric round 0
    q=max(abs([rmin;max(r(:))]));
    ColScale=[-q,q];
  end
end
if isnan(ColScale(1)),
  rCmin=rmin;
else
  rCmin=ColScale(1);
end
if isnan(ColScale(2)),
  rCmax=max(r(:));
else
  rCmax=ColScale(2);
end

if nargin<6,
  rContour=[];
end

if (nargin<7)|isempty(tmax),
  tmax=0;
end

if (nargin<8),
  ContourAnno=[];
end

h=ishold;
if ~h, cla('reset'); end

caxis([rCmin,rCmax]);
%set(gca,'CLim',[rCmin,rCmax],'CLimMode','manual');

if tmax~=0,  % plot 2-dim contour *******************************
  
  [ha,hs]=deal([]);
  
  deg=pi/180;
  
  dt=round(tmax./[3,4,5]/deg*1e3)/1e3;
  nn=find(dt==round(dt));
  if isempty(nn), 
    nn=2;
  else 
    nn=nn(1);
  end
  dt=dt(nn);
  tmax=dt*(nn+2)*deg;
  [hp,hpt,hr,hrt,hpatch]=PolarAxis(30*deg,dt*(1:nn+2));
  set(hpatch,'FaceColor',[1,1,1]*1);
  
  hold on;
  
  hsurf=pcolor(t.*cos(p)/deg,t.*sin(p)/deg,r);
  set(hsurf,'EdgeColor','none','FaceColor','interp','FaceAlpha',0.75); 
  
  if ~isempty(rContour),
    if ContourPatches,
      [c,hco]=contour(t.*cos(p)/deg,t.*sin(p)/deg,r,rContour);
      cmap=colormap;
      clim=caxis(gca);
      for k=1:length(hco),
        q=get(hco(k),'CData');
        q=q(1);
        q=max(1,min(size(cmap,1),1+(q-clim(1))/diff(clim)*(size(cmap,1))));
        set(hco(k),'EdgeColor',cmap(fix(q),:)*0.7);  % contour linecolor for patches
      end
    else
      [c,hco]=contour(t.*cos(p)/deg,t.*sin(p)/deg,r,rContour,'-');
      cmap=colormap;
      clim=caxis(gca);
      rC=zeros(length(hco),1);
      q=1;
      k=1;
      while q<size(c,2),
        rC(k)=c(1,q);
        q=q+c(2,q)+1;
        k=k+1;
      end
      rC=rC(1:k-1);
      for k=1:length(rC),
        q=rC(k);
        q=max(1,min(size(cmap,1),1+(q-clim(1))/diff(clim)*(size(cmap,1))));
        set(hco(k),'Color',cmap(fix(q),:)*0.7);  % contour linecolor for lines
      end
    end
    if ~isempty(ContourAnno)&~isempty(hco),
      if length(ContourAnno)==1,
        rC=zeros(rContour,1);
        q=1;
        k=1;
        while q<size(c,2),
          rC(k)=c(1,q);
          q=q+c(2,q)+1;
          k=k+1;
        end
        rC=rC(1:k-1);
        rC=unique(rC);
        if length(rC)>6,
          rC=rC(1:round(length(rC)/5):end);
        end
      else 
        rC=unique(ContourAnno);
      end
      if ~isempty(rC),
        hs=clabel(c,hco,rC,'LabelSpacing',150,...
          'FontAngle','normal','FontWeight','light','FontSize',8);
      end
    end
  end
  
  hold off;
  
else  % plot 3d pattern surface *************************************
  
  hold on;
  
  [x,y,z]=sph2cart(p,pi/2-t,r-rmin);
  
  hs=surf(x,y,z,r);
  
  set(hs,'FaceColor','interp');
  
  % if requested draw gain contours instead of theta- and phi-lines:
  
  if ~isempty(rContour),
    
    set(hs,'EdgeColor','none');
    
    if sin(t(1,1))>1e-2,
      line(x(:,1),y(:,1),z(:,1),'Color','k');
    end
    if sin(t(end,end))>1e-2,
      line(x(:,end),y(:,end),z(:,end),'Color','k');
    end
    if sin(abs(p(1,1)-p(end,end))/2)>1e-2,
      line(x(1,:),y(1,:),z(1,:),'Color','k');
      line(x(end,:),y(end,:),z(end,:),'Color','k');
    end
    
    if length(rContour)==1,
      rContour=min(max(round(rContour),1),30);
      if rContour==1,
        rContour=min(max(round(min(size(t))/6),4),8);
      end
    else
      rContour=rContour-rmin;
    end
    
    c=contourc(t(1,:),p(:,1),r-rmin,rContour);
    
    n=1;
    hco=[];
    q=rgb2hsv(colormap);
    q(:,2)=0;
    q(:,3)=(1-q(:,3)).^(1/2);
    q=hsv2rgb(q);
    while n<=size(c,2),
      m=c(2,n);
      [u,v,w]=sph2cart(c(2,n+1:n+m),pi/2-c(1,n+1:n+m),c(1,n));
      col=round(1+(c(1,n)+rmin-rCmin)/(rCmax-rCmin)*(size(q,1)-1));
      col=max(1,min(size(q,1),col));
      hco(end+1)=line(u,v,w,'Color',q(col,:));
      n=n+m+1;
    end
    hco=hco(:);
  end
  
  % draw major axes:
  
  m=1.2*[min(x(:)),min(y(:)),min(z(:));max(x(:)),max(y(:)),max(z(:))];
  z=zeros(2,1); 
  
  ha=line([m(:,1),z,z],[z,m(:,2),z],[z,z,m(:,3)],... 
    'LineWidth',3*get(gca,'DefaultLineLineWidth'),'Color','b');
  
  % additional plot cosmetics:
  
  set(gca,'XTickMode','manual','XTick',[]);
  set(gca,'YTickMode','manual','YTick',[]);
  set(gca,'ZTickMode','manual','ZTick',[]);
  
  set(gca,'Box','on');  
  
  set(gca,'DataAspectRatio',[1,1,1]);
  
end % of 3-dim surface pattern plot **********************************


% draw colorbar:

ca=gca;

hc=colorbar;
if length(LogScale)>1,
  axes(hc);
  xlabel('dB');
end

axes(ca);
if ~h, hold off; end



