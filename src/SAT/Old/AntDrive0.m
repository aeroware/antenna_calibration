
function [V,I,R]=AntDrive0(QG,Y,QR,G,Vo)

% [V,I]=AntDrive(QG,Y,[],G,Vo) calculates voltages V at and
% currents I into the antenna feeds when driven via a driving
% or load network defined by the matrix QG and the generators G.
% QG is fx2f, f=number of feeds, and G are the generators
% (voltage or currents sources) which may be zero when the 
% antenna is used for reception. The driving/load network is 
% represented by
%   G = QG * [V;-I]
% and the antenna system by
%   V = Z*I + Vo,  Z=inv(Y),
% where Y is the antenna admittance matrix and Vo are the open
% terminal voltages. G and Vo may be arrays with any number of 
% dimensions, in any case the first dimension must be f (or zero).
% If either G or Vo is empty, it is assumed zero; if both are 
% empty the transfer matrices are returned as explained below.
%
% [V,I,R]=AntDrive(QG,Y,QR,G,Vo) additionally calculates quantities
% defined by
%   R = QR * [V;-I]
% which usually are (but need not be) voltage or current values 
% in reception mode. 
% 
% [TVE,TIE,TRE]=AntDrive(QG,Y,QR,[],To) is an important example 
% which determines the E-transfer matrices for the antenna voltages V,
% currents I and the reception quantities R, when the network given 
% by QG is used as load. To is the open terminal transfer matrix 
% returned by To=AntTranfer(Ant,Op,er) for the directions of 
% incidence er.
%
% [TV,TI,TR]=AntDrive(QG,Y,QR) calculates generalized transfer matrices 
% of size fx2f which are defined by
%   V = TV * [G;Vo], 
%   I = TI * [G;Vo], 
%   R = TR * [G;Vo],
% where, as above, G are driving generators, and the open terminal 
% voltages Vo stem from antenna excitations by electromagnetic fields 
% incident to the antenna system.
%
% Summary of describing equations:
%
%   V = Z*I + Vo,   Z=inv(Y),
%   
%   [G;R] = [QG;QR] * [V;-I],   QG=[QGV,QGI], QR=[QRV,QRI], 
%   
%   (QGV-QGI*Y)*V = G -QGI*Y*Vo,
%   (QGV*Z-QGI)*I = G -QGV*Vo,
%
%   [V;I] = [TV;TI] * [G;Vo],   TV=[TVG,TVA], TI=[TIG,TIA],
%
%   TVG = inv(QGV-QGI*Y), 
%   TVA = -TVG*QGI*Y,
%   TIG = inv(QGV*Z-QGI),
%   TIA = -TIG*QGV,
%
%   R = QR * [V;-I] = TR * [G;Vo],   TR=[TRG,TRA],
%
%   TRG = QRV*TVG - QRI*TIG,
%   TRA = QRV*TVA - QRI*TIA,

f=size(QG,1);  % number of antenna feeds = number of "driving equations"
  
QGV=QG(:,1:f);
QGI=QG(:,f+1:2*f);

TVG = inv(QGV-QGI*Y);
TVA = -TVG*QGI*Y;
TIG = Y*TVG;
TIA = -TIG*QGV;

if (nargin<3)|isempty(QR),
  TRG=zeros(0,f);
  TRA=zeros(0,f);
else
  QRV=QR(:,1:f);
  QRI=QR(:,f+1:2*f);
  TRG=QRV*TVG-QRI*TIG;
  TRA=QRV*TVA-QRI*TIA;
end

if nargin<4, G=[]; end
if nargin<5, Vo=[]; end

if isempty(G)&isempty(Vo),
  V=[TVG,TVA];
  I=[TIG,TIA];
  R=[TRG,TRA];
  return
end
  
if isempty(G)|isequal(G,0),
  G=zeros(size(Vo));
end

if isempty(Vo)|isequal(Vo,0),
  Vo=zeros(size(G));
end

s=size(G);

V=reshape(TVG*G(:,:)+TVA*Vo(:,:),s);
I=reshape(TIG*G(:,:)+TIA*Vo(:,:),s);
R=reshape(TRG*G(:,:)+TRA*Vo(:,:),[size(QR,1),s(2:end)]);

