clear all
close all

GridFile='Data2\Marsis2a Grid.mat';
OperFile='Data2\Marsis2a 5MHz.mat';  

Or=[0,0,0];

Radius=10;
NRadius=10;
NTheta=10;

wt=1;
norm=3;

load(GridFile);
load(OperFile);

Op.Curr=shiftdim(Op.CurrSys(3,:,:),1);                     % -Z monopole
%Op.Curr=shiftdim(Op.CurrSys(1,:,:)-Op.CurrSys(2,:,:),1);     % X dipole

[x,y,z,E]=FieldImage3Sphere(CalcModel,Op,Or,Radius,NRadius,NTheta);


PlotField3(x,y,z,E,wt,norm);
hold on;
PlotGrid(CalcModel,'all');
axis equal;
hold off