clear all
close all

GridFile='Data2\Marsis2a Grid.mat';
OperFile='Data2\Marsis2a 5MHz.mat';  

Or=[-3.000,-3.000,-3.000];

nx=4;
ny=4;
nz=4;
wt=1;
norm=2;

load(GridFile);
load(OperFile);

Op.Curr=shiftdim(Op.CurrSys(3,:,:),1);                     % -Z monopole
%Op.Curr=shiftdim(Op.CurrSys(1,:,:)-Op.CurrSys(2,:,:),1);     % X dipole

[x,y,z,E]=FieldImage3Cube(CalcModel,Op,Or,nx,ny,nz);


PlotField3(x,y,z,E,wt,norm);
hold on;
PlotGrid(CalcModel,'all');
axis equal;
hold off