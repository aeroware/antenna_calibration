
function [tEs,n]=MMKernel(r1,r2,t1,t2,ke,Tol)

n=10;
a=[0:n-1]/n;
b=[1:n]/n;

if Mag(cross(r2-r1,t2-t1))>Mag(r2-r1)*Mag(t2-t1)*1e-14,
%if 1==1, 

  [tEs,n]=quadml(@MMIntegrand,a,b,[0,Tol],[],r1,r2,t1,t2,ke);
  
else
  
  e=r2-r1;
  L=Mag(e);
  e=e(:)/L;
  
  z1=(t1-r1)*e;
  z2=(t2-r1)*e;
  
  rho=(sqrt(sum((t1-r1).^2)-z1.^2)+sqrt(sum((t2-r1).^2)-z2.^2))/2;
  
  [tEs,n]=quadml(@MMIntegrandPar,a,b,[0,Tol],[],L,rho,z1,z2,ke);
  
end


function Ep=MMIntegrand(x,r1,r2,t1,t2,ke)

% Ep=MMIntegrand(x,r1,r2,t1,t2,ke) calculates integrand 
%   t(x) E(x).(t2-t1)
% for the determination of the matrix kernel element 
%   <t|Es> = int t(s) E(s).e ds (e .. unit vector in segment direction)
% with test function t, electric field operator E and source function s.
% x fractional length (0 through 1) along the test segment (from t1 to t2),
% source current from r1 to r2, ke wave constant of external medium.
% The currents along the source and test segments are assumed to be
% sinusoidal ~ sin(ke*x), with zero at the beginning and 1 at the end 
% of the segments.

dt=t2(:)-t1(:);

kL=ke*sqrt(sum(dt.^2));

tx=repmat(t1(:).',length(x(:)),1)+x(:)*dt.';

%Ep=FieldNear2(r1,r2,0,1,tx,ke,0,-2)*dt;
Ep=FieldNear1(r1,r2,tx,ke)*dt;

Ep=reshape(Ep,size(x)).*sin(kL.*x)./sin(kL);


function Ep=MMIntegrandPar(x,L,rho,z1,z2,ke)

% Ep=MMIntegrandPar(x,L,z1,z2,ke) calculates the same integrand 
% as MMIntegrand, but specialized for parallel segments,
% assuming segment 1 from 0 to L along z-axis, segment 2 from
% z1 to z2 at a distance rho from the z-axis.

dz=z2-z1;

kL=ke*abs(dz);

Ep=FieldNear0(L,rho,z1+dz*x,ke);

Ep=dz.*Ep.*sin(kL.*x)./sin(kL);

