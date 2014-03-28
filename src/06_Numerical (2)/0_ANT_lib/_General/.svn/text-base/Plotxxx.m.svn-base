
deg=pi/180;

nt=90;
np=180; 

t=(0:nt)/nt*pi;
p=(0:np)/np*2*pi;

[t,p]=meshgrid(t,p);

r={repmat(cat(3,sin(t).*cos(p).^2, sin(t).*sin(p).^2),[1,1,1,3]),...
   repmat(cat(3,sin(t).*sin(p).^2, sin(t).*cos(p).^2),[1,1,1,3])};
%r={permute(r{1},[1,2,4,3]),permute(r{2},[1,2,4,3])};
r{2}=r{1};

C0dB=nan;

figure(1);
rScale=[0.5,nan];
[hs,hc,ha,hco,c,hsurf]=PlotPolar3(t,p,r,rScale);
%axis equal

figure(2);
rScale=[-30,nan,1];
cScale=[-30,5,C0dB];
rContour=[0:-3:-18];
[hs,hc,ha,hco,c,hsurf]=PlotPolar3(t,p,r,rScale,cScale,rContour);
%axis equal

figure(3);
rScale=[-30,nan,1];
cScale=[-30,5,C0dB];
rContour=[0:-3:-18];
tmax=pi/2;
ContourAnno=1;
[hs,hc,ha,hco,c,hsurf]=PlotPolar3(t,p,r,rScale,cScale,rContour,...
  tmax,ContourAnno);
%axis equal

figure(4);
rScale=[-30,1];
n=1:round(size(p,2)/10):round(size(p,2)/2);
if iscell(r),
  rr=r{1};
else
  rr=r;
end
[hp,hr,ha]=PlotPolar2(p(:,n),rr(:,n),rScale);





