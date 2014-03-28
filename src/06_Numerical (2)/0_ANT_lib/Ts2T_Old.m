
function T=Ts2T(Ts,YA,YL,AntLen,AntDiam,AntDiamCorrect,Freq,epsilon)

% T=Ts2T(Ts,YA,YL) calculates transfer matrix T for loaded ports 
% from short-circuit transfer matrix Ts and antennna admittance matrix YA. 
% The load network is given by its admittance matrix YL.   
% The first dimension of Ts counts ports, the second coordinates, the
% dimensions from the third upwards are treated in parallel, T getting the
% same size as Ts. 
%
% The relations representing antenna and load network are 
%
%   I = YA*V + Ts*E, or V = ZA*I - To,  with ZA=inv(YA) and To=ZA*Ts
%   I = -YL*V
% 
% so one obtains the voltages V at the loaded antenna 
%
%   V = -T*E with T = inv(YA+YL)*Ts
%
% in particular, for open ports we have YL=0, T=ZA*Ts=To; this is 
% the default for empty of omitted YL, returning the open port transfer
% matrix.
%
% T=Ts2T(Ts,YA,YL,AntLen,AntDiam,AntDiamCorrect,Freq,epsilon)
% allows the correction of YA according to an adaptation of 
% antenna diameters. AntLen is the antenna length, AntDiam the diameter of
% the antennas for which Ts and YA are determined. AntDiamCorrect is the
% correct diameter of the real antennas. Freq is the operation frequency
% and epsilon the dielectric constant (default is vacuum).

f=size(Ts,1);  % number of feeds

if ~exist('YL','var')||isempty(YL),
  YL=zeros(f);
elseif length(YL)==1,
  YL=eye(f)*YL;
elseif size(YL,1)~=size(YL,2),
  YL=diag(YL);
end
YL(isinf(YL))=max(1,max(abs(YA(:))))*1e10;


if ~exist('AntLen','var')||isempty(AntLen),
  
  Q=inv(YA+YL);
  
else  % with correction for antenna radii:
  
  if ~exist('epsilon','var')||isempty(epsilon),
    c=2.99792458e8;
    mu=4e-7*pi;
    epsilon=1/c^2/mu;
  end
  
  if isequal(size(AntLen),[1,1]),
    AntLen=repmat(AntLen,f,1);
  end
  if isequal(size(AntDiam),[1,1]),
    AntDiam=repmat(AntDiam,f,1);
  end
  if isequal(size(AntDiamCorrect),[1,1]),
    AntDiamCorrect=repmat(AntDiamCorrect,f,1);
  end

  ZA=inv(YA);
  
  ZAc=ZA-diag(log(AntDiamCorrect./AntDiam)./(j*4*pi^2*epsilon*Freq*AntLen));
  
  Q=inv(eye(size(YL,1))+ZAc*YL)*ZA;
  
end

T=zeros(size(Ts));
for m=1:numel(Ts(1,1,:)),
  T(:,:,m)=Q*Ts(:,:,m);
end  
  

