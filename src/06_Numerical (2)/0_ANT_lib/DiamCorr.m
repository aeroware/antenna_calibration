
function Zcorr=DiamCorr(Z,AntLen,AntDiam,AntDiamCorr,Freq,epsilon)

% Zcorr=DiamCorr(Z,AntLen,AntDiam,AntDiamCorr,Freq,epsilon)
% performs a correction of the impedance matrix Z of a multi-port
% antenna system consisting of monopoles (i.e. each port is at a 
% monopole, but any number of other parasitic bodies may be present), 
% in order to adapt the antenna diameters. 
% AntLen is the antenna length, AntDiam the original diameter of the 
% antennas for which Z has been determined, and AntDiamCorr is the 
% correct diameter of the antennas for which Zcorr is to be calculated. 
% Freq is the operation frequency and epsilon the dielectric constant 
% (default is vacuum). Freq and epsilon must be scalars,
% AntLen, AntDiam and AntDiamCorr may be scalar or vectors having one 
% element for each monopole. If scalar, it means that the respective value
% holds for all monopoles.

NFeeds=length(Z);

if ~exist('epsilon','var')||isempty(epsilon),
  c=2.99792458e8;
  mu=4e-7*pi;
  epsilon=1/c^2/mu;
end

if isequal(size(AntLen),[1,1]),
  AntLen=repmat(AntLen,NFeeds,1);
end
if isequal(size(AntDiam),[1,1]),
  AntDiam=repmat(AntDiam,NFeeds,1);
end
if isequal(size(AntDiamCorr),[1,1]),
  AntDiamCorr=repmat(AntDiamCorr,NFeeds,1);
end

Zcorr=Z-diag(log(AntDiamCorr./AntDiam)./(j*4*pi^2*Freq*epsilon*AntLen));

