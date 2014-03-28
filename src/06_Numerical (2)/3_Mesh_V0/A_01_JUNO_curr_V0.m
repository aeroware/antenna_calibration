% *************************************************************************
% 0.00 - 00.00.0000:  
% 
% dependend on ant struct
% 
% *************************************************************************
% determine values
% *************************************************************************

% clear all
% close all
% clc
                           
% initialize model grid
ant = GridInit();
AttaInit;   % toolbox initialization for global variables

WorkingDir= pwd;

%------------------------------------------------------------------------
% MODEL GENERATION

load('JUNO_nas_mesh_V0.mat');

%------------------------------------------------------------------------

Freqs = [3]*1e5;

% directions
er = [1,0,0;0,1,0;0,0,1;-1,0,0;0,-1,0;0,0,-1;...
      1,1,1;-1,1,1;1,-1,1;1,1,-1;-1,-1,1;-1,1,-1;1,-1,-1;-1,-1,-1];

% calculate:
Solver='Feko';
WireOption={};            % {}=keep patches
FarFieldCalc='Solver';
Titel = 'JUNO_nas_mesh_V0 - V0 mesh';

% PhysGrid=GetPhysGrid(ant,Solver,WireOption,WorkingDir);
% Concept_CreateIn(PhysGrid,Freqs,FeedNum,Titel,WorkingDir)

% CalcAnt(PhysGrid,WorkingDir,Solver,Freqs,er,Titel,WireOption,FarFieldCalc);

CalcAnt(ant,WorkingDir,Solver,Freqs,er,Titel,WireOption,FarFieldCalc);
