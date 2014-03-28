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
Juno_Grid_V0 = GridInit();
AttaInit;   % toolbox initialization for global variables

Atta_COMSOL_mesh_In = '0_Juno_14_jul_09.mphtxt';

WorkingDir= pwd;

% ------------------------------------------------------------------------
% MODEL GENERATION

ant = COMSOL_mesh_Read(Juno_Grid_V0,WorkingDir,Atta_COMSOL_mesh_In);

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
% Surface Properties
ant = GridObj(ant,'Surf','all',...
                  'Name','body',...
                  'Graf',SurfProp);
ant.Obj(end).Phys.Act = 1;
ant.Desc=[];

%------------------------------------------------------------------------
% FEEDS - DEFAULT SETTINGS
feed.pos = 'mm';

% base functions
feed.nbases = 3;      

% relevant for cylindrical antennas
feed.cond = 50e6;
feed.diam = 2e-3;

% ------------------------------------------------------------------------
% feed insert
feed_vertex_geom = [ 1.412 -0.2271 -1.115;...  % twisted! first 2 inside vertex
                     1.412  0.2271 -1.115;...  
                     1.416 -0.2357 -1.118;...  % then 2 outside vertex => reshape!
                     1.416  0.2357 -1.118];

feed_vertex = GridNearest(ant_P_1_mm.Geom,feed_vertex_geom);

ant.Desc = reshape(feed_vertex,2,2);

% ant.Desc = [ feed_vertex(1) feed_vertex(2) ; ... % inside vertex first !!!
%              feed_vertex(3) feed_vertex(4)];     % put feeds in
         
ant = GridObj(ant,'Wire','all',...
                  'Name','Feeds',...
                  'Graf',WireProp);

ant.Obj(end).Phys.Act = 1;
ant.Obj(end).Phys.Posi = feed.pos;
ant.Obj(end).Phys.Cond = feed.cond;
ant.Obj(end).Phys.Diam = feed.diam;
ant.Obj(end).Phys.NBases = feed.nbases;

% ------------------------------------------------------------------------
% save model

VarSave('0_Juno_14_jul_09',ant,[],'ant');

% Gridpack not necessary in this mesh ------------------------------------

%Gridpack mit 1mmm
% ant_P_1_mm = GridPack (ant,0.001,'all',[0,1]);

% save model
% VarSave('0_Juno_14_jul_09_P_1_mm',ant_P_1_mm,[],'ant_P_1_mm');
