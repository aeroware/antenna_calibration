
function [Tp,dTp,Tc,dTc,dTc_p,Tout]=TransferFit(Ant,jk,T,e,n);

% [Tp,dTp,Tc,dTc,dTc_p,Tout]=TransferFit(Ant,jk,T,e,n) performs a 
% polynomial fit of the transfer matrix as a function of frequency, more 
% precisely as a function of jk:
%          !
%   T(q,:) = Tpfit(q,:) =   sum    Tp(m,:) jk(q)^(m-1),   (q=1..nf)
%                         m=1..n+1
%
% where q counts the jk-values, n=size(Tp,1)-1 is the order of 
% expansion and Tp returns the polynomial coefficients of the fit to T. 
% The array T represents the transfer matrix for the nd given directions e 
% as a function of jk=j*w*sqrt(eps*mu), w=2*pi*[Op.Freq],
% 
%   size(T) = size(dTp) = size(dTc) = nf x feeds x 3 x nd,
%
%                       size(Tp) = (n+1) x feeds x 3 x nd,
%    
%   nf = length(Op) ... number of frequencies (jk-values) 
%   nd = size(e,1)  ... number of directions (given in e) evaluated
%
% dTp are the residuals of the polynomial fit: dTp=T-Tpfit. 
% 
% Tc returns the coefficients of the transfer matrix Taylor series
% expansion at jk=0 for order 0 and 1. Tc is a 2x2 cell array yielding
% a further approximation by expanding Tp(1,:) and Tp(2,:) as follows:
%               !
%   Tp(1,:,:,d) = Tc{1,1}
%               !                                  (d=1..nd)
%   Tp(2,:,:,d) = Tc{2,1}*e(d,:).' + Tc{2,2}
%
% As above ! means "should be" or "as good as possible", which is 
% realized by least squares fits. For further information on the use 
% of Tc see the function TransferVal. Tc is composed of the tensors
% of the expansion after frequency for each feed. The expansion yields 
% the approximation 
%
%   Tcapp(q,:,:,qq) = shiftdim(Tc{1,1} + jk(q)*(Tc{2,1}*e(qq,:).'+Tc{2,2}),-1)
%
% dTc are the residuals of the expansion: dTc=T-Tcapp.
% dTc_p are the residuals of the single expansion terms:
%   dTc_p(1,:,:,d) = Tp(1,:,:,d) - Tc{1,1},
%   dTc_p(2,:,:,d) = Tp(2,:,:,d) - (Tc{2,1}*e(d,:).'+Tc{2,2}), d=1..nd.
% Use TransferVal to calculate T from Tc and given frequencies and directions.
%
% n is optional, the default order of the polynomial fit is n=3.
% Pass a negative value of n to omit calculation of the expansion
% tensors Tc, dTc and dTc_p.
%
% T is the open-terminal transfer matrix, for explanation see the function 
% AntTransfer where it is denoted by To.
% -----------------
% [Tp,dTp,Tc,dTc,dTc_p]=TransferFit(Ant,Op,T,e,n) does the same, calculating
% jk by j*Kepsmu(Op). 
%
% [Tp,dTp,Tc,dTc,dTc_p,T]=TransferFit(Ant,Op,[],e,n) calculates T 
% based on Op.CurrSys and returns it as last output argument.

% check Op/jk:

if isstruct(jk), 
  Op=jk;
  jk=j*Kepsmu(Op);
end
nf=length(jk);               % number of frequencies

% check e:

if (nargin<4)|isempty(e),
  e=[eye(3);-eye(3)];
end
nd=size(e,1);                % number of directions 
if nd<4,
  error(['Insufficient number of directions ',...
         'for the retrieval of Tensor coefficients.']);
end   

% check T:

if isempty(T),
  if ~exist('Op','var'),
    error('No antenna operation structure to calculate transfer matrices.');
  end
  feeds=size(Op(1).Feed,1);     % number of feeds
  T=zeros(nf,feeds,3,nd);
  for m=1:nf,
    T(m,:,:,:)=shiftdim(AntTransfer(Ant,Op(m),e),-1);
  end
else
  feeds=size(T,2);
end

if (size(T,1)~=nf)|(size(T,4)~=nd),
  error('Invalid size of transfer matrix.');
end

% check n:  

if (nargin<5)|isempty(n),
  n=3;
end
CalcTensors=(n>0);
n=abs(n);
if n<1,
  error('Order of transfer matrix fit must be >=1.');
end

% return T in  Tout:

if nargout>5,
  Tout=T;
end

% calculate polynomial fit Tp, dTp:
% ---------------------------------

[Tp,dTp]=PolyFitM(jk,T,n);

% calculate expansion coefficients Tc, dTc, dTc_p:
% ------------------------------------------------

if ~CalcTensors,  % skip calculation of tensors when n negative
  return
end

Tc=cell(2,2);
dTc=zeros(nf,feeds,3,nd);
dTc_p=zeros(2,feeds,3,nd);

% zeroth order:

Tc{1,1}=mean(shiftdim(Tp(1,:,:,:),1),3);

% first order:

Tc{2,1}=zeros(feeds,3,3);
Tc{2,2}=zeros(feeds,3);

for m=1:feeds*3,
  [i1,i2]=ind2sub([feeds,3],m);
  q=[e,ones(nd,1)]\reshape(Tp(2,i1,i2,:),[nd,1]);
  Tc{2,1}(i1,i2,:)=reshape(q(1:3),[1,1,3]);
  Tc{2,2}(i1,i2)=q(4);
end
  
% residuals:

Tcapp=zeros(nf,feeds,3,nd);

for d=1:nd,
  a1=shiftdim(Tc{1,1},-1);
  a2=reshape(reshape(Tc{2,1},feeds*3,3)*e(d,:).'+Tc{2,2}(:),[1,feeds,3]);
  Tcapp(:,:,:,d)=...
    repmat(a1,[nf,1,1])+repmat(jk(:),[1,feeds,3]).*repmat(a2,[nf,1,1]);
  dTc_p(1,:,:,d)=Tp(1,:,:,d)-a1;
  dTc_p(2,:,:,d)=Tp(2,:,:,d)-a2;
end

dTc=T-Tcapp;

