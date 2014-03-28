function nodevec=FindNodes(Geom,Desc,nodenumber)

% nodevec=FindNodes(Geom,Desc,nodenumber) is a function for finding the nodes 
% which are connected to the node given by nodenumber in the function.
% The result is given with the row vector nodevec, where one finds the
% nodes connected to the given node. If there are no nodes connected to
% the given node, a message is displayed. Such nodes should be eliminated
% from your wire-grid-model.
% Written by Georg Fischer, September 2000.

sgeom=size(Geom);
sdesc=size(Desc);
% Control input
nodenumber=floor(nodenumber);
if nodenumber<1
   disp('Node number should be an integer greater zero!')
   return
end
if nodenumber>sgeom(1)
   disp('There are not so much nodes in Geom!')
   return
end
% rowdesc is vector with numbers of rows of Desc where the node with the
% given nodenumber can be found
rowdesc=find(Desc==nodenumber);
for j=1:length(rowdesc)
      if rowdesc(j)>sdesc(1)
         rowdesc(j)=rowdesc(j)-sdesc(1);
      end
end
strnode=num2str(nodenumber);
if length(rowdesc)==0
   disp(['The node ' strnode ' is not connected to any other nodes!'])
   b=[];
end
for j=1:length(rowdesc)
   a=Desc(rowdesc(j),:);
   for k=1:2
      if a(k)~=nodenumber
         b(j)=a(k); % b is vector with nodes connected to given node
      end
   end
end
% Result
nodevec=b;

