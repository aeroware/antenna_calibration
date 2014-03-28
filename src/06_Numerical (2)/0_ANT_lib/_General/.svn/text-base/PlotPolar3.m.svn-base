
function [hs,hc,ha,hco,c,hcola,rSc,cSc]=...
  PlotPolar3(t,p,r,rScale,cScale,rContour,tmax,ContourAnno,verhor,cbar)

% [hs,hc,ha]=PlotPolar3(t,p,r) creates a 3-dimensional polar plot.
% t and p are matrices defining the colatitude and azimuth points
% for which the radius is given in r. Lines of constant latitude
% (parallels) and lines of constant azimuth (meridians) are drawn.
% The surface is colored using the colormap of the current axes.
% hs, hc and ha return handles to the plot surface, the colorbar
% and the drawn axeslines, respectively.
%
% In case the color of the surface shall be determined completely
% independent of the radius r, one can pass a cell array r={rr,cc}
% for r where the first element, rr, is the matrix representing the radii
% and the second element, cc, determines the colors. cc is of same size
% as rr.
%
% [hs,hc,ha]=PlotPolar3(t,p,r,rScale,cScale) can be used to define
% a scale for the radii (distance surface-origin) and separately for
% the color of the plotted pattern.
% rScale defines the scale for the radii (distance of surface from origin),
% two versions are possible:
% rScale=[rmin,rmax] defines a linear scale, with rmin being the value of
% the r value which is mapped to the origin, rmax determines
% the bounding box in which the pattern is plotted.
% rScale=[rdBmin,rdBmax,r0dB] defines a logarithmic scale with 0dB being
% at the r-value r0dB. rdBmin is the dB value at the origin, and
% rdBmax defines the bounding box.
% cScale sets the color scale, where in analogy to rScale
% two options are possible:
% cScale=[Cmin,Cmax] establishes a linear scale with the two ends of the
% color scale being mapped to the cc-values Cmin and Cmax.
% cScale=[CdBmin,CdBmax,C0dB] is a logarithmic scale with the ends
% of the color scale at the dB values CdBmin and CdBmax, 0dB being
% mapped to the cc-value C0dB.
% cScale='symm' uses a color scale symmetric wrt. zero (sign-symmetric).
% It is possible to set some of the elements of rScale and/or cScale
% to NaN in order to cause the automatic determination of the respective
% value(s).
%
% [hs,hc,ha,hco,c]=PlotPolar3(t,p,r,rScale,cScale,rContour)
% draws countour lines instead of theta- and phi-lines, where
% rContour is the number of contour lines to be drawn. If rContour
% is a vector, it gives directly the radius values for which the
% contours are drawn.
%
% [hs,hc,ha,hco,c,hcola]=PlotPolar3(t,p,r,rScale,cScale,...
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
%   hs handle of colored surface.
%
% [hs,hc,ha,hco,c,hcola,rSc,cSc]=...
%   PlotPolar3(t,p,r,rScale,cScale,rContour,tmax,ContourAnno,verhor)
% causes subplots with the arrangement defined in the 2-element vector 
% verhor=[ver,hor], hor and ver being the number of horizontal and vertical
% subplots, respectively. Furhtermore, the actually used radii and color
% scales rSc and cSc for each plot (arrays with one row per plot) are
% returned.

cColor=[1,1,1]*0.4;

[hs,hc,ha,hco,c,hcola]=deal({});

if iscell(r),
  [r,cc]=deal(r{1},r{2});
else
  cc=r;
end
r=abs(r(:,:,:));
c=c(:,:,:);

cceqr=isequal(cc,r);

% determine dimensions of t, p and r,
% and ensure that p changes along columns, t along rows:

p=mod(p,2*pi); % ensure that 0<=p<2*pi

nn=sum(abs(diff([t(:),p(:)],1))>1e-6,1);
if nn(1)<nn(2),
  nth=nn(1)+1;
  nph=numel(t)/nth;
  if round(nph)~=nph,
    error('Unsuitable distribution of directions in er.')
  end
  t=reshape(t,nph,nth);
  p=reshape(p,nph,nth);
  r=reshape(r,nph,nth,numel(r)/nth/nph);
  cc=reshape(cc,nph,nth,numel(cc)/nth/nph);
else
  nph=nn(2)+1;
  nth=numel(t)/nph;
  if round(nth)~=nth,
    error('Unsuitable distribution of directions in er.')
  end
  t=reshape(t,nth,nph).';
  p=reshape(p,nth,nph).';
  r=permute(reshape(r,nth,nph,numel(r)/nth/nph),[2,1,3]);
  cc=permute(reshape(cc,nth,nph,numel(cc)/nth/nph),[2,1,3]);
end  
ii=(abs(t(1,:))<1e-6)|(abs(t(1,:)-pi)<1e-6);
jj=find(~ii);
if ~isempty(jj),
  p(:,ii)=repmat(p(:,jj(1)),1,sum(ii));
end

% check scales:

nsubplots=size(r,3);

if ~exist('rScale','var')||isempty(rScale),
  rScale=[nan,nan];
end
if length(rScale)<2,
  rScale(end+1:2)=nan;
end
rSc=repmat(rScale(:),1,nsubplots);
if length(rScale)>2,  % dB-plot
  if isnan(rScale(3)),
    rSc(3,:)=max(r(:));
  elseif isinf(rScale(3)),
    rSc(3,:)=max(max(r,[],1),[],2);
  end
  r=10*log10(max(r./repmat(shiftdim(rSc(3,:),-1),size(r,1),size(r,2)),realmin));
end
if isnan(rScale(2)),
  rSc(2,:)=max(r(:));
elseif isinf(rScale(2)),
  rSc(2,:)=max(max(r,[],1),[],2);
end
if isnan(rScale(1)),
  if length(rScale)>2,
    rSc(1,:)=min(r(:));
  else
    rSc(1,:)=0;
  end
elseif isinf(rScale(1)),
  if length(rScale)>2,
    rSc(1,:)=min(min(r,[],1),[],2);
  else
    rSc(1,:)=0;
  end
end
ii=(rSc(1,:)>=rSc(2,:));
if ~isempty(ii),
  if length(rScale)>2,
    rSc(1,ii)=rSc(2,ii)-3;
  else
    rSc(1,ii)=0;
    rSc(2,ii&(rSc(2,:)<=0))=1;
  end
end
r=max(r,repmat(permute(rSc(1,:),[1,3,2]),size(r,1),size(r,2)));

if ~exist('cScale','var')||isempty(cScale),
  cScale=[nan,nan];
end
if ischar(cScale)&&(upper(cScale(1))=='S'), 
  % 0-symmetric linear color scale
  q=max(abs([min(cc(:));max(cc(:))]));
  cScale=[-q,q];
else
  % non-symmetric color scale
  if length(cScale)<2,
    cScale(end+1:2)=nan;
  end
  cSc=repmat(cScale(:),1,nsubplots);
  if length(cScale)>2,  % dB-plot
    if isnan(cScale(3)),
      cSc(3,:)=max(cc(:));
    elseif isinf(cScale(3)),
      cSc(3,:)=max(max(cc,[],1),[],2);
    end
    cc=10*log10(max(cc./repmat(shiftdim(cSc(3,:),-1),size(cc,1),size(cc,2)),realmin));
  end
  if isnan(cScale(2)),
    cSc(2,:)=max(cc(:));
  elseif isinf(cScale(2)),
    cSc(2,:)=max(max(cc,[],1),[],2);
  end
  if isnan(cScale(1)),
    if length(cScale)>2,
      cSc(1,:)=min(cc(:));
    else
      cSc(1,:)=min(cc(:));
    end
  elseif isinf(cScale(1)),
    if length(cScale)>2,
      cSc(1,:)=min(min(c,[],1),[],2);
    else
      cSc(1,:)=min(min(c,[],1),[],2);
    end
  end
  ii=(cSc(1,:)>=cSc(2,:));
  if ~isempty(ii),
    if length(cScale)>2,
      cSc(1,ii)=cSc(2,ii)-3;
    else
      cSc(1,ii)=0;
      cSc(2,ii&&(cSc(2,:)<=0))=1;
    end
  end
end % non-symmetric color scale

% check contour variables...

if ~exist('rContour','var')||isempty(rContour),
  rContour=[];
end

if ~exist('tmax','var')||isempty(tmax),
  tmax=[];
end

if ~exist('ContourAnno','var')||isempty(ContourAnno),
  ContourAnno=[];
end

% number of subplots (ver times hor) and sort of color bar:

if ~exist('verhor','var')||isempty(verhor),
  ver=ceil(sqrt(nsubplots));
  hor=ceil(nsubplots/ver);
else
  ver=verhor(1);
  hor=verhor(2);
end

hax=zeros(nsubplots,1); % axes handles for subplots

if ~exist('cbar','var')||isempty(cbar),
  cbar='';
end
if isempty(cbar),
  if hor>ver,
    cbar='South';
  else
    cbar='West';
  end
end


% plots:
% -------

if ~isempty(tmax),  % plot 2-dim contour *******************************

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
  
  ii=(t(1,:)>tmax*(1+1e-6));
  t(:,ii,:)=[];
  p(:,ii,:)=[];
  r(:,ii,:)=[];
  cc(:,ii,:)=[];

  for qq=1:nsubplots,
    
    subn=qq;

    %if hor*ver>1,
      hax(qq)=subplot(ver,hor,qq);
    %end

    hh=ishold;
    if ~hh, cla reset, end
    hold on;

    hs{subn}=pcolor(t.*cos(p)/deg,t.*sin(p)/deg,cc(:,:,subn));
    caxis([cSc(1,subn),cSc(2,subn)]);
    set(hs{subn},'EdgeColor','none','FaceColor','interp');
    %,'FaceAlpha',0.75);
    
    if ~isempty(rContour),

      rCo=rContour;
      if length(rCo)~=1,
        rCo=rCo((rCo>=rSc(1,subn))&(rCo<=rSc(2,subn)));
      end

      [c{subn},hco{subn}]=...
        contour(t.*cos(p)/deg,t.*sin(p)/deg,r(:,:,subn),rCo);
      
      set(hco{subn},'Color',cColor);
      
      if ~isempty(ContourAnno)&&~isempty(hco{subn}),
        if length(ContourAnno)==1,
          if numel(rContour)>1,
            rC=zeros(numel(rContour),1);
          else
            rC=zeros(rContour,1);
          end
          q=1;
          k=1;
          while q<size(c{subn},2),
            rC(k)=c{subn}(1,q);
            q=q+c{subn}(2,q)+1;
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
          rC=rC((rC>=rSc(1,subn))&(rC<=rSc(2,subn)));
          hcola{subn}=clabel(c{subn},hco{subn},rC,'LabelSpacing',150,...
            'FontAngle','normal','FontWeight','light','FontSize',8);
        end
      end
    end

    [hp,hpt,hr,hrt,hpatch]=PolarAxis(30*deg,dt*(1:nn+2));
    set(hpatch,'FaceColor','none');

    if ~hh, hold off; end

  end % subn-loop

