
function AA=Asap_FarA(Grid,Op,er)

% AA=Asap_FarA(Grid,Op,er) calculates vector potential in the far zone
% generated by the currents excited on the given antenna system.
% Actually, AA is the vector potential A apart from the factor
% exp(-jkr)/r:
%
%   AA = mu/(4*pi) Int I(r') exp(j*k*er.r') ds'

CountSegs=[];

if ~isequal(size(Op),[1,1]),
  error('Non-scalar Op structs not allowed.');
end

[k,epsilon,mu]=Kepsmu(Op.Freq,Grid);

er=er./repmat(Mag(er,2),[1,3]);  % ensure unit vectors

nr=size(er,1);
AA=zeros(nr,3);

ns=size(Grid.Desc,1);

if ~exist('CountSegs','var')||isempty(CountSegs),
  if nr>ns/2,
    CountSegs=1;
  else
    CountSegs=0;
  end
end

if CountSegs,
  
  for s=1:ns,

    r1=Grid.Geom(Grid.Desc(s,1),:);
    r2=Grid.Geom(Grid.Desc(s,2),:);
    L=Mag(r2-r1,2);           % Length of segment.
    ez=(r2-r1)./L;            % Unit vector in segment direction.
    x=er*ez.';
    y=Mag(cross(er,repmat(ez,[nr,1]),2),2);
    theta=atan2(y,x);         % angle between segment and er
    kL=k*L;
    x=kL.*sin(theta/2).^2;
    y=kL.*cos(theta/2).^2;

    I1=Op.Curr1(s,1);   % I(z1)
    I2=Op.Curr1(s,2);   % I(z2)

    n=find(x.*y);
    theta=zeros(size(x));
    theta(n)=(sin(x(n)).*y(n)-sin(y(n)).*x(n))./x(n)./y(n);
    n=find(x.*y==0);
    theta(n)=sinq(x(n))-sinq(y(n));

    theta=((I2+I1).*sin(kL/2).*(sinq(x)+sinq(y))+...
      j*(I2-I1).*cos(kL/2).*theta).*...
      L./sin(kL).*exp(er*(r1+r2).'*(k/2*j));

    AA=AA+theta*ez;
    
  end 
  
else  % ~CountSegs
  
  for d=1:nr,

    r1=Grid.Geom(Grid.Desc(:,1),:);
    r2=Grid.Geom(Grid.Desc(:,2),:);
    L=Mag(r2-r1,2);                 % Length of segment.
    ez=(r2-r1)./repmat(L,1,3);      % Unit vector in segment direction.
    x=ez*er(d,:).';
    y=Mag(cross(repmat(er(d,:),[ns,1]),ez,2),2);
    theta=atan2(y,x);               % angle between segment and er
    kL=k*L;
    x=kL.*sin(theta/2).^2;
    y=kL.*cos(theta/2).^2;

    I1=Op.Curr1(:,1);   % I(z1)
    I2=Op.Curr1(:,2);   % I(z2)

    n=find(x.*y);
    theta=zeros(size(x));
    theta(n)=(sin(x(n)).*y(n)-sin(y(n)).*x(n))./x(n)./y(n);
    n=find(x.*y==0);
    theta(n)=sinq(x(n))-sinq(y(n));

    theta=((I2+I1).*sin(kL/2).*(sinq(x)+sinq(y))+...
      j*(I2-I1).*cos(kL/2).*theta).*...
      L./sin(kL).*exp((r1+r2)*er(d,:).'*(k/2*j));

    AA(d,:)=theta.'*ez;
    
  end 
  
end

AA=AA*(mu/8/pi);


