
function [Mnodes,Msegs,Mlen]=FindMonopoles(Desc,Feeds)

% [Mnodes,Msegs,Mlen]=FindMonopoles(Desc,Feeds)
% finds the monopoles which are driven at the given Feeds.
% Mnodes{n}{q} returns the nodes of the q-th monopole originating from 
% Feeds(n), the repective first nodes being Feeds(n). 
% Msegs{n}{q} returns the corresponding monopole segments,
% starting with the segments at the feed, ending with the
% monopole tips. Mlen{n}(q) returns the monopole 'lengths', which 
% is the number of segments of the respective monopoles.

Feeds=Feeds(:);
if any(real(Feeds)==0),
  Feeds=real(CheckTerminal(Desc,Feeds));
  if any(Feeds==0),
    error('Nonvalid feed definition passed.');
  end
end
Feeds=real(Feeds);
nf=length(Feeds);

[Lnodes,Lsegs,Llen]=FindLines(Desc,Feeds,inf);

Mnodes=cell(nf,1);
Msegs=cell(nf,1);
Mlen=cell(nf,1);

for n=1:nf,
  
  nli=length(Lnodes{n});
  EndNodes=zeros(nli,1);
  
  for m=1:nli,
    EndNodes(m)=Lnodes{n}{m}(end);
  end
  
  [Segs,NoS]=FindSegs(Desc,EndNodes);
  q=find(NoS==1);
  
  Mnodes{n}=Lnodes{n}(q);
  Msegs{n}=Lsegs{n}(q);
  Mlen{n}=Llen{n}(q);
    
end
