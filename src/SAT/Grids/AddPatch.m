
function ant=AddPatch(ant0,n1,n2,n3,n4);

% ant=AddPatch(ant0,n1,n2,n3,n4) inserts a new patch, that connects nodes 
% n1-n4. If n4 is not defined, the patch will be a triangle. If n1-n4 are 
% integers, they are interpreted as indices to the respecting nodes. If 
% they are vectors in R3, they are the endpoints of the new vector.
%
% Written by Thomas Oswald, June 2007
 

if (nargin<4)  
  error('error...You need at least 3 nodes to construct a patch ;-)' )
end % if nargin...

if (nargin<5)  
    quad=0;
else
    quad=1;
end % if nargin...

% get indices

if length(n1) ==1
    i1=n1;
else
    ant0.Geom(length(ant0.Geom)+1)=n1;
    i1=length(ant0.Geom);
end % else

if length(n2) ==1
    i2=n2;
else
    ant0.Geom(length(ant0.Geom)+1,:)=n2;
    i2=length(ant0.Geom);
end % else

if length(n3) ==1
    i3=n3;
else
    ant0.Geom(length(ant0.Geom)+1,:)=n3;
    i3=length(ant0.Geom);
end % else

if quad
    if length(n4) ==1
        i4=n4;
    else
        ant0.Geom(length(ant0.Geom)+1,:)=n2;
        i4=length(ant0.Geom);
    end % else
end % if quad

ant0.Desc2d{length(ant0.Desc2d)+1}(1)=i1;
ant0.Desc2d{length(ant0.Desc2d)}(2)=i2;
ant0.Desc2d{length(ant0.Desc2d)}(3)=i3;

if quad
    ant0.Desc2d{length(ant0.Desc2d)}(4)=i4;
end

% splitting



ant=ant0;