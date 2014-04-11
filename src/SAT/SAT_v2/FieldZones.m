
function [RFar,RFresnel,d,c]=FieldZones(Ant,Op)

% [RFar,RFresnel,d,c]=FieldZones(Ant,Op) calculates the boundaries of
% radiation zones: The far zone extends from RFar to infinity 
% and the Fresnel zone from RFresnel to RFar. In the far zone the
% exponent kR in the radiation field integral can be calculated 
% by first-order expansion, in the Fresnel zone second-order 
% terms must be included. The returned zone boundaries are determined
% very optimistic, i.e. it may be that the expansion for kR gets 
% very poor when approaching the respective boundaries from outside.
% d returns the antenna dimension and c its center as radius vector 
% from the origin.

% calculate abs(k):

Exte=[0,1];
if isfield(Op,'Exte'),
  Exte=Op.Exte;
end
k=abs(Kepsmu(2*pi*Op.Freq,Exte(2),Exte(1)));

% antenna dimension d:

g=Ant.Geom(Ant.Desc(:),:);
d=Mag(max(g,[],1)-min(g,[],1));
c=(max(g,[],1)+min(g,[],1))/2;

% radiation zone boundaries:

RFar=max(k*d^2/pi,10/k);
RFresnel=max(sqrt(d^3*k/2/pi),5*d);

