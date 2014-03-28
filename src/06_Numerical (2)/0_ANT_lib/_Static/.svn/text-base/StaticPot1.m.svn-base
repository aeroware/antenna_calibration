
function psi=StaticPot1(L,rho,z)

% psi=StaticPot1(L,rho,z) calculates electrostatic potential psi of a
% constant line charge density on a straight segment in free space (vacuum), 
% with unit total charge on the segment. 
% L is the segment length, rho and z are the cylindrical coordinates of the 
% observation point. It is assumed that the segment extends from 
% the origin to the point z=L along the z-axis.

rho=max(rho,1e-30);

c=2.99792458e8;
eps0=1/(4e-7*pi*c^2);

% Preset psi, and extend L, rho and z to maximum size:

psi=zeros(size(rho+z+L));
L=L+psi; 
rho=rho+psi;
z=z+psi;

% proper filaments:

n=(L>0);
psi(n)=1./(4*pi*eps0*L(n)).*...
  (asinh(z(n)./rho(n))-asinh((z(n)-L(n))./rho(n)));
  
% alternative arrangements:
% (asinh(z./rho)-asinh((z-L)./rho)) =
% log((z+sqrt(rho.^2+(L-z).^2))./(z-L+sqrt(rho.^2+z.^2))) =
% log((L-z-sqrt(rho.^2+(L-z).^2))./(z-sqrt(rho.^2+z.^2)))

% degenerated filaments (point sources):

n=~n;
psi(n)=1./(4*pi*eps0*sqrt(rho(n).^2+z(n).^2));

