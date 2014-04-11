function ant=Wire2Patch(ant,titl)

% function ant=Wire2Patch(ant,titl) transforms the antenna structure ant in a way
% to be useable for a patch calculation i.e. it eliminates all wires
% that are concurrent to patches.
%
%   Input parameters :
%
%       ant...  antenna structure before conversion
%       titl... name of the model
%
%   Output parameters:
%
%       ant...  antenna structure after the conversion
%
% Written by Thomas Oswald, 2006
%
% Revision 12.6.7 by Thomas Oswald:
% Flexible number of feeds implemented
% Revision 13.6.7 by Thomas Oswald:
% Implemented active control of objects
% Revision 21.6.7 by Thomas Oswald:
% Converting quadrangles to triangles + Removing the multiple rods on a 
% patch
% Revision 9.7.7 by Thomas Oswald:
% Automatic setting of the segment feeds


nFeeds=length(ant.SegFeeds);

% remove all objects, not meant to be in the patch model


n=1;
while n<=length(ant.Obj)
    if ant.Obj(n).forpat==0
        ant=GridRemove(ant,-n);
        n=n-1;
    end
    n=n+1;
end % while

% divide patches with 5 nodes

nPats=length(ant.Desc2d);
for n=1:nPats
    if length(ant.Desc2d{n})==5
        ant.Desc2d{nPats+1}=[ant.Desc2d{n}(4) ant.Desc2d{n}(5) ant.Desc2d{n}(1)];
        ant.Desc2d{n}=ant.Desc2d{n}(1:4);
        nPats=nPats+1;
    end
end

% convert quadrangles to triangles

ant=Patch2Tri(ant);
ant=Check4DoubleSegs(ant);



FeedObj=GridFindObj(ant,'Name','Feeds');
ant.Feed=[ant.Obj(FeedObj).Elem];

%SegFeedObj=GridFindObj(ant,'Name','SegFeeds');
%ant.SegFeeds=[ant.Obj(SegFeedObj).Elem];

ant.Antennae(1).Obj=  GridFindObj(ant,'Name','A1');
if nFeeds >1
    ant.Antennae(2).Obj=  GridFindObj(ant,'Name','A2');
end
if nFeeds >2
    ant.Antennae(3).Obj=  GridFindObj(ant,'Name','A3');
end
if nFeeds >3
    ant.Antennae(4).Obj=  GridFindObj(ant,'Name','A4');
end

if nFeeds >4
    ant.Antennae(5).Obj=  GridFindObj(ant,'Name','A5');
end

if nFeeds >5
    ant.Antennae(6).Obj=  GridFindObj(ant,'Name','A6');
end
 
ant.SegFeeds(1)=ant.Obj(ant.Antennae(1).Obj).Elem(1);

if nFeeds >1
    ant.SegFeeds(2)=ant.Obj(ant.Antennae(2).Obj).Elem(1);
end
if nFeeds >2
   ant.SegFeeds(3)=ant.Obj(ant.Antennae(3).Obj).Elem(1);
end
if nFeeds >3
    ant.SegFeeds(4)=ant.Obj(ant.Antennae(4).Obj).Elem(1);
end
if nFeeds >4
    ant.SegFeeds(5)=ant.Obj(ant.Antennae(5).Obj).Elem(1);
end

if nFeeds >5
    ant.SegFeeds(6)=ant.Obj(ant.Antennae(6).Obj).Elem(1);
end


antrad=ant.Obj(ant.Antennae(1).Obj).Prop.Radius;
ant=SetWireRadii(ant);
ant=SetWiretype(ant);
