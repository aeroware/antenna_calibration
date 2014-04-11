
clf;

load TestAntOp;

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

[Ant1.Geom,Ant1.Desc]=GridExtract(Ant.Geom,Ant.Desc);
T=ones(size(Ant1.Geom,1),1)*[5,0,0]*1e-3;
Ant1.Geom=Ant1.Geom+T;

Ant1.Desc2d=...
  {[105,106,90,89];[104,105,89,88];[89,90,74,73];fliplr([104,105,89,88])};

Ant1.Obj(1).Type='Wire';
Ant1.Obj(1).Elem=382:383; 
Ant1.Obj(1).GraphProp=struct('Color','g');

Ant1.Obj(2).Type='Wire';
Ant1.Obj(2).Elem=379:380; 
Ant1.Obj(2).GraphProp=struct('Color','g');

Ant1.Obj(3).Type='Surf'; 
Ant1.Obj(3).Elem=1:3; 
Ant1.Obj(3).GraphProp=struct('FaceColor','c','EdgeColor','y','LineWidth',3,'Marker','o');

Ant1.Obj(4).Type='Surf';
Ant1.Obj(4).Elem=3:-1:1; 
Ant1.Obj(4).GraphProp=struct('FaceColor','b','LineWidth',5);

Ant1.Desc=[Ant1.Desc;fliplr(Ant1.Desc(1:10,:))];
Ant1.Desc2d=[Ant1.Desc2d;Ant1.Desc2d(1:3)];

AntJ=GridJoin(Ant1,Ant,1:10,211:220);

[Ant2,NewNodes,NewSegs,NewPats,NewObjs]=GridPack(AntJ,1e-2,'a',1);


PlotGrid(Ant2);
axis equal
