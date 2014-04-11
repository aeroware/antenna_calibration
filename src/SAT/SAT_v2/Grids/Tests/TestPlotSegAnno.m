
% TestPlotSegAnno

load TestAntOp;
Ant=GridInit(Ant);

PlotGrid(Ant);


Segs=1:50;
Action=1;
Anno=[];

PlotSegAnno(Ant,Segs,Action,Anno);
axis equal
