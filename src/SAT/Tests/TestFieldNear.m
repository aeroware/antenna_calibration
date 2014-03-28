
% TestFieldNear.m

CurrExists=0;
if exist('Op','var'),
  if isfield(Op,'Curr'),
    if ~isempty(Op.Curr),
      CurrExists=1;
    end
  end
end

if ~CurrExists,
  
  % symmetrical dipole along z-axis, feed at origin:
  z=(-1.5:0.5:1.5)';
  z0=zeros(size(z));
  Ant.Geom=[z0,z0,z];
  Ant.Desc=[1:length(z)-1;2:length(z)]';
  Ant.Wire=[1e-3,inf];
  Op.Feed=[(length(z)+1)/2,1];
  Op.Freq=50e6;
  
  % load TestAntOp; % loads variables Ant and Op from file
  % Op.Feed=[195,1];
  
  AIF='asapinx.dat';
  AOF='asapoutx.dat';
  
  Op=AntCurrent(Ant,Op,1,AIF,AOF,'***** TestFieldNear *****');
  
end

n=50;
y=5*(-n/2:n/2)./(n/2)+0e-4;
z=5*(-n/2:n/2)./(n/2)+0e-14;
%n=find(y==0&z==0);
%y(n)=1e-4;
ny=length(y);
nz=length(z);

y=repmat(y,[nz,1]);
z=repmat(z',[1,ny]);

r=[zeros([ny*nz,1]),y(:),z(:)];

[E1,H1]=OldFieldNear(Ant,Op,r,1);
[E2,H2]=OldFieldNear(Ant,Op,r,-1);

% plot real part of E (initial state, t=0):

t=4*pi/4;
E=real(E1.*exp(j*t));
Em=repmat(Mag(E,2),[1,3]); 
Eshow=E./Em.*Em.^0.1;
v=reshape(Eshow(:,2),[nz,ny]);
w=reshape(Eshow(:,3),[nz,ny]);
quiver(y,z,v,w,1);
% plot colors and mechanical dipole:
hold on;
cm=size(colormap,1);
q=sqrt(v.^2+w.^2);
qm=max(max(q));
pcolor(y,z,q/qm*cm); shading('interp');
d=[-1.5,-0.05;0.05,1.5]'; 
plot(zeros(length(d)/2,2),d,'k','LineWidth',2);
hold off;

return

% play movie:

n=50;
cm=size(colormap,1);
n0=find(z==0&y==0);
for m=1:n,
  t=2*pi*m/n;
  E=real(E1.*exp(j*t));
  Em=repmat(Mag(E,2),[1,3]); 
  if m==1,
    Emm=(max(Em(:,1)))^0.9;
  end
  Eshow=E./Em.*Em.^0.1*Emm;
  v=reshape(Eshow(:,2),[nz,ny]); 
  w=reshape(Eshow(:,3),[nz,ny]);
  quiver(y,z,v,w,1);
  % plot colors and mechanical dipole:
  hold on;
  q=sqrt(v.^2+w.^2);
  if m==1,
    qm=20*max(max(q));
  end
  v(n0)=qm/1.4;
  w(n0)=qm/1.4;
  pcolor(y,z,q); shading('interp');
  d=[-1.5,-0.05;0.05,1.5]'; 
  plot(zeros(length(d)/2,2),d,'k','LineWidth',2);
  hold off;
  M(m)=getframe;
end
movie(M,3,5)

