
function T=To2T(To,ZA,ZL)

% T=To2T(To,ZA,ZL) calculates voltage transfer matrix T for loaded ports 
% from open ports voltage transfer matrix To and antennna impedance 
% matrix ZA. The load network is given by its impedance matrix ZL.   
% The first dimension of To counts ports, the second coordinates, the
% 3rd directions (treated in parallel). T gets the same size as To. 
% The dimensions from the 3rd upwards of ZA and ZL must be all 1 or 
% agree with the dimensions of To from the 4th upwards.
%
% The relations representing antenna and load network are 
%
%   I = YA*V + Ts*E, or V = ZA*I - To,  with ZA=inv(YA) and To=ZA*Ts
%   I = -YL*V
% 
% so one obtains the voltages V at the loaded antenna 
%
%   V = -T*E with T = ZL*inv(ZL+ZA)*To
%
% in particular, for open ports we have ZL=Id*inf, T=To; this is 
% the default if ZL is empty or omitted.

if isempty(To),
  T=[];
  return
end

sT=[size(To),1];
NFeeds=sT(1);  % number of feeds
NDirs=sT(3);   % number of directions

if prod(sT(4:end))==1,
  sT3=@(x)(1);
else
  sT3=@(x)(x);
end

sA=[size(ZA),1];
if prod(sA(3:end))==1,
  sA3=@(x)(1);
else
  sA3=@(x)(x);
end

% check ZL:

if ~exist('ZL','var')||isempty(ZL),
  T=To;
  return
end

ZL(isinf(ZL))=max(1,max(abs(ZA(:))))*1e10;

if size(ZL,1)==1,
  ZL=permute(ZL,[2,1,3:ndims(ZL)]);
end
if size(ZL,1)==1,
  ZL=repmat(ZL,[NFeeds,1]);
end
if size(ZL,2)==1,
  ZL=repmat(ZL,[1,size(ZL,1)]);
  for n=1:numel(ZL(1,1,:)),
    ZL(:,:,n)=diag(ZL(:,1,n));
  end
end

sL=[size(ZL),1];
if prod(sL(3:end))==1,
  sL3=@(x)(1);
else
  sL3=@(x)(x);
end

% check consistency of dimensions of ZA, ZL and T:

if (sT3(2)*sA3(2)>2)&&~isequal(sT(4:end),sA(3:end)) ||...
   (sT3(2)*sL3(2)>2)&&~isequal(sT(4:end),sL(3:end)) ||...
   (sL3(2)*sA3(2)>2)&&~isequal(sL(3:end),sA(3:end)) ||...
   ~isequal(sA(1:2),[NFeeds,NFeeds]) ||...
   ~isequal(sL(1:2),[NFeeds,NFeeds]),...
   error('Inconsistent dimensions of input parameters.');
end

% calculate T:

T=zeros(size(To));

% number of instances (usually frequencies):
nn=max([prod(sT(4:end)),prod(sA(3:end)),prod(sL(3:end))]);

for n=1:nn,
  
  Q=ZL(:,:,sL3(n))*inv(ZA(:,:,sA3(n))+ZL(:,:,sL3(n)));
  
  sT3n=sT3(n);
  
  if 1==0, % slower
    for m=1:NDirs,
      T(:,:,m,sT3n)=Q*To(:,:,m,sT3n);
    end
  else % faster
    T(:,:,:,sT3n)=...
    reshape(Q*reshape(To(:,:,:,sT3n),[NFeeds,3*NDirs]),[NFeeds,3,NDirs]);
  end
  
end

