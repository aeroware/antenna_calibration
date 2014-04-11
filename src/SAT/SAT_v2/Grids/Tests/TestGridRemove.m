
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


Ant1=GridCircle(20,2*pi,5);
Ant=GridJoin(Ant,Ant1);

Ant1=GridCircle(10,pi/2,7);
Ant=GridJoin(Ant,Ant1);

Ant1=GridInit;
Ant1.Geom=[9,0,0;0,9,0];
Ant1.Desc=[1,2];
Ant=GridJoin(Ant,Ant1);


Nodes=setdiff(1:size(Ant.Geom,1),unique(Ant.Desc));

%Segms=setdiff([384:439],[391,394,426,427,436:439]); % HP without adapter
Segms=384:439; % complete HP

% antenna mounting:
% Segms=[Segms,373]; 
% Nodes=[Nodes,193,195:200,245:250,295:300];
% 
% Nodes=[Nodes,x+[1,22,32]];

n=length(Ant.Geom);
[Ant1,NewO,NewN,NewS,NewP,AddS]=GridRemove(Ant,[-1,-2,-3],...
  [Nodes(:)',n-14:n-12,n-11,n-5,n-7],-Segms,[3],3);

T=ones(size(Ant1.Geom,1),1)*[5,0,0];
Ant1.Geom=Ant1.Geom+T;

clf;

hold on;
axis equal
PlotGrid(Ant1);
PlotGrid(Ant);
hold off;


return

C='';
WriteASAP('asapin.dat',C,Geom1,Desc1,Feed,Freq,2e-3,0);


