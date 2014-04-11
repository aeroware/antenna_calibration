

load TestAntOp;


Segs=11+(0:11)*15;

Ant1=GridSplitSegs(Ant,Segs,0.1);

T=ones(size(Ant1.Geom,1),1)*[5,0,0];
Ant1.Geom=Ant1.Geom+T;


clf;

hold on;
axis equal
PlotGrid(Ant1);
PlotGrid(Ant);
hold off;
