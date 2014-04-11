
function [E,H]=FieldNear(Ant,Op,r,Method)

% [E,H]=FieldNear(Ant,Op,r) calculates the near field excited
% by the antenna currents at the positions r. The radius vectors 
% of the observation points are the rows of r. Similarly, E and H 
% contain the resp. field vectors as rows.

if nargin<4,
  Method=1;
end

w=2*pi*Op.Freq;
jw=j*w;

Exte=[0,1];
if isfield(Op,'Exte'),
  Exte=Op.Exte;
end
[k,eps,mu]=Kepsmu(w,Exte(2),Exte(1));
jk=j*k;

nr=size(r,1);
H=zeros(nr,3);
E=zeros(nr,3);

for s=1:size(Ant.Desc,1),
  
  r1=Ant.Geom(Ant.Desc(s,1),:);
  r2=Ant.Geom(Ant.Desc(s,2),:);
  R1v=r-repmat(r1,[nr,1]);  % r-r1
  R1=Mag(R1v,2);            % R1=|r-r1|
  R2v=r-repmat(r2,[nr,1]);  % r-r2
  R2=Mag(R2v,2);            % R2=|r-r2|
  L=Mag(r2-r1,2);           % Length of segment.
  ez=(r2-r1)/L;             % Unit vector in segment direction.
  ephi=R1v;                 % For the calculation of ephi, erho and 
  n=find(R2<R1);            % rho prefer R1v or R2v whichever is 
  ephi(n,:)=R2v(n,:);       % smaller to get better numerical accuracy. 
  ephi=cross(repmat(ez,[nr,1]),ephi,2);
  rho=Mag(ephi,2);          % distance normal to segment line
  m=find(rho==0);
  rho(m)=1;
  ephi=ephi./repmat(rho,[1,3]);
  ephi(m,:)=0;
  rho(m)=0;
  erho=cross(ephi,repmat(ez,[nr,1]),2);
  
  L1=R1v*ez.';              % z-z1 = ez.(r-r1)
  L2=R2v*ez.';              % z-z2 = ez.(r-r1)
  
  kL=k*L;
  skL=sin(kL);
  ckL=cos(kL);

  I1=Op.Curr(s,1);  % I(z1)
  I2=Op.Curr(s,2);  % I(z2)
  
  R1(find(~R1))=1;
  R2(find(~R2))=1;
  
  G1=exp(-jk*R1)./R1;
  G2=exp(-jk*R2)./R2;
  
  if abs(Method)==2, % Use only I(z1) and I(z2)
  
    G12=G1./G2;
    
    Hphi=(I2.*G2.*(R2.*ckL-j*skL.*L2-R1.*G12)+...
          I1.*G1.*(R1.*ckL+j*skL.*L1-R2./G12))*(k/skL);
        
    Erho=(I2.*G2.*(L2.*ckL-j*skL./R2.*L2.^2+...
                   (rho./R2).^2.*(skL/k)-L1.*G12)+...
          I1.*G1.*(L1.*ckL+j*skL./R1.*L1.^2-...
                   (rho./R1).^2.*(skL/k)-L2./G12))*(k/skL);
    
    Ez=I2.*G2.*( (jk+1./R2).*L2./R2+(k/skL).*(G12-ckL))+...
       I1.*G1.*(-(jk+1./R1).*L1./R1+(k/skL).*(1./G12-ckL));
     
  else  % Use I(z1), I(z2) and derivatives I'(z1), I'(z2) 
    
    dI1=k/skL*(I2-I1+2*I1*sin(kL/2)^2);  % I'(z1)
    dI2=k/skL*(I2-I1-2*I2*sin(kL/2)^2);  % I'(z2)
    
    Hphi=(G2.*(R2.*dI2-jk.*L2.*I2)-...
      G1.*(R1.*dI1-jk.*L1.*I1));
    
    Ez=((L2.*I2./R2.*(jk+1./R2)-dI2).*G2-...
      (L1.*I1./R1.*(jk+1./R1)-dI1).*G1);

    Erho=((L2.*dI2+(rho./R2).^2.*I2-jk.*L2.^2./R2.*I2).*G2-...  
      (L1.*dI1+(rho./R1).^2.*I1-jk.*L1.^2./R1.*I1).*G1);
    
  end
  
  if Method>=0, 
    
    % Again calculate Hphi and Erho for small rho and z<z1|z>z2 
    % to improve numerical accuracy.
    
    n=find(((L1<0 & rho<min(-L1,-0.1*L2))|...
            (L2>0 & rho<min( L2, 0.1*L1))) & (rho~=0));
    
    R1n=R1(n);
    R2n=R2(n);
    L1n=L1(n);
    L2n=L2(n);
    rhon=rho(n);
    
    t1=(rhon./L1n).^2;
    t1=t1./(1+sqrt(1+t1));
    t2=(rhon./L2n).^2;
    t2=t2./(1+sqrt(1+t2));
    et=exp(jk/2*(abs(L2n).*t2-abs(L1n).*t1));  % exp(jkt/2)
    st=imag(et);                               % sin(kt/2)

    Hphi(n)=...
      (I2.*G2(n).*(-2*ckL.*R2n.*et.*st+skL.*L2n.*et.*(t2.*et+2*j.*st))+...
       I1.*G1(n).*( 2*ckL.*R1n./et.*st-skL.*L1n./et.*(t1./et-2*j.*st)))...
       *(jk/skL);
        
    tt=t1+1; 
    Q1=L2n./tt.*et.*(-2*j.*st+t1./et-t2.*et);
    Q2=rhon.^2./R2n.*(1+1./(jk*R2n))-R2n.*t1./tt+2*j*R2n.*et.*st./tt;
    
    tt=t2+1;
    Q3=L1n./tt./et.*( 2*j.*st+t2.*et-t1./et);
    Q4=rhon.^2./R1n.*(1+1./(jk*R1n))-R1n.*t2./tt-2*j*R1n./et.*st./tt;
    
    Erho(n)=(I2.*G2(n).*(ckL.*Q1+j*skL.*Q2)+...
             I1.*G1(n).*(ckL.*Q3-j*skL.*Q4))*(k/skL);      
          
  end
  
  rho(m)=1;
  Hphi=Hphi./rho;
  Erho=Erho./rho;
  
  H=H+ephi.*repmat(Hphi,[1,3]);
  E=E+erho.*repmat(Erho,[1,3])+Ez*ez;
  
end

H=H./(4*pi*jk);
E=E./(4*pi*jw*eps);


