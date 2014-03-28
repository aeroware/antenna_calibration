
function Ant=GridLine(varargin)

% Ant=GridLine(Type,r,n)
% draws a line from the r(1,:) to r(2,:) to r(3,:) etc., i.e.
% a string of straight lines connecting the points r(1,:), r(2,:), etc.
% r is a matrix the rows of which define the points which are 
% to be connected (so r must have 3 colums and at least two rows).
% n is the number of segments to be used for each straight line; 
% a vector n may be passed to define the segmentation of each 
% straight line (in such a case length(n)=size(r,1)-1).
% n is optional, default=1, i.e. each straight line is 1 segment.
% Type signifies which object type has to be created, if not passed
% the default is as defined by Default2dObjType and OnlyObj2dElem.

% Written 28. Feb. 2008

[Type,r,n]=...
  FirstArgin(@(x)(ischar(x)||iscell(x)),'default',[],varargin{:});

Ant=GridInit;

if isempty(n),
  n=1;
end
if numel(n)==1,
  n=repmat(n,size(r,1)-1,1);
else
  n=n(:);
end
if length(n)~=size(r,1)-1,
  error('Inconsistent input parameters r and n.');
end

nsegs=sum(n);
Ant.Geom=zeros(nsegs+1,3);
Ant.Desc=[1:nsegs;2:nsegs+1].';

k=0;
for m=1:length(n),
  for q=0:n(m)-1, 
    k=k+1;
    Ant.Geom(k,:)=r(m,:)+(r(m+1,:)-r(m,:))*q/n(m);
  end
end
Ant.Geom(end,:)=r(end,:);

% define objects:

Ant=Grid1dObj(Ant,Type);


