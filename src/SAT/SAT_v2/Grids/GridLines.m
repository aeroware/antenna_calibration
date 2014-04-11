
function [LNodes,LSegs,LLen]=GridLines(Desc,MaxEndSegs)

% [LNodes,LSegs,LLen]=GridLines(Desc,MaxEndSegs) finds the 
% lines in the grid description Desc. The lines are the segment 
% strings of maximum length which are connected at nodes where 
% only two segments meet. The optional parameter MaxEndSegs 
% gives the maximum number of segments which may meet at the 
% start- and endnodes of lines. Lines ending at nodes where  
% more than MaxEndSegs meet are omitted. E.g. for MaxEndSegs=1, 
% 'stand-alone' lines are found which are not closed. Default
% is MaxEndSegs=2, which amounts to returning all stand-alone 
% lines (open and closed). 
% LNodes is a cell array of node strings (vectors of node 
% numbers), which represent the found lines. LSegs is a cell 
% array of the corresponding segment strings (vectors of 
% segment numbers). The number of segments per line is 
% returned in the vector LLen. So the k-th line is composed of 
% LLen(k)=length(LSegs{k}) segments, the segment numbers being 
% the components of the vector LSegs{k}. The corresponding 
% LLen(k)+1=length(LNodes{k}) nodes build the vector LNodes{k}. 
% If the line is closed, the first and the last node numbers 
% are equal: LNodes{k}(1)=LNodes{k}(end).
% Line-segments the directions of which are opposite to the 
% direction of the line get negative sign. Single-segment 
% lines are also taken into account (these are segments 
% between a single-segment node and an n-segment node with 
% n~=2 and 1<=n<=MaxEndSegs).

if (nargin<2)|isempty(MaxEndSegs),
  MaxEndSegs=2;
end
MaxEndSegs=max(1,floor(MaxEndSegs));

Nodes=1:max(max(Desc));

[AdSegs,NAd,AdNodes]=FindSegs(Desc,Nodes);

N2=find((NAd==2)|(NAd==1));

NoL=0;  % number of lines found
LNodes={};
LSegs={};
LLen=[];

n=zeros(1,length(N2)+2);
s=zeros(1,length(N2)+1);

while ~isempty(N2),
  f=N2(1);
  if NAd(f)==1,
    n(1:2)=[f,AdNodes{f}];
    s(1)=AdSegs{f};
    L=2;
  else  
    n(1:3)=[AdNodes{f}(1),f,AdNodes{f}(2)];
    s(1:2)=[-AdSegs{f}(1),AdSegs{f}(2)];
    L=3;
  end
  while (NAd(n(L))==2)&(n(L)~=n(1)),
    n(L+1)=setdiff(AdNodes{n(L)},n(L-1));
    s(L)=setdiff(AdSegs{n(L)},-s(L-1));
    L=L+1;
  end
  n(1:L)=fliplr(n(1:L));
  s(1:L-1)=-fliplr(s(1:L-1));
  while (NAd(n(L))==2)&(n(L)~=n(1)), 
    n(L+1)=setdiff(AdNodes{n(L)},n(L-1));
    s(L)=setdiff(AdSegs{n(L)},-s(L-1));
    L=L+1;
  end 
  if (NAd(n(1))<=MaxEndSegs)&(NAd(n(L))<=MaxEndSegs),
    NoL=NoL+1;
    LNodes{NoL,1}=n(1:L);
    LSegs{NoL,1}=s(1:L-1);
    LLen(NoL,1)=L-1;
  end
  N2=setdiff(N2,n(1:L));
end

% set line direction so that positive segments prevail:

for L=1:NoL,
  if length(find(LSegs{L}>0))<LLen(L)/2,
    LNodes{L}=fliplr(LNodes{L});
    LSegs{L}=-fliplr(LSegs{L});
  end
end

