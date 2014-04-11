
function M=PlotField(x,y,Fx,Fy,wt,Contents,ae,c)

% M=PlotField(x,y,Fx,Fy,wt,Contents,ae,c) plots the field given by 
% the complex vectors (Fx,Fy) at time-phase wt (default wt=0).
% Contents determines what is actually drawn:
%   Contents='a' ... arrows of field vectors at the instance wt
%   Contents='e' ... polarization ellipses
%   Contents='c' ... color image of field magnitude
% Any combination of these plots is possible, default='a'.
% x, y, Fx and Fy must be vectors or matrices of the same size. 
% For the color image plot they must be matrices where the first
% index represents y- and the second index represents x-direction.
% wt can be a vector of time-phase values. In this case the 
% corresponding plots are shown in succession. This is useful for 
% the creation of movies. For this purpose M returns a vector of 
% frames which can be used to show the movie, e.g. movie(M,3,5) 
% shows the movie 3 times, 5 frames the second.
%
% ae is a vector which specifies how arrows and ellipses are drawn:
%   ae=[p,s,sub,aecol]
% where p defines powers for normalization of vector lengths and
% s is a stretch factor for the resulting arrows:
%   vector shown = s * unit vector * (vector length)^p,
% e.g. p=1 shows the vectors as given, p=0.1 stretches vectors
% in such a way that 1/1024 of the maximum vector length is 
% actually shown as half the maximum vector length.
% sub determines that only on every sub'th field point arrows or
% ellipses are drawn. The 3 elements aecol set the rgb-color of 
% arrows and ellipses. 
% Default: ae=[1,1,1,0,0,0]
%
% c are specifications for the field maginitude color image:
%   c=[Cp,Cmax,Cbar]
% Cmax is the magnitude corresponding to the highest color index 
% in the current colormap; Cmax<=0 causes an automatic magnitude 
% determination. Cp works for c-scale like p for ae-scale.
% Cbar~=0 causes drawing of a color bar beside the plot, 
% where the labeling is in percent for Cbar=1, in dB for Cbar<0,
% and in proper field magnitudes otherwise.
% Default: c=[1,0,0]

if nargin<8,
  c=[];
end
d=[1,0,0]';
d(1:length(c(:)))=c(:);
Cmax=d(2);
Cp=d(1);
Cbar=d(3);

if nargin<7,
  ae=[];
end
d=[1,1,1,0,0,0]';
d(1:length(ae(:)))=ae(:);
p=d(1);
s=d(2);
sub=max(1,d(3));
aecol=d(4:6);

if nargin<6,
  Contents=[];
end
Contents=lower(Contents);
ArrowPlot=~isempty(findstr(Contents,'a'));
EllipsePlot=~isempty(findstr(Contents,'e'));
ColorPlot=~isempty(findstr(Contents,'c'));
if ~(ArrowPlot|EllipsePlot|ColorPlot),
  ArrowPlot=1;
end

if (nargin<5)|isempty(wt),
  wt=0;
end

% characteristic values of polarization:

[ny,nx]=size(x);
nn=nx*ny;

deltax=-angle(Fx);
deltay=-angle(Fy);
ax=abs(Fx);
ay=abs(Fy);
a=(ax.^2+ay.^2)/2;
a=sqrt(a+sqrt(a.^2-(ax.*ay.*sin(deltax-deltay)).^2)); % large semi-axis

% determine sub-structure for arrows and ellipses:

if (ny~=1)&(nx~=1),
  nsubx=min(nx,1+ceil(sub/2)):sub:nx;
  nsuby=min(ny,1+ceil(sub/2)):sub:ny;
  nsub=reshape(1:nx*ny,[ny,nx]);
  nsub=nsub(nsuby,nsubx);
  nsub=nsub(:);
else
  nsub=min(nn,1+ceil(sub/2)):sub:nn;
end

ns=length(nsub);

xs=x(nsub); 
xs=xs(:);
ys=y(nsub); 
ys=ys(:);

