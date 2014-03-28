
function CheckSegs(g,k)

% g antenna grid; 
% k wavenumber or Op-structure

if isstruct(k),
  k=kepsmu(k);
end

NN=size(g.Geom,1);
NS=size(g.Desc,1);

% and their lengths, Distance between :

V=g.Geom(g.Desc(:,2),:)-g.Geom(g.Desc(:,1),:);  % segment vectors 
L=Mag(s,2);                                     % segment lenghts
e=V./repmat(L,1,3);                             % unit vector in seg-dir

Dist=

% angle > 30 deg

[Segs,NoS,AdNodes]=FindSegs(g.Desc,1:NN);

for n=1:NN,
  s=Segs{n};
  if length(s)>1,
    a=V(s,:)*V(s,:)
  end