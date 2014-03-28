
function [Pats,NoP,Corners]=FindPats(Desc2d,Nodes,MaxNoP);

% [Pats,NoP,Corners]=FindPats(Desc,Nodes,MaxNoP) returns 
% the patches which meet at the given Nodes. NoP(k) is 
% the number of patches which are based on the k-th given node 
% Nodes(k). The corresponding patch numbers are returned 
% in Pats{k}, whereby Pats is a cell array of the same length
% as Nodes(:). Corners is of the same variable type as Pats, 
% giving to each patch the corner number where the respective
% node is situated within the patch definition.
%
% If MaxNoP is passed, it defines the maximum number of 
% patches returned per node. In this case Pats is a matrix(!) 
% of size length(Nodes(:)) times MaxNoP, and the k-th row 
% contains the respective patch numbers, with Pats(k,m)=0 
% for m>NoP(k). Pass MaxNoP=inf to get a matrix Pats 
% containing all found patches: in this case the row-length 
% agrees with the maximum number of patches meeting at any 
% node of Nodes.
%
% If Nodes is not given or any string, the search is performed 
% for all nodes from 1 to the highest node number in Desc2d.

if iscell(Desc2d),
  Desc2d=GatherMat(Desc2d);
end

if (nargin<2)|ischar(Nodes),
  Nodes=1:max(Desc2d(:));
end
Nodes=Nodes(:);
nn=length(Nodes);

Pats=cell(nn,1);
Corners=cell(nn,1);
NoP=zeros(nn,1);

for k=1:nn,
  [Pats{k},Corners{k}]=find(Desc2d==Nodes(k));
  NoP(k)=length(Pats{k});
end

if nargin>2,

  if isempty(MaxNoP),
    return
  end

  Pats=GatherMat(Pats,MaxNoP);
  Corners=GatherMat(Corners,MaxNoP);
  
end

