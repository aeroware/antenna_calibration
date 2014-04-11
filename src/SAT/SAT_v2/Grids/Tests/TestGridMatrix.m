
% TestGridMatrix

x=(-3:0.5:3)';
y=fliplr(-2.1:0.5:3);
[x,y]=deal(repmat(x,[1,length(y)]), repmat(y,[length(x),1]));
z=3*sinq(sqrt(x.^2+y.^2));

Ant=GridMatrix(x',y',z',2,[1,-1,2]);

PlotGrid(Ant);

xlabel('x');
ylabel('y');

p=findobj(gcf,'Type','patch');
set(p,'BackFaceLighting','unlit');
% camlight left
% camlight right
camlight(0,0)
camlight(180,-90)
camlight(180,90)
