
function [CurrSys,DescDip,CurrDip,K,V,W,Ep,r,c]=MMSolverx(Ant,Op,Quad,Testf)

% Quad degree of polynomial, 1=trapezoid, 2=simpson,...

% W,n: weights W and r-indices n for the integration of the matrix kernel. 
% W are the weights for the integration (summation) along the segments, 
% depending on the kind of integration and on the test functions.
% So the matrix elements are found by the numerical integration
%   sum(W.*Ep(n),2),
% where Ep are the fields parallel to the respective segments at r
% (r contains as rows all integration points of all segments,
%  first the Inte points of segment 1, ordered from node 1 to node 2 
%  of the segment, then the Inte points of segment 2, and so on;
%  n is the index into r, each row representing the points along a 
%  dipole starting from the dipole end of segment 1 over the middle 
%  dipole node towards the dipole end of segment 2),
%   size(r)=[ns*Inte,3],  ns..number of segments,
%   size(W)=[nd,2*Inte],  Inte..number of integration steps,
%   size(n)=[nd,2*Inte],  nd..number of dipoles.
% 
% Quad determines the kind of quadrature:
%   1..trapezoidal, 
%   2..simpson.
%
% Testf is the testfunction along the segment:
%   0..halfconstant (1 on the inner half, 0 on the outer half of the dipole,
%                    only possible for even Inte !!),
%   1..constant (1 on the whole dipole),
%   2..sine (using wavelength of exterior medium, 
%            zero at the dipole ends and 1 in the middle node).
%
% k is the wave index for the exterior medium, L is a vector containing
% the lengths of the segments.


if (nargin<3)|isempty(Quad),
  Quad=1;
end
Quad=max(Quad,0);

if (nargin<4)|isempty(Testf),
  Testf=2;
end

Inte=abs(Op.Inte);            % integration steps
if isempty(Inte)|(Inte<1),
  Inte=4;
end
Inte=max(Inte,1);

Term=CheckTerminal(Ant.Desc,Op.Feed(:,1));  % feed terminals
if any(Term==0),
  error('Invalid terminal definitions in the operation Feed-field.');
end
nt=length(Term);

ns=size(Ant.Desc,1);     % number of segments

Inte=max(Inte,ceil(Inte/(Quad+1))*(Quad+1));
%Inte=max(Inte,ceil((Inte-1)/Quad)*Quad+1);
if Inte>Op.Inte,
  disp(['Integration points changed from ',...
      num2str(Op.Inte),' to ',num2str(Inte),...
      ' to hold the required quadrature order ',num2str(Quad),'.']);
end

x=((1:Inte)-1/2)/Inte;    % fractional distribution x of points along segment
%x=(0:Inte-1)/(Inte-1); 

c=NewtonCotes(([1:Quad+1]-1/2)./(Quad+1));  % Newton-Cotes quadrature coefficients
c=repmat(c,[1,Inte./(Quad+1)])*(Quad+1)/Inte;
% cc=NewtonCotes([0:Quad]./Quad)*Quad/(Inte-1);
% c=zeros(Inte,1);
% for m=1:Quad:Inte-Quad,
%   c(m:m+Quad)=c(m:m+Quad)+cc(:);
% end

e=Ant.Geom(Ant.Desc(:,2),:)-Ant.Geom(Ant.Desc(:,1),:);

ii=reshape(repmat(1:ns,[Inte,1]),[ns*Inte,1]);

