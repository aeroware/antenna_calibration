
function PP=PowerRad(Ant,Op,RelTol,QuadFun)

% PP=PowerRad(Ant,Op,RelTol) returns the total complex power 
% radiated from the antenna system. The values have imaginary
% parts when the exterior is dissipative, then PP is normalized 
% (r=0 meter in the exponential factor) according to the 
% following formula:
%   
%  P = Int S r^2 dO = exp(2*Im(k)*r) Int SS dO = exp(2*Im(k)*r) PP,
%
% with dO = sin(t) dp dt. The optional parameter RelTol defines
% the relative tolerance for the numerical integration, default=5e-3.
%
% PP=PowerRad(Ant,Op,RelTol,QuadFun) additionally sets the quadrature
% function QuadFun to be used, default is quad or quadl dependent on 
% the requested accuracy.
%
% The currents are taken from Op.Curr (Op.CurrSys is ignored).

DefaultRelTol=5e-3;

if (nargin<3)|isempty(RelTol),
  RelTol=DefaultRelTol;  
end

if (nargin<4)|isempty(QuadFun),
  if RelTol<DefaultRelTol,
    QuadFun=@quadl;
  else
    QuadFun=@quad;
  end
end

% estimate power to determine absolute tolerance:

er=[1,0,0;0,1,0;0,0,1;1,1,1];
er=[er;-er];

PP=4*pi*max(Mag(FieldFar(Ant,Op,er,'SS'),2));

% double integration until requested accuracy reached:

POld=inf;
while abs(POld)>10*abs(PP),
  POld=PP;
  PP=dblquad(@PowerIntegrand,0,2*pi,0,pi,abs(RelTol*PP),QuadFun,Ant,Op);
end  
  

function PInteg=PowerIntegrand(p,t,Ant,Op)

% Integrand for calculation of total radiated power P, 
% P = Int I dO = Int G*P/(4*pi) dO,
% where I is radiant intensity (radiated power per solid angle), 
% G gain, and dO = sin(t) dt dp solid angle element.
% Therefore, Integ = I*sin(t).
% This routine is used by the function Gain and cannot be
% employed as a standalone function (see 'Gain').

n=max(length(p),length(t));

st=sin(t(:));

er=zeros(n,3);
er(:,1:2)=[st.*cos(p(:)),st.*sin(p(:))];
er(:,3)=cos(t(:));

PInteg=zeros(max(size(p),size(t)));

PInteg(:)=FieldFar(Ant,Op,er,'SS').*st;
