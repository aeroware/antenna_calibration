 
function l=SegLength(ant);

% function l=SegLength(ant); computes the length of each segment of
% the wiregrid stored in ant and returns the values in the vector l which
% has the dimensions length(ant.Desc)x1

 %-----------------------
 % read antgrid
 %-----------------------
  
 Nsegs=length(ant.Desc);
     
     % length of the segment
         
for n=1:Nsegs
    l(n)=norm(ant.Geom(ant.Desc(n,2),:)-ant.Geom(ant.Desc(n,1),:),'fro');
end
 
 
 
 
 
 
 
 
 
 
 
 
