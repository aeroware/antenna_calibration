
function [Segs,NoS,AdNodes]=FindSegs(Desc,Nodes,MaxNoS)

% [Segs,NoS,AdNodes]=FindSegs(Desc,Nodes,MaxNoS) returns 
% the segments which meet at the given Nodes. NoS(k) is 
% the number of segments connected to the k-th given node 
% Nodes(k). The corresponding segment numbers are returned 
% in Segs{k}, whereby Segs is a cell array of the same length
% as Nodes(:). 
%
% If MaxNoS is passed, it defines the maximum number of 
% segments returned per node. In this case Segs is a matrix(!) 
% of size length(Nodes(:)) times MaxNoS, and the k-th row 
% contains the respective segment numbers, with Segs(k,m)=0 
% for m>NoS(k). Pass MaxNoS=inf to get a matrix Segs containing 
% all found segments: the row-length agrees with the maximum 
% number of segments meeting at any node in Nodes.
%
% Negative segment numbers are returned if the respective node 
% represents the endpoint of the segment. 
%
% AdNodes returns the adjacent nodes, which are connected to Nodes 
% via Segs. The variable type of AdNodes goes with that of Segs,
% so AdNodes{k} (cell-version) or AdNodes(k,1:min(NoS(k),MaxNoS)) 
% (matrix-version) are the nodes connected to the node Nodes(k).
%
% If Nodes is not given or any string, the search is performed 
% for all nodes from 1 to the highest node number in Desc.

if (nargin<2)||ischar(Nodes),
  Nodes=1:max(Desc(:));
end
Nodes=Nodes(:);
nn=length(Nodes);

Segs=cell(nn,1);
AdNodes=cell(nn,1);
NoS=zeros(nn,1);
n=size(Desc,1);

for k=1:nn,
  [e,d]=find(Desc==Nodes(k));
  if ~isempty(e),
    Segs{k}=-(e.*(-1).^d)';
    AdNodes{k}=Desc(e+n*((d-1)==0))';
    NoS(k)=length(e);
  end
end

if nargin>2,

  if isempty(MaxNoS),
    return
  end

  Segs=GatherMat(Segs,MaxNoS);
  AdNodes=GatherMat(AdNodes,MaxNoS);
  
end


