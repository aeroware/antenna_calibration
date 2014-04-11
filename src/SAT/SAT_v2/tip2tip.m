function dist=tip2tip(node, ant)

%   function dist=tip2tip(node) calculates the distance between node node
%   and the node of the model ant which is furthest away.
%
%   Written by Thomas Oswald October 2009


    dist = 0;
    
    for n=1:length(ant.Geom)
        if node ~= n
            newdist=norm(ant.Geom(n,:)-ant.Geom(node,:),'fro');
            
            if newdist > dist
                dist=newdist;
            end % if
        end %if
    end % for
end