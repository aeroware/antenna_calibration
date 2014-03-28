
function [Mnodes,Msegs,Mlen]=FindMonopoles(Desc,Feeds)

% [Mnodes,Msegs,Mlen]=FindMonopoles(Desc,Feeds)
% finds the monopoles which are driven at the given Feeds.
% Mnodes{n}{q} returns the nodes of the q-th monopole originating from 
% Feeds(n), the repective first nodes being Feeds(n). 
% Msegs{n}{q} returns the corresponding monopole segments,
% starting with the segments at the feed, ending with the
% monopole tips. Mlen{n}(q) returns the monopole 'lengths', which 
% is the number of segments of the respective monopoles.

% Rev. Feb. 2008:
% simplified code on the basis of the Revision Feb. 2008 of FindLines.

Feeds=Feeds(:);
if any(real(Feeds)==0),
  Feeds=real(CheckTerminal(Desc,Feeds));
  if any(Feeds==0),
    error('Nonvalid feed definition passed.');
  end
end
Feeds=real(Feeds);

[Mnodes,Msegs,Mlen]=FindLines(Desc,Feeds,1);

