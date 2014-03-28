
function h=FarE2h(er,EE,Freq)

% h=FarE2h(er,EE,Freq) calculates effective length vectors h
% of a 1-port antenna on the basis of the normalized electric far field EE 
% radiated in the directions er in transmission mode at a frequency Freq. 
% EE and er are 2-dim arrays, the rows of er giving the unit vectors
% in the direction where the electric field E=EE*exp(-jkr)/r is radiated.
% So er, EE and h are size nx3, n being the number of directions.
%
% Application to the far fields radiated from the antenna
% when driven with unit current (1 Ampere) yields the short-circuit effective 
% length vector hs, which relates the incident E to the current I=hs.E 
% induced at the short-cicuited ports of the receiving antenna.
% The open-port effective length vector ho can be obtained by ho=hs/YA,
% where YA is the antenna admittance (holds only for 1-port antenna!).

if nargin<4,
  mu=4e-7*pi;
end

n=size(er,1);   % number of radiation/incidence directions

er=er./repmat(Mag(er,2),1,3);

AA=j/(2*pi*Freq)*cross(cross(er,EE,2),er,2);

if n>1,

  ediff=zeros(3*(n-1),n);
  for m=1:n-1,
    ediff(3*(m-1)+1:3*m,m:m+1)=[er(m,:).',-er(m+1,:).'];
  end

  Adiff=reshape(AA(2:end,:).'-AA(1:end-1,:).',3*(n-1),1);
  lam=ediff\Adiff;
  for mm=1:n,
    AA(mm,:)=AA(mm,:)+lam(mm)*er(mm,:);
  end

end

h=AA./(mu/(4*pi));

