
phi=2*pi;

AutoReduce=0;

nmin=5;

m=100;

% z=zeros(m,1);
% r=zeros(m,1);
% n=zeros(m,1);
% for k=1:m,
%   z(k)=k/m*10;
%   r(k)=1.3*sin(k/m*15)+2;
%   n(k)=24;
% end

[z,r]=fplot(inline('0.+0.1*sin(x*15)'),[0,1],1e-2);

n=-50;

Ant=GridRevol(z,r,n,phi,AutoReduce,nmin);
Ant=GridObj(Ant);

Ant.Obj(3).GraphProp=struct(...
  'DiffuseStrength',1,'AmbientStrength',0.5,'SpecularStrength',0.8,...
  'FaceAlpha',1,'FaceColor',[1,0.8,0.5],'FaceLighting','flat');
Ant.Obj(3).Name='Vase';

%return

figure(1);
[Nodes,Segs,Pats,NH,SH,PH]=PlotGrid(Ant); axis equal; light
set(gca,'AmbientLight',[1,1,1]);
%set(gcf,'Renderer','ZBuffer')

return

z=flipud(z); r=flipud(r); n=flipud(n);

Ant=GridRevol(z,r,n,phi,AutoReduce,nmin);
figure(2);
PlotGrid(Ant);
axis equal