deltaxs=deltax(nsub);
deltays=deltay(nsub);

axs=ax(nsub);
ays=ay(nsub);
as=a(nsub);

% normalization of axs and ays according to p:

m=find(as~=0);
axs(m)=axs(m).*as(m).^(p-1);  
ays(m)=ays(m).*as(m).^(p-1);

% adapting axs and ays to fit in x-y-grid:

q=zeros([ns,1]);
if (ny~=1)&(nx~=1),
  q=q+min(abs([ys(2)-ys(1),xs(length(nsuby)+1)-xs(1)]));
else
  for k=1:ns,
    r=Mag([xs(k)-xs,ys(k)-ys],2);
    q(k)=min(r(find(r~=0)));
  end
end
if isempty(m),
  m=1;
else
  m=s*0.5*min(q(m)./sqrt(axs(m).^2+ays(m).^2));
end
axs=m*axs;                   
ays=m*ays;

% Initialize Plot:

h=ishold;
if ~h, clf; hold on; end

axis([[min(x(:)),max(x(:))]+max(axs)*[-1,1],...
      [min(y(:)),max(y(:))]+max(ays)*[-1,1]]);

% Plot ellipses:

if EllipsePlot,

  EllPoints=40;  % number of points per ellipse

  tau=repmat((0:EllPoints)*(2*pi/EllPoints),[ns,1]);
  EllPoints=EllPoints+1;
  xe=repmat(axs,[1,EllPoints]).*cos(tau-repmat(deltaxs,[1,EllPoints]));
  xe=xe+repmat(xs,[1,EllPoints]);
  ye=repmat(ays,[1,EllPoints]).*cos(tau-repmat(deltays,[1,EllPoints]));
  ye=ye+repmat(ys,[1,EllPoints]);
  
  EllipH=line(xe',ye','Color',aecol);  

end

% Plot arrows and color background; take photos for movie:

ArrowH=[];
ColorH=[];

if ColorPlot,  % prepare for colorplot 

  % auto-determination of Cmax:
  c=a.^Cp;
  if Cmax<=0,
    Cmax=min(max(c(:)),mean(c(:))*3)^(1/Cp);
  end
  
  % colorbar:
  if Cbar,
    CbarH=colorbar('vert');    
%    d=str2num(get(CbarH,'YTickLabel'));
    d=(1:7)'./7*length(colormap);
    set(CbarH,'YTick',d);
    d=Cmax*(d/length(colormap)).^(1/Cp); 
    if Cbar<0,
      set(CbarH,'YTickLabel',num2str(10*log10(d/Cmax),'%.2g'));
      set(get(CbarH,'XLabel'),'String','dB');
    elseif Cbar==1,
      set(CbarH,'YTickLabel',num2str(d/Cmax,'%.2g'));
      set(get(CbarH,'XLabel'),'String','rel');
    else
      set(CbarH,'YTickLabel',num2str(d,'%.2g'));
      set(get(CbarH,'XLabel'),'String','');
    end  
  end

end

for k=1:length(wt),   % frame (photo) counter
  
  if ColorPlot,  % colorplot

    qx=cos(wt(k)-deltax);
    qy=cos(wt(k)-deltay);
    
    F=length(colormap)*(sqrt(abs(Fx.*qx).^2+abs(Fy.*qy).^2)/Cmax).^Cp;

    delete(ColorH);
    ColorH=pcolor(x(1,:),y(:,1),F); 
    set(ColorH,'CDataMapping','direct');
    shading interp;
    
  end
    
  if ArrowPlot,  % plot arrows
    
    qx=cos(wt(k)-deltaxs);
    qy=cos(wt(k)-deltays);
  
    delete(ArrowH);
    ArrowH=quiver(xs,ys,axs.*qx,ays.*qy,0);
    set(ArrowH,'Color',aecol);
    
  end
  
  if nargout>0,   % take photograph if M requested

    axis equal;
    M(k)=getframe(gca);
    
  end

end

if ~h, hold off; end

