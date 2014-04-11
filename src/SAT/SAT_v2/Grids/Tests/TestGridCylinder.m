
deg=pi/180;

Lmin=0.18;

r=0.27;

z1=0;
z2=0.92;

nz=5;%fix(z2/Lmin);

p=360*deg;
np=8;

% [type,nr,npmin,rmin,height]
floor=[1,2,0,r*0.5,0.2];
ceiling=[1,2,0,r*0.5,-0.2];

Ant=GridCylinder(r,z1,z2,nz,p,np,floor,ceiling);

%Geom=GridMove(Geom,eye(3),[0,1.24-r,0.66]);

[N,S,P,NH,SH,PH]=PlotGrid(Ant); axis equal

n=findobj('Tag','Node');

p=findobj('Type','patch');
% set(p,'BackFaceLighting','unlit','FaceColor',[0.9,0.8,0.5],...
%   'FaceAlpha',1,'FaceLighting','flat',...
%   'DiffuseStrength',1,'AmbientStrength',0.5,'SpecularStrength',0.8);
% 
% set(gcf,'Renderer','opengl')

%save('CylContainer','Geom','Desc');

