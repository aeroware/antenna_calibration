
function [G,Prad]=Gain(Geom,Desc,Curr,kvec,P)

% G=Gain(Geom,Desc,Curr,kvec,P) returns the gain of the
% antenna system, that is the radiant intensity I per
% mean power radiated into the unit solid angle:
%
%     r^2 |S|       I         c
% G = -------- = -------- = ----- Int |kvec x I heff|^2 
%     P/(4*pi)   P/(4*pi)   2e7 P
%
% where P is the total radiant power, r radius from antenna
% reference point (usually origin), S Pointing vector, and
% I radiant intensity = radiant power per solid angle:
%
%                 Z_0
% I = r^2 |S| = ------- Int |kvec x I heff|^2  
%               32 pi^2
%
% Z_0 = 4e-7*pi*c = 120*pi Ohms,
% kvec = k * unit vector in direction of emission,
% I heff = Heffect(Geom,Desc,Curr,kvec).
%
% When P passes the total radiated power Prad, then G is the
% directive Gain. When P is the total power input Pin to the antenna, 
% then G returns the power gain, which is the directive gain times 
% the efficiency (Prad/Pin). If no P is passed, the radiated power
% is calculated and returned as a second output argument (Prad), 
% and G returns the directive gain.
% If kvec is scalar, it is used as wavenumber |kvec| for the 
% calculation of Prad.


n=size(kvec,2);
if n==3, 
  kvec=kvec.'; 
end

c=2.99792458e8;
  

% Calculate P if required:

Prad=[];

if nargin<5 | isempty(P),
  
  global kGlobal GeomGlobal DescGlobal CurrGlobal;
  
  if size(kvec)==[1,1],
    kGlobal=abs(kvec);
  else 
    kGlobal=norm(kvec(:,1));
  end
  GeomGlobal=Geom;
  DescGlobal=Desc;
  CurrGlobal=Curr;
  
  Tol=[1e-4]; % tolerance: [demanded relative, absolute error]
  
  P=dblquad('OldPowerInteg',0,pi,0,2*pi,Tol,'quad8');
  
  clear global kGlobal GeomGlobal DescGlobal CurrGlobal;
    
  Prad=P;
  
end;


% Calculate gain values for all kvec-tors:

G=[];

if ~isempty(kvec) & (size(kvec,1)==3),
  G=c/2e7/P*sum(abs(Cross(kvec,Heffect(Geom,Desc,Curr,kvec))).^2,1);
end


if n==3,
  G=G.';
end

