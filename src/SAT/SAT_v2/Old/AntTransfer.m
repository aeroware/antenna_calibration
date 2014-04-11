
function [T,Ts,AA,EE,HH,SS]=AntTransfer(Ant,Op,er,solver,antennalength, diameter,ZL,YL)

% [T,Ts]=AntTransfer(Ant,Op,er,ZL) calculates transfer matrices, which
% relate the incident E-field with the received voltages.  The
% calculations are based on the current system Op.Curr.
% er is the radiation direction, several ones may be given by a 
% nx3 matrix. Accordingly T and Ts are 3-dimensional, size fx3xn
% for n requested directions, where f is the number of feeds.
% 
% The following explanations use n=1, but analogous considerations
% hold for arbitrary n.
%
% T returns the transfer matrix for the case of a connected load 
% network described by the impedance matrix ZL, which may be a scalar 
% or vector of loads, defining impedance values for each feed;
% So the voltages at the antenna feeds are given by
%
%   V = T*E = ZA*I + To*E = -ZL*I,
%
% To being the open terminal transfer matrix, from which T is 
% determined as
%
%   T = ZL*inv(ZA+ZL)*To
%
% Here I is the corresponding vector of feed currents, ZA the antenna
% impedance matrix, and To the transfer matrix in case of all open 
% terminals (feeds), i.e. ZL=inf*eye(f). 
%
% Default: ZL=inf*eye(f), so T=To is returned if ZL is omitted.
%
% Ts is the transfer matrix for single open feeds, i.e. V=Ts*E yields 
% a vector of voltages, where V(m) is the voltage at the m-th open feed
% when the respective remaining feeds are short-circuited.
% The relation between Ts and To is given by: To = ZA*diag(YA)*Ts.
%
% [T,Ts,AA,EE,HH,SS]=AntTransfer(Ant,Op,er,ZL) also returns the far-fields 
% for unit voltage sources at the feeds. AA contains the far-field
% vector potential A (apart from the factor exp(-jkr)/r, see FieldFar)
% as rows, the row (first) index counting the feeds, the 3rd index 
% counting the n directions given in er. EE, HH and SS analogously.
%
% AntTransfer(Ant,Op,er,[],YL) uses YL instead of ZL, which is advantageous 
% in case of infinite impedances (open terminals). 
% AntTransfer(Ant,Op,er,ZL,YL) uses ZL/YL as impedance matrix which
% can be used to treat short-circuited as well as open terminals without
% being forced to use inf-values.

% Check Op.Curr

if ~isfield(Op,'Curr'),
  error('Invalid OP stricture !');
end

if ~isequal(size(Op.Feed,1),size(Op.Curr,1)),
  error('Invalid specification of current and/or feed fields.');
end

if size(er,2)~=3,
  error('Invalid specification of direction vectors.');
end

if nargin<6
    antennalength=0
    diameter=0
end

% Determine antenna impedance and admittance matrices:

[ZA,YA]=AntImpedance(Ant,Op,solver);


% Matrix Q to transform from Ts to T by T=Q*Ts:

Q=ZA*diag(diag(YA));


f=size(Op.Curr,1);  % number of feeds;


n=size(er,1);          % number of radiation/incidence directions

% input parameters

if nargin<8,
  YL=[];
end

if nargin<7,
  ZL=[];
end

if isempty(YL)&isempty(ZL)
  ZL=eye(f);
  YL=zeros(f);
elseif isempty(ZL)
  ZL=eye(f);
elseif isempty(YL)
  YL=eye(f);
end

YL(find(isinf(YL)))=max(1,max(abs(YA(:))))*1e10;
if length(YL)==1,
  YL=eye(f)*YL;
elseif size(YL,1)~=size(YL,2),
  YL=diag(YL);
end

ZL(find(isinf(ZL)))=max(1,max(abs(ZA(:))))*1e10;
if length(ZL)==1,
  ZL=eye(f)*ZL;
elseif size(ZL,1)~=size(ZL,2),
  ZL=diag(ZL);
end

% save diag(YA)

I_feed=diag(YA);

if antennalength ~= 0
    % correct capacitance for radii
    factor=(log(2*antennalength/(Ant.Wire(1)*2))-1)/(log(2*antennalength/diameter)-1);
    YA=factor*YA;
    ZA=inv(YA);
end

Q=ZL*inv(ZA*YL+ZL)*Q;

% Calculate transfer matrices:

Ts=zeros([f,3,n]);
T=Ts;

if nargout>4,
  HH=T;
  EE=T;
  SS=zeros([f,n]);
end


for m=1:f % for all feeds
  if nargout>4,
      if(solver==1)
           [AA0,EE0,HH0,SS0]=FieldFar(Ant,Op,er,m);
      else
          [AA0,EE0,HH0,SS0]=FieldFarConcept(Ant,Op,er,m);
      end
      
    EE(m,:,:)=permute(EE0,[3,2,1]);
    HH(m,:,:)=permute(HH0,[3,2,1]);
    SS(m,:)=SS0(:).';
  else
      if(solver==1)
           AA0=FieldFar(Ant,Op,er,m);
      else
          AA0=FieldFarConcept(Ant,Op,er,m);
      end
  end
  AA(m,:,:)=permute(AA0,[3,2,1]);
  
  Ts(m,:,:)=AA(m,:,:)./I_feed(m)./1e-7;
%  Ts(m,:,:)=shiftdim(FieldFar(Ant,Op,er).',-1)/1e-7/YA(m,m);
  
end % for all feeds

for m=1:n,
  T(:,:,m)=Q*Ts(:,:,m);
end  
  

