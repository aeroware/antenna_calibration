
function GG=PowerGain(Ant,Op,er,feed,P)

% GG=PowerGain(Ant,Op,er) returns the power gain of the
% radiating antenna system, that is the mean power radiated into the 
% unit solid angle devided by the mean input power per solid angle
% (actually the gain compared to an isotropic antenna of the same 
% efficiency, which is driven with the same input power). 
% er defines the directions for which the gain is to be calculated,
% the direction vectors must be given as rows of er.
%
% GG=PowerGain(Ant,Op,er,P) refers the gain to P instead of the input 
% power Pin. So GG returns the radiated power per unit solid angle for 
% P=1, GG returns the directive gain for P=Pin-Ploss (total radiated power, 
% Ploss being the loss in the antenna system).
%
% For dissipative media (Im(k)~=0) the radiation is normalized to 
% r=1 meter, i.e. the factor exp(2*Im(k)*r) has to be multiplied with 
% the result GG to get the situation at distance r (which of course must be
% in the far field):
%
%       r^2 Re(S)      (2*Im(k)*r)  Re(SS)       (2*Im(k)*r)    
% G  =  ---------  =  e            --------  =  e            GG 
%       P/(4*pi)                   P/(4*pi)
%
% where G is gain, GG=G*exp(-2*Im(k)*r) normalized gain, S=1/2 E x H* complex 
% Poynting vector, SS=S*exp(-2*Im(k)*r)*r^2, r radius from antenna reference 
% point (usually origin), k=w*sqrt(mu*eps) komplex wave constant, 
% mu=4e-7*pi, w circular frequency, eps komplex dielectric constant.
%
% The currents are taken from Op.Curr, Op.CurrSys is ignored.

if (nargin<4)|isempty(P),
  P=real(PowerInput(Ant,Op,feed));
end

GG=(4*pi/P)*real(FieldFar(Ant,Op,er,feed,'SS'));
