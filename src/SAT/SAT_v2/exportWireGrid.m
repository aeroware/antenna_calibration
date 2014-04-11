 
function exportWireGrid(ant);

%   function [exportWireGrid(ant); exports a wiregrid model and saves it in
%   a text file which is called wiremodel.dat
%
%   This function was written by Thomas Oswald, 2009

 %-----------------------
 % read ant
 %-----------------------
 
 nNodes=length(ant.Geom);
 nSegs=length(ant.Desc);
 nFeeds=length(ant.Feed);
 
 % open/create concept input file:

fid=fopen('wiremodel.dat','wt');
if fid<0,
  error(['Could not open file ',CIF]);
end
 
% write nodes to file

fprintf(fid,'%i\n',nNodes);
for L=1:nNodes
   fprintf(fid,'%12.6e %12.6e %12.6e\n',ant.Geom(L,1),ant.Geom(L,2),ant.Geom(L,3));
end
    
% write segments to file

fprintf(fid,'%i\n',nSegs);
    
for L=1:nSegs
    fprintf(fid,'%i %i \n',ant.Desc(L,1),ant.Desc(L,2));
end
   
% feeds

fprintf(fid,'%i\n',nFeeds);
    
for L=1:nFeeds
    fprintf(fid,'%i %i \n',ant.Feed(L),ant.SegFeeds(L));
end

s=fclose(fid);
if s<0,
  error(['Could not close file ',CIF]);
end %if

 end

 
 
 
 
 
