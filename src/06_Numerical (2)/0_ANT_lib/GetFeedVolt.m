
function [VA,Feeds0,Feeds1,Pos]=GetFeedVolt(PhysGrid,FeedNum)

% VA=GetFeedVolt(PhysGrid,FeedNum) determines the voltages applied to
% at the antenna feeds. FeedNum may be 'all' or a scalar. In the former 
% case voltages are as defined in PhysGrid.Geom_.Feeds and/or
% PhysGrid.Desc_.Feeds; in the latter case unit voltage is applied at feed 
% FeedNum, the others being short-circuited.
%
% [VA,Feeds0,Feeds1,Pos]=GetFeedVolt(...) returns also the feed nodes
% Feeds0 and the feed segments Feeds1, with their feed positions Pos.

% determine feeds:

try
  Feeds0=PhysGrid.Geom_.Feeds.Elem;
catch
  Feeds0=[];
end

try
  Feeds1=PhysGrid.Desc_.Feeds.Elem;
catch
  Feeds1=[];
end

if isempty(Feeds1)&&isempty(Feeds0),
  error('No feeds defined.');
end

if ~exist('FeedNum','var')||isempty(FeedNum),
  error('No feed number specification (must be a scalar or ''all'').');
end
if ischar(FeedNum),
  FeedNum=lower(FeedNum(~isspace(FeedNum)));
  if ~isequal(FeedNum,'all'),
    error('Wrong feed number specification (must be a scalar or ''all'').');
  end
end

if isnumeric(FeedNum),
  VA=zeros(length(Feeds0)+length(Feeds1),1);
  VA(FeedNum)=1;
else
  try
    V0=PhysGrid.Geom_.Feeds.V;
  catch
    V0=[];
  end
  try
    V1=PhysGrid.Desc_.Feeds.V;
  catch
    V1=[];
  end
  if (length(Feeds0)~=length(V0))||(length(Feeds1)~=length(V1)),
    error('Incorrect number of defined feed voltages.');
  end
  VA=[V0(:);V1(:)];
end

if nargout<4,
  return
end

% determine feed positions:

if isempty(Feeds0),
  Pos0='';
else
  try
    Pos0=PhysGrid.Geom_.Feeds.Posi;
  catch
    Pos0='';
  end
  if isempty(Pos0),
    Pos0=repmat('n',size(Feeds0));
  end
end

if isempty(Feeds1),
  Pos1='';
else
  try
    Pos1=PhysGrid.Desc_.Feeds.Posi;
  catch
    Pos1='';
  end
  if isempty(Pos1),
    if isequal(CheckSolver(PhysGrid.Solver),CheckSolver('CONCEPT')),
      d=PhysGrid.Default.CONCEPT.Feeds.Posi;
    else
      d='n';
    end
    Pos1=repmat(d,size(Feeds1));
  end
  if (length(Pos1)~=length(Feeds1))||...
    isequal(CheckSolver(PhysGrid.Solver),CheckSolver('CONCEPT'))&&...
    ~all(ismember(Pos1(:),{'a','e','m'})),
    error('Error in position definitions of feed segments.');
  end
end

Pos=[Pos0(:);Pos1(:)].';

