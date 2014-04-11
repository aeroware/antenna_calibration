
function [VIR_Vo,VIR_G,c]=AntDrive(YA,QV,QI,QG,QR,Vo,G)

% AntDrive calculates the voltages V at and the currents I into! the 
% antenna feeds when connected to a driving or load network.
% The antenna is defined by the admittance matrix YA,
%
%   I = YA*V + Is, 
%   V = ZA*I + Vo,
%
% where
%
%   ZA=inv(YA),  Is = -YA*Vo,
%
% and Is denotes the short-circuit current and Vo the open-feed
% voltage of the receiving antenna. Note that the currents are defined
% to be positive when flowing into the antenna, ie. directed as the 
% currents drived through the antenna by positive voltages at the 
% resp. antenna feeds.
%
% Different calls of the function are valid according to the way 
% the connected network is to be defined:
%
% 1.
%   [VI_Vo,VI_G]=AntDrive(YA,YL)
%   YL is the admittance matrix of the network as seen from the antennas. 
%   YL may also be a vector of admittances defining the diagonal of the 
%   matrix, each element representing a terminal of the form
%
%         GI     I
%       0-->--+-->--0
%             |
%            YL      V        YL*V + I = GI
%             |
%       0-----+-->--0
%
%   where the terminal is driven by the current source GI.
%
% 2.
%   [VI_Vo,VI_G]=AntDrive(YA,[],ZL)
%   ZL is the impedance matrix of the network as seen from the antennas. 
%   ZL may also be a vector of impedances defining the diagonal of the 
%   matrix, each element representing a terminal of the form
%
%       o-----ZL-->--o
%     GV              V       V + ZL*I = GV
%       o------------o
%
%   where GV is a driving voltage source.
%
% 3.
%   [VI_Vo,VI_G]=AntDrive(YA,QV,QI)
%   Here the network is defined by the general linear set of equations
%
%     QV*V - QI*I = G
%
%   where G is any kind of source.
%
% 4.
%   [VI_Vo,VI_G]=AntDrive(YA,QV,QI,QG)
%   Similar to 3. except that here the source definition is still more general:
%
%     QV*V - QI*I + QG*G = 0
%
% 5.
%   [VIR_Vo,VIR_G]=AntDrive(YA,QV,QI,QG,QR)
%   This form additionally defines observed/received quantities R,
%   which are returned in the output variables in addition to V and I 
%   concatenated along the first dimension:
%
%     QV*V - QI*I + QG*G + QR*R = 0
%
% The returned output parameters are transfer matrices defining the
% linear relation between the seeked quantities in front of the 
% underscore (_) and the quantities after it so that 
%
%    [V;I] = VI_Vo*Vo + VI_G*G
% or
%    [V;I;R] = VIR_Vo*Vo + VIR_G*G
%
% The forms 1.-4. must define 1 equation per feed, the form 5. 
% additionally 1 equation per element in R, so there are f+r equations 
% in 5., when f feeds and r receiver quantities are present.
%
% The input parameters may be arrays of 2 or more dimensions. The dimensions 
% from the 3rd upwards must be the same for all matrices and are handled
% in parallel, the returned matrices adopt the same.
%
% 6.
%   VIR=AntDrive(YA,QV,QI,QG,QR,Vo,G)
%   is another form which does not return transfer matrices but 
%   the actual voltages and currents at the antenna terminals and the 
%   receiver quantities R for the case of given generators G and 
%   open antenna voltages Vo. For instance, this form can be used to
%   calculate the transfer matrices for the incidemnt E-field:
%
% 7.	
%   TVIR=AntDrive(YA,QV,QI,[],QR,To) 
%   Here To is the open terminal transfer matrix returned by 
%   To=AntTranfer(Ant,Op,er) for the directions of incidence er.
%
% The dimensions from the 3rd upwards of all input arrays must agree!
% 
% The function solves the following set of equations to get V, I and R
% as well as the transfer matrices:
%
%     QV  -QI  QR      V      -QG*G
%                  *   I   =  
%     YA   -1   0      R       YA*Vo
%

s=[size(YA),1];

f=s(1);      % number of antenna feeds = number of "driving equations"

m=prod(s(3:end));

if (nargin<5)|isempty(QR),
  QR=zeros(f,0,m);
end
r=size(QR,2);  % nuzmber of recorded/received quantities

if isempty(QV),
  QV=repmat([eye(f);zeros(r,f)],[1,1,m]);
end
QV=Diag2Matrix(QV,r);
  
if (nargin<3)|isempty(QI),
  QI=repmat(-[eye(f);zeros(r,f)],[1,1,m]);
end
QI=Diag2Matrix(QI,r);

if (nargin<4)|isempty(QG),
  QG=repmat(-[eye(f);zeros(r,f)],[1,1,m]);
end
g=size(QG,2);

if nargin<6, Vo=[]; end
if nargin<7, G=[]; end
CalcTransfer=isempty(G)&isempty(Vo);
if ~CalcTransfer,
  if isempty(G),
    G=zeros([g,size(Vo,2),m]);
  elseif isempty(Vo),
    Vo=zeros([f,size(G,2),m]);
  elseif size(G,2)~=size(Vo,2),
    error('Inconsistent size of G and Vo arrays.');
  end
end

Q=zeros([2*f+r,2*f+r,s(3:end)]);
c=zeros(s(3:end));

if CalcTransfer,
  VIR_G=zeros([2*f+r,g,s(3:end)]);
  VIR_Vo=zeros([2*f+r,f,s(3:end)]);
else
  VIR_G=zeros([2*f+r,size(G,2),s(3:end)]);
end

for k=1:m,
  Q(:,:,k)=[QV(:,:,k),-QI(:,:,k),QR(:,:,k); YA(:,:,k),-eye(f),zeros(f,r)];
  c(k)=cond(Q(:,:,k));
  if CalcTransfer,
    VIR_G(:,:,k)=Q(:,:,k)\[-QG(:,:,k);zeros(f,g)];
    VIR_Vo(:,:,k)=Q(:,:,k)\[zeros(f+r,f);YA(:,:,k)];
  else
    VIR_G(:,:,k)=Q(:,:,k)\[-QG(:,:,k)*G(:,:,k);YA(:,:,k)*Vo(:,:,k)];
  end
end


function y=Diag2Matrix(x,r)

if (size(x,1)==1)|(size(x,2)==1),
  s=[size(x),1];
  m=max(s(1:2));
  y=zeros([m+r,m,s(3:end)]);
  for k=1:prod(s(3:end)),
    y(1:m,:,k)=diag(x(:,:,k));
  end
else 
  y=x;
end
