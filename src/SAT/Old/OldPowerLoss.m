
function [P,c]=PowerLoss(Geom,Desc,Curr,Radi,Cond,k)

% PowerLoss(Geom,Desc,Curr,Radi,Cond,k) calculates the power 
% loss due to dissipation - conversion of electromagnetic 
% energy into thermal (or mechanical) energy.

c=2.99792458e8;

d=sqrt(2/(k*c*4e-7*pi*Cond));  % skin depth

kL=k*Mag(Geom(Desc(:,2),:)-Geom(Desc(:,1),:),2);

P=sum(kL./sin(kL).^2.* ...
  (-(abs(Curr(:,1)).^2+abs(Curr(:,2)).^2).*sinq1(2*kL) + ...
   2*real(Curr(:,1).*conj(Curr(:,2))).*sinqc(kL)) );
 
if Cond<=0,
  P=0;
  c=1;
else
  c=dPdLcorr(Radi/d);
  P=P/(k*8*pi*Radi*Cond*d)*c;
end


function c=dPdLcorr(r,ApproxLimit)

% Correction factor for segments of circular cross-section.
% This factor compensates for the fact that the skindepth may be 
% of the same order as the segment radius. It is negligible, i.e. 
% equal to 1, if the radius is much greater than the skindepth.

if nargin<2, 
  ApproxLimit=100;
end

c=zeros(size(r));

n=find(r<ApproxLimit);
if ~isempty(n),
  q=(1-i)*r(n);
  c(n)=imag((1+i)*besselj(0,q)./besselj(1,q));
end

n=find(r>=ApproxLimit);
if ~isempty(n),
  q=r(n);
  c(n)=1+1/2./q+3/16./q.^2-63/512./q.^4-27/128./q.^5-1899/8192./q.^6;
end
