
function Curr=ConceptEndCurr(Desc,CCurr);

% Curr=ConceptEndCurr(Desc,CCurr)
% converts Concept basis currents CCurr into 
% segment-end currents Curr as used by ASAP.

nsegs=size(Desc,1);
if size(CCurr,1)~=nsegs,
  error('Inconsistent size of input arrays.');
end

nb=size(CCurr,2);   % number of basis functions

[Segs,NoS,AdNodes]=FindSegs(Desc,'all');

Curr=zeros(nsegs,2);

for n=1:length(Segs),
  m=NoS(n);
  if m>1,
    s=Segs{n}(:);
    b=(s>0)+nb*(s<0);
    i1=sub2ind(size(CCurr),abs(s),b);
    e=(s>0)+2*(s<0);
    i2=sub2ind(size(Curr),abs(s),e);
    q=diag(sign(s));
    q=q*(m*eye(m)-ones(m))*q/(m-1);
    Curr(i2)=q*CCurr(i1)/2;
  end
end
