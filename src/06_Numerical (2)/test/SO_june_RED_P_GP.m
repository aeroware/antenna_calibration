% *************************************************************************
% 0.00 - 00.00.0000:  
% 
% dependend on ant struct
% 
% *************************************************************************
% determine values
% *************************************************************************

clear all
close all
clc
                           
% initialize model grid
SOGrid_RED_P = GridInit();
AttaInit;   % toolbox initialization for global variables

Atta_COMSOL_mesh_In = 'SO_june_RED_P.mphtxt';

WorkingDir= pwd;

% ------------------------------------------------------------------------
% MODEL GENERATION

SOGrid_RED_P = COMSOL_mesh_ReadIn(SOGrid_RED_P,WorkingDir,Atta_COMSOL_mesh_In);

% -----------------------------------------------------------------------
% overall GRAPHICAL properties of patches, segments and points
SurfProp=struct('EdgeColor','k',...
  'DiffuseStrength',0.4,'AmbientStrength',0.6,...
  'SpecularStrength',0.3,'SpecularColorReflectance',1,'SpecularExponent',3,...
  'FaceAlpha',1,'FaceLighting','flat','BackFaceLighting','unlit');

% graphical properties of add-ons
AddSurfProp = SurfProp;
AddSurfProp.FaceColor = [0.8,0.6,0];
AddSurfProp.BackFaceLighting = 'reverselit';

% graphical properties of cylindrical antennas
CylSurfProp = SurfProp;
CylSurfProp.FaceColor = [0.6,0.2,0];
CylSurfProp.BackFaceLighting = 'reverselit';
  
% graphical properties of wires 
WireProp=struct('LineWidth',0.5,'Color',[0,0,0]);

% ------------------------------------------------------------------------
% MODEL Properties
SOGrid_RED_P = GridObj(SOGrid_RED_P,'Surf','all',...
                  'Name','body',...
                  'Graf',SurfProp);
SOGrid_RED_P.Obj(end).Phys.Act = 1;
SOGrid_RED_P.Desc=[];

% save model
VarSave('SOGrid_RED_P',SOGrid_RED_P,[],'SOGrid_RED_P');

%Gridpack mit 1mmm
SOGrid_RED_P_1_mm = GridPack (SOGrid_RED_P,0.001,'all',[0,1]);

% save model
VarSave('SOGrid_RED_P_1_mm',SOGrid_RED_P_1_mm,[],'SOGrid_RED_P_1_mm');
