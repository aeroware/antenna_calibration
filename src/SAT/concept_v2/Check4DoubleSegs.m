function ant=Check4DoubleSegs(ant)

% function ant=Check4DoubleSegs(ant) looks for patches where more then one
% segment is attached and removes them by splitting the segment.
%
%   Input parameters :
%
%       ant...  antenna structure before conversion
%
%   Output parameters:
%
%       ant...  antenna structure after the conversion

nPats=length(ant.Desc2d);
nSegs=length(ant.Desc);
nNodes=length(ant.Geom);

 
    
[Nadj,adj]=GetAdjacent(ant);
    
for n=1:nPats
    if sum(Nadj(ant.Desc2d{n}(:)))>1 % if more than one node than split triangle
        if length(ant.Desc2d{n})==3
            if (adj(ant.Desc2d{n}(1))>0)&(adj(ant.Desc2d{n}(2))>0)
                newnode=(ant.Geom(ant.Desc2d{n}(1),:)+ant.Geom(ant.Desc2d{n}(2),:))/2;
                
                ant.Geom(length(ant.Geom)+1,:)=newnode;
                
                ant=AddPatch(ant,length(ant.Geom),ant.Desc2d{n}(2),ant.Desc2d{n}(3));
                ant.Desc2d{n}(2)=length(ant.Geom);
                
                [Nadj,adj]=GetAdjacent(ant);
            end
            if (adj(ant.Desc2d{n}(2))>0)&(adj(ant.Desc2d{n}(3))>0)
                newnode=(ant.Geom(ant.Desc2d{n}(2),:)+ant.Geom(ant.Desc2d{n}(3),:))/2;
                
                ant.Geom(length(ant.Geom)+1,:)=newnode;
                
                ant=AddPatch(ant,length(ant.Geom),ant.Desc2d{n}(3),ant.Desc2d{n}(1));
                ant.Desc2d{n}(3)=length(ant.Geom);
                
                [Nadj,adj]=GetAdjacent(ant);
            end
            if (adj(ant.Desc2d{n}(3))>0)&(adj(ant.Desc2d{n}(1))>0)
                newnode=(ant.Geom(ant.Desc2d{n}(3),:)+ant.Geom(ant.Desc2d{n}(1),:))/2;
                
                ant.Geom(length(ant.Geom)+1,:)=newnode;
                
                ant=AddPatch(ant,length(ant.Geom),ant.Desc2d{n}(1),ant.Desc2d{n}(2));
                ant.Desc2d{n}(1)=length(ant.Geom);
                
                [Nadj,adj]=GetAdjacent(ant);
            end              
        elseif length(ant.Desc2d{n})==4
            % at the moment keine vierecke
        end % vier segmente
    end %if
end % for
