
function I=IntegrateVV(Grid,Op,YL,m,n,S,QUV)

% I=IntegrateVV(Grid,Op,m,n,S) calculates total voltage coherences, 
%
%   Int <V_m V_n*> dOmega
%
% with
%
%   <V_m V_n*> = T_mr <E_r E_s*> T_ns* = T_mr er.fg <Eg Eh*> fh.es Tns* 
%              = T_mr er.fg cgh fh.es T_ns*
%
%   sum r,s=1..3; g,h=1..2
%   cgh = <Eg Eh*> coherency matrix of the incident E-fields per unit solid angle;
%   e1, e2 and e3 are the orthonormal basis,
%   and f1 and f2 are orthogonal unit vectors in the wave plane
%   with f1 x f2 = direction of propagation
%
% For natural light (Q=U=V=0):
%
%   c = [1,0;0,1] * S/2,
%
%   <V_m V_n*> = T_mr er.(f1|f1+f2|f2).es T_ns* S/2 = T (f1|f1+f2|f2) T*  S/2  
%   (T* beeing the adjoint to T)
%
%   S = <|E|^2> incident wave intensity per unit solid angle,
%
% This is the only form implemented so far, further assuming S=const, 
% default: S=1/(4pi), i.e. Int <|E|^2> dOmega = 1 (V/m)^2 total isotropically 
% incident 'power',
%   <V_m V_n*> = T (f1|f1+f2|f2) T* /(8pi)


global Global_VVI;

if (nargin<6)|isempty(S),
  S=1/4/pi;                 % 1 Watt total incident power by default 
end

Global_VVI.Grid=Grid;
Global_VVI.Op=Op;

RelTol=1e-3;      % relative accuracy of integral

QuadFun='quad';  % quadrature function: quadl or quad


% estimate power to determine absolute tolerance:

pt=[0,0; 0,pi/2; pi/4,pi/4; pi/2,pi/2];

II=max(abs(VVIntegrand(pt(:,1),pt(:,2),YL,m,n,S)))*pi;

% double integration until requested accuracy reached:

POld=inf;
while abs(POld)>10*abs(II),
  POld=II;
  II=dblquad(@VVIntegrand,0,2*pi,0,pi,abs(RelTol*II),QuadFun,YL,m,n,S);
  %fprintf('IIOld,II=%f, %f\n',POld,II);
end  
%fprintf('\n');

I=II;

clear global Global_VVI.Grid Global_VVI.Op


function VVs=VVIntegrand(p,t,YL,m,n,S)

% Integrand for calculation of total voltage coherences, 
%
% VVs = <V_m V_n*> sin(t)
%
% uses f1=-etheta, f2=ephi !

global Global_VVI;

si=max(size(t),size(p));
q=max(length(t(:)),length(p(:)));

st=sin(t(:));
ct=cos(t(:));
sp=sin(p(:));
cp=cos(p(:));

er=zeros(q,3);
er(:,1:2)=[st.*cp,st.*sp];
er(:,3)=ct;

T=AntTransfer(Global_VVI.Grid,Global_VVI.Op,er,[],YL);

% f1=-etheta
f1=zeros(q,3);
f1(:,1:2)=-[ct.*cp,ct.*sp];
f1(:,3)=st;

% f2=ephi
f2=zeros(q,3);
f2(:,1:2)=[-sp,cp];

if m*n==0,
  T(4,:,:)=T(1,:,:)-T(2,:,:);
  if m==0,
    m=4;
  end
  if n==0,
    n=4;
  end
end

% {T.f1}_m {f1.T*}_n:
T1=sum(permute(T(m,:,:),[3,2,1]).*f1,2).*...
   conj(sum(permute(T(n,:,:),[3,2,1]).*f1,2));

% {T.f2}_m {f2.T*}_n:
T2=sum(permute(T(m,:,:),[3,2,1]).*f2,2).*...
   conj(sum(permute(T(n,:,:),[3,2,1]).*f2,2));

VVs=reshape((T1+T2).*st*(S/2),si);
  
