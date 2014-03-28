
function [Lnodes,Lsegs,Llen]=FindLines(Desc,Nodes,MaxEndSegs)

% W=FindLines(Desc,Nodes,MaxEndSegs) find lines 
% starting at the given Nodes and ending in at most 
% MaxEndSegs nodes. Nodes may contain a vector of nodes.
% For each node the found lines are returned in the cell arrays
% Lnodes, Lsegs and Llen. Lnodes is a cell array which
% contains the nodes of the lines, Lsegs contains the corresponding 
% segments and Llen the line lenghts. 
% E.g. Lnodes{n}{m}(q) is the q-th node of the m-th line originating 
% from the node Nodes(n), Lsegs{n}{m}(q) is the q-th segment of the 
% m-th line originating from the node Nodes(n), and Llen{n}(m) is the
% number of segments the m-th line originating from Nodes(n) consists of. 

[Ln,Ls,Ll]=GridLines(Desc,MaxEndSegs);

Nodes=Nodes(:);
nn=length(Nodes);

Lnodes=cell(nn,1);
Lsegs=cell(nn,1);
Llen=cell(nn,1);

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
  Lnodes{n}=no;
  Lsegs{n}=se;
  Llen{n}=le;
end
