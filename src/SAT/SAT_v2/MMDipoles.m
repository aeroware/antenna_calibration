
function DescDip=MMDipoles(Desc)

% DescDip=MMDipoles(Desc) calculates dipoles with 
% description DescDip from the segments given by Desc.

[Segs,NoS]=FindSegs(Desc);

NoDip=max(0,NoS-1);

DescDip=zeros(sum(NoDip),2);

n=0;
nd=find(NoDip>0);
for d=nd(:)',
  s=Segs{d}(:);
  k=length(s)-1;
  DescDip(n+(1:k),1)=-s(1);
  DescDip(n+(1:k),2)=s(2:end);
  n=n+k;
end

