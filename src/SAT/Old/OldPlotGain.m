
function PlotGain(Geom,Desc,Curr,k,P,x,y,n,Loga,Comp);

% PlotGain(Geom,Desc,Curr,k,P,x,y,n) draws one of these gain plots:
% In case x and y are 3-dimensional vectors, a polar plot in the
% plane spanned by x and y is generated. When x and y are 2-dimensional,
% they define a solid angle of emission direction, colatitute running
% from x(1) to x(2), and azimuth from y(1) to y(2).
% If Loga~=0, the plot scale is logarithmic. 
% Comp~=0 -> comparison with inf. dipole is shown for 2-dim plot.
% n is the number of interpolation points to draw and need not be  
% given (none or [] passed), default is 100 for 2d and 
% round(10*[x(end)-x(1),y(end)-y(1)]) for 3d plots.

h=ishold;
if ~h, clf; hold on; end

if size(x,1)==1, x=x'; end
if size(y,1)==1, y=y'; end

if size(x,1)==3,  % 2-dimensional plot
  
  if (nargin<8) | isempty(n), n=100; end
  n=max(12,n(1));
  n=min(1e4,n(1));
  
  x=x/norm(x);
  y=y-x.*(x'*y);
  y=y/norm(y);
  
  p=0:2*pi/n:2*pi;
  kvec=k*(x*cos(p)+y*sin(p));
  G=Gain(Geom,Desc,Curr,kvec,P);
  [mi,ni]=min(G);
  [ma,na]=max(G);
  if (nargin>=9) & Loga,
    polar(p,30+10*log10(max(1e-3,G/ma)),'b');
    if (nargin>9) & Comp,
      G=ma*sin(p-p(ni)).^2;  % infinitesimal dipole 
      polar(p,30+10*log10(max(1e-3,G/ma)),'r.');
    end
  else
    polar(p,G,'b');
    if (nargin>9) & Comp,
      G=ma*sin(p-p(ni)).^2;  % infinitesimal dipole 
      polar(p,G,'r.');
    end
  end
  
else  % 3-dimensional plot
  
  x=sort(min(pi,max(0,x)));
  y=sort(min(2*pi,max(-2*pi,y)));
  
  if (nargin<8) | isempty(n), 
    n=round(30/pi*[x(end)-x(1),y(end)-y(1)]); 
  end
  n=max(2,n);
  n=min(1e3,n);
  
  kvec=k*OldSph2Cart(SphPart(x(1),x(end),n(1),y(1),y(end),n(end)));
  
  G=Gain(Geom,Desc,Curr,kvec,P);
  
  kvec=kvec./k.*G(:,[1,1,1]);
  
  m=[min(kvec); max(kvec)]; 
  
  kvec=reshape(kvec,n(1),3*n(end));
  xx=kvec(:,1:n(end));
  yy=kvec(:,n(end)+1:2*n(end));
  zz=kvec(:,2*n(end)+1:3*n(end));
  cc=sqrt(xx.^2+yy.^2+zz.^2);
  surf(xx,yy,zz,cc);
     
  z=zeros(2,1); 
  m=1.2*m;
  line([m(:,1),z,z],[z,m(:,2),z],[z,z,m(:,3)],... % draw major axes
    'LineWidth',5*get(gca,'LineWidth'),'Color','b')
     
%   set(gca,'XTickMode','manual','XTick',[]);
%   set(gca,'YTickMode','manual','YTick',[]);
%   set(gca,'ZTickMode','manual','ZTick',[]);
  set(gca,'Box','on');   
     
end

if ~h, hold off; end

  