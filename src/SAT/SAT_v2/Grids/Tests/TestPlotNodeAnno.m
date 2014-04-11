
% TestPlotNodeAnno

load TestAntOp;
Ant=GridInit(Ant);

PlotGrid(Ant);


Nodes=1:50;
Action=1;
Anno=[];

PlotNodeAnno(Ant,Nodes,Action,Anno);

