
function [Ez,Erho,Hphi]=FieldNear0(L,rho,z,k)

% Ez and Erho have still to be multiplied by 1/(4*pi*j*w*eps) to
% get the true electric fields.

skL=sin(k*L);
ckL=cos(k*L);

zL=z-L;

R1=sqrt(rho.^2+z.^2);
R2=sqrt(rho.^2+zL.^2);

G1=exp(-j.*k.*R1)./R1;
G2=exp(-j.*k.*R2)./R2;

Ez=(G2.*(j.*skL.*zL./R2-ckL)+G1).*(k/skL);
  
if nargout<2,
  return
end

Erho=(G2.*(zL.*ckL-j.*skL.*zL.^2./R2)-G1.*z)./rho.*(k/skL);
  
if nargout<3,
  return
end

Hphi=-zL+R2./skL.*(-sin(k.*(R2-R1))-2*j*(sin((k/2)*(R2-R1)).^2-sin(k*L/2).^2));
Hphi=Hphi.*G2./rho/(4*pi);

