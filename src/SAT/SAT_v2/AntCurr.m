
function Curr=AntCurr(Ant,Op,Type,S)

% Curr=AntCurr(Ant,Op,'V',V) is calulates the current for the 
% voltage sources given in the vector V (can also be calculated
% via AntCurrent).
%
% Curr=AntCurr(Ant,Op,'I',I) is similar, but for current
% sources given in the vector I.
%
% CurrSysI=AntCurr(Ant,Op,'I') returns the current system for
% unit current sources, i.e. non-driven feeds are open (in contrast 
% to Op.CurrSys which is the current system for unit voltage 
% sources, i.e. non-driven feeds are short-circuited).
%
% CurrSysI_V1=AntCurr(Ant,Op) is a special form which calculates
% the current system for current sources, where the driving currents
% are chosen such that unit voltages are obtained at the respective 
% driving point. In other words CurrSysI(k,:,:) is the current
% distribution for unit voltage at feed k and zero currents at the
% other feeds (open feeds).
%
% The calculations are based on the following formulas:
%
%   CurrSysI(k,:) = sum Znk * CurrSys(n,:),
%                    n

%   CurrSysI_V1(k,:) = CurrSysI(k,:) / Zkk,
%   
% where CurrSys(n,:) is the current distribution when driving the 
% n-th feed with unit voltage source and short-circuiting the others,
% CurrSysI(k,:) is the current distribution when driving the k-th feed
% with unit current source and leaving the others open, and
% CurrSysI_V1(k,:) is the current distribution when driving the k-th 
% feed with unit voltage source and leaving the others open.
% Znk is the (n,k)-th element of the impedance matrix.

if (nargin<3)|isempty(Type),
  Type='V';
else
  Type=upper(Type(1));
end

if (nargin<4),
  S=[];
end

s=size(Op.CurrSys);
s=s(2:end);

if isequal(Type,'V')&~isempty(S),
  Curr=reshape(S(:).'*Op.CurrSys(:,:),s);
  return
end

[Z,Y]=AntImpedance(Ant,Op,2);

Curr=Op.CurrSys;
Curr(:)=Z.'*Op.CurrSys(:,:);

if isequal(Type,'I'),
  if ~isempty(S),
    Curr=reshape(S(:).'*Curr(:,:),s);
  end
  return
end

if isequal(Type,'V'),
  Curr=Curr./repmat(diag(Z),[1,s]);
  return
end

error('Incorrect calculation option, must be ''V'' of ''I''.');

