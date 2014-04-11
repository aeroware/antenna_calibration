
function Cx=InterpC(x,L,C,k)

% Cx=InterpC(x,L,C,k) returns current through a segment of length L at 
% locations x. C(1) and C(2) must pass the currents at node x=0 and x=L, 
% respectively. k is the wavenumber (2 pi / wavelength). The wavelength 
% is set to 1 meter if not passed.
% Either x or L can be a column vector. In the latter case
% C must have the corresponding size = length(L) x 2.
% If both x and L are vectors, then it is assumed that corresponding 
% indices refer to the same segments.


if nargin<4,
  k=2*pi;
end

if size(C,1)==2,
  if size(C,2)~=2, C=C.'; end
end
  

Cx=(C(:,1).*sin(k*(L-x))+C(:,2).*sin(k*x))./sin(k*L);

