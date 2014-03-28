
% TestPlotField

CurrExists=0;
if exist('Op','var'),
  if isfield(Op,'Curr'),
    if ~isempty(Op.Curr),
      CurrExists=1;
    end
  end
end

if ~CurrExists,
  
  % symmetrical dipole along z-axis, feed at origin:
  z=(-1.5:0.5:1.5)';
  z0=zeros(size(z));
  Ant.Geom=[z0,z0,z];
  Ant.Desc=[1:length(z)-1;2:length(z)]';
  Ant.Wire=[1e-3,inf];
  Op.Feed=[(length(z)+1)/2,1];
  Op.Freq=50e6;
  
  % load TestAntOp; % loads variables Ant and Op from file
  % Op.Feed=[195,1];
  
  AIF='asapinx.dat';
  AOF='asapoutx.dat';
  
  Op=AntCurrent(Ant,Op,1,AIF,AOF,'***** TestFieldNear *****');
  
end

O=[0,0,0];
dx=[0,5,0];
dy=[0,0,1];
nx=41;
ny=41;

[x,y,Ex,Ey,Hx,Hy]=FieldImage(Ant,Op,O,dx,dy,nx,ny);
E=max(Mag([Ex,Ey],2));

n=40;

ae=[0.1,1,4,0,0,0];
c=[0.6,0,1];

M=PlotField(x,y,Ex,Ey,(1:n)*(2*pi/n),'aec',ae,c);


