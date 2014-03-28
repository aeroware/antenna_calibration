
function PlotNodesC(Geom,Desc,Curr,Nodes,Part,Stretch)

% Plot current vectors at nodes. The vector at a certain node is 
% obtained by simply adding I ds of all segments meeting at 
% this node, where ds represents the vectorial line element
% of the segment and I the respective current.
% Part defines if real or imaginary part of current is plotted.

if nargin<4, return, end
if nargin<6, Stretch=1; end

h=ishold;
if ~h, clf; hold on; end

S=FindSegs(Desc,Nodes,inf);

C=zeros(size(S,1),3);

for n=1:length(Nodes),
  Sn=S(n,:);
  st=Sn(find(Sn>0));                  % segments starting at node
  en=-Sn(find(Sn<0));                 % segments ending at node
  al=[st,en];                         % all segments meeting at node
  if isempty(al),
    C(n,:)=zeros(1,3);
  else
    I=[Curr(st,1);Curr(en,2)]*[1,1,1];
    ds=Geom(Desc(al,2),:)-Geom(Desc(al,1),:);  
    C(n,:)=sum(I.*ds)/mean(diag(ds*ds')); % total current vector at node n
  end
end
  
% Now plot current vectors at nodes

if nargin<5,
  Part='a';
end
Part=lower(Part);

ds=Geom(Desc(:,2),:)-Geom(Desc(:,1),:);
if (findstr(Part,'r')&findstr(Part,'i'))|findstr(Part,'a'),
  C=C/max(Mag(C,2));
else
  C=real(C)/max(Mag(real(C),2))+i*imag(C)/max(Mag(imag(C),2));
end
C=C*max(Mag(ds,2));

if findstr(Part,'r'),
  quiver3(Geom(Nodes,1),Geom(Nodes,2),Geom(Nodes,3),...
    real(C(:,1)),real(C(:,2)),real(C(:,3)),Stretch,'b');
end

if findstr(Part,'i'),
  quiver3(Geom(Nodes,1),Geom(Nodes,2),Geom(Nodes,3),...
    imag(C(:,1)),imag(C(:,2)),imag(C(:,3)),Stretch,'r');
end

if findstr(Part,'a'),
  quiver3(Geom(Nodes,1),Geom(Nodes,2),Geom(Nodes,3),...
    abs(C(:,1)),abs(C(:,2)),abs(C(:,3)),Stretch,'g');
end

Toscale;

if ~h, hold off; end


