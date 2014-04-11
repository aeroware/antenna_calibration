
function Ant=AddSeg(Ant0,n1,n2,n);

% Ant=AddSeg(Ant0,n1,n2,n) inserts a new segment, that connects nodes n1 and
% n2, consisting of n segments. If n1, n2 are integers, they are
% interpreted as indices to the respecting nodes. If they are vectors in
% V3, they are the endpoints of the new vector.
%
% Written by Thomas Oswald, 2005
 

Ant=GridInit;

if (nargin<4)  
  n=1;  %default
end % if nargin...

% get indices

if length(n1) ==1
    i1=n1;
else
    Ant0.Geom(size(Ant0.Geom,1)+1,:)=n1;
    i1=size(Ant0.Geom,1);
end % else

if length(n2) ==1
    i2=n2;
else
    Ant0.Geom(size(Ant0.Geom,1)+1,:)=n2;
    i2=size(Ant0.Geom,1);
end % else

Ant0.Desc(size(Ant0.Desc,1)+1,1)=i1;
Ant0.Desc(size(Ant0.Desc,1),2)=i2;

% splitting

while n>1
    frac = 1/n;
    
    i=size(Ant0.Desc,1);
    [Ant0,i]=GridSplitSegs(Ant0,i,frac);
    n=n-1;
end %while

Ant=Ant0;