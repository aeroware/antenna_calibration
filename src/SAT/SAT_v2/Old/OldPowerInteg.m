
function Integ=PowerInteg(t,p)

% Integrand for calculation of total radiated power P, 
% P = Int I dO = Int G*P/(4*pi) dO,
% where I is radiant intensity (radiated power per solid angle), 
% G gain, and dO = sin(t) dt dp solid angle element.
% Therefore, Integ = I*sin(t).
% This routine is used by the function Gain and cannot be
% employed as a standalone function (see 'Gain').


global kGlobal GeomGlobal DescGlobal CurrGlobal;


n=size(t,1).*size(p,1);
if n~=1, 
  t=t'; 
  p=p';
end

kvec=kGlobal*[sin(t).*cos(p); sin(t).*sin(p); cos(t)];

Integ=Gain(GeomGlobal,DescGlobal,CurrGlobal,kvec,4*pi).*sin(t);

if n~=1,
  I=I.';
end

