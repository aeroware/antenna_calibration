
function [LNodes,LSegs,LLen]=FindLines(Desc,Nodes,MaxEndSegs)

% [LNodes,LSegs,LLen]=FindLines(Desc,Nodes,MaxEndSegs) 
% find segment-lines starting at the given Nodes and ending in a node 
% connecting at most MaxEndSegs segments. 
% Nodes may contain a vector of nodes.
% For each node the found lines are returned in the cell arrays
% LNodes, LSegs and LLen.  LNodes is a cell array which
% contains the nodes of the lines, LSegs contains the corresponding 
% segments and LLen the number of segments of the respective lines; 
% e.g. LNodes{n}{m}(q) is the q-th node of the m-th line originating 
% from the node Nodes(n), LSegs{n}{m}(q) is the q-th segment of the 
% m-th line originating from the node Nodes(n), and LLen{n}(m) is the
% number of segments the m-th line originating from Nodes(n) 
% consists of. 
% Single-segment lines are also taken into account (these are segments 
% between a single-segment node and an n-segment node with 
% n~=2 and 1<=n<=MaxEndSegs).
% Line-segments the directions of which are opposite to the 
% direction of the line get negative sign. 
% Default for MaxEndSegs is 2, which amounts to returning all  
% lines connected to Nodes which have open ends. 
%
% [LNodes,LSegs,LLen]=FindLines(Desc,[],MaxEndSegs)
% If Nodes=[] is passed, the function finds all 
% lines in the grid description Desc. The lines are the segment 
% strings of maximum length which are connected at nodes where 
% only two segments meet. The optional parameter MaxEndSegs 
% gives the maximum number of segments which may meet at the 
% start- and endnodes of lines. Lines ending at nodes where  
% more than MaxEndSegs meet are omitted. E.g. for MaxEndSegs=1, 
% 'stand-alone' lines are found which are not closed. 
% Default is MaxEndSegs=2, which amounts to returning all stand-alone 
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

% Rev. Feb. 2008:
% Now also lines are found which start at Nodes connecting more
% than MaxEndSegs segments. 
% With Nodes=[] the function does what the former function GridLines
% (now subfunction FindAllLines) has done in earlier toolbox versions. 

if (nargin<3)||isempty(MaxEndSegs),
  MaxEndSegs=2;
end
MaxEndSegs=max(1,floor(MaxEndSegs));

if (nargin<2)||isempty(Nodes),
  [LNodes,LSegs,LLen]=FindGridLines(Desc,MaxEndSegs);
  return
end

[Ln,Ls,Ll]=FindAllLines(Desc,inf);

[Segs,NoS]=FindSegs(Desc);
  
Nodes=Nodes(:);
nn=length(Nodes);

LNodes=cell(nn,1);
LSegs=cell(nn,1);
LLen=cell(nn,1);

for n=1:nn,
  no={};
  se={};
  le=[];
  for k=1:length(Ln),
    q=find(Ln{k}==Nodes(n));
    if ~isempty(q),
      if q==1,
        no{end+1,1}=Ln{k};
        se{end+1,1}=Ls{k};
        le(end+1,1)=Ll(k);
      elseif q==length(Ln{k}),
        no{end+1,1}=Ln{k}(end:-1:1);
        se{end+1,1}=-Ls{k}(end:-1:1);
        le(end+1,1)=Ll(k);
      elseif Ln{k}(1)==Ln{k}(end), % 1 closed line
        no{end+1,1}=[Ln{k}(q:end),Ln{k}(2:q)];
        se{end+1,1}=[Ls{k}(q:end),Ls{k}(1:q-1)];
        le(end+1,1)=Ll(k);
      else  % 2 open lines
        no=[no;{Ln{k}(q:end);Ln{k}(q:-1:1)}];
        se=[se;{Ls{k}(q:end);-Ls{k}(q-1:-1:1)}];
        le(end+1:end+2,1)=[Ll(k)-q+1;q-1];
      end
    end
  end
  endn=zeros(length(no),1);
  for k=1:length(endn),
    endn(k)=no{k}(end);
  end
  endn=find(NoS(endn)<=MaxEndSegs);
  LNodes{n}=no(endn);
  LSegs{n}=se(endn);
  LLen{n}=le(endn);
end

end


function [LNodes,LSegs,LLen]=FindAllLines(Desc,MaxEndSegs)

% [LNodes,LSegs,LLen]=FindAllLines(Desc,MaxEndSegs) 
% is called when Nodes=[] is passed in FindLines. 

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
  while (NAd(n(L))==2)&&(n(L)~=n(1)),
    n(L+1)=setdiff(AdNodes{n(L)},n(L-1));
    s(L)=setdiff(AdSegs{n(L)},-s(L-1));
    L=L+1;
  end
  n(1:L)=fliplr(n(1:L));
  s(1:L-1)=-fliplr(s(1:L-1));
  while (NAd(n(L))==2)&&(n(L)~=n(1)), 
    n(L+1)=setdiff(AdNodes{n(L)},n(L-1));
    s(L)=setdiff(AdSegs{n(L)},-s(L-1));
    L=L+1;
  end 
  if (NAd(n(1))<=MaxEndSegs)&&(NAd(n(L))<=MaxEndSegs),
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
    LNodes{L}=LNodes{L}(end:-1:1);
    LSegs{L}=-LSegs{L}(end:-1:1);
  end
end

end % FindAllLines

