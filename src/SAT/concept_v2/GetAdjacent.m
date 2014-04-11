 
function [Nadj,adj]=GetAdjacent(ant);

%   function [Nadj,adj]=GetAdjacent(ant); iis a function which takes the
%   grid structure ant as input parameter and return a vector and a matrix.
%   The vector Nadj has the dimensions length(ant.Geom)x1 and holds the
%   numbers of adjacent segments to each node. The matrix
%   nadj(length(ant.Geom)x4) actually holds the segment numbers which
%   converge on the given node.


 %-----------------------
 % read ant
 %-----------------------
 
 
  
 Nnodes=length(ant.Geom);
 Nsegs=length(ant.Desc);
 
 % vector to save the number of adjacent segments
 
 Nadj=zeros(Nnodes,1);
 
 for n=1:Nsegs
     Nadj(ant.Desc(n,1))=Nadj(ant.Desc(n,1))+1;
     Nadj(ant.Desc(n,2))=Nadj(ant.Desc(n,2))+1;
 end % for all segments
 
 % vector to save the adjacent segments
 
 adj=zeros(Nnodes,4);   % max 4
 counter(1:Nnodes) =1;
 
 for n=1:Nnodes
     for m=1:Nsegs
         if ant.Desc(m,1)==n
             adj(n,counter(n))=m;
             counter(n)=counter(n)+1;
         end
         if ant.Desc(m,2)==n
             adj(n,counter(n))=m;
             counter(n)=counter(n)+1;
         end
     end
 end
     
 
 
 
 
 
 
 
 
