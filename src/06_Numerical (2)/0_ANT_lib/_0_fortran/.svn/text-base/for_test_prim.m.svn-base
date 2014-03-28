% *************************************************************************
% 0.00 - 00.00.0000:  
% 
% dependend on ant struct
% 
% *************************************************************************
% determine values
% *************************************************************************

% clear all;

load('SOGrid_RED_P.mat');

dist = 0.01;

xSOGrid = SOGrid_RED_P;

% xSOGrid.Geom = SOGrid_RED_P.Geom(1:5,:)
% xSOGrid.Geom = [1 0 0; 0 1 0; 0 0 2 ]
% tic
loadlibrary('x64\debug\ant-f-lib.dll','ant-f-lib.h','alias','fortran-lib');
% libfunctions fortran-lib -full;

rows = size (xSOGrid.Geom,1);
node = ones(1,rows);

[new_nodes,New_Geom]=calllib('fortran-lib','det_n_grid',node,xSOGrid.Geom,rows,dist);

unloadlibrary fortran-lib
% toc

% tic
% [Ant,NewObjs,NewSegs,NewPats]=GridUpdate(xSOGrid,'Nodes+',new_nodes,[0,1]);
% toc
% 
% tic
% SOGrid_RED_P_1_mm = GridPack (xSOGrid,dist,'all',[0,1]);
% toc
