
load testantop;

Segs=1:10:size(Ant.Desc,1);
Nodes=1:10:size(Ant.Geom,1);
Col=['bgqy']';
LineStyle='-';
LineWidth=2;
MinLen=0.1;
Marker=['+*.']';
MarkerSize=6;
AnnoCol=[1;20;40;60];

H=PlotSegs(Ant.Geom,Ant.Desc,Segs,Col,AnnoCol);
hold on;
H=PlotNodes(Ant.Geom,Nodes,Col,[],AnnoCol);
hold off;

[N,S,NH,SH]=PlotRecog(Ant.Geom,Ant.Desc);

isequal(N(:),Nodes(:))
isequal(S(:),Segs(:))

pause

RemNodes=1:15:size(Ant.Geom,1);
RemSegs=1:15:size(Ant.Desc,1);

[N1,S1,NH1,SH1]=PlotRemove(Ant.Geom,Ant.Desc,RemNodes,RemSegs);

[N2,S2,NH2,SH2]=PlotRecog(Ant.Geom,Ant.Desc);

isequal(N1,N2)
isequal(NH1,NH2)
isequal(S1,S2)
isequal(SH1,SH2)

N3=union(N1,intersect(RemNodes(:),N));
S3=union(S1,intersect(RemSegs(:),S));

isequal(N,N3)
isequal(S,S3)
