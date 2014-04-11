
load TestAntOp;

Ant=GridInit(Ant);


Ant.Desc2d=...
  {[105,106,90,89];[89,90,74,73];[106,107,91,90];[90,91,75,74]};

Ant.Obj(1).Type='Wire';
Ant.Obj(1).Elem=376:377; 
Ant.Obj(1).GraphProp=struct('Color','r'); 

Ant.Obj(2).Type='Wire';
Ant.Obj(2).Elem=379:380; 
Ant.Obj(2).GraphProp=struct('Color','r'); 

Ant.Obj(3).Type='Surf';
Ant.Obj(3).Elem=2:3; 
Ant.Obj(3).GraphProp=struct('FaceColor','g','EdgeColor','r','LineWidth',3);

Ant.Obj(4).Type='Point';
Ant.Obj(4).Elem=100:150; 
Ant.Obj(4).GraphProp=struct('MarkerEdgeColor',[1,0.5,0]);


Ant1=GridExtract(Ant,'all',1:300,[],[]);

T=ones(size(Ant1.Geom,1),1)*[5,0,0];
Ant1.Geom=Ant1.Geom+T;


clf;

hold on;
axis equal
PlotGrid(Ant1);
PlotGrid(Ant);
hold off;

% n0=size(Ant.Geom,1);
% n=find(~FindSegs(Ant.Desc,1:n0,1));
% k=setdiff(1:n0,n);
% NewN=zeros(n0,1);
% NewN(k)=1:length(k);

% Ant2=GridUpdate(Ant,'Nodes',NewN);
