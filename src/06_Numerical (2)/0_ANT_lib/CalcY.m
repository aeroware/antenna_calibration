
function Y=CalcY(Op,FeedNum)

% Y=CalcY(Op) determines the antenna admittances for 
% the currents given in Op, which means:
%   Y(m,n,q) = Op(n,q).Ifeed(m)/Op(n,q).Vfeed(m)
% in case FeedNum='all', i.e. if Op was obtained by driving all feeds 
% simultaneously using the option FeedNum='all' in CalcCurr; otherwise
%   Y(m,n,q) = Op(n,q).Ifeed(m)/Op(n,q).Vfeed(n),
% which returns proper admittance matrices when current systems
% were obtained by passing FeedNum='sys' to CalcCurr.
% If FeedNum is not given, the second method is the default one
% in case max(n)=max(m), otherwise the first.
%
% Here q may also stand for a list of indices q1,q2,q3,...

Y=[];
if isempty(Op),
  return
end

% number of observed feeds:
mm=numel(Op(1).Ifeed);

% number of driven feeds:
nn=size(Op,1);

% number of driving situations (apart from feed variation), usually frequencies:
qq=numel(Op)/nn;        

s=[size(Op),1];

Y=zeros([mm,nn,s(3:end)]);

if ~exist('FeedNum','var')||isempty(FeedNum),
  if nn==mm,
    FeedNum='sys';
  else
    FeedNum='all';
  end
end
if ischar(FeedNum),
  FeedNum=lower(FeedNum(~isspace(FeedNum)));
end

if isequal(FeedNum,'all'),

  for n=1:nn,
    for q=1:qq,
      Y(:,n,q)=Op(n,q).Ifeed(:)./Op(n,q).Vfeed(:);
    end
  end

else

  for n=1:nn,
    for q=1:qq,
      Y(:,n,q)=Op(n,q).Ifeed(:)./Op(n,q).Vfeed(n);
    end
  end

end

