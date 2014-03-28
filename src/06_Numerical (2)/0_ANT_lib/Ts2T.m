
function T=Ts2T(Ts,YA,YL)

% T=Ts2T(Ts,YA,YL) calculates voltage transfer matrix T for loaded ports 
% from short-circuit current transfer matrix Ts and antennna admittance 
% matrix YA. The load network is given by its admittance matrix YL.   
% The first dimension of Ts counts ports, the second coordinates, the
% 3rd directions (treated in parallel). T gets the same size as Ts. 
% The dimensions from the 3rd upwards of YA and YL must be all 1 or 
% agree with the dimensions of Ts from the 4th upwards.
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
% the default if YL is empty or omitted, returning the open port transfer
% matrix.


if isempty(Ts),
  T=[];
  return
end

sT=[size(Ts),1];
NFeeds=sT(1);  % number of feeds
NDirs=sT(3);   % number of directions

if prod(sT(4:end))==1,
  sT3=@(x)(1);
else
  sT3=@(x)(x);
end

sA=[size(YA),1];
if prod(sA(3:end))==1,
  sA3=@(x)(1);
else
  sA3=@(x)(x);
end

% check YL:

if ~exist('YL','var')||isempty(YL),
  YL=zeros(NFeeds);
end

YL(isinf(YL))=max(1,max(abs(YA(:))))*1e10;

if size(YL,1)==1,
  YL=permute(YL,[2,1,3:ndims(YL)]);
end
if size(YL,1)==1,
  YL=repmat(YL,[NFeeds,1]);
end
if size(YL,2)==1,
  YL=repmat(YL,[1,size(YL,1)]);
  for n=1:numel(YL(1,1,:)),
    YL(:,:,n)=diag(YL(:,1,n));
  end
end

sL=[size(YL),1];
if prod(sL(3:end))==1,
  sL3=@(x)(1);
else
  sL3=@(x)(x);
end

% check consistency of dimensions of YA, YL and T:

if (sT3(2)*sA3(2)>2)&&~isequal(sT(4:end),sA(3:end)) ||...
   (sT3(2)*sL3(2)>2)&&~isequal(sT(4:end),sL(3:end)) ||...
   (sL3(2)*sA3(2)>2)&&~isequal(sL(3:end),sA(3:end)) ||...
   ~isequal(sA(1:2),[NFeeds,NFeeds]) ||...
   ~isequal(sL(1:2),[NFeeds,NFeeds]),...
   error('Inconsistent dimensions of input parameters.');
end

% calculate T:

T=zeros(size(Ts));

% number of instances (usually frequencies):
nn=max([prod(sT(4:end)),prod(sA(3:end)),prod(sL(3:end))]);

for n=1:nn,
  
  Q=inv(YA(:,:,sA3(n))+YL(:,:,sL3(n)));
  
  sT3n=sT3(n);
    
  if 1==0, % slower
    for m=1:NDirs,
      T(:,:,m,sT3n)=Q*Ts(:,:,m,sT3n);
    end
  else % faster
    T(:,:,:,sT3n)=...
      reshape(Q*reshape(Ts(:,:,:,sT3n),[NFeeds,3*NDirs]),[NFeeds,3,NDirs]);
  end


end

