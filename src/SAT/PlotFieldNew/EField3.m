clear all
close all

GridFile='Data2\Marsis2a Grid.mat';
OperFile='Data2\Marsis2a 5MHz.mat';  

norm=1;
wt=1;

Or=[-3.000,-3.000,-1];

xvec=[1,0,1];
yvec=[0,1,2];
yvec=cross(xvec,cross(yvec,xvec));

xlen=6.000;
xnum=7;
ynum=xnum;

load(GridFile);
load(OperFile);

Op.Curr=shiftdim(Op.CurrSys(3,:,:),1);                     % -Z monopole
%Op.Curr=shiftdim(Op.CurrSys(1,:,:)-Op.CurrSys(2,:,:),1);     % X dipole

[x,y,E]=FieldImage3(CalcModel,Op,Or,xlen*xvec,yvec,xnum,ynum);

CalcModel.Geom=GridMove(CalcModel.Geom,[xvec;yvec;Or]',[1,0,0;0,1,0;0,0,0]',2);

PlotField3(x,y,zeros(size(x)),E,wt,norm);
hold on;
PlotGrid(CalcModel,'all');
axis equal;
hold off

