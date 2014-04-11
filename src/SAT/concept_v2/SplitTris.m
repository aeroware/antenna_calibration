function ant=SplitTris(ant,tris)

% function ant=SplitTris(ant) splits all patches of the the antenna
% structure ant into 2;
% function ant=SplitTris(ant,tris)splits the patches in tri of the the antenna
% structure ant into 2;

        

if nargin<2
    tris=1:length(ant.Desc2d);
end

nPats=length(ant.Desc2d);
nTris=length(tris);
nNodes=length(ant.Geom);


for n=1:nTris
    if length(ant.Desc2d{tris(n)})==3
        l1=norm(ant.Geom(ant.Desc2d{tris(n)}(1),:)-ant.Geom(ant.Desc2d{tris(n)}(2),:));
        l2=norm(ant.Geom(ant.Desc2d{tris(n)}(3),:)-ant.Geom(ant.Desc2d{tris(n)}(2),:));
        l3=norm(ant.Geom(ant.Desc2d{tris(n)}(1),:)-ant.Geom(ant.Desc2d{tris(n)}(3),:));
        
        if max([l1 l2 l3])==l1
            ant.Geom(nNodes+1,:)=(ant.Geom(ant.Desc2d{tris(n)}(1),:)+ant.Geom(ant.Desc2d{tris(n)}(2),:))/2;
            nNodes=nNodes+1;
            ant.Desc2d{nPats+1}=[nNodes ant.Desc2d{tris(n)}(2) ant.Desc2d{tris(n)}(3)];
            ant.Desc2d{tris(n)}=[ant.Desc2d{tris(n)}(1) nNodes ant.Desc2d{tris(n)}(3)];
        elseif max([l1 l2 l3])==l2
            ant.Geom(nNodes+1,:)=(ant.Geom(ant.Desc2d{tris(n)}(2),:)+ant.Geom(ant.Desc2d{tris(n)}(3),:))/2;
            nNodes=nNodes+1;
            ant.Desc2d{nPats+1}=[ant.Desc2d{tris(n)}(1) ant.Desc2d{tris(n)}(2) nNodes];
            ant.Desc2d{tris(n)}=[nNodes ant.Desc2d{tris(n)}(3) ant.Desc2d{tris(n)}(1)];
        else
            ant.Geom(nNodes+1,:)=(ant.Geom(ant.Desc2d{tris(n)}(1),:)+ant.Geom(ant.Desc2d{tris(n)}(3),:))/2;
            nNodes=nNodes+1;
            ant.Desc2d{nPats+1}=[ant.Desc2d{tris(n)}(1) ant.Desc2d{tris(n)}(2) nNodes];
            ant.Desc2d{tris(n)}=[nNodes ant.Desc2d{tris(n)}(2) ant.Desc2d{tris(n)}(3)];
        end % if
        
        nPats=nPats+1;
    end % if viereck
end % while 
   
