
function [RFar,RFresnel,d,c]=FieldZones(Freq,AntGrid)

% [RFar,RFresnel,d,c]=FieldZones(Freq,AntGrid) calculates the boundaries of
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

k=Kepsmu(Freq,AntGrid);

ak=abs(k);

% antenna dimension d and center c:

g=AntGrid.Geom();
ma=max(g,[],1);
mi=min(g,[],1);
d=Mag(ma-mi);
c=(ma+mi)/2;

% radiation zone boundaries:

RFresnel=max(sqrt(d^3*ak/2/pi), 5*d);

RFar=max([RFresnel, ak*d^2/pi, 10/ak]);
