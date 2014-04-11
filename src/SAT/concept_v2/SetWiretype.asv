 
function ant=SetWiretype(ant);

% ant=SetWiretype(ant) creates a new field called wiretype in the ant 
% structure which holds - oh yes - the wiretype. The only input and output 
% parameter is the variable ant which holds the wiregrid-structure. 
%
%   -   ant.wiretype(Nsegs,1) is created which holds the type of each
%       segment according to the following definition:
%
%  0...no connection at all ->      distance between base points is l/4
%                                   distance between node 1 and first base 
%                                   point is l/4 distance between node 2 
%                                   and last base point is l/4
%
%  1...connections at node 1 ->     distance between base points is 2*l/7
%                                   distance between node 1 and first base
%                                   point is l/7
%                                   distance between node 2 and last base
%                                   point is 2*l/7
%                                   
%  2...connections at node 2 ->     distance between base points is 2l/7
%                                   distance between node 1 and first base
%                                   point is 2*l/7
%                                   distance between node 2 and last base
%                                   point is l/7
%
%  3...connections at both nodes -> distance between base points is l/3
%                                   distance between node 1 and first base
%                                   point is l/6
%                                   distance between node 2 and last base
%                                   point is l/6

 
 %-----------------------
 % read antgrid
 %-----------------------
 
 
  
 
 Nnodes=length(ant.Geom);
 Nsegs=length(ant.Desc);
 
     
  % get the adjacent segments to each node
 
 [Nadj,adj]=GetAdjacent(ant);
 
 
 ant.wiretype=zeros(Nsegs,1);
 
 
  % compute type of wire
 
 
 for n=1:Nsegs
     if(Nadj(ant.Desc(n,1))==1 & Nadj(ant.Desc(n,2))==1)
        ant.wiretype(n)=0;
     else if(Nadj(ant.Desc(n,1))==1)
        ant.wiretype(n)=2;
     else if(Nadj(ant.Desc(n,2))==1)
        ant.wiretype(n)=1;
     else 
        ant.wiretype(n)=3;
     end
     end
     end
 end % for all segs
 

 

 
 
 
 
 
 
 
 
 
 
 
 