r=Ant.Geom(Ant.Desc(ii,1),:)+...   % points on the segments for num. quadrature
  reshape(x(:)*e(:)',[Inte*ns,3]);

L=Mag(e,2);          % lengths of segments

e=e./repmat(L,1,3);  % unit vectors in segment directions

% physical constants: 

w=2*pi*Op.Freq;
[ke,eps,mu]=Kepsmu(Op);   % wave constant, permittivity and permeability 
                          % of exterior medium
Wire=CheckWire(Ant);      % wire properties [radius,conductivity]

Zs=zeros(ns,1);               % surface impedance Zs of segments
nq=find(~isinf(Wire(:,2)));
q=sqrt(-j*w*mu*Wire(nq,2));   % wave constant in the conductor
Zs(nq)=q./(2*pi*Wire(nq,1).*Wire(nq,2)).*...     
       besselj(0,q.*Wire(nq,1))./besselj(1,q.*Wire(nq,1));

% create description of dipoles:

DescDip=MMDipoles(Ant.Desc);

nd=size(DescDip,1);

% integration weights W and indices nr into r:

nr=zeros(nd,2*Inte);
W=zeros(nd,2*Inte);
I1=1:Inte;
I2=Inte+1:2*Inte;

for d=1:nd,
  
  s1=DescDip(d,1);
  s2=DescDip(d,2);
  L1=L(abs(s1));
  L2=L(abs(s2));

  % test functions:
  
  switch Testf,  
  case 0,
    W(d,Inte/2+1:3*Inte/2+1)=1;
  case 1,
    W(d,:)=1;
  case 2,
    W(d,I1)=sin(ke*L1*x)/sin(ke*L1);
    W(d,I2)=sin(ke*L2*fliplr(x))/sin(ke*L2);    
  end
  
  % Quadrature coefficients:
  
  c=c(:).';
  W(d,I1)=W(d,I1).*c*L1;
  W(d,I2)=W(d,I2).*c*L2;
  
  % indices into r and corrections for segments of opposite orientation:
  
  nr(d,I1)=(abs(s1)-1)*Inte+(1:Inte);
  if s1<0,
    W(d,I1)=-W(d,I1);
    nr(d,I1)=fliplr(nr(d,I1));
  end
  
  nr(d,I2)=(abs(s2)-1)*Inte+(1:Inte);
  if s2<0,
    W(d,I2)=-W(d,I2);
    nr(d,I2)=fliplr(nr(d,I2));
  end
  
end

% calculate matrix kernel K and voltage vectors V:

K=zeros(nd,nd);
V=zeros(nd,nt);

for d=1:nd
  
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
  
  % E and Zs*I at r-positions in the respective segment directions e:
  
  Ep=sum((FieldNear2(r1,r2,0,1,r+a1(ii,:),ke,Wire(abs(s1),1),-1)+...
          FieldNear2(r1,r2,0,1,r-a1(ii,:),ke,Wire(abs(s1),1),-1)+...
          FieldNear2(r2,r3,1,0,r+a2(ii,:),ke,Wire(abs(s2),1),-1)+...
          FieldNear2(r2,r3,1,0,r-a2(ii,:),ke,Wire(abs(s2),1),-1)).*e(ii,:),2)./...
          (2*4*pi*j*w*eps);
      
  ZsI=zeros(Inte,ns);
  ZsI(:,abs(s1))=Zs(abs(s1))*sin(ke*L1*x(:))/sin(ke*L1);
  if s1<0,
    ZsI(:,abs(s1))=-flipud(ZsI(:,abs(s1)));
  end
  ZsI(:,abs(s2))=-Zs(abs(s2))*sin(ke*L2*x(:))/sin(ke*L2); 
  if s2>0,
    ZsI(:,abs(s2))=-flipud(ZsI(:,abs(s2)));
  end
  ZsI=ZsI(:);
  
  % matrix kernel, column d:
  
  K(:,d)=sum(W.*reshape(Ep(nr)-ZsI(nr),size(nr)),2);

  % calculate d-th row of voltage vectors:

  V(d,:)=-(imag(Term)'==-s1)+(imag(Term)'==s2);
  
end  
  
% solve equation system for dipole currents:

CurrDip=-K\V;

% convert dipole currents into segment currents:

CurrSys=zeros(nt,ns,2);
for m=1:nt,
  CurrSys(m,:,:)=shiftdim(MMConvCurr(DescDip,CurrDip(:,m)),-1);
end


