
% TestFieldFar.m

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
%   z=(-1.5:0.5:1.5)';
%   z0=zeros(size(z));
%   Ant.Geom=[z0,z0,z];
%   Ant.Desc=[1:length(z)-1;2:length(z)]';
%   Ant.Wire=[1e-3,inf];
%   Op.Feed=[(length(z)+1)/2,1];
%   Op.Freq=50e6;   

% loads variables Ant and Op from file:
    load TestAntOp; 
    Op.Feed=[195,1];
  
  AIF='asapinx.dat';
  AOF='asapoutx.dat';
  
  Op=AntCurrent(Ant,Op,1,AIF,AOF,'***** TestFieldFar *****');
  
  w=2*pi*Op.Freq;
  Exte=[0,1];
  if isfield(Op,'Exte'),
    if ~isempty(Exte),
      Exte=Op.Exte;
    end
  end
  [k,eps,mu]=Kepsmu(w,Exte(2),Exte(1));
  
end

n=50;
%y=50*(-n/2:n/2)./(n/2)+0e-4;
%z=50*(-n/2:n/2)./(n/2)+0e-14;
y=1e0*(-5:0.2:5);
z=1e0*(-5:0.2:5);
ny=length(y);
nz=length(z);

y=repmat(y,[nz,1]);
z=repmat(z',[1,ny]);

r=[zeros([ny*nz,1]),y(:),z(:)];
rr=repmat(Mag(r,2),[1,3]);

[A1,E1,H1]=FieldFar(Ant,Op,r);
%A1=exp(-j*k*rr)./rr.*A1;
H1=exp(-j*k*rr)./rr.*H1;
E1=exp(-j*k*rr)./rr.*E1;

[E2,H2]=FieldNear(Ant,Op,r);

dH=reshape(Mag(H1-H2,2),[nz,ny]);
dHr=reshape(Mag(H1-H2,2)./Mag(H2,2),[nz,ny]);

dE=reshape(Mag(E1-E2,2),[nz,ny]);
dEr=reshape(Mag(E1-E2,2)./Mag(E2,2),[nz,ny]);

figure(1);
surf(z,y,log10(dEr));
figure(2);
surf(z,y,log10(dHr))

%A3=mu/4/pi*Heffect(Ant.Geom,Ant.Desc,Op.Curr,k*r./repmat(Mag(r,2),[1,3]));

return

% plot real part of E (initial state, t=0):

figure(1);
t=0*pi/4;
E=real(E2.*exp(j*t));
Em=repmat(Mag(E,2),[1,3]); 
Eshow=E./Em.*Em.^0.1;
v=reshape(Eshow(:,2),[nz,ny]);
w=reshape(Eshow(:,3),[nz,ny]);
quiver(y,z,v,w,1);

figure(2);
t=2*pi/4;
E=real(E2.*exp(j*t));
Em=repmat(Mag(E,2),[1,3]).^1; 
Eshow=E./Em;
v=reshape(Eshow(:,2),[nz,ny]);
w=reshape(Eshow(:,3),[nz,ny]);
quiver(y,z,v,w,1,'.');

figure(3);
surf(y,z,dEr);
%shading interp

