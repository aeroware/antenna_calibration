
function [e,d]=GridEqual(Ant1,Ant2,Perm)

% [e,d]=GridEqual(Ant1,Ant2) checks if the given antenna grid
% structure-variables Ant1 and Ant2 contain the same antenna 
% grid topography, i.e. if they have the same Geom, Desc and
% Desc2d fields, apart from permutations of nodes, segments 
% or patches. d returns the non-coincidences in a vector, 
% where 1, 2 and 3 denote nodes, segments and patches, 
% respectively.
%
% [e,d]=GridEqual(Ant1,Ant2,Perm) with Perm=0 does not accept 
% permutations as equal representations. Perm may be a 3-element 
% vector, the coordinates referring to resp. permutation restriction 
% of [nodes,segments,patches]. Use Perm~=0 to recognize permutations 
% which is equal to the default behaviour of GridEqual(Ant1,Ant2).
% There is one additional feature: Perm(1)=2 also accepts the
% presence of multiple nodes, which amounts to packing nodes before
% the equality test.

if (nargin<3)||isempty(Perm),
  Perm=1;
end
Perm(end+1:3)=Perm(1);

n1=1:size(Ant1.Geom,1);
q1=Ant1.Geom;
if isempty(q1),
  q1=[];
elseif Perm(1),
  if Perm(1)==2,
    [q1,m,n1]=unique(Ant1.Geom);
  else
    [q1,n1]=sortrows(Ant1.Geom);
    n1(n1)=1:size(Ant1.Geom,1);
  end
  n1=n1(:)';
end

n2=1:size(Ant2.Geom,1);
q2=Ant2.Geom;
if isempty(q2),
  q2=[];
elseif Perm(1),
  if Perm(1)==2,
    [q2,m,n2]=unique(Ant2.Geom);
  else
    [q2,n2]=sortrows(Ant2.Geom);
    n2(n2)=1:size(Ant2.Geom,1);
  end
  n2=n2(:)';
end

d=~isequal(q1,q2);

q1=n1(Ant1.Desc);
if isempty(q1),
  q1=[];
elseif Perm(2),
  q1=sortrows(q1);
end

q2=n2(Ant2.Desc);
if isempty(q2),
  q2=[];
elseif Perm(2),
  q2=sortrows(q2);
end

d(2)=~isequal(q1,q2);

q1=GatherMat(Ant1.Desc2d);
q1(:)=MapComp(q1(:),n1);
if isempty(Ant1.Desc2d),
  q1=[];
elseif Perm(3),
  q1=sortrows(q1);
end

q2=GatherMat(Ant2.Desc2d);
q2(:)=MapComp(q2(:),n2);
if isempty(Ant2.Desc2d),
  q2=[];
elseif Perm(3),
  q2=sortrows(q2);
end

d(3)=~isequal(q1,q2);

d=find(d);

e=isempty(d);
