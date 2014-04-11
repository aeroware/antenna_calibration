
function [CurrSys,DescDip,CurrDip,Z,K,V]=MMSolver(Ant,Op,K)

Tol=1e-12;

if (nargin<3)|isempty(K),
  Kgiven=0;
else
  Kgiven=1;
end

Term=CheckTerminal(Ant.Desc,Op.Feed(:,1));  % feed terminals
if any(Term==0),
  error('Invalid terminal definitions in the operation Feed-field.');
end
nt=length(Term);

ns=size(Ant.Desc,1);     % number of segments

e=Ant.Geom(Ant.Desc(:,2),:)-Ant.Geom(Ant.Desc(:,1),:);

L=Mag(e,2);          % lengths of segments

e=e./repmat(L,1,3);  % unit vectors in segment directions

% physical constants: 

w=2*pi*Op.Freq;
[ke,eps,mu]=Kepsmu(Op);   % wave constant, permittivity and permeability 
                          % of exterior medium
Wire=CheckWire(Ant);      % wire properties [radius,conductivity]

Zs=zeros(ns,1);               % wire surface impedance Zs=E/I of segments
nq=find(~isinf(Wire(:,2)));
q=sqrt(-j*w*mu*Wire(nq,2));   % wave constant in the conductor
Zs(nq)=q./(2*pi*Wire(nq,1).*Wire(nq,2)).*...     
       besselj(0,q.*Wire(nq,1))./besselj(1,q.*Wire(nq,1));

% create description of dipoles:

DescDip=MMDipoles(Ant.Desc);

nd=size(DescDip,1);

% calculate matrix kernel K-ZsI:

if ~Kgiven,
  
K=zeros(nd,nd);

for d=1:nd,
  
  % segments (s1,s2) and node points (r1,r2,r3) of dipole d:
  
  s1=DescDip(d,1);
  r1=Ant.Geom(Ant.Desc(abs(s1),1+(s1<0)),:);
  r2=Ant.Geom(Ant.Desc(abs(s1),1+(s1>0)),:);
  s2=DescDip(d,2);
  r3=Ant.Geom(Ant.Desc(abs(s2),1+(s2>0)),:);
  if ~isequal(r2,Ant.Geom(Ant.Desc(abs(s2),1+(s2<0)),:)),
    error(['Invalid dipole description for dipole ',num2str(d)]);
  end
  L1=L(abs(s1));
  L2=L(abs(s2));
  
  % vectors a1 and a2 from wire center to correspoding nearest surface points:
  
  a1=cross(repmat(e(abs(s1),:),[ns,1]),e,2);
  m=find(Mag(a1,2)==0);
  [q,nq]=min(abs(e(m,:)),[],2);
  a1(sub2ind(size(a1),m(:),nq(:)))=1;
  a1=a1-e.*repmat(sum(a1.*e,2),1,3);
  a1=a1.*repmat(Wire(:,1)./Mag(a1,2),1,3);
  
  a2=cross(repmat(e(abs(s2),:),[ns,1]),e,2);
  m=find(Mag(a2,2)==0);
  [q,nq]=min(abs(e(m,:)),[],2);
  a2(sub2ind(size(a2),m(:),nq(:)))=1;
  a2=a2-e.*repmat(sum(a2.*e,2),1,3);
  a2=a2.*repmat(Wire(:,1)./Mag(a2,2),1,3);
  
  % matrix kernel, column d:
  
  n=[];
  
  for d_=1:nd,
    
    s1_=DescDip(d_,1);
    r1_=Ant.Geom(Ant.Desc(abs(s1_),1+(s1_<0)),:);
    r2_=Ant.Geom(Ant.Desc(abs(s1_),1+(s1_>0)),:);
    s2_=DescDip(d_,2);
    r3_=Ant.Geom(Ant.Desc(abs(s2_),1+(s2_>0)),:);
    
    q=any(ismember([r1;r2],[r1_;r2_],'rows'));
    an=a1(abs(s1_),:)*q;
    [q11,nn]=MMKernel(r1,r2,r1_+an,r2_+an,ke,Tol);
    n(end+1)=nn;
    
    q=any(ismember([r1;r2],[r3_;r2_],'rows'));
    an=a1(abs(s2_),:)*q;
    [q12,nn]=MMKernel(r1,r2,r3_+an,r2_+an,ke,Tol);
    n(end+1)=nn;
    
    q=any(ismember([r3;r2],[r1_;r2_],'rows'));
    an=a2(abs(s1_),:)*q;
    [q21,nn]=MMKernel(r3,r2,r1_+an,r2_+an,ke,Tol);
    n(end+1)=nn;
    
    q=any(ismember([r3;r2],[r3_;r2_],'rows'));
    an=a2(abs(s2_),:)*q;
    [q22,nn]=MMKernel(r3,r2,r3_+an,r2_+an,ke,Tol);
    n(end+1)=nn;
    
    K(d_,d)=(q11-q12-q21+q22)/(4*pi*j*w*eps);
    
  end
  
%   n(:)'
%   sum(n)
  
end  
  
end % of K-calculation (~Kgiven)

Z=K;

% calculate voltages:

V=zeros(nd,nt);

for d=1:nd,
  
  s1=DescDip(d,1);
  s2=DescDip(d,2);

  L1=L(abs(s1));
  L2=L(abs(s2));

  % subtract drop voltages ZsI from K:
  
  ZsI=zeros(nd,1);
  
  % segment s1:
  q=L1;
  u=-q/2/sin(ke*q)^2*sinq1(2*ke*q)*Zs(abs(s1)); % int sin(ks)^2 ds / sin(kL)^2 * Zs
  v= q/2/sin(ke*q)^2*sinqc(ke*q)*Zs(abs(s1)); % int sin(ks)*sin(k(L-s)) ds / sin(kL)^2 * Zs
  m=find(DescDip(:,1)==s1);
  ZsI(m)=ZsI(m)+u;
  m=find(DescDip(:,1)==-s1);
  ZsI(m)=ZsI(m)-v;
  m=find(DescDip(:,2)==s1);
  ZsI(m)=ZsI(m)+v;
  m=find(DescDip(:,2)==-s1);
  ZsI(m)=ZsI(m)-u;
  
  % segment s2:
  q=L2;
  u=-q/2/sin(ke*q)^2*sinq1(2*ke*q)*Zs(abs(s2)); % int sin(ks)^2 ds / sin(kL)^2 * Zs
  v= q/2/sin(ke*q)^2*sinqc(ke*q)*Zs(abs(s2)); % int sin(ks)*sin(k(L-s)) ds / sin(kL)^2 * Zs
  m=find(DescDip(:,1)==s2);
  ZsI(m)=ZsI(m)+v;
  m=find(DescDip(:,1)==-s2);
  ZsI(m)=ZsI(m)-u;
  m=find(DescDip(:,2)==s2);
  ZsI(m)=ZsI(m)+u;
  m=find(DescDip(:,2)==-s2);
  ZsI(m)=ZsI(m)-v;
  
  Z(:,d)=ZsI-K(:,d);

  % voltage vectors from driving voltages:
  
  V(d,:)=-(imag(Term)'==-s1)+(imag(Term)'==s2);
  
end

% solve equation system for dipole currents:

CurrDip=Z\V;

% convert dipole currents into segment currents:

CurrSys=zeros(nt,ns,2);
for m=1:nt,
  CurrSys(m,:,:)=shiftdim(MMConvCurr(DescDip,CurrDip(:,m)),-1);
end

