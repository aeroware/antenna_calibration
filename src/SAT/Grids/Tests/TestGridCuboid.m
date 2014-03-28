
% TestGridCuboid

a=[3,-1,-2];
b=[10,0,-1];
c=[5,-2,0];

ma=[1,2,3,7];
mb=[0,1,2,2.2]';
mc=0:0.5:8;

Ant=GridCuboid(a,b,c,ma,mb,mc,[]);

PlotGrid(Ant);

m=[-1;6];
hold on;
line(m,m,m);
hold off;

xlabel('x');
ylabel('y');
axis equal

p=findobj(gcf,'Type','patch');
set(p,'BackFaceLighting','unlit','SpecularColorReflectance',0);

camlight(0,0);
camlight(0,140);
camlight(90,-50);
