
function Ant=AbsorbNodes(Ant0,Nodes)

% Ant=AbsorbNodes(Ant0) adds the nodes which are on edges of patches
% to the respective patches. 
%
% Ant=AbsorbNodes(Ant0,Nodes) restricts the function to the node 
% numbers given in Nodes.

Ant=Ant0;

if ~exist('Nodes','var'),
  Nodes='all';
end
if ischar(Nodes),
  Nodes=1:size(Ant.Geom,1);
end
Nodes=intersect(Nodes(:),1:size(Ant.Geom,1));
if isempty(Nodes),
  return
end

nn=length(Nodes);

r=Ant.Geom(Nodes,:);

d=max(Mag(Ant.Geom,2))/1e5;

for p=1:numel(Ant.Desc2d),
 pat=Ant.Desc2d{p}(:);
 newpat=cell(2,numels(pat));
 for n=1:length(pat),
   r1=Ant.Geom(pat(n),:);
   r2=Ant.Geom(pat(mod(n,length(pat))+1),:);
   e=r2-r1;
   L=(e*e');
   e=e./L;
   tau=e*(r-repmat(r1,nn,1)).';
   dist=Mag(cross(repmat(e,nn,1),r-repmat(r1,nn,1)),2).';
   newpat{1,n}=pat(n);
   newpat{2,n}=Nodes((tau<L-d)&(tau>d)&(dist<d));
 end
 Ant.Desc2d{p}=[newpat{:}];
end


   