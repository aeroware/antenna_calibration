
function Z=CalcZ(Op,FeedNum)

% Z=CalcZ(Op,FeedNum) determines the antenna impedances for 
% the currents given in Op, which means:
%   Z(m,n,q) = Op(n,q).Vfeed(m) / Op(n,q).Ifeed(m)
% in case FeedNum='all', i.e. if Op was obtained by driving all feeds 
% simultaneously using the option FeedNum='all' in CalcCurr; otherwise
%   Z(:,:,q) = inv(Y(:,:,q)), with
%   Y(m,n,q) = Op(n,q).Ifeed(m)/Op(n,q).Vfeed(n),
% which returns proper impedance matrices when current systems
% were obtained by passing FeedNum='sys' to CalcCurr.
% If FeedNum is not given, the second method is the default one
% in case max(n)=max(m), otherwise the first.
%
% Here q may also stand for a list of indices q1,q2,q3,...

Z=[];
if isempty(Op),
  return
end

if ~exist('FeedNum','var'),
  FeedNum=[];
end

Z=CalcY(Op,FeedNum);

if isequal(FeedNum,'all'),
  
  for n=1:size(Z(:,:,:),3),
    Z(:,:,n)=1./Z(:,:,n);
  end
  
else
  
  for n=1:size(Z(:,:,:),3),
    Z(:,:,n)=inv(Z(:,:,n));
  end
  
end
