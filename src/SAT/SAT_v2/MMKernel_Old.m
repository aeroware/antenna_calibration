
function [tEs,n,AbsTol]=MMKernel(r1,r2,t1,t2,ke,Tol)

% x=[0:1/4:1];
% w=ones(size(x))/(length(x)-1);
% w(1)=w(1)/2;
% w(end)=w(end)/2;

% n=3;
% x=[(1:n)-1/2]/n;
% w=ones(1,n)/n;
% 
% est=sum(w.*MMIntegrand(x,r1,r2,t1,t2,ke));
% 
% AbsTol=Tol*abs(est);
%
% [tEs,n]=quadrl(@MMIntegrand,0,1,AbsTol,[],r1,r2,t1,t2,ke);

n=10;
a=[0:n-1]/n;
b=[1:n]/n;
[tEs,n]=quadml(@MMIntegrand,a,b,[0,Tol],[],r1,r2,t1,t2,ke);
AbsTol=0;

%tEs=tEs/(4*pi*j*w*eps);


function Ep=MMIntegrand(x,r1,r2,t1,t2,ke)

% Ep=MMIntegrand(x,r1,r2,t1,t2,ke) calculates integrand 
%   t(x) E(x).(t2-t1)
% for the determination of the matrix kernel element 
%   <t|Es> = int t(s) E(s).e ds (e .. unit vector in segment direction)
% with test function t, electric field operator E and source function s.
% x fractional length (0 through 1) along the test segment (from t1 to t2),
% source current from r1 to r2, ke wave constant of external medium.
% The currents along the source and test segments are assumed to be
% sinusoidal ~sin(ke*x), with zero at the beginning and 1 at the end 
% of the segments.

dt=t2(:)-t1(:);

kL=ke*sqrt(sum(dt.^2));

tx=repmat(t1(:).',length(x(:)),1)+x(:)*dt.';

%Ep=FieldNear2(r1,r2,0,1,tx,ke,0,-2)*dt;
Ep=FieldNear1(r1,r2,tx,ke,0)*dt;

Ep=reshape(Ep,size(x)).*sin(kL.*x)./sin(kL);