else  % plot 3d pattern surface *************************************

  for qq=1:nsubplots,
    
    subn=qq;

    %if hor*ver>1,
      hax(qq)=subplot(ver,hor,qq);
    %end

    hh=ishold;
    if ~hh, cla reset, end
    hold on;

    [x,y,z]=sph2cart(p,pi/2-t,...
      (r(:,:,subn)-rSc(1,subn))/(rSc(2,subn)-rSc(1,subn)));

    hs{subn}=surf(x,y,z,cc(:,:,subn));
    caxis([min(cSc(1,:)),max(cSc(2,:))]);
    set(hs{subn},'FaceColor','interp');

    set(hs{subn},'EdgeColor','none');
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

    % if requested draw gain contours:

    if ~isempty(rContour),

      rCo=rContour;
      if length(rCo)==1,
        rCo=min(max(round(rCo),1),30);
        if rCo==1,
          rCo=min(max(round(min(size(t))/6),4),8);
        end
      else
        rCo=rCo((rCo>=rSc(1,subn))&(rCo<=rSc(2,subn)));
      end

      c{subn}=contourc(t(1,:),p(:,1),r(:,:,subn),rCo);  
      
      n=1;
      hco{subn}=[];
      q=rgb2hsv(colormap);
      %q(:,1)=0.5;
      q(:,2)=0;
      q(:,3)=(1-q(:,3)).^(1/2);  % improve!!!
      q=hsv2rgb(q);
      q=repmat(cColor,size(q,1),1);
      while n<=size(c{subn},2),
        m=c{subn}(2,n);
        [u,v,w]=sph2cart(c{subn}(2,n+1:n+m),pi/2-c{subn}(1,n+1:n+m),...
          (c{subn}(1,n)-rSc(1,subn))/(rSc(2,subn)-rSc(1,subn)));
        if ~cceqr,
          col=cColor;
        else
          [mm,ii]=min(abs(c{subn}(1,n)-r(:)));
          col=round(1+(cc(ii)-cScale(1))/(cScale(2)-cScale(1))*(size(q,1)-1));
          col=max(1,min(size(q,1),col));
          col=q(col,:);
        end
        hco{subn}(end+1)=line(u,v,w,'Color',col);
        n=n+m+1;
      end
      hco{subn}=hco{subn}(:);
      
    end % rContour

    % draw major axes:

    m=[-1,-1,-1;1,1,1]*1.2;
    z=zeros(2,1);

    ha{subn}=line([m(:,1),z,z],[z,m(:,2),z],[z,z,m(:,3)],...
      'LineWidth',3*get(gca,'DefaultLineLineWidth'));
    set(ha{subn},{'Color'},{[1,0,0]*0.9;[0,1,0]*0.9;[0,0,1]});

    axis(m(:).'*1.2); 
    axis vis3d
    
    % additional plot cosmetics:

    set(gca,'XTickMode','manual','XTick',[]);
    set(gca,'YTickMode','manual','YTick',[]);
    set(gca,'ZTickMode','manual','ZTick',[]);

    set(gca,'Box','on');

    set(gca,'DataAspectRatio',[1,1,1]);
    
    if ~hh, hold off, end

  end % subn-loop
  
  % link plots:
  
  hlink=linkprop(hax,...
    {'CameraUpVectorMode','CameraUpVector',...
    'CameraViewAngleMode','CameraViewAngle',...
    'CameraTargetMode','CameraTarget',...
    'CameraPositionMode','CameraPosition',...
    });
  set(hax(1),'UserData',hlink);
  
  set(hax(1),'CameraTarget',[0,0,0])
  
end % of 3-dim surface pattern plot **********************************

set(findobj(gcf,'type','axes'),...
  'visible','off','ActivePositionProperty','Position');

% draw colorbar and set axes positions:

if isinf(cScale(3)),
  dBref='i';  
else
  dBref=sprintf('%.2g',cSc(3,1));
end

switch lower(cbar),
  case 'south'
    hc{2}=axes('position',[0.15,0,0.7,0.2]);
    axis off
    caxis([min(cSc(1,:)),max(cSc(2,:))]);
    hc{1}=colorbar('South');
    if length(cScale)>2,
      ylabel(hc{1},['dB(',dBref,')'],'rotation',0,...
        'VerticalAlignment','middle','HorizontalAlignment','Right');
    end
    xax=[0,0.1,1,0.9];
  case 'north'
    hc{2}=axes('position',[0.15,0.8,0.7,0.2]);
    axis off
    caxis([min(cSc(1,:)),max(cSc(2,:))]);
    hc{1}=colorbar('North');
    if length(cScale)>2,
      ylabel(hc{1},['dB(',dBref,')'],'rotation',0,...
        'VerticalAlignment','middle','HorizontalAlignment','Right');
    end
    xax=[0,0,1,0.9];
  case 'east'
    hc{2}=axes('position',[0.79,0.15,0.2,0.7]);
    axis off
    caxis([min(cSc(1,:)),max(cSc(2,:))]);
    hc{1}=colorbar('East');
    if length(cScale)>2,
      xlabel(hc{1},sprintf('dB\n{}(%s)',dBref));
    end
    xax=[0,0,0.9,1];
  otherwise,
    hc{2}=axes('position',[0.01,0.15,0.2,0.7]);
    axis off
    caxis([min(cSc(1,:)),max(cSc(2,:))]);
    hc{1}=colorbar('West');
    if length(cScale)>2,
      xlabel(hc{1},sprintf('dB\n{}(%s)',dBref));
    end
    xax=[0.1,0,0.9,1];
end

if nsubplots>1,
  for qq=1:nsubplots,
    xpos(4)=xax(4)/ver;
    xpos(3)=xax(3)/hor;
    xpos(2)=xax(2)+xpos(4)*(ver-1-floor((qq-1)/hor));
    xpos(1)=xax(1)+xpos(3)*(mod(qq-1,hor));
    set(hax(qq),'position',...
      [xpos(1)+xpos(3)*0.1,xpos(2)+xpos(4)*0.05,0.8*xpos(3),0.8*xpos(4)]);
  end
end

drawnow;

