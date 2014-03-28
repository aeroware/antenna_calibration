
function Heff=Heffect(Geom,Desc,Curr,kvec)

% Determine effective length vector as a function of the wavevector kvec, 
% where kvec = k * unit vector in direction of radiation, 
% k=2*pi/wavelength. A number of wavevectors can be given as rows of 
% the matrix kvec, so that Heffect returns a scan of the effective 
% length vector over the corresponding directions. Actually, 
% the returned vector is the effective length vector times the 
% driving current:
%   Int J(r') exp(+i kvec.r') dV'
%


Heff=[];
kvec=-kvec;

if size(kvec,2)~=3, 
  kvec=kvec.'; 
  t=1; 
else
  t=0;
end

if size(kvec,2)~=3, return, end;


Heff=zeros(size(kvec));

k=sqrt(sum(abs(kvec).^2,2));

for S=1:size(Desc,1),
  r1=Geom(Desc(S,1),:);
  dr=Geom(Desc(S,2),:)-r1;
  L=sqrt(dr(:,1).^2+dr(:,2).^2+dr(:,3).^2);
  kL=k*L;
  kdr=kvec*dr';
  IL=1/2/i*(exp(i*(kL-kdr)/2).*sinq((kL-kdr)/2)-...
           exp(-i*(kL+kdr)/2).*sinq((kL+kdr)/2));
  Heff=Heff + (exp(-i*kvec*r1')./sin(kL).*...
               (Curr(S,1)*exp(-i*kdr).*conj(IL)+Curr(S,2)*IL)) * dr;
end


if t, Heff=Heff.'; end

