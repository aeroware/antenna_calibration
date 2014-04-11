
function [P,PW,PL,Corr,d]=PowerLoss(Ant,Op)

% P=PowerLoss(Ant,Op) calculates the power loss due to dissipation 
% - conversion of electromagnetic energy into thermal energy - 
% in the wires and in the loads.
%
% The fields Ant.Geom, Ant.Desc, Op.Curr, Op.Freq and Op.Exte are used.

c=2.99792458e8;

Radi=Ant.Wire(1,1);
Cond=Ant.Wire(1,2);

if (Cond<=0)|isinf(Cond),
  
  PW=zeros(size(Ant.Desc,1),1);
  
else
  
  k=Kepsmu(Op);
  
  d=sqrt(2/(k*c*4e-7*pi*Cond));  % skin depth
  
  kL=k*Mag(Ant.Geom(Ant.Desc(:,2),:)-Ant.Geom(Ant.Desc(:,1),:),2);
  
  PW=kL./sin(kL).^2.* ...
    (-(abs(Op.Curr(:,1)).^2+abs(Op.Curr(:,2)).^2).*sinq1(2*kL) + ...
    2*real(Op.Curr(:,1).*conj(Op.Curr(:,2))).*sinqc(kL));
  
  Corr=dPdLcorr(Radi/d);
  
  PW=PW./(k*8*pi.*Radi.*Cond.*d).*Corr;
  
end

Load=[];
if isfield(Op,'Load'),
  Load=Op.Load;
end

if isempty(Load),
  
  PL=[];
  
else  % power lost in connected Loads:

  % Determine load segments and at which end they are driven:
  
  TC=CheckTerminal(Ant.Desc,Load(:,1));
  
  if any(TC==0),
    error('Invalid Op.Feed passed.');
  end
  
  SegNum=abs(imag(TC));
  SegEnd=1+(imag(TC)<0);
  
  % Load currents:
  
  I=Op.Curr(sub2ind(size(Op.Curr),SegNum,SegEnd));
  I=I(:);
  
  % Load voltages:
  
  V=I.*Load(:,2);
 
  % Power loss in loads:
  
  PL=conj(I).*V/2;
  
end

P=sum(PL)+sum(PW);
  

function Corr=dPdLcorr(r,ApproxLimit)

% Correction factor for segments of circular cross-section.
% This factor compensates for the fact that the skindepth may be 
% of the same order as the segment radius. It is negligible, i.e. 
% equal to 1, if the radius is much greater than the skindepth.

if nargin<2, 
  ApproxLimit=100;
end

Corr=zeros(size(r));

n=find(r<ApproxLimit);
if ~isempty(n),
  q=(1-i)*r(n);
  Corr(n)=imag((1+i)*besselj(0,q)./besselj(1,q));
end

n=find(r>=ApproxLimit);
if ~isempty(n),
  q=r(n);
  Corr(n)=1+1/2./q+3/16./q.^2-63/512./q.^4-27/128./q.^5-1899/8192./q.^6;
end
