
load testantop;

Ant=GridInit(Ant);

Segs=1:1:size(Ant.Desc,1);
Nodes=1:10:size(Ant.Geom,1);
%Nodes=[];
Col=['bgrk']';
AnnoCol=[1;20;40;60];
AnnoCol=[];

Ant.Desc2d=...
  {[105,106,90,89];[89,90,74,73];[106,107,91,90];[90,91,75,74]};
Pats=1:4;

Ant.Wires(1).Segs=376:377; Ant.Wires(1).LineProp=struct('Color','r');
Ant.Wires(2).Segs=379:380; Ant.Wires(2).LineProp=struct('Color','r');
Ant.Wires(3).Segs=382:383; Ant.Wires(3).LineProp=struct('Color','r');
[Ant.Wires.Name]=deal('eins','zwei','drei');

Ant.Surfs(1).Pats=2:3; Ant.Surfs(1).PatchProp=struct('FaceColor','g','EdgeColor','r','LineWidth',3);

[N,S,P,NH,SH,PH]=PlotGrid(Ant);
axis equal

return

H=PlotSegs(Ant.Geom,Ant.Desc,Segs,Col,AnnoCol);
hold on;
H=PlotNodes(Ant.Geom,Nodes,Col,[],AnnoCol);
H=PlotPats(Ant.Geom,Ant.Desc2d,Pats,['gbry']',['kg']');
H=PlotPats(Ant.Geom,Ant.Desc2d);

hold off;

[N,S,P,NH,SH,PH]=PlotRecog(Ant);

isequal(N(:),Nodes(:))
isequal(S(:),Segs(:))
isequal(P(:),Pats(:))

pause

RemNodes=1:15:size(Ant.Geom,1);
RemSegs=1:15:size(Ant.Desc,1);
RemPats=2:3;

[N1,S1,P1,NH1,SH1,PH1]=PlotRemove(Ant,RemNodes,RemSegs,RemPats);

[N2,S2,P2,NH2,SH2,PH2]=PlotRecog(Ant);

isequal(N1,N2)
isequal(NH1,NH2)
isequal(S1,S2)
isequal(SH1,SH2)
isequal(P1,P2)
isequal(PH1,PH2)

N3=union(N1,intersect(RemNodes(:),N));
S3=union(S1,intersect(RemSegs(:),S));
P3=union(P1,intersect(RemPats(:),P));

isequal(N,N3)
isequal(S,S3)
isequal(P,P3)

